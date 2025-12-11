# -*- coding: utf-8 -*-

import arcpy,os,sys,json,csv;
from arcgis.gis import GIS;
from arcgis.features import FeatureLayerCollection,FeatureLayer;

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
         
###############################################################################
class LoadTribalCSVsUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A3 Load Tribal CSVs";
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
      
      src_fac = parameters[0].valueAsText;
      src_rel = parameters[1].valueAsText;
      src_ust = parameters[2].valueAsText;
      
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
      
      #########################################################################
      arcpy.AddMessage("Tribal CSVs loaded.");
   
###############################################################################
class UpsertTribalDataUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A4 Upsert Tribal Data";
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
      arcpy.management.TruncateTable(in_table = trb_fac);
      
      trb_rel  = g_config.datasource('tribal_rel',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_rel):
         raise Exception('tribal releases table not found');
      arcpy.management.TruncateTable(in_table = trb_rel);
      
      trb_usts = g_config.datasource('tribal_usts',aprx=aprx,wrkspc=wrkspc);
      if not arcpy.Exists(trb_usts):
         raise Exception('tribal USTs table not found');
      arcpy.management.TruncateTable(in_table = trb_usts);

###############################################################################
class RebuildMapsUST(object):

   #...........................................................................
   def __init__(self):

      self.label              = "A5 Rebuild Maps";
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
