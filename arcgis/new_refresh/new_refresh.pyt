# -*- coding: utf-8 -*-

import arcpy,os,sys,json,csv;
from arcgis.gis import GIS;
from arcgis.features import FeatureLayerCollection,FeatureLayer;
import pandas as pd;
import numpy as np;
from pandas.api.types import is_numeric_dtype;
import sqlite3;

##############################################################################
g_tribal_fac = 'TrUSTD UST Facilities 11-19-25.csv';
g_tribal_rel = 'TrUSTD LUST UF1 11-19-25.csv';
g_tribal_usts = 'TrUSTD USTs UF1 11-19-25.csv';

# default zoom is set to Washington, DC
g_default_zoom = arcpy.Extent(
    XMin = -78.21
   ,YMin =  38.11
   ,XMax = -75.65
   ,YMax =  39.28
   ,spatial_reference = arcpy.SpatialReference(4326)
).projectAs(arcpy.SpatialReference(3857));

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
      self.tools.append(DeduplicateAGOUST);
      self.tools.append(LoadTribalCSVsUST);
      self.tools.append(UpsertTribalDataUST);
      self.tools.append(RebuildMapsUST);
      
      
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
         str_clause = "objectid <= 150";
      else:
         str_clause = None;
      
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
      ust = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(ust):
         raise Exception('usts not found');

      #########################################################################
      arcpy.AddMessage("harvesting facilities");
      bef_cnt = arcpy.management.GetCount(gs.url + '/0')[0]; 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = fac);
      arcpy.management.Append(
          inputs      = gs.url + '/0'
         ,target      = fac
         ,schema_type = 'NO_TEST'
         ,expression  = str_clause
      );
      aft_cnt = arcpy.management.GetCount(fac)[0];
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");      
      
      arcpy.AddMessage("harvesting releases");
      bef_cnt = arcpy.management.GetCount(gs.url + '/1')[0]; 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = rel);
      arcpy.management.Append(
          inputs      = gs.url + '/1'
         ,target      = rel
         ,schema_type = 'NO_TEST'
         ,expression  = str_clause
      );
      aft_cnt = arcpy.management.GetCount(rel)[0];
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      arcpy.AddMessage("harvesting facilities_by_county");
      bef_cnt = arcpy.management.GetCount(gs.url + '/2')[0]; 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = fbc);
      arcpy.management.Append(
          inputs      = gs.url + '/2'
         ,target      = fbc
         ,schema_type = 'NO_TEST'
         ,expression  = str_clause
      );
      aft_cnt = arcpy.management.GetCount(fbc)[0];
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      arcpy.AddMessage("harvesting releases_by_county");
      bef_cnt = arcpy.management.GetCount(gs.url + '/3')[0]; 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.TruncateTable(in_table = rbc);
      arcpy.management.Append(
          inputs      = gs.url + '/3'
         ,target      = rbc
         ,schema_type = 'NO_TEST'
         ,expression  = str_clause
      );
      aft_cnt = arcpy.management.GetCount(rbc)[0];
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      arcpy.AddMessage("harvesting usts");
      arcpy.management.TruncateTable(in_table = ust);
      bef_cnt = arcpy.management.GetCount(gs.url + '/4')[0]; 
      arcpy.AddMessage(". AGO has " + str(bef_cnt) + " records.");
      arcpy.management.Append(
          inputs      = gs.url + '/4'
         ,target      = ust
         ,schema_type = 'NO_TEST'
         ,expression  = str_clause
      );
      aft_cnt = arcpy.management.GetCount(ust)[0];
      arcpy.AddMessage(". Target has " + str(aft_cnt) + " records.");
      
      #########################################################################
      arcpy.AddMessage("Cleaning up bad keys");
      
      with arcpy.da.UpdateCursor(
          in_table     = fac
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'state'
          ]
      ) as ucursor:
         
         for row in ucursor:
            boo_update = False;
            
            if row[1] == '':
               boo_update = True;
               row[1] = None;
               
            if row[2] == '':
               boo_update = True;
               row[2] = None;
               
            if boo_update:
               ucursor.updateRow(row);
               arcpy.AddMessage(". bad keys on facilities objectid " + str(row[0]));
               
      with arcpy.da.UpdateCursor(
          in_table     = rel
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'lust_id'
            ,'state'
          ]
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
               arcpy.AddMessage(". bad keys on releases objectid " + str(row[0]));
               
      with arcpy.da.UpdateCursor(
          in_table     = rel
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'tank_id'
            ,'state'
          ]
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
               arcpy.AddMessage(". bad keys on usts objectid " + str(row[0]));
      
