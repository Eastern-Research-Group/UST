# -*- coding: utf-8 -*-

import arcpy,os,sys,json,csv,datetime,requests;
from urllib.parse import urlsplit,urlencode,urlunsplit,parse_qs,quote;
from arcgis.gis import GIS;
from arcgis.features import FeatureLayerCollection,FeatureLayer;
from arcgis.geocoding import Geocoder, geocode, batch_geocode,reverse_geocode;
from arcgis.geometry import Point, filters;
import pandas as pd;
import numpy as np;
from pandas.api.types import is_numeric_dtype;
import sqlite3;

##############################################################################
g_tribal_fac  = 'TrUSTD UST Facilities 11-19-25.csv';
g_tribal_rel  = 'TrUSTD LUST UF1 11-19-25.csv';
g_tribal_usts = 'TrUSTD USTs UF1 11-19-25.csv';
g_tribal_nfa  = 'TrUSTD Release Report list for FY25 NFA letter 508 compliance and linking to UF.csv';
g_epa_gc      = '92c07361d015431f88ec828c08e5c852';
g_lust_srid   = 4326;

# default zoom is set to Washington, DC
g_default_zoom = arcpy.Extent(
    XMin = -78.21
   ,YMin =  38.11
   ,XMax = -75.65
   ,YMax =  39.28
   ,spatial_reference = arcpy.SpatialReference(4326)
).projectAs(arcpy.SpatialReference(3857));

# CONUS bounding box
g_conus = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(-128.0,20.2)
         ,arcpy.Point(-64.0 ,20.2)
         ,arcpy.Point(-64.0 ,52.0)
         ,arcpy.Point(-128.0,52.0)
         ,arcpy.Point(-128.0,20.2)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