###############################################################################
class DeduplicateAGOUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A3 Deduplicate AGO";
      self.name               = "DeduplicateAGOUST";
      self.description        = "DeduplicateAGOUST";
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
      arcpy.AddMessage("Checking for bad facilities records with empty keys.");
      with arcpy.da.UpdateCursor(
          in_table     = fac
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'state'
          ]
      ) as ucursor:
         
         for row in ucursor:
            if row[1] is None or row[2] is None:
               arcpy.AddMessage(". deleting facilities row " + str(row[0]) + " having empty keys");
               ucursor.deleteRow();
      
      #########################################################################      
      arcpy.AddMessage("Checking for bad releases records with empty keys.");
      with arcpy.da.UpdateCursor(
          in_table     = rel
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'lust_id'
            ,'state'
          ]
      ) as ucursor:
         
         for row in ucursor:
            if row[1] is None and row[2] is None:
               arcpy.AddMessage(". deleting releases row " + str(row[0]) + " having no facility or lust id");
               ucursor.deleteRow();
               
            if row[2] is None or row[3] is None:
               arcpy.AddMessage(". deleting releases row " + str(row[0]) + " having empty keys");
               ucursor.deleteRow();
      
      #########################################################################      
      arcpy.AddMessage("Checking for bad usts records with empty keys.");
      with arcpy.da.UpdateCursor(
          in_table     = usts
         ,field_names  = [
             'objectid'
            ,'facility_id'
            ,'state'
            ,'tank_id'
          ]
      ) as ucursor:
         
         for row in ucursor:
            if row[1] is None or row[2] is None or row[3] is None:
               arcpy.AddMessage(". deleting usts row " + str(row[0]) + " having empty keys");
               ucursor.deleteRow();
      
      #########################################################################
      arcpy.AddMessage("Setting up temp tables.");
      
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
      
      conn.commit();
                    
      #########################################################################      
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
               if zip_code == 0:
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
               
         arcpy.AddMessage(". examining " + str(row[0]) + " " + str(row[1]) + " having " + str(row[2]) + " dups, keeping " + str(winner[0]) + " with score " + str(winner[1]) + ".");
         
         cursor2.execute("""
            DELETE FROM main.facilities
            WHERE
                facility_id = ?
            AND state       = ?
            AND objectid   != ?
         """,[row[0],row[1],winner[0]]);  
      
      conn.commit();
      
      #########################################################################      
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
               if zip_code == 0:
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
      
      conn.commit();
      
      #########################################################################      
      arcpy.AddMessage("Scoring and removing usts dups.");
      facscore = {};
      
      cursor.execute("""
         SELECT
          a.facility_id
         ,a.state
         ,a.tank_id
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
            ,a.tank_id
            ,a.state
            ,a.tank_status
            ,a.installation_date
            ,a.removal_date
            ,a.capacity
            ,a.substances
            ,a.tank_wall_type
            FROM
            main.facilities a
            WHERE
                COALESE(a.facility_id,'') || a.lust_id  = ?
            AND a.state = ?
         """,[row[0],row[1]]);
         
         for row2 in cursor2:
            score    = 0;
            
            objectid       = row2[0];
            facility_id    = row2[1];
            tank_status    = row2[4];
            installation_date = row2[5];
            removal_date   = row2[6];
            capacity       = row2[7];
            tank_wall_type = row2[8];
            
            if tank_status is not None:
               score += 1;
            
            if installation_date is not None:
               score += 1;
            
            if removal_date is not None:
               score += 1;
            
            if capacity is not None:
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
      
      conn.commit();
      
      del conn;
      
      arcpy.AddMessage("Deduplication complete.");
              
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
      
      params = [
          param0
         ,param1
         ,param2
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

      def dznull(cell):       
         try:
            if cell is None:
               return None;
            elif pd.isnull(cell) or pd.isna(cell):
               return None;
            elif is_numeric_dtype(cell):
               return None
            elif str(cell) in ['None','NaN','Null']:
               return None;
               
         except:
            arcpy.AddMessage("choking on " + str(cell));
            raise;
            
         return cell;
      
      aprx = g_config.aprx;
      wrkspc = g_config.wrkspc;
      arcpy.env.workspace = wrkspc;
      
      src_fac  = parameters[0].valueAsText;
      src_rel  = parameters[1].valueAsText;
      src_usts = parameters[2].valueAsText;
      
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
         
      #########################################################################
      etl_dict = g_config.etl_lkup('tribal_fac',aprx=aprx,wrkspc=wrkspc);
      
      with arcpy.da.InsertCursor(
          in_table    = trb_fac
         ,field_names = g_config.flds('tribal_fac',aprx=aprx,wrkspc=wrkspc)
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
         
      #########################################################################
      etl_dict = g_config.etl_lkup('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      
      with arcpy.da.InsertCursor(
          in_table    = trb_rel
         ,field_names = g_config.flds('tribal_rel',aprx=aprx,wrkspc=wrkspc)
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
                        
      #########################################################################
      etl_dict = g_config.etl_lkup('tribal_usts',aprx=aprx,wrkspc=wrkspc);
      
      with arcpy.da.InsertCursor(
          in_table    = trb_usts
         ,field_names = g_config.flds('tribal_usts',aprx=aprx,wrkspc=wrkspc)
      ) as icursor:
      
         with open(src_usts,'r') as file:
            reader = csv.DictReader(file);
            headers = reader.fieldnames;
         
            for row in reader:
               inrow = [None] * len(etl_dict);
              
               for item in headers:
              
                  if item in etl_dict:
                     inrow[etl_dict[item]] = dznull(row[item]);
                     
               icursor.insertRow(inrow); 
      
      #########################################################################
      arcpy.AddMessage("Tribal CSVs loaded.");
   
###############################################################################
class UpsertTribalDataUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A5 Upsert Tribal Data";
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
         
      ust = g_config.datasource('usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(ust):
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
      conn = sqlite3.connect(aprx.defaultGeodatabase);
      cursor = conn.cursor();
      
      cursor.execute("""DROP TABLE IF EXISTS main.temp_work""");
      
      cursor.execute("""
         CREATE TABLE main.temp_work(
             dataset     TEXT(255)
            ,identifier  TEXT(255)
            ,actiontaken TEXT(255)
            ,PRIMARY KEY(dataset,identifier)
         )
      """);
      
      conn.commit();
 
      cursor.execute("""    
         INSERT INTO main.temp_work(
             dataset
            ,identifier
            ,actiontaken
         )
         SELECT
          'facilities' 
         ,a.facility_id
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
            ,bb.facility_id AS checkit
            FROM
            main.tribal_fac aa
            LEFT JOIN
            main.facilities bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state = bb.state
         ) a
      """);
      
      cursor.execute("""    
         INSERT INTO main.temp_work(
             dataset
            ,identifier
            ,actiontaken
         )
         SELECT
          'releases'
         ,a.facility_id
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
            ,bb.facility_id AS checkit
            FROM
            main.tribal_rel aa
            LEFT JOIN
            main.releases bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state = bb.state
         ) a
      """);
      
      cursor.execute("""    
         INSERT INTO main.temp_work(
             dataset
            ,identifier
            ,actiontaken
         )
         SELECT
          'usts'
         ,a.facility_id
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
            ,bb.facility_id AS checkit
            FROM
            main.tribal_fac aa
            LEFT JOIN
            main.facilities bb
            ON
                aa.location_id = bb.facility_id
            AND aa.state = bb.state
         ) a
      """);
      
      conn.commit();
      
      

      del conn;
      
###############################################################################
class RebuildMapsUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A6 Rebuild Maps";
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
      #########################################################################
      mapobj = g_config.build_map(
          mapid   = 'ust_finder_feature_layer'
         ,aprx    = aprx
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'facilities'
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'releases'
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'facilities_by_county'
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_layer(
          mapobj  = mapobj
         ,layerid = 'releases_by_county'
         ,wrkspc  = wrkspc
      );
      
      z1 = g_config.add_table(
          mapobj  = mapobj
         ,tableid = 'usts'
         ,wrkspc  = wrkspc
      );
      
      mapobj['map'].defaultCamera.setExtent(g_default_zoom);
      mapobj['map'].openView();