# Alaska bounding box
g_alaska = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(-180  ,48)
         ,arcpy.Point(-128  ,48)
         ,arcpy.Point(-128  ,90)
         ,arcpy.Point(-180  ,90)
         ,arcpy.Point(-180  ,48)
       ])
      ,arcpy.Array([
          arcpy.Point(168  ,48)
         ,arcpy.Point(180  ,48)
         ,arcpy.Point(180  ,90)
         ,arcpy.Point(168  ,90)
         ,arcpy.Point(168  ,48)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

# Hawaii bounding box
g_hawaii = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(-180.0,10.0)
         ,arcpy.Point(-146.0,10.0)
         ,arcpy.Point(-146.0,35.0)
         ,arcpy.Point(-180.0,35.0)
         ,arcpy.Point(-180.0,10.0)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

# PRVI bounding box
g_prvi = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(-69.0,16.0)
         ,arcpy.Point(-63.0,16.0)
         ,arcpy.Point(-63.0,20.0)
         ,arcpy.Point(-69.0,20.0)
         ,arcpy.Point(-69.0,16.0)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

# GUMP bounding box
g_gump = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(136.0,8.0)
         ,arcpy.Point(154.0,8.0)
         ,arcpy.Point(154.0,25.0)
         ,arcpy.Point(136.0,25.0)
         ,arcpy.Point(136.0,8.0)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

# AMSAMOA bounding box
g_amsamoa = arcpy.Polygon( 
    arcpy.Array([
       arcpy.Array([
          arcpy.Point(-178.0,-20.0)
         ,arcpy.Point(-163.0,-5.0)
         ,arcpy.Point(-178.0,-5.0)
         ,arcpy.Point(-178.0,-20.0)
         ,arcpy.Point(-178.0,-20.0)
       ])
    ])
   ,arcpy.SpatialReference(4326)
);

import importlib;
import configdz;
importlib.reload(configdz);
        
g_config = None;
 
###############################################################################
class Toolbox(object):

   def __init__(self):
      global g_config;

      self.label = "UST Refresh";
      self.alias = "UST Refresh";

      self.tools = [];

      self.tools.append(RebuildSystemUST);
      self.tools.append(ReloadFromAGOUST);
      self.tools.append(NormalizeAGOUST);
      self.tools.append(LoadTribalCSVsUST);
      self.tools.append(GeocodeTribalUST);
      self.tools.append(UpsertTribalDataUST);
      self.tools.append(RebuildMapsUST);
      
      self.tools.append(SaveToStash);
      self.tools.append(RestoreFromStash);
      self.tools.append(CheckNFALetters);
      self.tools.append(GenerateStateStats);
      
      
      g_config = configdz.ConfigDZ(
          config_file = "ust.json"
         ,aprx        = arcpy.mp.ArcGISProject("CURRENT")
      );
      
###############################################################################
class RebuildSystemUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A1 Rebuild System";
      self.name               = "RebuildSystemUST";
      self.description        = "RebuildSystemUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      if not arcpy.Exists(aprx.defaultGeodatabase):
         arcpy.management.CreateMobileGDB(
             out_folder_path = os.path.dirname(aprx.defaultGeodatabase)
            ,out_name        = os.path.basename(aprx.defaultGeodatabase)
         );
         
      #########################################################################
      relcls = g_config.relationshipclass('facilities_usts',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(relcls):
         arcpy.Delete_management(relcls);
         
      #########################################################################
      fac = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(fac):
         arcpy.Delete_management(fac);
         
      rel = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(rel):
         arcpy.Delete_management(rel);
         
      fbc = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(fbc):
         arcpy.Delete_management(fbc);
         
      rbc = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(rbc):
         arcpy.Delete_management(rbc);
         
      ust = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(ust):
         arcpy.Delete_management(ust);
         
      trib_fac = g_config.datasource('tribal_fac',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(trib_fac):
         arcpy.Delete_management(trib_fac);
         
      trib_rel = g_config.datasource('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(trib_rel):
         arcpy.Delete_management(trib_rel);
         
      trib_ust = g_config.datasource('tribal_usts',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(trib_ust):
         arcpy.Delete_management(trib_ust);
         
      trib_nfa = g_config.datasource('tribal_nfa',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(trib_nfa):
         arcpy.Delete_management(trib_nfa);
      
      #########################################################################
      g_config.purge_domains(aprx=aprx,wrkspc=wrkspc);
      g_config.build_domains(aprx=aprx,wrkspc=wrkspc);
      
      #########################################################################
      g_config.build_dataset('facilities'          ,aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('releases'            ,aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('releases_by_county'  ,aprx=aprx,wrkspc=wrkspc);
      
      g_config.build_dataset('usts'                ,aprx=aprx,wrkspc=wrkspc);
      
      g_config.build_dataset('tribal_fac'          ,aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('tribal_rel'          ,aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('tribal_usts'         ,aprx=aprx,wrkspc=wrkspc);
      g_config.build_dataset('tribal_nfa'          ,aprx=aprx,wrkspc=wrkspc);

###############################################################################
class ReloadFromAGOUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A2 Reload From AGO";
      self.name               = "ReloadFromAGOUST";
      self.description        = "ReloadFromAGOUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      #########################################################################
      param0 = arcpy.Parameter(
          displayName   = "Source AGO GUID"
         ,name          = "SourceAGOGUID"
         ,datatype      = "GPString"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param0.value = g_config.map_guid('ust_finder_feature_layer');
      
      #########################################################################
      param1 = arcpy.Parameter(
          displayName   = "Limit Data Test Flag"
         ,name          = "LimitDataTestFlag"
         ,datatype      = "GPBoolean"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param1.value = False;

      
      params = [
          param0
         ,param1
      ];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      src_guid = parameters[0].valueAsText;
      boo_testdata = parameters[1].value;
      
      if boo_testdata:
         arcpy.AddMessage("*** Extracting with test flag to limit results records ***");
      
      gis = GIS();
      gs = gis.content.get(src_guid);
      arcpy.AddMessage("Pulling data from " + str(gs.url));
      
      #########################################################################
      fac = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
      rel = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
      fbc = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
      rbc = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found',aprx=aprx,wrkspc=wrkspc);
      usts = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(usts):
         raise Exception('usts not found');
      
      #########################################################################
      arcpy.AddMessage("harvesting facilities");
      bef_cnt = int(arcpy.management.GetCount(gs.url + '/0')[0]); 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = fac);
      
      ins_cnt = 0;
      fac_flds = g_config.flds('facilities',aprx=aprx,wrkspc=wrkspc,match_etl=True) + ['SHAPE@'];      
      with arcpy.da.InsertCursor(
          in_table    = fac
         ,field_names = fac_flds
      ) as outcurs:
      
         with arcpy.da.SearchCursor(
             in_table     = gs.url + '/0'
            ,field_names  = fac_flds
         ) as incurs:
            
            for row in incurs:
               
               row2 = list(row);
               
               # Trim Facility ID
               if row2[0] is not None:
                  row2[0] = row2[0].strip();
                  
               # Trim state
               if row2[5] is not None:
                  row2[5] = row2[5].strip();
               
               if boo_testdata and ins_cnt >= 100:
                  break;
                  
               outcurs.insertRow(row2);
               
               if ins_cnt > 0 and ins_cnt % 10000 == 0:
                  arcpy.AddMessage(". harvested " + str(ins_cnt) + " facilities records...");
               
               ins_cnt = ins_cnt + 1;
               
      arcpy.AddMessage(". Inserted " + str(ins_cnt) + " records.");
      aft_cnt = int(arcpy.management.GetCount(fac)[0]);
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");

      if bef_cnt != aft_cnt:
         raise Exception("error in download counts");         
      
      #########################################################################
      arcpy.AddMessage("harvesting releases");
      bef_cnt = int(arcpy.management.GetCount(gs.url + '/1')[0]); 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = rel);

      nfa_letter_1_cnt = 0;
      nfa_letter_2_cnt = 0;
      nfa_letter_3_cnt = 0;
      nfa_letter_4_cnt = 0;
      
      ins_cnt = 0;
      rel_flds = g_config.flds('releases',aprx=aprx,wrkspc=wrkspc,match_etl=True) + ['SHAPE@'];      
      with arcpy.da.InsertCursor(
          in_table    = rel
         ,field_names = rel_flds
      ) as outcurs:
      
         with arcpy.da.SearchCursor(
             in_table     = gs.url + '/1'
            ,field_names  = rel_flds
         ) as incurs:
            
            for row in incurs:
               
               row2 = list(row);
               
               # Trim Facility ID
               if row2[0] is not None:
                  row2[0] = row2[0].strip();
                  
               # Trim Lust ID
               if row2[1] is not None:
                  row2[1] = row2[1].strip();
                  
               # Trim state
               if row2[7] is not None:
                  row2[7] = row2[7].strip();
               
               if row2[31] is not None:
                  nfa_letter_1_cnt = nfa_letter_1_cnt + 1;
               if row2[32] is not None:
                  nfa_letter_2_cnt = nfa_letter_2_cnt + 1;
               if row2[33] is not None:
                  nfa_letter_3_cnt = nfa_letter_3_cnt + 1;
               if row2[34] is not None:
                  nfa_letter_4_cnt = nfa_letter_4_cnt + 1;
               
               if boo_testdata and ins_cnt >= 100:
                  break;
                  
               outcurs.insertRow(row2);
               
               if ins_cnt > 0 and ins_cnt % 10000 == 0:
                  arcpy.AddMessage(". harvested " + str(ins_cnt) + " releases records...");
                  
               ins_cnt = ins_cnt + 1;

      arcpy.AddMessage(". Inserted " + str(ins_cnt) + " records.");
      aft_cnt = int(arcpy.management.GetCount(rel)[0]);
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      arcpy.AddMessage(". " + str(nfa_letter_1_cnt) + " records have nfa letter 1 values.");
      arcpy.AddMessage(". " + str(nfa_letter_2_cnt) + " records have nfa letter 2 values.");
      arcpy.AddMessage(". " + str(nfa_letter_3_cnt) + " records have nfa letter 3 values.");
      arcpy.AddMessage(". " + str(nfa_letter_4_cnt) + " records have nfa letter 4 values.");
      
      if bef_cnt != aft_cnt:
         raise Exception("error in download counts");  
      
      #########################################################################
      arcpy.AddMessage("harvesting facilities_by_county");
      bef_cnt = int(arcpy.management.GetCount(gs.url + '/2')[0]); 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = fbc);
      
      ins_cnt = 0;
      fbc_flds = g_config.flds('facilities_by_county',aprx=aprx,wrkspc=wrkspc,match_etl=True) + ['SHAPE@'];      
      with arcpy.da.InsertCursor(
          in_table    = fbc
         ,field_names = fbc_flds
      ) as outcurs:
      
         with arcpy.da.SearchCursor(
             in_table     = gs.url + '/2'
            ,field_names  = fbc_flds
         ) as incurs:
            
            for row in incurs:
               
               row2 = list(row);
               
               if boo_testdata and ins_cnt >= 100:
                  break;
                  
               outcurs.insertRow(row2);
               ins_cnt = ins_cnt + 1;
      
      arcpy.AddMessage(". Inserted " + str(ins_cnt) + " records.");
      aft_cnt = int(arcpy.management.GetCount(fbc)[0]);
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      if bef_cnt != aft_cnt:
         raise Exception("error in download counts");  
         
      #########################################################################
      arcpy.AddMessage("harvesting releases_by_county");
      bef_cnt = int(arcpy.management.GetCount(gs.url + '/3')[0]); 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = rbc);
      
      ins_cnt = 0;
      rbc_flds = g_config.flds('releases_by_county',aprx=aprx,wrkspc=wrkspc,match_etl=True) + ['SHAPE@'];      
      with arcpy.da.InsertCursor(
          in_table    = rbc
         ,field_names = rbc_flds
      ) as outcurs:
      
         with arcpy.da.SearchCursor(
             in_table     = gs.url + '/3'
            ,field_names  = rbc_flds
         ) as incurs:
            
            for row in incurs:
               
               row2 = list(row);
               
               if boo_testdata and ins_cnt >= 100:
                  break;
                  
               outcurs.insertRow(row2);
               ins_cnt = ins_cnt + 1;
      
      arcpy.AddMessage(". Inserted " + str(ins_cnt) + " records.");
      aft_cnt = int(arcpy.management.GetCount(rbc)[0]);
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      if bef_cnt != aft_cnt:
         raise Exception("error in download counts");  
         
      #########################################################################
      arcpy.AddMessage("harvesting usts");
      arcpy.management.TruncateTable(in_table = usts);
      bef_cnt = int(arcpy.management.GetCount(gs.url + '/4')[0]); 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");

      ins_cnt = 0;
      usts_flds = g_config.flds('usts',aprx=aprx,wrkspc=wrkspc,match_etl=True);      
      with arcpy.da.InsertCursor(
          in_table    = usts
         ,field_names = usts_flds
      ) as outcurs:
      
         with arcpy.da.SearchCursor(
             in_table     = gs.url + '/4'
            ,field_names  = usts_flds
         ) as incurs:
            
            for row in incurs:
               
               row2 = list(row);
               
               # Trim facility id
               if row2[0] is not None:
                  row2[0] = row2[0].strip();
                  
               # Trim tank_id
               if row2[1] is not None:
                  row2[1] = row2[1].strip();
                
               # Trim state
               if row2[2] is not None:
                  row2[2] = row2[2].strip();
               
               if boo_testdata and ins_cnt >= 100:
                  break;
                  
               outcurs.insertRow(row2);
               
               if ins_cnt > 0 and ins_cnt % 10000 == 0:
                  arcpy.AddMessage(". harvested " + str(ins_cnt) + " usts records...");
                  
               ins_cnt = ins_cnt + 1;
      
      arcpy.AddMessage(". Inserted " + str(ins_cnt) + " records.");
      aft_cnt = int(arcpy.management.GetCount(usts)[0]);
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      if bef_cnt != aft_cnt:
         raise Exception("error in download counts");  
         
      #########################################################################
      arcpy.AddMessage("Gathering stats.");
      conn    = sqlite3.connect(aprx.defaultGeodatabase);
      cursor  = conn.cursor();
      
      cursor.execute("""ANALYZE main.facilities""");
      cursor.execute("""ANALYZE main.releases""");
      cursor.execute("""ANALYZE main.facilities_by_county""");
      cursor.execute("""ANALYZE main.releases_by_county""");
      cursor.execute("""ANALYZE main.usts""");
      conn.commit();
      del conn;
      
      arcpy.AddMessage("Refresh from AGO complete.");

###############################################################################
class NormalizeAGOUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A3 Normalize AGO";
      self.name               = "NormalizeAGOUST";
      self.description        = "NormalizeAGOUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      fac  = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
      rel  = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
      fbc  = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
      rbc  = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found',aprx=aprx,wrkspc=wrkspc);
      usts = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(usts):
         raise Exception('usts not found');
         
      #########################################################################
      cnt = 0;
      arcpy.AddMessage("Cleaning up facilities changing empty strings to nulls");
      with arcpy.da.UpdateCursor(
          in_table     = fac
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'state'
            
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            
            ,'zip_code'
            ,'address_match_type'
            
            ,'landuse'
            ,'within_spa'
            ,'spa_pws_facilityid'
            ,'spa_water_type'
            ,'spa_facility_type'
            ,'spa_huc12'
            ,'within_whpa'
            ,'whpa_pws_facilityid'
            ,'whpa_water_type'
            ,'whpa_facility_type'
            ,'whpa_huc12'
            ,'epa_region'
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            boo_update = False;
            
            if row[1] == '':
               boo_update = True;
               row[1] = None;
               
            if row[2] == '':
               boo_update = True;
               row[2] = None;
            
            if row[3] == '':
               boo_update = True;
               row[3] = None;
            
            if row[4] == '':
               boo_update = True;
               row[4] = None;
            
            if row[5] == '':
               boo_update = True;
               row[5] = None;
            
            if row[6] == '':
               boo_update = True;
               row[6] = None;
            
            if row[7] == '':
               boo_update = True;
               row[7] = None;
            
            if row[8] == '':
               boo_update = True;
               row[8] = None;
            
            if row[9] == '':
               boo_update = True;
               row[9] = None;
            
            if row[10] == '':
               boo_update = True;
               row[10] = None;
            
            if row[11] == '':
               boo_update = True;
               row[11] = None;
            
            if row[12] == '':
               boo_update = True;
               row[12] = None;
            
            if row[13] == '':
               boo_update = True;
               row[13] = None;
            
            if row[14] == '':
               boo_update = True;
               row[14] = None;
            
            if row[15] == '':
               boo_update = True;
               row[15] = None;
            
            if row[16] == '':
               boo_update = True;
               row[16] = None;
            
            if row[17] == '':
               boo_update = True;
               row[17] = None;
            
            if row[18] == '':
               boo_update = True;
               row[18] = None;
            
            if row[19] == '':
               boo_update = True;
               row[19] = None;
            
            if boo_update:
               ucursor.updateRow(row);
               cnt = cnt + 1;
      
      arcpy.AddMessage(". " + str(cnt) + " facilities records with empty strings tidied up.");
               
      #########################################################################
      cnt = 0;
      arcpy.AddMessage("Cleaning up releases changing empty strings to nulls");
      with arcpy.da.UpdateCursor(
          in_table     = rel
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'lust_id'
            ,'state'
            
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            ,'zip_code'
            
            ,'status'
            ,'substance'
            
            ,'address_match_type'
            ,'epa_region'
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            boo_update = False;
            
            # Facility ID
            if row[1] == '':
               boo_update = True;
               row[1] = None;
               
            # LUST ID
            if row[2] == '':
               boo_update = True;
               row[2] = None;
               
            # State
            if row[3] == '':
               boo_update = True;
               row[3] = None;
               
            # Name
            if row[4] == '':
               boo_update = True;
               row[4] = None;
               
            # Address
            if row[5] == '':
               boo_update = True;
               row[5] = None;
               
            # City
            if row[6] == '':
               boo_update = True;
               row[6] = None;
               
            # County
            if row[7] == '':
               boo_update = True;
               row[7] = None;
               
            # Push Zip Code Zero to NULL
            if row[8] in ['','0']:
               boo_update = True;
               row[8] = None;
               
            # Status
            if row[9] == '':
               boo_update = True;
               row[9] = None;
               
            # Substance
            if row[10] == '':
               boo_update = True;
               row[10] = None;
               
            # Address Match Type
            if row[11] == '':
               boo_update = True;
               row[11] = None;
               
            # EPA Region
            if boo_update:
               ucursor.updateRow(row);
               cnt = cnt + 1;
               
      arcpy.AddMessage(". " + str(cnt) + " releases records with empty strings tidied up.");
               
      #########################################################################
      cnt = 0;
      arcpy.AddMessage("Cleaning up usts changing empty strings to nulls");
      with arcpy.da.UpdateCursor(
          in_table     = usts
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'tank_id'
            ,'state'
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            boo_update = False;
            
            if row[1] == '':
               boo_update = True;
               row[1] = None;
               
            if row[2] == '':
               boo_update = True;
               row[2] = None;
               
            if row[3] == '':
               boo_update = True;
               row[3] = None;
               
            if boo_update:
               ucursor.updateRow(row);               
               cnt = cnt + 1;
               
      arcpy.AddMessage(". " + str(cnt) + " usts records with empty strings tidied up.");
      
      #########################################################################      
      cnt = 0;
      key = 1;
      arcpy.AddMessage("Plugging empty facilities keys with placeholders.");
      with arcpy.da.UpdateCursor(
          in_table     = fac
         ,field_names  = [
             'state'
            ,'facility_id'
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            ,'latitude'
            ,'longitude'
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            str_state       = row[0];
            str_facility_id = row[1];
            
            boo_update = False;
            if str_facility_id is None:
               arcpy.AddMessage(".   plugging empty facility id key (" + str(row) + ")");
               row[1] = "unk_id" + str(key);
               key = key + 1;
               boo_update = True;               
               
            if str_state is None:
               arcpy.AddMessage(".   plugging empty state key (" + str(row) + ")");
               row[0] = 'Unknown';
               boo_update = True;
               
            if boo_update:
               ucursor.updateRow(row);
               cnt = cnt + 1;
               
      arcpy.AddMessage(". " + str(cnt) + " facilities records with empty keys updated.");
      
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Plugging empty releases keys with placeholders.");
      with arcpy.da.UpdateCursor(
          in_table     = rel
         ,field_names  = [
             'state'
            ,'facility_id'
            ,'lust_id'
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            ,'latitude'
            ,'longitude'
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            str_state       = row[0];
            str_facility_id = row[1];
            str_lust_id     = row[2];
            
            boo_update = False;
            if str_lust_id is None:
               arcpy.AddMessage(".   plugging empty lust id key (" + str(row) + ")");
               row[2] = "unk_id" + str(key);
               key = key + 1;
               boo_update = True;
               
            if str_state is None:
               arcpy.AddMessage(".   plugging empty state key (" + str(row) + ")");
               row[0] = 'Unknown';
               boo_update = True;
               
            if boo_update:
               ucursor.updateRow(row);
               cnt = cnt + 1;
               
      arcpy.AddMessage(". " + str(cnt) + " resources records with empty keys updated.");
      
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Plugging empty usts keys with placeholders.");
      with arcpy.da.UpdateCursor(
          in_table     = usts
         ,field_names  = [
             'state'
            ,'facility_id'
            ,'tank_id'
            ,'tank_status'
            ,'installation_date'
            ,'removal_date'     
            ,'capacity'       
            ,'substances'   
            ,'tank_wall_type'   
          ]
         ,sql_clause = (None,'ORDER BY state')
      ) as ucursor:
         
         for row in ucursor:
            str_state       = row[0];
            str_facility_id = row[1];
            str_tank_id     = row[2];
            
            boo_update = False;
            if str_tank_id is None:
               arcpy.AddMessage(".   plugging empty tank id key (" + str(row) + ")");
               row[2] = "unk_id" + str(key);
               key = key + 1;
               boo_update = True;
            
            if str_state is None:
               arcpy.AddMessage(".   plugging empty state key (" + str(row) + ")");
               row[0] = 'Unknown';
               boo_update = True;
               
            if boo_update:
               ucursor.updateRow(row);
               cnt = cnt + 1;
               
      arcpy.AddMessage(". " + str(cnt) + " ust records with empty keys updated");
      
      #########################################################################
      arcpy.AddMessage("Setting up dups temp tables.");
      
      conn    = sqlite3.connect(aprx.defaultGeodatabase);
      cursor  = conn.cursor();
      cursor2 = conn.cursor();
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_fac_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_fac_dups(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(facility_id,state)
         )
      """);
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_rel_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_rel_dups(
             faclust_id  TEXT(255)
            ,state       TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(faclust_id,state)
         )
      """);
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_usts_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_usts_dups(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,tank_id     TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(facility_id,state,tank_id)
         )
      """);
      
      conn.commit();
      
      #########################################################################
      arcpy.AddMessage("Loading dups into temp tables.");
      
      cursor.execute("""
         INSERT INTO main.temp_fac_dups(
             facility_id
            ,state
            ,dupcount
         )
         SELECT
          a.facility_id
         ,a.state
         ,COUNT(*) AS dupcount
         FROM
         main.facilities a
         GROUP BY
          a.facility_id
         ,a.state
         HAVING
         COUNT(*) > 1
      """);
      
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_fac_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". Facilities dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      cursor.execute("""
         INSERT INTO main.temp_rel_dups(
             faclust_id
            ,state
            ,dupcount
         )
         SELECT
          COALESCE(a.facility_id,'') || a.lust_id
         ,a.state
         ,COUNT(*) AS dupcount
         FROM
         main.releases a
         GROUP BY
          COALESCE(a.facility_id,'') || a.lust_id
         ,a.state
         HAVING
         COUNT(*) > 1
      """);
  
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_rel_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". Releases dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      cursor.execute("""
         INSERT INTO main.temp_usts_dups(
             facility_id
            ,state
            ,tank_id
            ,dupcount
         )
         SELECT
          a.facility_id
         ,a.state
         ,a.tank_id
         ,COUNT(*) AS dupcount
         FROM
         main.usts a
         GROUP BY
          a.facility_id
         ,a.state
         ,a.tank_id
         HAVING
         COUNT(*) > 1
      """);
      
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_usts_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". USTS dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      conn.commit();
                    
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing facilities dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.dupcount
         FROM
         main.temp_fac_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.facility_id
            ,a.state
            ,a.name
            ,a.address
            ,a.city
            ,a.county
            ,a.zip_code
            ,a.address_match_type
            ,a.tos_usts
            ,a.landuse
            ,a.facility_status
            ,a.date_of_last_inspection
            ,a.epa_region
            ,a.tribe
            FROM
            main.facilities a
            WHERE
                a.facility_id = ?
            AND a.state = ?
         """,[row[0],row[1]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid   = row2[0];
            name       = row2[3];
            address    = row2[4];
            city       = row2[5];
            county     = row2[6];
            zip_code   = row2[7];
            address_match_type = row2[8];
            tos_usts   = row2[9];
            landuse    = row2[10];
            facility_status = row2[11];
            date_of_last_inspection = row2[12];
            epa_region = row2[13];
            tribe      = row2[14];
            
            if name is not None:
               score += 1;
            
            if address is not None:
               score += 1;
            
            if city is not None:
               score += 1;
            
            if county is not None:
               score += 1;
            
            if zip_code is not None:
               if zip_code == '0':
                  score += -1;
               else:
                  score += 1;
            
            if address_match_type is not None:
               if address_match_type == 'PointAddress':
                  score += 2;
               elif address_match_type == 'Fail':
                  score += -5;
               else:
                  score += 1;
               
            if tos_usts is not None:
               score += 1;
               
            if landuse is not None:
               score += 1;
            
            if facility_status is not None:
               if facility_status == 'Open UST(s)':
                  score += 2;
               else:
                  score += 1;
               
            if date_of_last_inspection is not None:
               score += 1;
            
            if epa_region is not None:
               if epa_region == 0:
                  score += -1;
               else:
                  score += 2;
            
            if tribe is not None:
               score += 3;
            
            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[1]) + " " + str(row[0]) + " having " + str(row[2]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.facilities
            WHERE
                facility_id = ?
            AND state       = ?
            AND objectid   != ?
         """,[row[0],row[1],winner[0]]);
         cnt = cnt + row[2] - 1;
      
      conn.commit();
      arcpy.AddMessage(". removed " + str(cnt) + " facilities dups.");
      
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing releases dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.faclust_id
         ,a.state
         ,a.dupcount
         FROM
         main.temp_rel_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.facility_id
            ,a.lust_id
            ,a.state
            ,a.name
            ,a.address
            ,a.city
            ,a.county
            ,a.zip_code
            ,a.address_match_type
            ,a.status
            ,a.substance
            ,a.epa_region
            ,a.tribe
            ,a.nfa_letter_1
            ,a.nfa_letter_2
            ,a.nfa_letter_3
            ,a.nfa_letter_4
            FROM
            main.releases a
            WHERE
                COALESCE(a.facility_id,'') || a.lust_id  = ?
            AND a.state = ?
            ORDER BY
            a.reported_date DESC            
         """,[row[0],row[1]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid     = row2[0];
            facility_id  = row2[1];
            name         = row2[4];
            address      = row2[5];
            city         = row2[6];
            county       = row2[7];
            zip_code     = row2[8];
            address_match_type = row2[9];
            status       = row2[10];
            substance    = row2[11];
            epa_region   = row2[12];
            tribe        = row2[13];
            nfa_letter_1 = row2[14];
            nfa_letter_2 = row2[15];
            nfa_letter_3 = row2[16];
            nfa_letter_4 = row2[17];
            
            if name is not None:
               score += 1;
            
            if address is not None:
               score += 1;
            
            if city is not None:
               score += 1;
            
            if county is not None:
               score += 1;
            
            if zip_code is not None:
               if zip_code == '0':
                  score += -1;
               else:
                  score += 1;
            
            if address_match_type is not None:
               if address_match_type == 'PointAddress':
                  score += 2;
               elif address_match_type == 'Fail':
                  score += -5;
               elif address_match_type == 'DistanceMarker':
                  score += 1;
               else:
                  score += 1;
               
            if status is not None:
               if status.lower() == 'open':
                  score += 2;
               elif status.lower() == 'no further action':
                  score += 1;
               else:
                  score += 1;
               
            if substance is not None:
               if substance.lower()[0:7] == 'unknown':
                  if substance.lower() == 'unknown petroleum':
                     score += 1;
                  else:
                     score += 0;
               elif substance.lower()[0:8] == 'gasoline':
                  score += 2;
               elif substance.lower()[0:6] == 'diesel':
                  score += 2;
               elif substance.lower()[0:7] == 'benzene':
                  score += 2;
               elif substance.lower()[0:9] == 'petroleum':
                  score += 2;
               else:
                  score += 1;
            
            if epa_region is not None:
               if epa_region == 0:
                  score += -1;
               else:
                  score += 2;
            
            if tribe is not None:
               score += 3;
            
            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " having " + str(row[2]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.releases
            WHERE
                COALESCE(facility_id,'') || lust_id = ?
            AND state       = ?
            AND objectid   != ?
         """,[row[0],row[1],winner[0]]);
         cnt = cnt + row[2] - 1;
      
      conn.commit();
      arcpy.AddMessage(". removed " + str(cnt) + " releases dups.");
      
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing usts dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.tank_id
         ,a.dupcount
         FROM
         main.temp_usts_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.facility_id
            ,a.state
            ,a.tank_id
            
            ,a.tank_status
            ,a.installation_date
            ,a.removal_date
            ,a.capacity
            ,a.substances
            ,a.tank_wall_type
            FROM
            main.usts a
            WHERE
                a.facility_id = ?
            AND a.state = ?
            AND a.tank_id  = ? 
            ORDER BY
            a.removal_date DESC            
         """,[row[0],row[1],row[2]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid          = row2[0];
            facility_id       = row2[1];
            
            tank_status       = row2[4];
            installation_date = row2[5];
            removal_date      = row2[6];
            capacity          = row2[7];
            substances        = row2[8];
            tank_wall_type    = row2[9];
            
            if tank_status is not None:
               score += 1;
            
            if installation_date is not None:
               score += 1;
            
            if removal_date is not None:
               score += 1;
            
            if capacity is not None:
               score += 1;
            
            if substances is not None:
               score += 1;
            
            if tank_wall_type is not None:
               score += 1;

            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " " + str(row[2]) + " having " + str(row[3]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.usts
            WHERE
                facility_id = ?
            AND state       = ?
            AND tank_id     = ?
            AND objectid   != ?
         """,[row[0],row[1],row[2],winner[0]]); 
         cnt = cnt + row[3] - 1; 
      
      conn.commit();
      
      del conn;
      arcpy.AddMessage(". removed " + str(cnt) + " usts dups.");
      
      #########################################################################      
      cnt1 = 0;
      cnt2 = 0;
      cnt3 = 0;
      cnt4 = 0;
      bad1 = 0;
      bad2 = 0;
      bad3 = 0;
      bad4 = 0;
      arcpy.AddMessage("Checking NFA URL validity.");
      
      cnt = 0;
      with arcpy.da.SearchCursor(
          in_table     = rel
         ,field_names  = ['lust_id','tribe','nfa_letter_1','nfa_letter_2','nfa_letter_3','nfa_letter_4']
         ,where_clause = 'nfa_letter_1 IS NOT NULL OR nfa_letter_2 IS NOT NULL OR nfa_letter_3 IS NOT NULL OR nfa_letter_4 IS NOT NULL' 
      ) as scursor:
         
         for row in scursor:
         
            lust_id      = row[0];
            tribe        = row[1];
            nfa_letter_1 = row[2];
            nfa_letter_2 = row[3];
            nfa_letter_3 = row[4];
            nfa_letter_4 = row[5];
      
            if nfa_letter_1 is not None:
               cnt1 = cnt1 + 1;
               z = requests.head(nfa_letter_1);
               if z.status_code != 200:
                  arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 1 " + nfa_letter_1 + " returned status " + str(z.status_code));
                  bad1 = bad1 + 1;
      
            if nfa_letter_2 is not None:
               cnt2 = cnt2 + 1;
               z = requests.head(nfa_letter_2);
               if z.status_code != 200:
                  arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 2 " + nfa_letter_2 + " returned status " + str(z.status_code));
                  bad2 = bad2 + 1;
                  
            if nfa_letter_3 is not None:
               cnt3 = cnt3 + 1;
               z = requests.head(nfa_letter_3);
               if z.status_code != 200:
                  arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 3 " + nfa_letter_3 + " returned status " + str(z.status_code));
                  bad3 = bad3 + 1;
                  
            if nfa_letter_4 is not None:
               cnt4 = cnt4 + 1;
               z = requests.head(nfa_letter_4);
               if z.status_code != 200:
                  arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 4 " + nfa_letter_4 + " returned status " + str(z.status_code));
                  bad4 = bad4 + 1;
                  
            if cnt > 0 and cnt % 1000 == 0:
               arcpy.AddMessage(". checked " + str(cnt) + " nfa letter sets...");
            
            cnt = cnt + 1;
            
      
      arcpy.AddMessage(". checked " + str(cnt1) + " nfa 1 urls, found " + str(bad1) + " problems.");
      arcpy.AddMessage(". checked " + str(cnt2) + " nfa 2 urls, found " + str(bad2) + " problems."); 
      arcpy.AddMessage(". checked " + str(cnt3) + " nfa 3 urls, found " + str(bad3) + " problems.");     
      arcpy.AddMessage(". checked " + str(cnt4) + " nfa 4 urls, found " + str(bad4) + " problems.");
      
###############################################################################
class LoadTribalCSVsUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A4 Load Tribal CSVs";
      self.name               = "LoadTribalCSVs";
      self.description        = "LoadTribalCSVs";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      param0 = arcpy.Parameter(
          displayName   = "Tribal Facilities CSV"
         ,name          = "TribalFacilitiesCSV"
         ,datatype      = "DEFile"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param0.filter.list = ['txt','csv'];
      param0.value = os.path.join(aprx.homeFolder,g_tribal_fac);
      
      #########################################################################
      param1 = arcpy.Parameter(
          displayName   = "Tribal Releases CSV"
         ,name          = "TribalReleasesCSV"
         ,datatype      = "DEFile"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param1.filter.list = ['txt','csv'];
      param1.value = os.path.join(aprx.homeFolder,g_tribal_rel);
      
      #########################################################################
      param2 = arcpy.Parameter(
          displayName   = "Tribal USTs CSV"
         ,name          = "TribalUSTsCSV"
         ,datatype      = "DEFile"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param2.filter.list = ['txt','csv'];
      param2.value = os.path.join(aprx.homeFolder,g_tribal_usts);
      
      #########################################################################
      param3 = arcpy.Parameter(
          displayName   = "Tribal NFA CSV"
         ,name          = "TribalNFACSV"
         ,datatype      = "DEFile"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param3.filter.list = ['txt','csv'];
      param3.value = os.path.join(aprx.homeFolder,g_tribal_nfa);
      
      params = [
          param0
         ,param1
         ,param2
         ,param3
      ];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................

   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):
      
      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      src_fac  = parameters[0].valueAsText;
      src_rel  = parameters[1].valueAsText;
      src_usts = parameters[2].valueAsText;
      src_nfa  = parameters[3].valueAsText;
      
      #########################################################################
      trb_fac  = g_config.datasource('tribal_fac',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_fac):
         raise Exception('tribal facilities table not found');
      arcpy.management.TruncateTable(in_table = trb_fac);
      
      trb_rel  = g_config.datasource('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_rel):
         raise Exception('tribal releases table not found');
      arcpy.management.TruncateTable(in_table = trb_rel);
      
      trb_usts = g_config.datasource('tribal_usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_usts):
         raise Exception('tribal USTs table not found');
      arcpy.management.TruncateTable(in_table = trb_usts);
      
      trb_nfa  = g_config.datasource('tribal_nfa',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_nfa):
         raise Exception('tribal nfa table not found');
      arcpy.management.TruncateTable(in_table = trb_nfa);
      
      #########################################################################
      def genfile_rows(csv_file):
         cnt = 0;
         with open(csv_file,'r',newline='') as file:
            reader = csv.reader(file);
            cnt = sum(1 for row in reader);
            cnt = cnt - 1;
            
         return cnt;
      
      #########################################################################
      arcpy.AddMessage("Loading tribal facilities CSV");
      
      etl_dict = g_config.lkup('tribal_fac','etl','etl',aprx=aprx,wrkspc=wrkspc);
      bef_cnt = genfile_rows(src_fac);
      arcpy.AddMessage(". tribal facilities CSV has " + str(bef_cnt) + " data rows");
      
      with arcpy.da.InsertCursor(
          in_table    = trb_fac
         ,field_names = g_config.flds('tribal_fac',aprx=aprx,wrkspc=wrkspc,match_etl=True)
      ) as icursor:
      
         with open(src_fac,'r') as file:
            reader = csv.DictReader(file);
            headers = reader.fieldnames;
         
            for row in reader:
               inrow = [None] * len(etl_dict);
              
               for item in headers:
              
                  if item in etl_dict:
                     inrow[etl_dict[item]] = dznull(row[item]);
                     
               icursor.insertRow(inrow);
               
      aft_cnt = arcpy.management.GetCount(trb_fac)[0];
      arcpy.AddMessage(". target has " + str(aft_cnt) + " records."); 
      
      #########################################################################
      cnt = 0;
      arcpy.AddMessage("Adjusting tribal facilities longitudes");
      with arcpy.da.UpdateCursor(
          in_table    = trb_fac
         ,field_names = ['State','Longitude']
      ) as ucursor:
         
         for row in ucursor:
            
            if row[0] not in ['Hawaii','American Samoa','Guam','Commonwealth of the Northern Mariana Islands','Northern Mariana Islands']:
               if row[1] is not None and row[1] != "": 
                  num_long = float(row[1]);
                  if num_long > 0:
                     row[1] = str(num_long * -1);
                     ucursor.updateRow(row);
                     cnt = cnt + 1;
                  
      arcpy.AddMessage(". poked longitude for " + str(cnt) + " facilities records."); 
         
      #########################################################################
      arcpy.AddMessage("Loading tribal releases CSV");

      etl_dict = g_config.lkup('tribal_rel','etl','etl',aprx=aprx,wrkspc=wrkspc);
      bef_cnt = genfile_rows(src_rel);
      arcpy.AddMessage(". tribal releases CSV has " + str(bef_cnt) + " data rows");
      
      with arcpy.da.InsertCursor(
          in_table    = trb_rel
         ,field_names = g_config.flds('tribal_rel',aprx=aprx,wrkspc=wrkspc,match_etl=True)
      ) as icursor:
      
         with open(src_rel,'r') as file:
            reader = csv.DictReader(file);
            headers = reader.fieldnames;
         
            for row in reader:
               inrow = [None] * len(etl_dict);
              
               for item in headers:
              
                  if item in etl_dict:
                     inrow[etl_dict[item]] = dznull(row[item]);
                     
               icursor.insertRow(inrow);
               
      aft_cnt = arcpy.management.GetCount(trb_rel)[0];
      arcpy.AddMessage(". target has " + str(aft_cnt) + " records.");
      
      #########################################################################
      cnt = 0;
      arcpy.AddMessage("Adjusting tribal releases longitudes");
      with arcpy.da.UpdateCursor(
          in_table    = trb_rel
         ,field_names = ['State','Longitude']
      ) as ucursor:
         
         for row in ucursor:
            
            if row[0] not in ['Hawaii','American Samoa','Guam','Northern Mariana Islands']:
               if row[1] is not None and row[1] != "": 
                  num_long = float(row[1]);
                  if num_long > 0:
                     row[1] = str(num_long * -1);
                     ucursor.updateRow(row);
                     cnt = cnt + 1;
                  
      arcpy.AddMessage(". poked longitude for " + str(cnt) + " releases records."); 
                        
      #########################################################################
      arcpy.AddMessage("Loading tribal USTs CSV");
      
      etl_dict = g_config.lkup('tribal_usts','etl','etl',aprx=aprx,wrkspc=wrkspc);
      bef_cnt = genfile_rows(src_usts);
      arcpy.AddMessage(". tribal USTs CSV has " + str(bef_cnt) + " data rows")
      
      cnt = 0;
      filter_cnt = 0;
      with arcpy.da.InsertCursor(
          in_table    = trb_usts
         ,field_names = g_config.flds('tribal_usts',aprx=aprx,wrkspc=wrkspc,match_etl=True)
      ) as icursor:
      
         with open(src_usts,'r') as file:
            reader = csv.DictReader(file);
            headers = reader.fieldnames;
         
            for row in reader:
               inrow = [None] * len(etl_dict);
              
               boo_insert = True;
               for item in headers:
              
                  if item in etl_dict:
                     val = dznull(row[item]);
                     
                     if item.lower() == 'tank_status' and val is not None:
                        if 1==2:
                           filter_cnt = filter_cnt + 1;
                           boo_insert = False;
                           
                     inrow[etl_dict[item]] = val;
                     
               if boo_insert:
                  icursor.insertRow(inrow);
                  cnt = cnt + 1;
                  
      arcpy.AddMessage(". " + str(cnt) + " loaded with " + str(filter_cnt) + " records removed.");
               
      aft_cnt = arcpy.management.GetCount(trb_usts)[0];
      arcpy.AddMessage(". target has " + str(aft_cnt) + " records."); 

      #########################################################################
      if src_nfa is not None and src_nfa != "":
         arcpy.AddMessage("Loading tribal NFA CSV");
         
         etl_dict = g_config.lkup('tribal_nfa','etl','etl',aprx=aprx,wrkspc=wrkspc);
         bef_cnt = genfile_rows(src_nfa);
         arcpy.AddMessage(". tribal NFA CSV has " + str(bef_cnt) + " data rows")
         
         with arcpy.da.InsertCursor(
             in_table    = trb_nfa
            ,field_names = g_config.flds('tribal_nfa',aprx=aprx,wrkspc=wrkspc,match_etl=True)
         ) as icursor:
         
            with open(src_nfa,'r') as file:
               reader = csv.DictReader(file);
               headers = reader.fieldnames;
            
               for row in reader:
                  inrow = [None] * len(etl_dict);
                 
                  for item in headers:
                 
                     if item in etl_dict:
                        # Force Region back to string
                        if item == 'Region':
                           inrow[etl_dict[item]] = str(row[item]);
                        else:
                           inrow[etl_dict[item]] = dznull(row[item]);
                        
                  icursor.insertRow(inrow);
                  
         aft_cnt = arcpy.management.GetCount(trb_nfa)[0];
         arcpy.AddMessage(". target has " + str(aft_cnt) + " records."); 
                  
      #########################################################################
      update_cnt = 0;
      delete_cnt = 0;
      arcpy.AddMessage("Altering tribal facilities inputs per client requests");
      with arcpy.da.UpdateCursor(
          in_table    = trb_fac
         ,field_names = ['Location_ID','State','Facility_Status']
      ) as ucursor:
         
         for row in ucursor:
            
            if row[2] is None or row[2] == '' or row[2] == ' ':
               arcpy.AddMessage("Deleting tribal facilities " + str(row[0]) + " " + str(row[1]) + " having blank status");
               ucursor.deleteRow();
               delete_cnt = delete_cnt + 1;
               
            else:
               boo_update = False;
               
               if len(row[0]) != len(row[0].strip()):
                  row[0] = row[0].strip();
                  boo_update = True;
                  
               if len(row[1]) != len(row[1].strip()):
                  row[1] = row[1].strip();
                  boo_update = True;
               
               if row[2].lower() in  ['non-operating','abandoned','operating','temporary closed']:
                  row[2] = 'Open UST(s)';
                  boo_update = True;
               
               if row[2].lower() in  ['permanent closed']:
                  row[2] = 'Closed UST(s)';
                  boo_update = True;
               
               if boo_update:
                  ucursor.updateRow(row);
                  update_cnt = update_cnt + 1;
                  
      arcpy.AddMessage(". updated " + str(update_cnt) + " tribal facilities inputs per facility status condition");
      arcpy.AddMessage(". deleted " + str(delete_cnt) + " tribal facilities inputs per facility status condition");
                  
      #########################################################################
      update_cnt = 0;
      arcpy.AddMessage("Altering tribal releases inputs per client requests");
      with arcpy.da.UpdateCursor(
          in_table    = trb_rel
         ,field_names = ['Location_ID','State','LUST_ID','Status']
      ) as ucursor:
         
         for row in ucursor:
            
            boo_update = False;
            if len(row[0]) != len(row[0].strip()):
               row[0] = row[0].strip();
               boo_update = True;
               
            if len(row[1]) != len(row[1].strip()):
               row[1] = row[1].strip();
               boo_update = True;
               
            if len(row[2]) != len(row[2].strip()):
               row[2] = row[2].strip();
               boo_update = True;
                  
            if row[3] is not None:
               if row[3].lower() == 'closed':
                  row[3] = 'No Further Action';
                  boo_update = True;
               elif row[3].lower() == 'unkown':
                  row[3] = 'Unknown';
                  boo_update = True;
                  
            if boo_update:
               ucursor.updateRow(row);
               
      arcpy.AddMessage(". updated " + str(update_cnt) + " tribal releases inputs per facility status condition");
      
      #########################################################################
      update_cnt = 0;
      arcpy.AddMessage("Altering tribal usts inputs per client requests");
      with arcpy.da.UpdateCursor(
          in_table    = trb_usts
         ,field_names = ['State','Location_ID','Tank_ID']
      ) as ucursor:
         
         for row in ucursor:
            
            boo_update = False;
            if row[0] is not None:
               if len(row[0]) != len(row[0].strip()):
                  row[0] = row[0].strip();
                  boo_update = True;
               
            if len(row[1]) != len(row[1].strip()):
               row[1] = row[1].strip();
               boo_update = True;
               
            if len(row[2]) != len(row[2].strip()):
               row[2] = row[2].strip();
               boo_update = True;
                  
            if boo_update:
               ucursor.updateRow(row);
               
      arcpy.AddMessage(". updated " + str(update_cnt) + " tribal usts inputs per facility status condition");
      
      #########################################################################
      arcpy.AddMessage("Setting up to dedup tribal CSVs");
      conn    = sqlite3.connect(aprx.defaultGeodatabase);
      cursor  = conn.cursor();
      cursor2 = conn.cursor();
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_tribal_fac_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_tribal_fac_dups(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(facility_id,state)
         )
      """);
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_tribal_rel_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_tribal_rel_dups(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,lust_id     TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(facility_id,state,lust_id)
         )
      """);
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_tribal_usts_dups""");
      cursor.execute("""
         CREATE TABLE main.temp_tribal_usts_dups(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,tank_id     TEXT(255)
            ,dupcount    INTEGER
            ,dupscore    INTEGER
            ,PRIMARY KEY(facility_id,state,tank_id)
         )
      """);
      
      #########################################################################
      arcpy.AddMessage("Loading dups into temp tables.");
      
      cursor.execute("""
         INSERT INTO main.temp_tribal_fac_dups(
             facility_id
            ,state
            ,dupcount
         )
         SELECT
          a.location_id
         ,a.state
         ,COUNT(*) AS dupcount
         FROM
         main.tribal_fac a
         GROUP BY
          a.location_id
         ,a.state
         HAVING
         COUNT(*) > 1
      """);
      
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_tribal_fac_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". tribal facilities dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      cursor.execute("""
         INSERT INTO main.temp_tribal_rel_dups(
             facility_id
            ,state
            ,lust_id
            ,dupcount
         )
         SELECT
          a.location_id
         ,a.state
         ,a.lust_id
         ,COUNT(*) AS dupcount
         FROM
         main.tribal_rel a
         GROUP BY
          a.location_id
         ,a.state
         ,a.lust_id
         HAVING
         COUNT(*) > 1
      """);
      
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_tribal_rel_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". tribal releases dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      cursor.execute("""
         INSERT INTO main.temp_tribal_usts_dups(
             facility_id
            ,state
            ,tank_id
            ,dupcount
         )
         SELECT
          a.location_id
         ,a.state
         ,a.tank_id
         ,COUNT(*) AS dupcount
         FROM
         main.tribal_usts a
         GROUP BY
          a.location_id
         ,a.state
         ,a.tank_id
         HAVING
         COUNT(*) > 1
      """);
      
      cursor.execute("""
         SELECT
          a.state
         ,SUM(a.actual_dups) AS actual_dupcount
         FROM (
            SELECT
             aa.state
            ,aa.dupcount - 1 AS actual_dups
            FROM
            main.temp_tribal_usts_dups aa
         ) a
         GROUP BY         
         a.state
         ORDER BY         
         a.state
      """);
      
      arcpy.AddMessage(". tribal usts dups by state");
      for row in cursor:
         arcpy.AddMessage(".    " + row[0] + ": " + str(row[1]));
      
      conn.commit();

      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing tribal fac dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.dupcount
         FROM
         main.temp_tribal_fac_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.location_id
            ,a.state
            
            ,a.region
            ,a.tribe
            ,a.name
            ,a.address
            ,a.city
            ,a.county
            ,a.zip
            ,a.temporarily_out_of_service_usts
            ,a.facility_status
            ,a.date_of_last_inspection
            FROM
            main.tribal_fac a
            WHERE
                a.location_id = ?
            AND a.state = ?
            ORDER BY 
            a.date_of_last_inspection DESC
         """,[row[0],row[1]]);
         
         for row2 in cursor2:
            score = 0;
            
            objectid                = row2[0];
            
            epa_region              = row2[3];
            tribe                   = row2[4];
            name                    = row2[5];
            address                 = row2[6];
            city                    = row2[7];
            county                  = row2[8];
            zip_code                = row2[9];
            tos_usts                = row2[10];
            facility_status         = row2[11];
            date_of_last_inspection = row2[12];
            
            if name is not None:
               score += 1;
            
            if address is not None:
               score += 1;
            
            if city is not None:
               score += 1;
            
            if county is not None:
               score += 1;
            
            if zip_code is not None:
               if zip_code == '0':
                  score += -1;
               else:
                  score += 1;
               
            if tos_usts is not None:
               score += 1;
            
            if facility_status is not None:
               if facility_status == 'Open UST(s)':
                  score += 2;
               else:
                  score += 1;
               
            if date_of_last_inspection is not None:
               score += 1;
            
            if epa_region is not None:
               if epa_region == 0:
                  score += -1;
               else:
                  score += 2;
            
            if tribe is not None:
               score += 3;
            
            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " having " + str(row[2]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.tribal_fac
            WHERE
                location_id = ?
            AND state       = ?
            AND objectid   != ?
         """,[row[0],row[1],winner[0]]);
         cnt = cnt + row[2] - 1;

      arcpy.AddMessage(". removed " + str(cnt) + " duplicate tribal facilities records.");
      conn.commit();

      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing tribal rel dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.lust_id
         ,a.dupcount
         FROM
         main.temp_tribal_rel_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.location_id
            ,a.state
            ,a.lust_id

            ,a.epa_region
            ,a.tribe
            ,a.name
            ,a.address
            ,a.city
            ,a.county
            ,a.zip
            ,a.status
            ,a.substance
            ,a.nfa_letter_1
            ,a.nfa_letter_2
            ,a.nfa_letter_3
            ,a.nfa_letter_4
            FROM
            main.tribal_rel a
            WHERE
                a.location_id = ?
            AND a.state       = ?
            AND a.lust_id     = ?
            ORDER BY
            a.reported_date DESC
         """,[row[0],row[1],row[2]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid           = row2[0];
            facility_id        = row2[1];
            state              = row2[2];
            lust_id            = row2[3];
            
            epa_region         = row2[4];
            tribe              = row2[5];
            name               = row2[6];
            address            = row2[7];
            city               = row2[8];
            county             = row2[9];
            zip_code           = row2[10];
            status             = row2[11];
            substance          = row2[12];
            nfa_letter_1       = row2[13];
            nfa_letter_2       = row2[14];
            nfa_letter_3       = row2[15];
            nfa_letter_4       = row2[16];
            
            if name is not None:
               score += 1;
            
            if address is not None:
               score += 1;
            
            if city is not None:
               score += 1;
            
            if county is not None:
               score += 1;
            
            if zip_code is not None:
               if zip_code == '0':
                  score += -1;
               else:
                  score += 1;
               
            if status is not None:
               if status.lower() == 'open':
                  score += 2;
               elif status.lower() == 'no further action':
                  score += 1;
               else:
                  score += 1;
               
            if substance is not None:
               if substance.lower()[0:7] == 'unknown':
                  if substance.lower() == 'unknown petroleum':
                     score += 1;
                  else:
                     score += 0;
               elif substance.lower()[0:8] == 'gasoline':
                  score += 2;
               elif substance.lower()[0:6] == 'diesel':
                  score += 2;
               elif substance.lower()[0:7] == 'benzene':
                  score += 2;
               elif substance.lower()[0:9] == 'petroleum':
                  score += 2;
               else:
                  score += 1;
            
            if epa_region is not None:
               if epa_region == 0:
                  score += -1;
               else:
                  score += 2;
            
            if tribe is not None:
               score += 3;
            
            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " having " + str(row[2]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.tribal_rel
            WHERE
                location_id = ?
            AND state       = ?
            AND lust_id     = ?
            AND objectid   != ?
         """,[row[0],row[1],winner[0]]);  
         cnt = cnt + row[2] - 1;  
         
      arcpy.AddMessage(". removed " + str(cnt) + " duplicate tribal releases records.");
      conn.commit();
      
      #########################################################################      
      cnt = 0;
      arcpy.AddMessage("Scoring and removing tribal usts dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.tank_id
         ,a.dupcount
         FROM
         main.temp_tribal_usts_dups a
      """);
      
      for row in cursor:
         winner = [None,None];
         
         cursor2.execute("""
            SELECT
             a.objectid
            ,a.location_id
            ,a.tank_id
            ,a.state
            
            ,a.tank_status
            ,a.installation_date
            ,a.removal_date
            ,a.capacity
            ,a.substance_stored
            ,a.tank_wall_type
            FROM
            main.tribal_usts a
            WHERE
                a.location_id = ?
            AND a.state = ?
            AND a.tank_id  = ?            
         """,[row[0],row[1],row[2]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid          = row2[0];
            facility_id       = row2[1];
            state             = row2[2];
            tank_id           = row2[3];
            
            tank_status       = row2[4];
            installation_date = row2[5];
            removal_date      = row2[6];
            capacity          = row2[7];
            substances        = row2[8];
            tank_wall_type    = row2[9];
            
            if tank_status is not None:
               if tank_status.lower() == 'currently in use':
                  score += 5;
               elif tank_status.lower() == 'temporarily out of use':
                  score += 3;   
               elif tank_status.lower() == 'permanently out of use':
                  score += 1;
               else:
                  score += 3;
            
            if installation_date is not None:
               score += 1;
            
            if removal_date is not None:
               score += 1;
            
            if capacity is not None:
               score += 1;
               
            if substances is not None:
               score += 1;
            
            if tank_wall_type is not None:
               score += 1;

            if winner[0] is not None:
               if score > winner[1]:
                  winner[0] = objectid;
                  winner[1] = score;
             
            else:
               winner[0] = objectid;
               winner[1] = score;
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " " + str(row[2]) + " having " + str(row[3]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.tribal_usts
            WHERE
                location_id = ?
            AND state       = ?
            AND tank_id     = ?
            AND objectid   != ?
         """,[row[0],row[1],row[2],winner[0]]);  
         cnt = cnt + row[3] - 1;  
         
      arcpy.AddMessage(". removed " + str(cnt) + " duplicate tribal releases records.");
      conn.commit();
      
      #########################################################################
      arcpy.AddMessage("Reporting on NFA letters by Tribe BEFORE");

      cursor.execute("""
         SELECT
          a.tribe
         ,a.state
         ,COUNT(*)     AS total_records
         ,SUM(a.nfa_1) AS nfa_1_cnt
         ,SUM(a.nfa_2) AS nfa_2_cnt
         ,SUM(a.nfa_3) AS nfa_3_cnt
         ,SUM(a.nfa_4) AS nfa_4_cnt
         FROM (
            SELECT
             aa.tribe
            ,aa.state
            ,CASE
             WHEN aa.nfa_letter_1 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_1
            ,CASE
             WHEN aa.nfa_letter_2 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_2
            ,CASE
             WHEN aa.nfa_letter_3 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_3
            ,CASE
             WHEN aa.nfa_letter_4 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_4
            FROM
            main.tribal_rel aa
         ) a
         GROUP BY
          a.tribe
         ,a.state
         ORDER BY
          a.tribe
         ,a.state
      """);
      
      for row in cursor:
         arcpy.AddMessage(row[0] + "|" + str(row[1]) + '|' + str(row[2]) + '|' + str(row[3]) + '|' + str(row[4]) + '|' + str(row[5]) + '|' + str(row[6]));

      del conn;         
      
      #########################################################################
      def check_nfa(val,lust_id):
         
         if val is None or val == "" or val == " ":
            return None;
            
         pts = urlsplit(val.strip());
         qps = parse_qs(pts.query,keep_blank_values=True);
         ep = quote(pts.path);
         eq = urlencode(qps);
    
         eu = urlunsplit((pts.scheme,pts.netloc,ep,eq,pts.fragment));
         
         r = requests.head(eu);
         
         if r.status_code != 200:
            arcpy.AddMessage("QA check returned " + r.status_code + " for lust_id " + lust_id + " nfa url " + eu);
            
         return eu;
      
      #########################################################################
      if src_nfa is not None and src_nfa != "":
         cnt = 0;
         arcpy.AddMessage("Merging tribal nfa into tribal releases");
         
         with arcpy.da.SearchCursor(
             in_table    = trb_nfa
            ,field_names = g_config.flds('tribal_nfa',aprx=aprx,wrkspc=wrkspc)
         ) as scursor:
            
            for row in scursor:
               location_id = row[1];
               city        = row[5];
               lust_id     = row[16];
               state       = row[17];
               new_nfa_1   = check_nfa(row[18],lust_id);
               new_nfa_2   = check_nfa(row[19],lust_id);
               new_nfa_3   = check_nfa(row[20],lust_id);
               new_nfa_4   = check_nfa(row[21],lust_id);
               
               if new_nfa_1 is not None:
                  new_nfas = [];
                  
                  if new_nfa_1 is not None:
                     new_nfas.append(new_nfa_1);
                  if new_nfa_2 is not None:
                     new_nfas.append(new_nfa_2);
                  if new_nfa_3 is not None:
                     new_nfas.append(new_nfa_3);
                  if new_nfa_4 is not None:
                     new_nfas.append(new_nfa_4);
                  
                  with arcpy.da.UpdateCursor(
                      in_table    = trb_rel
                     ,field_names = g_config.flds('tribal_rel',aprx=aprx,wrkspc=wrkspc)
                     ,where_clause = "Location_ID = '" + str(location_id) + "' AND State = '" + str(state) + "' AND LUST_ID = '" + str(lust_id) + "'" 
                  ) as ucursor:
                     
                     boo_check = False;
                     boo_write = False;
                     
                     for row2 in ucursor:
                        boo_check   = True;
                        cur_nfa_1   = row2[17];
                        cur_nfa_2   = row2[18];
                        cur_nfa_3   = row2[19];
                        cur_nfa_4   = row2[20];
               
                        cur_nfas = [];
                        
                        if cur_nfa_1 is not None:
                           cur_nfas.append(cur_nfa_1);
                        if cur_nfa_2 is not None:
                           cur_nfas.append(cur_nfa_2);
                        if cur_nfa_3 is not None:
                           cur_nfas.append(cur_nfa_3);
                        if cur_nfa_4 is not None:
                           cur_nfas.append(cur_nfa_4);
                           
                        merged = new_nfas + list(set(cur_nfas) - set(new_nfas));
                        
                        if len(merged) > 0:
                           row2[17] = merged[0];
                           boo_write = True;
                           
                        if len(merged) > 1:
                           row2[18] = merged[1];
                           
                        if len(merged) > 2:
                           row2[19] = merged[2];
                           
                        if len(merged) > 3:
                           row2[20] = merged[3];
                           
                        if len(merged) > 4:
                           arcpy.AddMessage(".  more than four merged nfa values for " + str(location_id));
                           
                        if boo_write:
                           arcpy.AddMessage(".  updating " + str(location_id)); 
                           ucursor.updateRow(row2);
                           
                     if not boo_check:
                        arcpy.AddMessage(". warning, no match for nfa location_id " + str(location_id) + ", " + str(state) +", " + str(lust_id));
            
      #########################################################################
      arcpy.AddMessage("Reporting on NFA letters by Tribe AFTER");

      conn    = sqlite3.connect(aprx.defaultGeodatabase);
      cursor  = conn.cursor();
      
      cursor.execute("""
         SELECT
          a.tribe
         ,a.state
         ,COUNT(*)     AS total_records
         ,SUM(a.nfa_1) AS nfa_1_cnt
         ,SUM(a.nfa_2) AS nfa_2_cnt
         ,SUM(a.nfa_3) AS nfa_3_cnt
         ,SUM(a.nfa_4) AS nfa_4_cnt
         FROM (
            SELECT
             aa.tribe
            ,aa.state
            ,CASE
             WHEN aa.nfa_letter_1 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_1
            ,CASE
             WHEN aa.nfa_letter_2 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_2
            ,CASE
             WHEN aa.nfa_letter_3 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_3
            ,CASE
             WHEN aa.nfa_letter_4 IS NOT NULL
             THEN
               1
             ELSE
               0
             END AS nfa_4
            FROM
            main.tribal_rel aa
         ) a
         GROUP BY
          a.tribe
         ,a.state
         ORDER BY
          a.tribe
         ,a.state
      """);
      
      for row in cursor:
         arcpy.AddMessage(row[0] + "|" + str(row[1]) + '|' + str(row[2]) + '|' + str(row[3]) + '|' + str(row[4]) + '|' + str(row[5]) + '|' + str(row[6]));
 
      del conn;
      #########################################################################
      arcpy.AddMessage("Tribal CSVs loaded.");

###############################################################################
class GeocodeTribalUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A5 Geocode Tribal Data";
      self.name               = "GeocodeTribalUST";
      self.description        = "GeocodeTribalUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      tribal_fac  = g_config.datasource('tribal_fac',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(tribal_fac):
         raise Exception('tribal_fac not found');
      tribal_rel  = g_config.datasource('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(tribal_rel):
         raise Exception('tribal_rel not found');
      
      #########################################################################
      result = arcpy.management.GetCount(tribal_fac);
      fac_count = int(result[0]);
      
      result = arcpy.management.GetCount(tribal_rel);
      rel_count = int(result[0]);
      
      if fac_count == 0 and rel_count == 0:
         arcpy.AddError("no records found to geocode");
         raise Exception;
         
      else:
         arcpy.AddMessage("tribal facilities have " + str(fac_count) + " total records.");
         arcpy.AddMessage("tribal releases have " + str(rel_count) + " total records.");
      
      #########################################################################
      portalurl = arcpy.GetActivePortalURL();
      pi = arcpy.GetPortalInfo(portal_URL=portalurl);
      
      # Remove this to allow credits geocoding
      if 'organization' not in pi or pi['organization'] != 'U.S. EPA':
         arcpy.AddError("active portal not set to EPA");
         raise Exception;
      
      signin = arcpy.GetSigninToken();
      if signin is None:
         arcpy.AddError("Portal unknown, you may need to log into EPA Geoplatform");
         
      token = signin['token'];
      
      gis = GIS(
          url   = portalurl
         ,token = token
      );
      
      # Remove the reference to EPA geoportal guid to use credits
      gs = gis.content.get(g_epa_gc);
      gc = Geocoder.fromitem(gs);
      
      #########################################################################
      gcnt = 0;
      with arcpy.da.UpdateCursor(
          tribal_fac
         ,[
             'OID@'
            ,'longitude'
            ,'latitude'
            
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            ,'state'
            ,'zip'
            ,'address_match_type'
            ,'lat_lon_source'
          ]
      ) as ucursor:
            
         for row in ucursor:
            
            int_oid          = row[0];
            preexisting_long = lust_float(row[1]);
            preexisting_lat  = lust_float(row[2]);
            str_name         = row[3];
            str_street       = row[4];
            str_city         = row[5];
            str_county       = row[6];
            str_state        = row[7];
            str_zip_raw      = str(row[8]);
            if str_zip_raw.find('-') > 0:
               (str_zip,str_zip4)  = str_zip_raw.split('-');
    
            else:
               (str_zip,str_zip4)  = (str_zip_raw,None);
            
            boo_do_geocode = True;
            
            if preexisting_long is None \
            or preexisting_lat  is None \
            or preexisting_long == 0    \
            or preexisting_lat  == 0:
               boo_do_geocode = True;
            
            else:
               geom_wgs84 = configdz.ConfigDZ.coord2shape(
                   preexisting_long
                  ,preexisting_lat
                  ,g_lust_srid
                  ,4326
               );
            
               if geom_wgs84.within(g_conus):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_alaska):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_hawaii):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_prvi):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_gump):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_amsamoa):
                  boo_do_geocode = False;
            
            if boo_do_geocode:
                  
               address = {};
                
               address['OBJECTID'] = int_oid;
              
               if str_street is not None:
                  address['Address'] = str_street;

               if str_name is not None:
                  address['POI'] = str_name;
               
               if str_city is not None:
                  address['City'] = str_city;
                  
               if str_county is not None:
                  address['Subregion'] = str_county;
               
               if str_state is not None:
                  address['Region'] = str_state;
                  
               if str_zip is not None:
                  address['Postal'] = str_zip;
                  
               if str_zip4 is not None:
                  address['PostalExt'] = str_zip4;
                  
               try:
                  bgc = geocode(
                      address       = address
                     ,geocoder      = gc
                     ,location_type = 'rooftop'
                  );

               except Exception as e:
                  
                  if hasattr(e, 'message'):
                     arcpy.AddMessage(e.message);
                  
                     bgc = geocode(
                         address       = address
                        ,geocoder      = gc
                        ,location_type = 'rooftop'
                     );

               if bgc is not None:                           
                  #arcpy.AddMessage(str(bgc));
                  
                  row[1]  = bgc[0]['attributes']['DisplayX'];
                  row[2]  = bgc[0]['attributes']['DisplayY'];
                  
                  row[9]  = bgc[0]['attributes']['Addr_type'];
                  row[10] = 'Geocode';
                     
                  ucursor.updateRow(row);
                  gcnt += 1;
      
      arcpy.AddMessage("geocoded tribal facilities updating " + str(gcnt) + " records.");
      
      #########################################################################
      gcnt = 0;
      with arcpy.da.UpdateCursor(
          tribal_rel
         ,[
             'OID@'
            ,'longitude'
            ,'latitude'
            
            ,'name'
            ,'address'
            ,'city'
            ,'county'
            ,'state'
            ,'zip'
            ,'address_match_type'
            ,'lat_lon_source'
          ]
      ) as ucursor:
            
         for row in ucursor:
            
            int_oid          = row[0];
            preexisting_long = lust_float(row[1]);
            preexisting_lat  = lust_float(row[2]);
            name             = row[3];
            address          = row[4];
            city             = row[5];
            county           = row[6];
            state            = row[7];
            str_zip_raw      = str(row[8]);
            if str_zip_raw.find('-') > 0:
               (str_zip,str_zip4)  = str_zip_raw.split('-');
    
            else:
               (str_zip,str_zip4)  = (str_zip_raw,None);
            
            boo_do_geocode = True;
            
            if preexisting_long is None \
            or preexisting_lat  is None \
            or preexisting_long == 0    \
            or preexisting_lat  == 0:
               boo_do_geocode = True;
            
            else:
               geom_wgs84 = configdz.ConfigDZ.coord2shape(
                   preexisting_long
                  ,preexisting_lat
                  ,g_lust_srid
                  ,4326
               );
            
               if geom_wgs84.within(g_conus):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_alaska):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_hawaii):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_prvi):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_gump):
                  boo_do_geocode = False;
               elif geom_wgs84.within(g_amsamoa):
                  boo_do_geocode = False;
            
            if boo_do_geocode:
                  
               address = {};
                
               address['OBJECTID'] = int_oid;
              
               if str_street is not None:
                  address['Address'] = str_street;

               if str_name is not None:
                  address['POI'] = str_name;
               
               if str_city is not None:
                  address['City'] = str_city;
                  
               if str_county is not None:
                  address['Subregion'] = str_county;
               
               if str_state is not None:
                  address['Region'] = str_state;
                  
               if str_zip is not None:
                  address['Postal'] = str_zip;
                  
               if str_zip4 is not None:
                  address['PostalExt'] = str_zip4;
                  
               try:
                  bgc = geocode(
                      address       = address
                     ,geocoder      = gc
                     ,location_type = 'rooftop'
                  );

               except Exception as e:
                  
                  if hasattr(e, 'message'):
                     arcpy.AddMessage(e.message);
                  
                     bgc = geocode(
                         address       = address
                        ,geocoder      = gc
                        ,location_type = 'rooftop'
                     );

               if bgc is not None:
                  
                  row[1]  = bgc[0]['attributes']['DisplayX'];
                  row[2]  = bgc[0]['attributes']['DisplayY'];
                  
                  row[9]  = bgc[0]['attributes']['Addr_type'];
                  row[10] = 'Geocode';
                     
                  ucursor.updateRow(row);
                  gcnt += 1;
      
      arcpy.AddMessage("geocoded tribal releases updating " + str(gcnt) + " records.");
         
###############################################################################
class UpsertTribalDataUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A6 Upsert Tribal Data";
      self.name               = "UpsertTribalDataUST";
      self.description        = "UpsertTribalDataUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      fac = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
         
      rel = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
         
      fbc = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
         
      rbc = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found');
         
      usts = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(usts):
         raise Exception('usts not found');
         
      #########################################################################
      trb_fac  = g_config.datasource('tribal_fac',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_fac):
         raise Exception('tribal facilities table not found');
      
      trb_rel  = g_config.datasource('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_rel):
         raise Exception('tribal releases table not found');
      
      trb_usts = g_config.datasource('tribal_usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_usts):
         raise Exception('tribal USTs table not found');
 
      #########################################################################
      cnt = 0;
      with arcpy.da.SearchCursor(
          in_table     = fac
         ,field_names  = "SHAPE@"
      ) as curs:
         for row in curs:
            if row[0] is None:
               cnt = cnt + 1;
               
      arcpy.AddMessage(". BEFORE upsert facilities has " + str(cnt) + " null geometries");
      
      cnt = 0;
      with arcpy.da.SearchCursor(
          in_table     = rel
         ,field_names  = "SHAPE@"
      ) as curs:
         for row in curs:
            if row[0] is None:
               cnt = cnt + 1;
               
      arcpy.AddMessage(". BEFORE upsert releases has " + str(cnt) + " null geometries");
      
      #########################################################################
      arcpy.AddMessage("Determining upsert workload");
      
      conn = sqlite3.connect(aprx.defaultGeodatabase);
      cursor = conn.cursor();
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_fac_work""");
      
      cursor.execute("""
         CREATE TABLE main.temp_fac_work(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,actiontaken TEXT(255)
            ,PRIMARY KEY(facility_id,state)
         )
      """);
      
      cursor.execute("""CREATE INDEX temp_fac_work_01i ON temp_fac_work(facility_id)""");
      cursor.execute("""CREATE INDEX temp_fac_work_02i ON temp_fac_work(state)""");
      cursor.execute("""CREATE INDEX temp_fac_work_03i ON temp_fac_work(actiontaken)""");
 
      cursor.execute("""    
         INSERT INTO main.temp_fac_work(
             facility_id 
            ,state
            ,actiontaken
         )
         SELECT
          a.facility_id
         ,a.state
         ,CASE
          WHEN a.checkit IS NULL
          THEN
            'INSERT'
          ELSE
            'UPDATE'
          END AS actiontaken
         FROM (
            SELECT
             aa.location_id AS facility_id
            ,aa.state
            ,bb.facility_id AS checkit
            FROM
            main.tribal_fac aa
            LEFT JOIN
            main.facilities bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state       = bb.state
         ) a
      """);
      cnt = cursor.rowcount;
      arcpy.AddMessage(". found " + str(cnt) + " tribal facilities to process");
      
      conn.commit();
      cursor.execute("""ANALYZE main.temp_fac_work""");
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_rel_work""");
      
      cursor.execute("""
         CREATE TABLE main.temp_rel_work(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,lust_id     TEXT(255)
            ,actiontaken TEXT(255)
            ,PRIMARY KEY(facility_id,state,lust_id)
         )
      """);

      cursor.execute("""CREATE INDEX temp_rel_work_01i ON temp_rel_work(facility_id)""");
      cursor.execute("""CREATE INDEX temp_rel_work_02i ON temp_rel_work(state)""");
      cursor.execute("""CREATE INDEX temp_rel_work_03i ON temp_rel_work(lust_id)""");
      cursor.execute("""CREATE INDEX temp_rel_work_04i ON temp_rel_work(actiontaken)""");
      
      cursor.execute("""    
         INSERT INTO main.temp_rel_work(
             facility_id
            ,state
            ,lust_id
            ,actiontaken
         )
         SELECT
          a.facility_id
         ,a.state
         ,a.lust_id
         ,CASE
          WHEN a.checkit IS NULL
          THEN
            'INSERT'
          ELSE
            'UPDATE'
          END AS actiontaken
         FROM (
            SELECT
             aa.location_id AS facility_id
            ,aa.state
            ,aa.lust_id
            ,bb.facility_id AS checkit
            FROM
            main.tribal_rel aa
            LEFT JOIN
            main.releases bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state       = bb.state
            AND aa.lust_id     = bb.lust_id
         ) a
      """);
      cnt = cursor.rowcount;
      arcpy.AddMessage(". found " + str(cnt) + " tribal releases to process");
      
      conn.commit();
      cursor.execute("""ANALYZE main.temp_rel_work""");
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_usts_work""");
      
      cursor.execute("""
         CREATE TABLE main.temp_usts_work(
             facility_id TEXT(255)
            ,state       TEXT(255)
            ,tank_id     TEXT(255)
            ,actiontaken TEXT(255)
            ,PRIMARY KEY(facility_id,state,tank_id)
         )
      """);
      
      cursor.execute("""CREATE INDEX temp_usts_work_01i ON temp_usts_work(facility_id)""");
      cursor.execute("""CREATE INDEX temp_usts_work_02i ON temp_usts_work(state)""");
      cursor.execute("""CREATE INDEX temp_usts_work_03i ON temp_usts_work(tank_id)""");
      cursor.execute("""CREATE INDEX temp_usts_work_04i ON temp_usts_work(actiontaken)""");
      
      cursor.execute("""    
         INSERT INTO main.temp_usts_work(
             facility_id
            ,state
            ,tank_id
            ,actiontaken
         )
         SELECT
          a.facility_id
         ,a.state
         ,a.tank_id
         ,CASE
          WHEN a.checkit IS NULL
          THEN
            'INSERT'
          ELSE
            'UPDATE'
          END AS actiontaken
         FROM (
            SELECT
             aa.location_id AS facility_id
            ,aa.state
            ,aa.tank_id
            ,bb.facility_id AS checkit
            FROM
            main.tribal_usts aa
            LEFT JOIN
            main.usts bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state       = bb.state
            AND aa.tank_id     = bb.tank_id
         ) a
      """);
      cnt = cursor.rowcount;
      arcpy.AddMessage(". found " + str(cnt) + " tribal usts to process");
      
      conn.commit();
      cursor.execute("""ANALYZE main.temp_usts_work""");
      
      #########################################################################
      arcpy.AddMessage("Applying Inserts");
      
      cnt = 0;
      with arcpy.da.InsertCursor(
          in_table    = fac
         ,field_names = g_config.flds('facilities',aprx=aprx,wrkspc=wrkspc) + ["SHAPE@"]
      ) as icursor:
         
         cursor.execute("""
            SELECT
             a.facility_id
            ,b.name
            ,b.address
            ,b.city
            ,b.county
            ,a.state
            ,b.zip AS zip_code
            ,b.latitude
            ,b.longitude
            ,b.lat_lon_source AS coordinate_source
            ,b.address_match_type
            ,CAST(b.open_usts AS INTEGER) AS open_usts 
            ,CAST(b.closed_usts AS INTEGER) AS closed_usts
            ,CAST(b.temporarily_out_of_service_usts AS INTEGER) AS tos_usts
            ,CAST(NULL AS INTEGER) AS population_1500ft
            ,CAST(NULL AS INTEGER) AS private_wells_1500ft
            ,CAST(NULL AS TEXT) AS within_100yr_floodplain
            ,CAST(NULL AS TEXT) AS landuse
            ,CAST(NULL AS TEXT) AS within_spa
            ,CAST(NULL AS TEXT) AS spa_pws_facilityid
            ,CAST(NULL AS TEXT) AS spa_water_type
            ,CAST(NULL AS TEXT) AS spa_facility_type
            ,CAST(NULL AS TEXT) AS spa_huc12
            ,CAST(NULL AS TEXT) AS within_whpa
            ,CAST(NULL AS TEXT) AS whpa_pws_facilityid
            ,CAST(NULL AS TEXT) AS whpa_water_type
            ,CAST(NULL AS TEXT) AS whpa_facility_type
            ,CAST(NULL AS TEXT) AS whpa_huc12
            ,b.facility_status
            ,b.date_of_last_inspection
            ,b.region AS epa_region
            ,b.tribe
            ,CAST('I' AS TEXT) AS qa
            FROM
            main.temp_fac_work a
            JOIN
            main.tribal_fac b
            ON
                a.facility_id = b.location_id
            AND a.state       = b.state
            WHERE
            a.actiontaken = 'INSERT'
         """);

         for row in cursor:
      
            y_wgs84 = lust_float(row[7]);
            x_wgs84 = lust_float(row[8]);
           
            pnt_webmc = None;
            if  x_wgs84 is not None \
            and y_wgs84 is not None \
            and x_wgs84 != 0        \
            and y_wgs84 != 0:
               pnt_webmc = configdz.ConfigDZ.coord2shape(
                   p_x = x_wgs84
                  ,p_y = y_wgs84
               );
               
               if pnt_webmc is None:
                  raise Exception(row[0] + " " + row[1] + ": [" + str(x_wgs84) + "] [" + str(y_wgs84) + "]");
                  
            icursor.insertRow((
                lust_trim(row[0],255)
               ,lust_trim(row[1],255)
               ,lust_trim(row[2],255)
               ,lust_trim(row[3],255)
               ,lust_trim(row[4],255)
               ,lust_trim(row[5],255)
               ,lust_trim(row[6],255)
               ,y_wgs84
               ,x_wgs84
               ,lust_trim(row[9],255)
               ,lust_trim(row[10],255)
               ,lust_int(row[11])
               ,lust_int(row[12])
               ,lust_int(row[13])
               ,lust_int(row[14])
               ,lust_int(row[15])
               ,lust_trim(row[16],3)
               ,lust_trim(row[17],50)
               ,lust_trim(row[18],3)
               ,lust_trim(row[19],254)
               ,lust_trim(row[20],254)
               ,lust_trim(row[21],254) 
               ,lust_trim(row[22],3)
               ,lust_trim(row[23],254) 
               ,lust_trim(row[24],3)
               ,lust_trim(row[25],254) 
               ,lust_trim(row[26],254) 
               ,lust_trim(row[27],254)
               ,lust_trim(row[28],254)
               ,lust_time(row[29]) 
               ,lust_int(row[30]) 
               ,lust_trim(row[31],8000)
               ,row[32]
               ,pnt_webmc
            ));

            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   inserted " + str(cnt) + " facilities tribal records...");
            
            cnt = cnt + 1;
            
      arcpy.AddMessage(". processed " + str(cnt) + " inserts for tribal facilities");
      
      #########################################################################
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.lust_id
         ,b.name
         ,b.address
         ,b.city
         ,b.county
         ,b.zip AS zip_code
         ,a.state
         ,b.latitude
         ,b.longitude
         ,b.lat_lon_source AS coordinate_source     
         ,b.address_match_type
         ,b.reported_date
         ,b.status AS facility_status
         ,b.substance
         ,CAST(NULL AS INTEGER) AS population_within_1500ft
         ,CAST(NULL AS INTEGER) AS domesticwells_within_1500ft
         ,CAST(NULL AS TEXT) AS landuse
         ,CAST(NULL AS TEXT) AS within_spa
         ,CAST(NULL AS TEXT) AS spa_pws_facilityid
         ,CAST(NULL AS TEXT) AS spa_water_type
         ,CAST(NULL AS TEXT) AS spa_facility_type
         ,CAST(NULL AS TEXT) AS spa_huc12
         ,CAST(NULL AS TEXT) AS within_whpa
         ,CAST(NULL AS TEXT) AS whpa_pws_facilityid
         ,CAST(NULL AS TEXT) AS whpa_water_type
         ,CAST(NULL AS TEXT) AS whpa_facility_type
         ,CAST(NULL AS TEXT) AS whpa_huc12
         ,CAST(NULL AS TEXT) AS within_100yr_floodplain
         ,b.tribe
         ,b.region AS epa_region
         ,b.nfa_letter_1
         ,b.nfa_letter_2
         ,b.nfa_letter_3
         ,b.nfa_letter_4
         ,CAST(NULL AS TEXT) AS closed_with_residual_contaminat
         ,CAST('I' AS TEXT) AS qa
         FROM
         main.temp_rel_work a
         JOIN
         main.tribal_rel b
         ON
             a.facility_id = b.location_id
         AND a.state       = b.state
         AND a.lust_id     = b.lust_id
         WHERE
         a.actiontaken = 'INSERT'
      """);
      
      cnt = 0;    
      with arcpy.da.InsertCursor(
          in_table    = rel
         ,field_names = g_config.flds('releases',aprx=aprx,wrkspc=wrkspc) + ["SHAPE@"]
      ) as icursor:
            
         for row in cursor:
            
            y_wgs84 = lust_float(row[8]);
            x_wgs84 = lust_float(row[9]);
           
            pnt_webmc = None;
            if  x_wgs84 is not None \
            and y_wgs84 is not None \
            and x_wgs84 != 0        \
            and y_wgs84 != 0:
               pnt_webmc = configdz.ConfigDZ.coord2shape(
                   p_x = x_wgs84
                  ,p_y = y_wgs84
               );
               
               if pnt_webmc is None:
                  raise Exception(row[0] + " " + row[1] + ": [" + str(x_wgs84) + "] [" + str(y_wgs84) + "]");
                  
            icursor.insertRow((
                lust_trim(row[0],8000) 
               ,lust_trim(row[1],8000) 
               ,lust_trim(row[2],8000)
               ,lust_trim(row[3],8000)
               ,lust_trim(row[4],8000)
               ,lust_trim(row[5],8000)
               ,lust_int(row[6])
               ,lust_trim(row[7],8000)
               ,y_wgs84
               ,x_wgs84
               ,lust_trim(row[10],8000)
               ,lust_trim(row[11],8000)
               ,lust_time(row[12])
               ,lust_trim(row[13],8000)
               ,lust_trim(row[14],8000)
               ,lust_int(row[15])
               ,lust_int(row[16])
               ,lust_trim(row[17],8000)
               ,lust_trim(row[18],8000)
               ,lust_trim(row[19],8000)
               ,lust_trim(row[20],8000)
               ,lust_trim(row[21],8000)
               ,lust_int(row[22])
               ,lust_trim(row[23],8000)
               ,lust_trim(row[24],8000) 
               ,lust_trim(row[25],8000)
               ,lust_trim(row[26],8000)
               ,lust_trim(row[27],8000)
               ,lust_trim(row[28],8000)
               ,lust_trim(row[29],8000)
               ,lust_int(row[30])
               
               ,lust_trim(row[31],8000)
               ,lust_trim(row[32],8000)
               ,lust_trim(row[33],8000)
               ,lust_trim(row[34],8000)
               
               ,lust_trim(row[35],8000)
               ,row[36]
               ,pnt_webmc
            ));              

            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   inserted " + str(cnt) + " releases tribal records...");
               
            cnt = cnt + 1;
            
      arcpy.AddMessage(". processed " + str(cnt) + " inserts for tribal releases");
      
      #########################################################################
      cursor.execute("""
         SELECT
          a.state
         ,a.facility_id
         ,a.tank_id
         ,b.tank_status
         ,b.installation_date
         ,b.removal_date
         ,b.capacity
         ,b.substance_stored AS substances
         ,b.tank_wall_type
         ,CAST('I' AS TEXT) AS qa
         FROM
         main.temp_usts_work a
         JOIN
         main.tribal_usts b
         ON
             a.facility_id = b.location_id
         AND a.state       = b.state
         AND a.tank_id     = b.tank_id
         WHERE
         a.actiontaken = 'INSERT'
      """);
      
      cnt = 0;
      with arcpy.da.InsertCursor(
          in_table    = usts
         ,field_names = g_config.flds('usts',aprx=aprx,wrkspc=wrkspc)
      ) as icursor:
            
         for row in cursor:
                  
            icursor.insertRow((
                lust_trim(row[0],8000)
               ,lust_trim(row[1],8000)
               ,lust_trim(row[2],8000)
               ,lust_trim(row[3],8000)
               ,lust_time(row[4])
               ,lust_time(row[5])
               ,lust_int(row[6])
               ,lust_trim(row[7],8000)
               ,lust_trim(row[8],8000)
               ,row[9]
            ));              

            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   inserted " + str(cnt) + " usts tribal records...");
               
            cnt = cnt + 1;
            
      arcpy.AddMessage(". processed " + str(cnt) + " inserts for tribal usts");
      
      #########################################################################
      arcpy.AddMessage("Applying releases updates");
     
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.lust_id
         ,b.name
         ,b.address
         ,b.city
         ,b.county
         ,b.zip AS zip_code
         ,a.state
         ,b.latitude
         ,b.longitude
         ,b.lat_lon_source AS coordinate_source
         ,b.address_match_type
         ,b.reported_date
         ,b.status
         ,b.substance
         ,CAST(NULL AS INTEGER) AS population_within_1500ft
         ,CAST(NULL AS INTEGER) AS domesticwells_within_1500ft
         ,CAST(NULL AS TEXT) AS landuse
         ,CAST(NULL AS TEXT) AS within_spa
         ,CAST(NULL AS TEXT) AS spa_pws_facilityid
         ,CAST(NULL AS TEXT) AS spa_water_type
         ,CAST(NULL AS TEXT) AS spa_facility_type
         ,CAST(NULL AS TEXT) AS spa_huc12
         ,CAST(NULL AS TEXT) AS within_whpa
         ,CAST(NULL AS TEXT) AS whpa_pws_facilityid
         ,CAST(NULL AS TEXT) AS whpa_water_type
         ,CAST(NULL AS TEXT) AS whpa_facility_type
         ,CAST(NULL AS TEXT) AS whpa_huc12
         ,CAST(NULL AS TEXT) AS within_100yr_floodplain
         ,b.tribe
         ,b.region AS epa_region
         ,b.nfa_letter_1
         ,b.nfa_letter_2
         ,b.nfa_letter_3
         ,b.nfa_letter_4
         ,CAST(NULL AS TEXT) AS closed_with_residual_contaminat
         FROM
         main.temp_rel_work a
         JOIN
         main.tribal_rel b
         ON
             a.facility_id = b.location_id
         AND a.state       = b.state
         AND a.lust_id     = b.lust_id
         WHERE
         a.actiontaken = 'UPDATE'
      """);
      
      cnt = 0;
      rel_fields = g_config.flds('releases',aprx=aprx,wrkspc=wrkspc) + ["SHAPE@"];
      #arcpy.AddMessage(str(rel_fields));
      
      for row in cursor:
         
         str_facility_id = row[0];
         str_lust_id     = row[1];
         str_state       = row[7];
         
         with arcpy.da.UpdateCursor(
             in_table    = rel
            ,field_names = rel_fields
            ,where_clause = "facility_id = '" + str(str_facility_id).replace("'","''") + "' AND state = '" + str(str_state).replace("'","''") + "' AND lust_id = '" + str(str_lust_id).replace("'","''") + "'" 
         ) as ucursor:
            boo_check = False;
            
            for row2 in ucursor:
               boo_check = True;
               
               y_wgs84 = lust_float(row[8]);
               x_wgs84 = lust_float(row[9]);

               pnt_webmc = None;
               if  x_wgs84 is not None \
               and y_wgs84 is not None \
               and x_wgs84 != 0        \
               and y_wgs84 != 0:
                  pnt_webmc = configdz.ConfigDZ.coord2shape(
                      p_x = x_wgs84
                     ,p_y = y_wgs84
                  );
                  
                  if pnt_webmc is None:
                     raise Exception(str_state + " " + str_facility_id + " " + str_lust_id + ": [" + str(x_wgs84) + "] [" + str(y_wgs84) + "]");
                     
               else:
                  arcpy.AddMessage(".   empty geometry for " + row[1] + " " + row[0] + " using " + str(row[9]) + "," + str(row[8])); 
               
               row2[2]  = lust_trim(row[2],8000);  # Name
               row2[3]  = lust_trim(row[3],8000);  # Address
               row2[4]  = lust_trim(row[4],8000);  # City
               row2[5]  = lust_trim(row[5],8000);  # County
               row2[6]  = lust_trim(row[6],8000);  # Zip_Code
               
               row2[8]  = y_wgs84; # Latitude
               row2[9]  = x_wgs84; # Longtiude
               row2[10] = lust_trim(row[10],8000); # Coordinate_Source
               
               row2[12] = lust_time(row[12]); # Reported_Date
               row2[13] = lust_trim(row[13],8000); # Status
               row2[14] = lust_trim(row[14],8000); # Substance
               
               row2[29] = lust_trim(row[29],8000); # Tribe
               row2[30] = lust_int(row[30]); # EPA_Region
               
               cur_nfa_1 = lust_trim(row2[31],8000);
               cur_nfa_2 = lust_trim(row2[32],8000);
               cur_nfa_3 = lust_trim(row2[33],8000);
               cur_nfa_4 = lust_trim(row2[34],8000);
               
               new_nfa_1 = lust_trim(row[31],8000);
               new_nfa_2 = lust_trim(row[32],8000);
               new_nfa_3 = lust_trim(row[33],8000);
               new_nfa_4 = lust_trim(row[34],8000);
               
               new_nfas = [];
                  
               if new_nfa_1 is not None:
                  new_nfas.append(new_nfa_1);
               if new_nfa_2 is not None:
                  new_nfas.append(new_nfa_2);
               if new_nfa_3 is not None:
                  new_nfas.append(new_nfa_3);
               if new_nfa_4 is not None:
                  new_nfas.append(new_nfa_4);
               
               cur_nfas = [];
                        
               if cur_nfa_1 is not None:
                  cur_nfas.append(cur_nfa_1);
               if cur_nfa_2 is not None:
                  cur_nfas.append(cur_nfa_2);
               if cur_nfa_3 is not None:
                  cur_nfas.append(cur_nfa_3);
               if cur_nfa_4 is not None:
                  cur_nfas.append(cur_nfa_4);
               
               merged = new_nfas + list(set(cur_nfas) - set(new_nfas));
               
               row2[31] = None;
               row2[32] = None;
               row2[33] = None;
               row2[34] = None; 
               
               if len(merged) > 0:
                  row2[31] = merged[0];
                  
               if len(merged) > 1:
                  row2[32] = merged[1];
                  
               if len(merged) > 2:
                  row2[33] = merged[2];
                  
               if len(merged) > 3:
                  row2[34] = merged[3];
               
               row2[36] = 'U'; 
               row2[37] = pnt_webmc;
  
               ucursor.updateRow(row2);            

            if not boo_check:
               raise Exception("failed to update releases " + str_state + " " + str_facility_id + " " + str_lust_id);
            
            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   updated " + str(cnt) + " releases tribal records...");
               
            cnt = cnt + 1;   
            
      arcpy.AddMessage(". processed " + str(cnt) + " updates for tribal releases");
      
      cnt = 0;
      with arcpy.da.SearchCursor(
          in_table     = rel
         ,field_names  = "SHAPE@"
      ) as curs:
         for row in curs:
            if row[0] is None:
               cnt = cnt + 1;
               
      arcpy.AddMessage(". AFTER upsert releases has " + str(cnt) + " null geometries");
      
      #########################################################################
      arcpy.AddMessage("Applying facilities updates");

      cursor.execute("""
         SELECT
          a.facility_id
         ,b.name
         ,b.address
         ,b.city
         ,b.county
         ,a.state
         ,b.zip AS zip_code
         ,b.latitude
         ,b.longitude
         ,b.lat_lon_source AS coordinate_source
         ,b.address_match_type
         ,b.open_usts
         ,b.closed_usts
         ,b.temporarily_out_of_service_usts AS tos_usts
         ,CAST(NULL AS INTEGER) AS population_1500ft
         ,CAST(NULL AS INTEGER) AS private_wells_1500ft
         ,CAST(NULL AS TEXT) AS within_100yr_floodplain
         ,CAST(NULL AS TEXT) AS landuse
         ,CAST(NULL AS TEXT) AS within_spa
         ,CAST(NULL AS TEXT) AS spa_pws_facilityid
         ,CAST(NULL AS TEXT) AS spa_water_type
         ,CAST(NULL AS TEXT) AS spa_facility_type
         ,CAST(NULL AS TEXT) AS spa_huc12
         ,CAST(NULL AS TEXT) AS within_whpa
         ,CAST(NULL AS TEXT) AS whpa_pws_facilityid
         ,CAST(NULL AS TEXT) AS whpa_water_type
         ,CAST(NULL AS TEXT) AS whpa_facility_type
         ,CAST(NULL AS TEXT) AS whpa_huc12
         ,b.facility_status
         ,b.date_of_last_inspection
         ,b.region AS epa_region
         ,b.tribe
         FROM
         main.temp_fac_work a
         JOIN
         main.tribal_fac b
         ON
             a.facility_id = b.location_id
         AND a.state       = b.state
         WHERE
         a.actiontaken = 'UPDATE'
      """);
      
      cnt = 0;
      for row in cursor:
         
         str_facility_id = row[0];
         str_state       = row[5];
      
         with arcpy.da.UpdateCursor(
             in_table    = fac
            ,field_names = g_config.flds('facilities',aprx=aprx,wrkspc=wrkspc) + ['SHAPE@']
            ,where_clause = "facility_id = '" + str(str_facility_id).replace("'","''") + "' AND state = '" + str(str_state).replace("'","''") + "'" 
         ) as ucursor:
            boo_check = False;
            
            for row2 in ucursor:
               boo_check = True;
               
               y_wgs84 = lust_float(row[7]);
               x_wgs84 = lust_float(row[8]);
              
               pnt_webmc = None;
               if  x_wgs84 is not None \
               and y_wgs84 is not None \
               and x_wgs84 != 0        \
               and y_wgs84 != 0:
                  pnt_webmc = configdz.ConfigDZ.coord2shape(
                      p_x = x_wgs84
                     ,p_y = y_wgs84
                  );
                  
                  if pnt_webmc is None:
                     raise Exception(str_state + " " + str_facility_id + ": [" + str(x_wgs84) + "] [" + str(y_wgs84) + "]");
                     
               else:
                  arcpy.AddMessage(".   empty geometry for " + str_state + " " + str_facility_id + " using " + str(x_wgs84) + "," + str(y_wgs84)); 
               
               row2[1]  = lust_trim(row[1],255);  # Name
               row2[2]  = lust_trim(row[2],255);  # Address
               row2[3]  = lust_trim(row[3],255);  # City
               row2[4]  = lust_trim(row[4],255);  # County
               
               row2[6]  = lust_trim(row[6],255);  # Zip_Code
               row2[7]  = y_wgs84; # Latitude
               row2[8]  = x_wgs84; # Longtiude
               row2[9]  = lust_trim(row[9],255);  # Coordinate_Source
               row2[10] = lust_trim(row[10],255); # Address Match Type
               row2[11] = lust_int(row[11]); # Open_USTs
               row2[12] = lust_int(row[12]); # Closed_USTs
               row2[13] = lust_int(row[13]); # TOS_USTs

               row2[28] = lust_trim(row[28],254); # Facility_Status
               row2[29] = lust_time(row[29]); # Date_of_Last_Inspection
               row2[30] = lust_int(row[30]); # EPA_Region
               row2[31] = lust_trim(row[31],8000); # Tribe
               
               row2[32] = 'U'; 
               row2[33] = pnt_webmc;
                  
               ucursor.updateRow(row2);
   
            if not boo_check:
               raise Exception("failed to update facilities " + str(str_state) + " " + str(str_facility_id));            
            
            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   updated " + str(cnt) + " facilities tribal records...");
               
            cnt = cnt + 1;
            
      arcpy.AddMessage(". processed " + str(cnt) + " updates for tribal facilities");
      
      #########################################################################
      cnt = 0;
      with arcpy.da.SearchCursor(
          in_table     = fac
         ,field_names  = "SHAPE@"
      ) as curs:
         for row in curs:
            if row[0] is None:
               cnt = cnt + 1;
               
      arcpy.AddMessage(". AFTER upsert facilities has " + str(cnt) + " null geometries");
      
      #########################################################################
      arcpy.AddMessage("Applying USTs updates");
      
      cursor.execute("""
         SELECT
          a.state
         ,a.facility_id
         ,a.tank_id
         ,b.tank_status
         ,b.installation_date
         ,b.removal_date
         ,b.capacity
         ,b.substance_stored AS substances
         ,b.tank_wall_type
         FROM
         main.temp_usts_work a
         JOIN
         main.tribal_usts b
         ON
             a.facility_id = b.location_id
         AND a.state       = b.state
         AND a.tank_id     = b.tank_id
         WHERE
         a.actiontaken = 'UPDATE'
      """);
      
      cnt = 0;
      for row in cursor:
         
         str_state       = row[0];
         str_facility_id = row[1];
         str_tank_id     = row[2];
         
         with arcpy.da.UpdateCursor(
             in_table    = usts
            ,field_names = g_config.flds('usts',aprx=aprx,wrkspc=wrkspc)
            ,where_clause = "facility_id = '" + str(str_facility_id).replace("'","''") + "' AND state = '" + str(str_state).replace("'","''") + "' AND tank_id = '" + str(str_tank_id).replace("'","''") + "'" 
         ) as ucursor:
            boo_check = False;
            
            for row2 in ucursor:
               boo_check = True;
               
               row2[3]  = lust_trim(row[3],8000);  # Tank_Status
               row2[4]  = lust_time(row[4]);       # Installation_Date
               row2[5]  = lust_time(row[5]);       # Removal_Date
               row2[6]  = lust_int(row[6]);        # Capacity
               row2[7]  = lust_trim(row[7],8000);  # Substance    
               row2[8]  = lust_trim(row[8],8000);  # Tank_Wall_Type
               row2[9]  = 'U'; 
                  
               ucursor.updateRow(row2);
               
            if not boo_check:
               raise Exception("failed to update usts " + str(str_state) + " " + str(str_facility_id) + " " + str(str_tank_id));
         
            if cnt > 0 and cnt % 100 == 0:
               arcpy.AddMessage(".   updated " + str(cnt) + " usts tribal records...");
               
            cnt = cnt + 1;
             
      arcpy.AddMessage(". processed " + str(cnt) + " updates for tribal usts");
      
      #########################################################################
      check_nfa_letter_urls(rel);

      #########################################################################
      arcpy.AddMessage("Upsert complete");
      
      del conn;
      
###############################################################################
class RebuildMapsUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A7 Rebuild Maps";
      self.name               = "RebuildMapsUST";
      self.description        = "RebuildMapsUST";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      fac = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
      rel = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
      fbc = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
      rbc = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found');
      ust = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(ust):
         raise Exception('usts not found');
      
      #########################################################################
      maps = aprx.listMaps('*');
      for item in maps:
         aprx.deleteItem(item);
         
      #########################################################################
      relcls = g_config.relationshipclass('facilities_usts',aprx=aprx,wrkspc=wrkspc);
      if arcpy.Exists(relcls):
         arcpy.Delete_management(relcls);
      
      #########################################################################
      arcpy.AddMessage(". Building fresh map");
      mapobj = g_config.build_map(
          mapid   = 'ust_finder_feature_layer'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      arcpy.AddMessage(". Adding fresh layers");
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'facilities'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'releases'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'facilities_by_county'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'releases_by_county'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      arcpy.AddMessage(". Adding fresh tables");
      z1 = g_config.add_table(
          mapobj  = mapobj
         ,tableid = 'usts'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      arcpy.AddMessage(". Rebuilding relationship class between facilities and usts");
      z1 = g_config.build_relationshipclass(
          relationshipclassid = 'facilities_usts'
         ,aprx                = aprx
         ,wrkspc              = wrkspc
      );
      
      mapobj['map'].defaultCamera.setExtent(g_default_zoom);
      mapobj['map'].openView();
      
###############################################################################
class SaveToStash(object):

   #...........................................................................
   def __init__(self):

      self.label              = "U1 Save To Stash";
      self.name               = "SaveToStash";
      self.description        = "SaveToStash";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      fac  = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
      rel  = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
      fbc  = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
      rbc  = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found',aprx=aprx,wrkspc=wrkspc);
      usts = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(usts):
         raise Exception('usts not found');
         
      #########################################################################
      fac_stash = fac + '_stash';
      if arcpy.Exists(fac_stash):
         arcpy.management.Delete(fac_stash);
      rel_stash = rel + '_stash';
      if arcpy.Exists(rel_stash):
         arcpy.management.Delete(rel_stash);
      
      fbc_stash = fbc + '_stash';
      if arcpy.Exists(fbc_stash):
         arcpy.management.Delete(fbc_stash);
      rbc_stash = rbc + '_stash';
      if arcpy.Exists(rbc_stash):
         arcpy.management.Delete(rbc_stash);      
         
      usts_stash = usts + '_stash';
      if arcpy.Exists(usts_stash):
         arcpy.management.Delete(usts_stash);
         
      #########################################################################
      arcpy.AddMessage("stashing facilities");
      arcpy.management.CopyFeatures(fac,fac_stash);
      arcpy.AddMessage("stashing releases");
      arcpy.management.CopyFeatures(rel,rel_stash);
      
      arcpy.AddMessage("stashing facilities_by_county");
      arcpy.management.CopyFeatures(fbc,fbc_stash);
      arcpy.AddMessage("stashing releases_by_county");
      arcpy.management.CopyFeatures(rbc,rbc_stash);
      
      arcpy.AddMessage("stashing usts");
      arcpy.management.CopyRows(usts,usts_stash);
      
###############################################################################
class RestoreFromStash(object):

   #...........................................................................
   def __init__(self):

      self.label              = "U2 Restore From Stash";
      self.name               = "RestoreFromStash";
      self.description        = "RestoreFromStash";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      fac  = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fac):
         raise Exception('facilities not found');
      rel  = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
      fbc  = g_config.datasource('facilities_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(fbc):
         raise Exception('facilities by county not found');
      rbc  = g_config.datasource('releases_by_county',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rbc):
         raise Exception('resources not found',aprx=aprx,wrkspc=wrkspc);
      usts = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(usts):
         raise Exception('usts not found');
         
      #########################################################################
      fac_stash = fac + '_stash';
      if not arcpy.Exists(fac_stash):
         raise Exception("facilities_stash not found");
      rel_stash = rel + '_stash';
      if not arcpy.Exists(rel_stash):
         raise Exception("releases_stash not found");
      
      fbc_stash = fbc + '_stash';
      if not arcpy.Exists(fbc_stash):
         raise Exception("facilities_by_county_stash not found");
      rbc_stash = rbc + '_stash';
      if not arcpy.Exists(rbc_stash):
         raise Exception("releases_by_county_stash not found");
      
      usts_stash = usts + '_stash';
      if not arcpy.Exists(usts_stash):
         raise Exception("usts_stash not found");
      
      arcpy.management.TruncateTable(in_table = fac);
      arcpy.management.TruncateTable(in_table = rel);
      
      arcpy.management.TruncateTable(in_table = fbc);
      arcpy.management.TruncateTable(in_table = rbc);
      
      arcpy.management.TruncateTable(in_table = usts);
      
      #########################################################################
      arcpy.AddMessage("restoring facilities");
      arcpy.management.CopyFeatures(fac_stash,fac);
      arcpy.AddMessage("restoring releases");
      arcpy.management.CopyFeatures(rel_stash,rel);
      
      arcpy.AddMessage("restoring facilities_by_county");
      arcpy.management.CopyFeatures(fbc_stash,fbc);
      arcpy.AddMessage("restoring releases_by_county");
      arcpy.management.CopyFeatures(rbc_stash,rbc);
      
      arcpy.AddMessage("restoring usts");
      arcpy.management.CopyRows(usts_stash,usts);
      
      
###############################################################################
class CheckNFALetters(object):

   #...........................................................................
   def __init__(self):

      self.label              = "U3 Check NFA Letters";
      self.name               = "CheckNFALetters";
      self.description        = "CheckNFALetters";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      params = [];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      #########################################################################
      rel  = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(rel):
         raise Exception('releases not found');
         
      #########################################################################
      check_nfa_letter_urls(rel);
      
      #########################################################################
      arcpy.AddMessage(". check complete");
      
###############################################################################
class GenerateStateStats(object):

   #...........................................................................
   def __init__(self):

      self.label              = "U4 Generate State Stats";
      self.name               = "GenerateStateStats";
      self.description        = "GenerateStateStats";
      self.canRunInBackground = False;

   #...........................................................................
   def getParameterInfo(self):
      
      #########################################################################
      param0 = arcpy.Parameter(
          displayName   = "AGO GUID"
         ,name          = "AGOGUID"
         ,datatype      = "GPString"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param0.value = g_config.map_guid('ust_finder_feature_layer');
      
      param1 = arcpy.Parameter(
          displayName   = "Use Pending Data"
         ,name          = "UsePendingData"
         ,datatype      = "GPBoolean"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param1.value = False
      
      #########################################################################
      param2 = arcpy.Parameter(
          displayName   = "Report Tag"
         ,name          = "ReportTag"
         ,datatype      = "GPString"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = False
      );
      param2.value = g_config.map_guid('ust_finder_feature_layer')[:5];
      
      #########################################################################
      param3 = arcpy.Parameter(
          displayName   = "Datasets"
         ,name          = "Datasets"
         ,datatype      = "GPString"
         ,parameterType = "Required"
         ,direction     = "Input"
         ,enabled       = True
         ,multiValue    = True
      );
      param3.value  = ["releases"];
      param3.filter.list = ["facilities", "releases", "usts"];
      
      params = [
          param0
         ,param1
         ,param2
         ,param3
      ];
      
      return params;

   #...........................................................................
   def isLicensed(self):

      return True;

   #...........................................................................
   def updateParameters(self,parameters):

      if parameters[1].altered and not parameters[1].hasBeenValidated:
         
         if parameters[1].value:
            parameters[0].enabled = False;
            parameters[2].value = 'pending'
         elif not parameters[1].value:
            parameters[0].enabled = True;
            parameters[2].value = g_config.map_guid('ust_finder_feature_layer')[:5];
      
      return;

   #...........................................................................
   def updateMessages(self,parameters):

      return;

   #...........................................................................
   def execute(self,parameters,messages):

      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      src_guid = parameters[0].valueAsText;
      str_pend = parameters[1].valueAsText;
      rpt_tag  = parameters[2].valueAsText;
      ary_data = parameters[3].valueAsText.split(';');

      if str_pend.lower() in ['true']:
         fac_src  = g_config.datasource('facilities',aprx=aprx,wrkspc=wrkspc);
         rel_src  = g_config.datasource('releases',aprx=aprx,wrkspc=wrkspc);
         usts_src = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
         arcpy.AddMessage("Pulling data from pending for " + str(ary_data));
         boo_match_etl = False;
         
      else:
         gis = GIS();
         gs = gis.content.get(src_guid);
         arcpy.AddMessage("Pulling data from " + str(gs.url) + " for " + str(ary_data));
         fac_src  = gs.url + '/0';
         rel_src  = gs.url + '/1';
         usts_src = gs.url + '/4';
         boo_match_etl = True;
      
      conn    = sqlite3.connect(aprx.defaultGeodatabase);
      cursor  = conn.cursor();
      
      #------------------------------------------------------------------------
      if 'facilities' in ary_data:
         
         facrpt      = os.path.join(aprx.defaultGeodatabase,'facrpt_' + rpt_tag);
         facstaterpt = os.path.join(aprx.defaultGeodatabase,'facstaterpt_' + rpt_tag);
         factriberpt = os.path.join(aprx.defaultGeodatabase,'factriberpt_' + rpt_tag);
         
         if arcpy.Exists(facrpt):
            arcpy.Delete_management(facrpt);
            
         if arcpy.Exists(facstaterpt):
            arcpy.Delete_management(facstaterpt);
            
         if arcpy.Exists(factriberpt):
            arcpy.Delete_management(factriberpt);
         
         g_config.build_from_schema(
             schemaid          = 'facilities'
            ,datasetname       = facrpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         g_config.build_from_schema(
             schemaid          = 'facstaterpt'
            ,datasetname       = facstaterpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         g_config.build_from_schema(
             schemaid          = 'factriberpt'
            ,datasetname       = factriberpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         facrpt_flds      = g_config.flds_from_schema('facilities' ,aprx=aprx,wrkspc=wrkspc,match_etl=boo_match_etl) + ['SHAPE@'];
         facstaterpt_flds = g_config.flds_from_schema('facstaterpt',aprx=aprx,wrkspc=wrkspc)
         factriberpt_flds = g_config.flds_from_schema('factriberpt',aprx=aprx,wrkspc=wrkspc)
         
         bef_cnt = arcpy.management.GetCount(fac_src)[0]; 
         arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
         
         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = facrpt
            ,field_names = facrpt_flds
         ) as outcurs:
         
            with arcpy.da.SearchCursor(
                in_table     = fac_src
               ,field_names  = facrpt_flds
            ) as incurs:
               
               for row in incurs:
                     
                  outcurs.insertRow(row);
                  
                  if ins_cnt > 0 and ins_cnt % 10000 == 0:
                     arcpy.AddMessage(". harvested " + str(ins_cnt) + " facilities records...");
                  
                  ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " facilities records.");
         aft_cnt = arcpy.management.GetCount(facrpt)[0];

         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = facstaterpt
            ,field_names = facstaterpt_flds
         ) as outcurs:
            
            cursor.execute("""
               SELECT
                a.state
               ,a.facility_status
               ,COUNT(*) AS cnt
               ,SUM(a.tribe_cnt) AS tribe_cnt
               ,SUM(a.null_geo)  AS null_geo
               FROM (
                  SELECT
                   aa.state
                  ,aa.facility_status
                  ,CASE
                   WHEN aa.tribe IS NOT NULL
                   THEN
                     1
                   ELSE
                     0
                   END tribe_cnt
                  ,CASE
                   WHEN aa.shape IS NULL
                   THEN
                     1
                   ELSE
                     0
                   END null_geo
                  FROM
                  main.facrpt_""" + rpt_tag + """ aa
               ) a
               GROUP BY
                a.state
               ,a.facility_status
               ORDER BY
                a.state
               ,a.facility_status
            """);

            for row in cursor:
               outcurs.insertRow(row);
               ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " facstaterpt records.");

         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = factriberpt
            ,field_names = factriberpt_flds
         ) as outcurs:
            
            cursor.execute("""
               SELECT
                a.tribe
               ,a.facility_status
               ,COUNT(*) AS cnt
               ,SUM(a.null_geo)  AS null_geo
               FROM (
                  SELECT
                   aa.tribe
                  ,aa.facility_status
                  ,CASE
                   WHEN aa.shape IS NULL
                   THEN
                     1
                   ELSE
                     0
                   END null_geo
                  FROM
                  main.facrpt_""" + rpt_tag + """ aa
               ) a
               GROUP BY
                a.tribe
               ,a.facility_status
               ORDER BY
                a.tribe
               ,a.facility_status
            """);

            for row in cursor:
               outcurs.insertRow(row);
               ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " factriberpt records.");
         conn.commit();
         
         ######################################################################
         facstaterpt_csv = os.path.join(aprx.homeFolder,'facstaterpt_' + rpt_tag + '.csv');
         if arcpy.Exists(facstaterpt_csv):
            arcpy.Delete_management(facstaterpt_csv);
         arcpy.management.CopyRows(facstaterpt,facstaterpt_csv);
         
         factriberpt_csv = os.path.join(aprx.homeFolder,'factriberpt_' + rpt_tag + '.csv');
         if arcpy.Exists(factriberpt_csv):
            arcpy.Delete_management(factriberpt_csv);
         arcpy.management.CopyRows(factriberpt,factriberpt_csv);

         arcpy.AddMessage("Facilities reports loaded.");
      
      #------------------------------------------------------------------------
      if 'releases' in ary_data:
         
         relrpt      = os.path.join(aprx.defaultGeodatabase,'relrpt_' + rpt_tag);
         relstaterpt = os.path.join(aprx.defaultGeodatabase,'relstaterpt_' + rpt_tag);
         reltriberpt = os.path.join(aprx.defaultGeodatabase,'reltriberpt_' + rpt_tag);
         
         if arcpy.Exists(relrpt):
            arcpy.Delete_management(relrpt);
            
         if arcpy.Exists(relstaterpt):
            arcpy.Delete_management(relstaterpt);
            
         if arcpy.Exists(reltriberpt):
            arcpy.Delete_management(reltriberpt);
         
         g_config.build_from_schema(
             schemaid          = 'releases'
            ,datasetname       = relrpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         g_config.build_from_schema(
             schemaid          = 'relstaterpt'
            ,datasetname       = relstaterpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         g_config.build_from_schema(
             schemaid          = 'reltriberpt'
            ,datasetname       = reltriberpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         relrpt_flds      = g_config.flds_from_schema('releases'   ,aprx=aprx,wrkspc=wrkspc,match_etl=boo_match_etl) + ['SHAPE@'];
         relstaterpt_flds = g_config.flds_from_schema('relstaterpt',aprx=aprx,wrkspc=wrkspc)
         reltriberpt_flds = g_config.flds_from_schema('reltriberpt',aprx=aprx,wrkspc=wrkspc)
         
         bef_cnt = arcpy.management.GetCount(rel_src)[0]; 
         arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
         
         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = relrpt
            ,field_names = relrpt_flds
         ) as outcurs:
         
            with arcpy.da.SearchCursor(
                in_table     = rel_src
               ,field_names  = relrpt_flds
            ) as incurs:
               
               for row in incurs:
                     
                  outcurs.insertRow(row);
                  
                  if ins_cnt > 0 and ins_cnt % 10000 == 0:
                     arcpy.AddMessage(". harvested " + str(ins_cnt) + " releases records...");
                  
                  ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " releases records.");
         aft_cnt = arcpy.management.GetCount(relrpt)[0];

         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = relstaterpt
            ,field_names = relstaterpt_flds
         ) as outcurs:
            
            cursor.execute("""
               SELECT
                a.state
               ,a.status
               ,COUNT(*) AS cnt
               ,SUM(a.tribe_cnt) AS tribe_cnt
               ,SUM(a.has_nfa1)  AS has_nfa1
               ,SUM(a.has_nfa2)  AS has_nfa2
               ,SUM(a.has_nfa3)  AS has_nfa3
               ,SUM(a.has_nfa4)  AS has_nfa4
               ,SUM(a.null_geo)  AS null_geo
               FROM (
                  SELECT
                   aa.state
                  ,aa.status
                  ,CASE
                   WHEN aa.tribe IS NOT NULL
                   THEN
                     1
                   ELSE
                     0
                   END tribe_cnt
                  ,CASE
                   WHEN aa.nfa_letter_1 IS NOT NULL
                   AND aa.nfa_letter_1 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa1
                  ,CASE
                   WHEN aa.nfa_letter_2 IS NOT NULL
                   AND aa.nfa_letter_2 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa2
                  ,CASE
                   WHEN aa.nfa_letter_3 IS NOT NULL
                   AND aa.nfa_letter_3 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa3
                  ,CASE
                   WHEN aa.nfa_letter_4 IS NOT NULL
                   AND aa.nfa_letter_4 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa4
                  ,CASE
                   WHEN aa.shape IS NULL
                   THEN
                     1
                   ELSE
                     0
                   END null_geo
                  FROM
                  main.relrpt_""" + rpt_tag + """ aa
               ) a
               GROUP BY
                a.state
               ,a.status
               ORDER BY
                a.state
               ,a.status
            """);

            for row in cursor:
               outcurs.insertRow(row);
               ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " relstaterpt records.");

         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = reltriberpt
            ,field_names = reltriberpt_flds
         ) as outcurs:
            
            cursor.execute("""
               SELECT
                a.tribe
               ,a.status
               ,COUNT(*) AS cnt
               ,SUM(a.has_nfa1)  AS has_nfa1
               ,SUM(a.has_nfa2)  AS has_nfa2
               ,SUM(a.has_nfa3)  AS has_nfa3
               ,SUM(a.has_nfa4)  AS has_nfa4
               ,SUM(a.null_geo)  AS null_geo
               FROM (
                  SELECT
                   aa.tribe
                  ,aa.status
                  ,CASE
                   WHEN aa.nfa_letter_1 IS NOT NULL
                   AND aa.nfa_letter_1 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa1
                  ,CASE
                   WHEN aa.nfa_letter_2 IS NOT NULL
                   AND aa.nfa_letter_2 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa2
                  ,CASE
                   WHEN aa.nfa_letter_3 IS NOT NULL
                   AND aa.nfa_letter_3 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa3
                  ,CASE
                   WHEN aa.nfa_letter_4 IS NOT NULL
                   AND aa.nfa_letter_4 != ''
                   THEN
                     1
                   ELSE
                     0
                   END has_nfa4
                  ,CASE
                   WHEN aa.shape IS NULL
                   THEN
                     1
                   ELSE
                     0
                   END null_geo
                  FROM
                  main.relrpt_""" + rpt_tag + """ aa
               ) a
               GROUP BY
                a.tribe
               ,a.status
               ORDER BY
                a.tribe
               ,a.status
            """);

            for row in cursor:
               outcurs.insertRow(row);
               ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " reltriberpt records.");

         arcpy.AddMessage("Releases reports loaded.");
         conn.commit();
         
         ######################################################################
         relstaterpt_csv = os.path.join(aprx.homeFolder,'relstaterpt_' + rpt_tag + '.csv');
         if arcpy.Exists(relstaterpt_csv):
            arcpy.Delete_management(relstaterpt_csv);
         arcpy.management.CopyRows(relstaterpt,relstaterpt_csv);
         
         reltriberpt_csv = os.path.join(aprx.homeFolder,'reltriberpt_' + rpt_tag + '.csv');
         if arcpy.Exists(reltriberpt_csv):
            arcpy.Delete_management(reltriberpt_csv);
         arcpy.management.CopyRows(reltriberpt,reltriberpt_csv);
         
      #------------------------------------------------------------------------
      if 'usts' in ary_data:
         
         ustsrpt      = os.path.join(aprx.defaultGeodatabase,'ustsrpt_' + rpt_tag);
         ustsstaterpt = os.path.join(aprx.defaultGeodatabase,'ustsstaterpt_' + rpt_tag);
         
         if arcpy.Exists(ustsrpt):
            arcpy.Delete_management(ustsrpt);
            
         if arcpy.Exists(ustsstaterpt):
            arcpy.Delete_management(ustsstaterpt);
         
         g_config.build_from_schema(
             schemaid          = 'usts'
            ,datasetname       = ustsrpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         g_config.build_from_schema(
             schemaid          = 'ustsstaterpt'
            ,datasetname       = ustsstaterpt
            ,aprx              = aprx
            ,wrkspc            = wrkspc
         );
         
         ustsrpt_flds      = g_config.flds_from_schema('usts'        ,aprx=aprx,wrkspc=wrkspc,match_etl=boo_match_etl);
         ustsstaterpt_flds = g_config.flds_from_schema('ustsstaterpt',aprx=aprx,wrkspc=wrkspc)
         
         bef_cnt = arcpy.management.GetCount(usts_src)[0]; 
         arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
         
         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = ustsrpt
            ,field_names = ustsrpt_flds
         ) as outcurs:
         
            with arcpy.da.SearchCursor(
                in_table     = usts_src
               ,field_names  = ustsrpt_flds
            ) as incurs:
               
               for row in incurs:
                     
                  outcurs.insertRow(row);
                  
                  if ins_cnt > 0 and ins_cnt % 10000 == 0:
                     arcpy.AddMessage(". harvested " + str(ins_cnt) + " usts records...");
                  
                  ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " usts records.");
         aft_cnt = arcpy.management.GetCount(ustsrpt)[0];

         ######################################################################
         ins_cnt = 0;
         with arcpy.da.InsertCursor(
             in_table    = ustsstaterpt
            ,field_names = ustsstaterpt_flds
         ) as outcurs:
            
            cursor.execute("""
               SELECT
                a.state
               ,a.tank_status
               ,COUNT(*) AS cnt
               FROM
               main.ustsrpt_""" + rpt_tag + """ a
               GROUP BY
                a.state
               ,a.tank_status
               ORDER BY
                a.state
               ,a.tank_status
            """);

            for row in cursor:
               outcurs.insertRow(row);
               ins_cnt = ins_cnt + 1;

         arcpy.AddMessage(". Inserted " + str(ins_cnt) + " ustsstaterpt records.");
         conn.commit();
         
         arcpy.AddMessage("USTs reports loaded.");
         
         ######################################################################
         ustsstaterpt_csv = os.path.join(aprx.homeFolder,'ustsstaterpt_' + rpt_tag + '.csv');
         if arcpy.Exists(ustsstaterpt_csv):
            arcpy.Delete_management(ustsstaterpt_csv);
         arcpy.management.CopyRows(ustsstaterpt,ustsstaterpt_csv);
         
      del conn;

###############################################################################
def check_nfa_letter_urls(
    rel
):
   cnt1 = 0;
   cnt2 = 0;
   cnt3 = 0;
   cnt4 = 0;
   bad1 = 0;
   bad2 = 0;
   bad3 = 0;
   bad4 = 0;
   arcpy.AddMessage("Checking NFA URL validity.");
   
   cnt = 0;
   with arcpy.da.SearchCursor(
       in_table     = rel
      ,field_names  = ['lust_id','tribe','nfa_letter_1','nfa_letter_2','nfa_letter_3','nfa_letter_4']
      ,where_clause = 'nfa_letter_1 IS NOT NULL OR nfa_letter_2 IS NOT NULL OR nfa_letter_3 IS NOT NULL OR nfa_letter_4 IS NOT NULL' 
   ) as scursor:
      
      for row in scursor:
      
         lust_id      = row[0];
         tribe        = row[1];
         nfa_letter_1 = row[2];
         nfa_letter_2 = row[3];
         nfa_letter_3 = row[4];
         nfa_letter_4 = row[5];
   
         if nfa_letter_1 is not None:
            cnt1 = cnt1 + 1;
            z = requests.head(nfa_letter_1);
            if z.status_code != 200:
               arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 1 " + nfa_letter_1 + " returned status " + str(z.status_code));
               bad1 = bad1 + 1;
   
         if nfa_letter_2 is not None:
            cnt2 = cnt2 + 1;
            z = requests.head(nfa_letter_2);
            if z.status_code != 200:
               arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 2 " + nfa_letter_2 + " returned status " + str(z.status_code));
               bad2 = bad2 + 1;
               
         if nfa_letter_3 is not None:
            cnt3 = cnt3 + 1;
            z = requests.head(nfa_letter_3);
            if z.status_code != 200:
               arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 3 " + nfa_letter_3 + " returned status " + str(z.status_code));
               bad3 = bad3 + 1;
               
         if nfa_letter_4 is not None:
            cnt4 = cnt4 + 1;
            z = requests.head(nfa_letter_4);
            if z.status_code != 200:
               arcpy.AddMessage(". lust id " + lust_id + " for tribe " + tribe + " nfa letter 4 " + nfa_letter_4 + " returned status " + str(z.status_code));
               bad4 = bad4 + 1;
               
         if cnt > 0 and cnt % 1000 == 0:
            arcpy.AddMessage(". checked " + str(cnt) + " nfa letter sets...");
         
         cnt = cnt + 1;
         
   arcpy.AddMessage(". checked " + str(cnt1) + " nfa 1 urls, found " + str(bad1) + " problems.");
   arcpy.AddMessage(". checked " + str(cnt2) + " nfa 2 urls, found " + str(bad2) + " problems."); 
   arcpy.AddMessage(". checked " + str(cnt3) + " nfa 3 urls, found " + str(bad3) + " problems.");     
   arcpy.AddMessage(". checked " + str(cnt4) + " nfa 4 urls, found " + str(bad4) + " problems.");      
         
def dznull(cell):    
         
   try:
      if cell is None:
         return None;
      elif pd.isnull(cell) or pd.isna(cell):
         return None;
      elif is_numeric_dtype(cell):
         return None
      elif str(cell) in ['None','NaN','Null','',' ']:
         return None;
         
   except:
      arcpy.AddMessage("choking on " + str(cell));
      raise;
      
   return cell;

def lust_int(val):
   
   if val is None or val == '' or val == ' ':
      return None;
      
   rez = int(val);
      
   return rez;
   
def lust_float(val):
   
   if val is None or val == '' or val == ' ':
      return None;
      
   rez = float(val);
  
   return rez;
         
def lust_time(val):
   
   if val is None or val == '' or val == ' ':
      return None;
      
   elems = val.split('-');
   
   if len(elems) != 3:
      raise Exception("unable to parse " + str(val));
      
   dy = int(elems[0]);
   
   smnt = elems[1].lower();
   if smnt == 'jan':
      mnt = 1;
   elif smnt == 'feb':
      mnt = 2;
   elif smnt == 'mar':
      mnt = 3;
   elif smnt == 'apr':
      mnt = 4;
   elif smnt == 'may':
      mnt = 5;
   elif smnt == 'jun':
      mnt = 6;
   elif smnt == 'jul':
      mnt = 7;
   elif smnt == 'aug':
      mnt = 8;
   elif smnt == 'sep':
      mnt = 9;
   elif smnt == 'oct':
      mnt = 10;
   elif smnt == 'nov':
      mnt = 11;
   elif smnt == 'dec':
      mnt = 12;
      
   yr = int(elems[2]);
   
   if len(elems[2]) == 2:

      if yr > 40:
         yr = 1900 + yr;
      else:
         yr = 2000 + yr;
         
   return datetime.datetime(year=yr,month=mnt,day=dy);
   
def lust_trim(val,amt):
   
   if val is None or val == '' or val == ' ':
      return None;
      
   return val[:amt];
   