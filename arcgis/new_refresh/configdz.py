import arcpy,os,sys,json,shutil;

###############################################################################
class ConfigDZ:
   
   #...........................................................................
   def __init__(
       self
      ,config_file
      ,aprx
      ,wrkspc = None
   ):
      self.aprx = aprx;
         
      if wrkspc is None:
         self.wrkspc = aprx.defaultGeodatabase;
         wrkspc = self.wrkspc;
      else:
         self.wrkspc = wrkspc
         
      with open(
          os.path.join(os.path.dirname(os.path.realpath(__file__)),config_file)
         ,'r'
      ) as f:
         self.g_config = json.load(f);
         
      env_path = os.path.join(os.path.dirname(os.path.realpath(__file__)),".env");
      if arcpy.Exists(env_path):
         self.env  = ConfigDZ.get_env_data(env_path);
      else:
         self.env = {};
         
   #...........................................................................
   def datasource(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " dataset not found");
         
      if "geodatabase" not in self.g_config['datasets'][datasetid]:
         raise Exception("geodatabase missing from config datasets");
         
      if "datasource" not in self.g_config['datasets'][datasetid]:
         raise Exception("geodatabase missing from config datasets");
         
      if self.g_config['datasets'][datasetid]['geodatabase'] == "default":
         gd = aprx.defaultGeodatabase;
      else:
         gd = self.g_config['datasets'][datasetid]['geodatabase'];
         
      df = self.g_config['datasets'][datasetid]['datasource'];
      
      return os.path.join(gd,df);
      
   #...........................................................................
   def relationshipclass(
       self
      ,relationshipclassid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if relationshipclassid not in self.g_config['relationshipclasses']:
         raise Exception(str(relationshipclassid) + " relationshipclass not found");
         
      if "geodatabase" not in self.g_config['relationshipclasses'][relationshipclassid]:
         raise Exception("geodatabase missing from config relationshipclasses");
         
      if "datasource" not in self.g_config['relationshipclasses'][relationshipclassid]:
         raise Exception("geodatabase missing from config relationshipclasses");
         
      if self.g_config['relationshipclasses'][relationshipclassid]['geodatabase'] == "default":
         gd = aprx.defaultGeodatabase;
      else:
         gd = self.g_config['relationshipclasses'][relationshipclassid]['geodatabase'];
         
      df = self.g_config['relationshipclasses'][relationshipclassid]['datasource'];
      
      return os.path.join(gd,df);
   
   #...........................................................................
   def etlsrc(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if "etlsrc" not in self.g_config['datasets'][datasetid]:
         raise Exception("etlsrc not found in config dataset");
         
      return self.g_config['datasets'][datasetid]["etlsrc"];

   #...........................................................................
   def fld_def(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = [];
      for item in self.g_config['schemas'][schemaid]["flds"]:
         
         results.append(item[:6]);
      
      return results;

   #...........................................................................
   def fld_idx(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = [];
      for item in self.g_config['schemas'][schemaid]["flds"]:
      
         if item[6]:
            results.append(item[0]);
            
      return results;
   
   #...........................................................................
   def flds(
       self
      ,datasetid
      ,aprx      = None
      ,wrkspc    = None
      ,match_etl = False
      ,prefix    = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = [];
      for item in self.g_config['schemas'][schemaid]["flds"]:
         
         if match_etl and item[7] is None:
            pass;
         else:
            r = item[0];
            
            if prefix is not None:
               r = prefix + '.' + r;   
            
            results.append(r);
            
      return results;
      
   #...........................................................................
   def etl_flds(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = [];
      for item in self.g_config['schemas'][schemaid]["flds"]:
         
         if item[7] is not None:
            results.append(item[7]);
            
      return results;
      
   #...........................................................................
   def lkup(
       self
      ,datasetid
      ,search     = None
      ,results    = None
      ,aprx       = None
      ,wrkspc     = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
      
      if search is None:
         search = 'flds';
         
      if results is None:
         results = 'flds';
      
      idx = 0;
      rez = {};
         
      for item in self.g_config['schemas'][schemaid]["flds"]:
         
         if search == 'flds':
         
            if results == 'flds':
               rez[item[0]] = idx;
               idx = idx + 1;
               
            elif results == 'etl':
               if item[7] is not None:
                  rez[item[0]] = idx;
                  idx = idx + 1;
         
         elif search == 'etl':
            
            if results == 'flds':
               if item[7] is not None:
                  rez[item[7]] = idx;
               idx = idx + 1;
               
            elif results == 'etl':
               if item[7] is not None:
                  rez[item[7]] = idx;
                  idx = idx + 1;
                  
      return rez;
   
   #...........................................................................
   def alias_dict(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = {};
      for item in self.g_config['schemas'][schemaid]["flds"]:
      
         if item[0].lower() not in ['objectid','globalid','shape']:
            results[item[0]] = item[2];
            
      return results;
      
   #...........................................................................
   def map_guid(
       self
      ,mapid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if mapid not in self.g_config['maps']:
         raise Exception(str(mapid) + " not found in config maps");
         
      if 'guid' not in self.g_config['maps'][mapid]:
         raise Exception("guid key for " + str(mapid) + " not found in config");
         
      return self.g_config['maps'][mapid]['guid'];
   
   #...........................................................................
   def cim_flds(
       self
      ,datasetid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if "flds" not in self.g_config['schemas'][schemaid]:
         raise Exception("flds element not found in config schemas");
         
      results = [];
      for item in self.g_config['schemas'][schemaid]["flds"]:
         fld = {
             "type"      : "CIMFieldDescription"
            ,"alias"     : item[2]
            ,"fieldName" : item[0]
            ,"visible"   : True
            ,"searchMode": "Exact"
         }
         
         if item[1] == 'DOUBLE':
            fld["numberFormat"] = {
                "type" : "CIMNumericFormat"
               ,"alignmentOption" : "esriAlignRight"
               ,"alignmentWidth" : 0
               ,"roundingOption" : "esriRoundNumberOfDecimals"
               ,"roundingValue" : 6
            }
            
         elif item[1] == 'LONG':
            fld["numberFormat"] = {
                "type" : "CIMNumericFormat"
               ,"alignmentOption" : "esriAlignRight"
               ,"alignmentWidth" : 0
               ,"roundingOption" : "esriRoundNumberOfDecimals"
               ,"roundingValue" : 0
            }
         
         results.append(fld);
         
      return results;
      
   #...........................................................................
   def get_map(
       self
      ,mapid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
         
      ary_maps = aprx.listMaps('*');
      
      if len(ary_maps) > 0:
         for item in ary_maps:
         
            if item.name == self.g_config['maps'][mapid]['mapname']:
               self.g_config['maps'][mapid]['map'] = item;
               break;
      
      return self.g_config['maps'][mapid];
      
   #...........................................................................
   def build_map(
       self
      ,mapid
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      mapobj = self.get_map(
          mapid = mapid
      );
      
      in_mapname = mapobj['mapname'];
      if 'mapx' not in mapobj:
         raise Exception("mapx not found in config");
         
      if mapobj['mapx'] is None or mapobj['mapx'] == "":
         raise Exception("mapx file not found " + str(mapobj['mapx']));
         
      in_mapx = os.path.join(aprx.homeFolder,mapobj['mapx']);
      
      if not arcpy.Exists(in_mapx):
         raise Exception("mapx not found " + in_mapx);
      
      md_title             = None;
      md_summary           = None;
      md_description       = None;
      md_credits           = None;
      md_tags              = None;
      md_accessConstraints = None;
      md_thumbnail         = None;
      
      if 'maptitle' in mapobj: 
         md_title = mapobj['maptitle'];
         
      if 'mapsummary' in mapobj:
         md_summary = mapobj['mapsummary'];
         
      if 'mapdescription' in mapobj:
         md_description = mapobj['mapdescription'];
         
      if 'mapcredits' in mapobj:
         md_credits = mapobj['mapcredits'];
         
      if 'maptags' in mapobj:
         md_tags = mapobj['maptags'];
         
      if 'mapaccess' in mapobj:
         md_accessConstraints = mapobj['mapaccess'];
         
      if 'mapthumbnail' in mapobj:
         md_thumbnail = mapobj['mapthumbnail'];
         
      #########################################################################
      ary_maps = aprx.listMaps('*');
      
      if len(ary_maps) > 0:
         
         boo_hit = False;
         for item in ary_maps:
            
            for suf in ['1','2','3','4','5','6','7','8','9']:
               if item.name == in_mapname + suf:
                  arcpy.AddMessage("removing existing " + item.name);
                  aprx.deleteItem(item);
                  
            if item.name == in_mapname:
               aprx.deleteItem(item);
               break;            

      #########################################################################
      mapx = self.tempMapx(
          mapxfile    = in_mapx
         ,name        = in_mapname
      );
      map = aprx.importDocument(mapx);

      md = map.metadata;
      
      if md_title is not None:
         md.title = md_title;
         
      if md_summary is not None:
         md.summary = md_summary;
         
      if md_description is not None:
         md.description = md_description;
         
      if md_credits is not None:
         md.credits = md_credits;
         
      if md_tags is not None:
         md.tags = md_tags;
      
      if md_accessConstraints is not None:
         md.accessConstraints = md_accessConstraints;
     
      # Weirdly, the thumbnailUri will import and then delete the icon file
      # So we copy it to temp and let the managling happen on the copy
      if md_thumbnail is not None:
         if md_thumbnail.lower()[:4] == 'http':
            md.thumbnailUri = md_thumbnail;
         
         else:
            icon_scratch = os.path.join(arcpy.env.scratchFolder,md_thumbnail);
            shutil.copyfile(os.path.join(aprx.homeFolder,md_thumbnail),icon_scratch);
            
            md.thumbnailUri = icon_scratch;
      
      md.save();
      
      mapobj['map'] = map;
      
      return mapobj;
         
   #...........................................................................
   def tempMapx(
       self
      ,mapxfile
      ,name
      ,aprx   = None
      ,wrkspc = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      with open(mapxfile,"r") as jsonFile_target:
         data_in = json.load(jsonFile_target);

      if 'mapDefinition' in data_in:
      
         if name is not None:
            data_in['mapDefinition']['name'] = name;
         
      mapx_target = os.path.join(arcpy.env.scratchFolder,name + '.mapx');
      with open(mapx_target,"w") as jsonFile:
         json.dump(data_in,jsonFile);

      return mapx_target;
   
   #...........................................................................
   def tempLyrx(
       self
      ,in_layerfile
      ,dataset
      ,searchName
      ,name             = None
      ,displayfield     = None
      ,description      = None
      ,summary          = None
      ,popupInfoTitle   = None
      ,visibility       = None
      ,serviceLayerID   = None
      ,cim_fields       = None
      ,workspaceFactory = None
      ,timeEnabled      = None
      ,aprx             = None
      ,wrkspc           = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      #........................................................................
      fldaliashash = {};
      flds = arcpy.ListFields(dataset);
      for fld in flds:
         if not fld.required:
            fldaliashash[fld.name] = fld.aliasName;      
      
      #........................................................................
      with open(in_layerfile,"r") as jsonFile_target:
         data_in = json.load(jsonFile_target);
      
      boo_check = False;
      
      #........................................................................
      if 'layerDefinitions' in data_in:
         
         for item in data_in["layerDefinitions"]:
            
            if item["name"] == searchName:
               boo_check = True;
               
               item["featureTable"]["dataConnection"]["workspaceConnectionString"] = "DATABASE=" + aprx.defaultGeodatabase;
               item["featureTable"]["dataConnection"]["dataset"] = dataset;

               if "fieldDescriptions" in item["featureTable"]:
                  for fld in item["featureTable"]["fieldDescriptions"]:
                     if fld["fieldName"] in fldaliashash:
                        if fld["alias"] != fldaliashash[fld["fieldName"]]:
                           fld["alias"] = fldaliashash[fld["fieldName"]];  
                           
               if workspaceFactory is not None:
                  item["featureTable"]["dataConnection"]["workspaceFactory"] = workspaceFactory;
               
               if name is not None:
                  item["name"] = name;
                  
               if summary is not None:
                  item["summary"] = summary;
                  
               if description is not None:
                  item["description"] = description;
               
               if displayfield is not None:
                  item["displayfield"] = displayfield;
                  
               if popupInfoTitle is not None and "popupInfo" in item:
                  item["popupInfo"]["Title"] = popupInfoTitle;
                  
               if visibility is not None:
                  item["visibility"] = visibility;
                  
               if serviceLayerID is not None:
                  item["serviceLayerID"] = serviceLayerID;                
                  
               if cim_fields is not None and "featureTable" in item:
                  if "fieldDescriptions" in item["featureTable"]:
                     
                     has_shape = False;
                     has_glbid = False;
                     for fld in item["featureTable"]["fieldDescriptions"]:
                        
                        if fld["fieldName"].lower() == 'shape':
                           has_shape = True;
                           
                        if fld["fieldName"].lower() == 'globalid':
                           has_glbid = True;
                     
                     item["featureTable"]["fieldDescriptions"] = [
                         {
                            "type" : "CIMFieldDescription"
                           ,"alias" : "ObjectID"
                           ,"fieldName" : "objectid"
                           ,"numberFormat" : {
                               "type" : "CIMNumericFormat"
                              ,"alignmentOption" : "esriAlignRight"
                              ,"alignmentWidth" : 0
                              ,"roundingOption" : "esriRoundNumberOfDecimals"
                              ,"roundingValue" : 0
                            }
                           ,"readOnly" : True
                           ,"visible" : True
                           ,"searchMode" : "Exact"
                         }
                     ];
                     
                     if has_shape:
                        item["featureTable"]["fieldDescriptions"].append(
                            {
                               "type" : "CIMFieldDescription"
                              ,"alias" : "Shape"
                              ,"fieldName" : "shape"
                              ,"visible" : True
                              ,"searchMode" : "Exact"
                            }
                        );
                     
                     for fd in cim_fields: 
                        item["featureTable"]["fieldDescriptions"].append(fd);
                           
                     if has_glbid:
                        item["featureTable"]["fieldDescriptions"].append(
                            {
                               "type" : "CIMFieldDescription"
                              ,"alias" : "GlobalID"
                              ,"fieldName" : "globalid"
                              ,"visible" : True
                              ,"searchMode" : "Exact"
                            }
                        );     
               
               if timeEnabled is not None:
                  item["featureTable"]["timeFields"]["type"] = "CIMTimeTableDefinition";
                  
                  if 'startTimeField' in timeEnabled:
                     item["featureTable"]["timeFields"]["startTimeField"] = timeEnabled['startTimeField'];
                  
                  if 'endTimeField' in timeEnabled:
                     item["featureTable"]["timeFields"]["endTimeField"] = timeEnabled['endTimeField'];
      
      #........................................................................
      if 'tableDefinitions' in data_in:
         
         for item in data_in["tableDefinitions"]:
         
            if item["name"] == searchName:
               boo_check = True;
               
               item["dataConnection"]["workspaceConnectionString"] = "DATABASE=" + aprx.defaultGeodatabase;
               item["dataConnection"]["dataset"] = dataset;
               
               if workspaceFactory is not None:
                  item["dataConnection"]["workspaceFactory"] = workspaceFactory;

               if name is not None:
                  item["name"] = name;
                  
               if summary is not None:
                  item["summary"] = summary;
                  
               if description is not None:
                  item["description"] = description;
               
               if displayfield is not None:
                  item["displayfield"] = displayfield;
                  
               if serviceLayerID is not None:
                  item["serviceTableID"] = serviceLayerID;
      
      if not boo_check:
         raise Exception("searchName not found in lyrx file for " + str(searchName));
      
      lyrx_target = os.path.join(arcpy.env.scratchFolder,dataset + '.lyrx');
      with open(lyrx_target,"w") as jsonFile:
         json.dump(data_in,jsonFile);

      return lyrx_target;
         
   #...........................................................................
   def add_lyr_base(
       self
      ,in_map
      ,in_lyrx
      ,in_dataset
      ,in_searchName 
      ,in_name
      ,summary           = None
      ,description       = None
      ,in_popupInfoTitle = None
      ,displayfield      = None
      ,copyrighttext     = None
      ,accessConstraints = None
      ,symbology_fields  = None
      ,update_symbology  = None
      ,visibility        = None
      ,serviceLayerID    = None
      ,cim_fields        = None
      ,timeEnabled       = None
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      lyrx = self.tempLyrx(
          in_layerfile     = in_lyrx
         ,dataset          = os.path.basename(in_dataset)
         ,searchName       = in_searchName
         ,name             = in_name
         ,summary          = summary
         ,description      = description
         ,popupInfoTitle   = in_popupInfoTitle
         ,displayfield     = displayfield
         ,visibility       = visibility
         ,serviceLayerID   = serviceLayerID
         ,cim_fields       = cim_fields
         ,timeEnabled      = timeEnabled
         ,aprx             = aprx
         ,wrkspc           = wrkspc
      );
      
      lyrfile = arcpy.mp.LayerFile(lyrx);
 
      md = lyrfile.metadata;
      
      if description is not None:
         md.description = description;
         
      if copyrighttext is not None:
         md.credits = copyrighttext;
         
      if summary is not None:
         md.summary = summary;
         
      if accessConstraints is not None:
         md.accessConstraints = accessConstraints;
      
      md.save();
      
      lyr = in_map.addLayer(lyrfile,'BOTTOM');
      
      ############################################################################
      if symbology_fields is not None: 
         
         lyr = arcpy.management.ApplySymbologyFromLayer(
             in_layer           = lyr
            ,in_symbology_layer = lyrx
            ,symbology_fields   = symbology_fields
            ,update_symbology   = update_symbology
         );  
         
      return lyr;

   #...........................................................................
   def add_tbl_base(
       self
      ,in_map
      ,in_lyrx
      ,in_dataset
      ,in_searchName 
      ,in_name
      ,summary           = None
      ,description       = None
      ,displayfield      = None
      ,copyrighttext     = None
      ,accessConstraints = None
      ,serviceTableID    = None
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      tblx = self.tempLyrx(
          in_layerfile     = in_lyrx
         ,dataset          = os.path.basename(in_dataset)
         ,searchName       = in_searchName
         ,name             = in_name
         ,summary          = summary
         ,description      = description
         ,displayfield     = displayfield
         ,popupInfoTitle   = None
         ,visibility       = None
         ,serviceLayerID   = serviceTableID
         ,cim_fields       = None
         ,timeEnabled      = None
         ,aprx             = aprx
         ,wrkspc           = wrkspc
      );
      
      tbl = arcpy.mp.LayerFile(tblx);
      
      md = tbl.metadata;
      
      if description is not None:
         md.description = description;
         
      if copyrighttext is not None:
         md.credits = copyrighttext;
         
      if summary is not None:
         md.summary = summary;
         
      if accessConstraints is not None:
         md.accessConstraints = accessConstraints;
      
      md.save();

      tbl = in_map.addLayer(tbl);
      
      return tbl;
   
   #...........................................................................
   def add_layer(
       self
      ,mapobj
      ,layerid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if layerid not in mapobj['layers']:
         raise Exception("layerid not found in config " + str(layerid) + " " + str(mapobj['layers']));
      
      lyrobj = mapobj['layers'][layerid];
      if 'lyrx' not in lyrobj:
         raise Exception("lyrx for layer not found in config");
         
      lyrx   = os.path.join(aprx.homeFolder,lyrobj['lyrx']);
      if not arcpy.Exists(lyrx):
         raise Exception("lyrx file not found " + str(lyrx));
         
      datasetid = mapobj['layers'][layerid]['datasetid'];
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
           
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
      
      val_displayfield = None;
      val_description = None;
      val_copyrighttext = None;
      val_popupInfoTitle = None;
      val_symbology_fields = None;
      val_update_symbology = None;
      val_visibility = None;
      val_serviceLayerID = None;
      val_accessConstraints = None;
      val_cim_fields = None;
      val_timeEnabled = None;
      
      if 'displayfield' in lyrobj:
         val_displayfield = lyrobj['displayfield'];
         
      if 'description' in lyrobj:
         val_description = lyrobj['description'];
         
      if 'copyrighttext' in lyrobj:
         val_copyrighttext = lyrobj['copyrighttext'];
         
      if 'popupInfoTitle' in lyrobj:
         val_popupInfoTitle = lyrobj['popupInfoTitle'];
         
      if 'symbology_fields' in lyrobj:
         val_symbology_fields = lyrobj['symbology_fields'];
         
      if 'update_symbology' in lyrobj:
         val_update_symbology = lyrobj['update_symbology'];
         
      if 'visibility' in lyrobj:
         val_visibility = lyrobj['visibility'];
         
      if 'serviceLayerID' in lyrobj:
         val_serviceLayerID = lyrobj['serviceLayerID'];
         
      if 'accessConstraints' in lyrobj:
         val_accessConstraints = lyrobj['accessConstraints'];
         
      if 'cim_fields' in lyrobj:
         val_cim_fields = lyrobj['cim_fields'];
         
      if 'timeEnabled' in lyrobj:
         val_timeEnabled = lyrobj['timeEnabled'];
      
      lyr = self.add_lyr_base(
          in_map            = mapobj['map']
         ,in_lyrx           = lyrx
         ,in_dataset        = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc)
         ,in_searchName     = lyrobj['searchName']
         ,in_name           = lyrobj['name']
         ,description       = val_description
         ,in_popupInfoTitle = val_popupInfoTitle
         ,copyrighttext     = val_copyrighttext
         ,displayfield      = val_displayfield
         ,symbology_fields  = val_symbology_fields
         ,update_symbology  = val_update_symbology
         ,visibility        = val_visibility
         ,serviceLayerID    = val_serviceLayerID
         ,accessConstraints = val_accessConstraints
         ,cim_fields        = val_cim_fields
         ,timeEnabled       = val_timeEnabled
         ,aprx              = aprx
         ,wrkspc            = wrkspc
      );
      
      return lyr;

   #...........................................................................
   def add_table(
       self
      ,mapobj
      ,tableid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
         
      if tableid not in mapobj['tables']:
         raise Exception("tableid not found in config " + str(tableid) + " " + str(mapobj['tables']));
      
      tblobj = mapobj['tables'][tableid];
      if 'lyrx' not in tblobj:
         raise Exception("lyrx for table not found in config");
      
      lyrx   = os.path.join(aprx.homeFolder,tblobj['lyrx']);
      if not arcpy.Exists(lyrx):
         raise Exception("lyrx file not found " + str(lyrx));
         
      datasetid = mapobj['tables'][tableid]['datasetid'];
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception('schema ' + str(schemaid) + ' not found in config');
           
      val_displayfield = None;
      if 'displayfield' in tblobj:
         val_displayfield = tblobj['displayfield'];
      
      val_description = None;  
      if 'description' in tblobj:
         val_description = tblobj['description'];
         
      val_copyrighttext = None;
      if 'copyrighttext' in tblobj:
         val_copyrighttext = tblobj['copyrighttext'];
         
      val_serviceTableID = None;
      if 'serviceTableID' in tblobj:
         val_serviceTableID = tblobj['serviceTableID'];
         
      val_accessConstraints = None;
      if 'accessConstraints' in tblobj:
         val_accessConstraints = tblobj['accessConstraints'];
         
      tbl = self.add_tbl_base(
          in_map            = mapobj['map']
         ,in_lyrx           = lyrx
         ,in_dataset        = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc)
         ,in_searchName     = tblobj['searchName']
         ,in_name           = tblobj['name']
         ,description       = val_description
         ,displayfield      = val_displayfield
         ,copyrighttext     = val_copyrighttext
         ,accessConstraints = val_accessConstraints
         ,serviceTableID    = val_serviceTableID
         ,aprx              = aprx
         ,wrkspc            = wrkspc
      );
      
      return tbl;
   
   #...........................................................................
   def purge_domains(
       self
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      desc = arcpy.Describe(wrkspc);
      
      for domain in desc.Domains:
         arcpy.management.DeleteDomain(
             in_workspace = wrkspc
            ,domain_name  = domain
         );
            
      return 0;

   #...........................................................................
   def domain_exists(
       self
      ,domain_name
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      desc = arcpy.Describe(wrkspc);
      
      for domain in desc.Domains:
         if domain == domain_name:
            return True;
            
      return False;
   
   #...........................................................................
   def build_domains(
       self
      ,domain_name       = None
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
           
      if len(self.g_config['domains']) > 0:
            
         if domain_name is None:
            keys = [key for key in self.g_config['domains']];

         else:
            if domain_name not in self.g_config['domains']:
               raise Exception("domain missing from config");      
            
            else:
               keys = list(domain_name);         
         
         for item in keys:
            dm = self.g_config['domains'][item];
            
            arcpy.management.CreateDomain(
                in_workspace       = wrkspc
               ,domain_name        = dm["name"]
               ,domain_description = dm["description"]
               ,field_type         = dm["field_type"]
               ,domain_type        = dm["domain_type"]
               ,split_policy       = dm["split_policy"]
               ,merge_policy       = dm["merge_policy"]
            );
            
            if dm["domain_type"] == "CODED":
               
               for vals in dm["coded_values"]:
                  
                  arcpy.management.AddCodedValueToDomain(
                      in_workspace       = wrkspc
                     ,domain_name        = dm["name"]
                     ,code               = vals[0]
                     ,code_description   = vals[1]
                  );
                  
   #...........................................................................
   def build_dataset(
       self
      ,datasetid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;
      
      if datasetid not in self.g_config['datasets']:
         raise Exception(str(datasetid) + " not found in config datasets");
         
      if 'schemaid' not in self.g_config['datasets'][datasetid]:
         raise Exception("schemaid element not found in config datasets");
         
      schemaid = self.g_config['datasets'][datasetid]['schemaid'];
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schemaid " + str(schemaid) + " not found in config schemas");
         
      if 'geometry_type' in self.g_config['schemas'][schemaid]:
         if self.g_config['schemas'][schemaid]['geometry_type'] is not None:
            self.build_feature_class(
                datasetid = datasetid
               ,schemaid  = schemaid
               ,aprx      = aprx
               ,wrkspc    = wrkspc
            );
         
         else:
            self.build_table(
                datasetid = datasetid
               ,schemaid  = schemaid
               ,aprx      = aprx
               ,wrkspc    = wrkspc
            );

      else:
         self.build_table(
             datasetid = datasetid
            ,schemaid  = schemaid
            ,aprx      = aprx
            ,wrkspc    = wrkspc
         );
      
   #...........................................................................
   def build_feature_class(
       self
      ,datasetid
      ,schemaid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      if schemaid not in self.g_config['schemas']:
         raise Exception("schema missing from config")
         
      fc = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc);
      ob = self.g_config['schemas'][schemaid];
      
      if arcpy.Exists(fc):
         raise Exception("preexisting " + datasetid + " found");

      arcpy.CreateFeatureclass_management(
          out_path          = os.path.dirname(fc)
         ,out_name          = os.path.basename(fc)
         ,geometry_type     = ob["geometry_type"]
         ,has_m             = ob["has_m"]
         ,has_z             = ob["has_z"]
         ,spatial_reference = arcpy.SpatialReference(ob["srid"])
         ,oid_type          = ob["oid_type"]
      );

      arcpy.management.AddFields(
          in_table          = fc
         ,field_description = self.fld_def(datasetid)
      );
         
      for item in self.fld_idx(datasetid):
         arcpy.management.AddIndex(
             in_table   = fc
            ,fields     = [item]
            ,index_name = item + '_idx'
         );
         
      if 'add_globalids' in ob:
         if ob['add_globalids']:
            add_globalids = True;
            
         else:
            add_globalids = False;
         
      else:
         add_globalids = False;
         
      if add_globalids:
         arcpy.management.AddGlobalIDs(
            in_datasets  = fc
         );
   
   #...........................................................................
   def build_table(
       self
      ,datasetid
      ,schemaid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;  
      
      if schemaid not in self.g_config['schemas']:
         raise Exception("schema missing from config")
         
      tb = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc);
      ob = self.g_config['schemas'][schemaid];
      
      if arcpy.Exists(tb):
         raise Exception("preexisting " + datasetid + " found");

      arcpy.CreateTable_management(
          out_path          = os.path.dirname(tb)
         ,out_name          = os.path.basename(tb)
         ,oid_type          = ob["oid_type"]
      );

      arcpy.management.AddFields(
          in_table          = tb
         ,field_description = self.fld_def(datasetid)
      );
         
      for item in self.fld_idx(datasetid):
         arcpy.management.AddIndex(
             in_table   = tb
            ,fields     = [item]
            ,index_name = item + '_idx'
         );
         
      if 'add_globalids' in ob:
         if ob['add_globalids']:
            add_globalids = True;
            
         else:
            add_globalids = False;
         
      else:
         add_globalids = False;
         
      if add_globalids:
         arcpy.management.AddGlobalIDs(
            in_datasets  = tb
         );
      
   #...........................................................................
   def build_relationshipclass(
       self
      ,relationshipclassid
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;  
      
      if relationshipclassid not in self.g_config['relationshipclasses']:
         raise Exception("relationshipclass missing from config relationshipclasses");
         
      tb = self.relationshipclass(relationshipclassid,aprx=aprx,wrkspc=wrkspc);
      
      if arcpy.Exists(tb):
         raise Exception("preexisting " + str(relationshipclassid) + " found");
      
      origin_table = self.datasource(
          self.g_config['relationshipclasses'][relationshipclassid]['origin_datasetid']
         ,aprx=aprx,wrkspc=wrkspc
      );
      destination_table = self.datasource(
          self.g_config['relationshipclasses'][relationshipclassid]['destination_datasetid']
         ,aprx=aprx,wrkspc=wrkspc
      );
      
      if 'relationship_table_datasetid' in self.g_config['relationshipclasses'][relationshipclassid]:
         relationship_table = self.datasource(
             self.g_config['relationshipclasses'][relationshipclassid]['relationship_table_datasetid']
            ,aprx=aprx,wrkspc=wrkspc
         );
      else:
         relationship_table = None;
         
      if 'attribute_fields' in self.g_config['relationshipclasses'][relationshipclassid]:
         attribute_fields = self.g_config['relationshipclasses'][relationshipclassid]['attribute_fields'];
      else:
         attribute_fields = None;
         
      if 'attributed' in self.g_config['relationshipclasses'][relationshipclassid]:
         attributed = self.g_config['relationshipclasses'][relationshipclassid]['attributed'];
      else:
         attributed = None;
         
      if relationship_table is not None:
         arcpy.management.TableToRelationshipClass(
             origin_table            = origin_table
            ,destination_table       = destination_table
            ,out_relationship_class  = tb
            ,relationship_type       = self.g_config['relationshipclasses'][relationshipclassid]['relationship_type']
            ,forward_label           = self.g_config['relationshipclasses'][relationshipclassid]['forward_label']
            ,backward_label          = self.g_config['relationshipclasses'][relationshipclassid]['backward_label']
            ,message_direction       = self.g_config['relationshipclasses'][relationshipclassid]['message_direction']
            ,cardinality             = self.g_config['relationshipclasses'][relationshipclassid]['cardinality']
            ,relationship_table      = relationship_table
            ,attribute_fields        = attribute_fields
            ,origin_primary_key      = self.g_config['relationshipclasses'][relationshipclassid]['origin_primary_key']
            ,origin_foreign_key      = self.g_config['relationshipclasses'][relationshipclassid]['origin_foreign_key']
            ,destination_primary_key = self.g_config['relationshipclasses'][relationshipclassid]['destination_primary_key']
            ,destination_foreign_key = self.g_config['relationshipclasses'][relationshipclassid]['destination_foreign_key']
         );
         
      else:      
         arcpy.management.CreateRelationshipClass(
             origin_table            = origin_table
            ,destination_table       = destination_table
            ,out_relationship_class  = tb
            ,relationship_type       = self.g_config['relationshipclasses'][relationshipclassid]['relationship_type']
            ,forward_label           = self.g_config['relationshipclasses'][relationshipclassid]['forward_label']
            ,backward_label          = self.g_config['relationshipclasses'][relationshipclassid]['backward_label']
            ,message_direction       = self.g_config['relationshipclasses'][relationshipclassid]['message_direction']
            ,cardinality             = self.g_config['relationshipclasses'][relationshipclassid]['cardinality']
            ,attributed              = attributed
            ,origin_primary_key      = self.g_config['relationshipclasses'][relationshipclassid]['origin_primary_key']
            ,origin_foreign_key      = self.g_config['relationshipclasses'][relationshipclassid]['origin_foreign_key']
            ,destination_primary_key = self.g_config['relationshipclasses'][relationshipclassid]['destination_primary_key']
            ,destination_foreign_key = self.g_config['relationshipclasses'][relationshipclassid]['destination_foreign_key']
         );        
         
   #...........................................................................
   def get_env_data(
       path: str
   ) -> dict:

      rez = {};
      with open(path, 'r') as f:
         for line in f.readlines():
            line = line.replace('\n','');
            if '=' in line and not line.startswith('#'):
               a,b = line.split('=');
               rez[a] = b;
               
      return rez;
      
   #...........................................................................
   def coord2shape(
       p_x
      ,p_y
      ,int_srid = 4326
      ,out_srid = 3857
   ):
      
      if int_srid is None:
         int_srid = 4326;
         
      if out_srid is None:
         out_srid = 3857;
         
      if p_x is None or p_y is None:
         return None;
      
      num_x = None;
      num_y = None; 
      
      try:
         num_x = float(p_x);
      except ValueError:
         return None;
      
      try:
         num_y = float(p_y);
      except ValueError:
         return None;
            
      if num_x is None or num_y is None:
         return None;
         
      pnt   = arcpy.Point(num_x,num_y);
      pnt_1 = arcpy.PointGeometry(pnt,arcpy.SpatialReference(int_srid));
      pnt_2 = pnt_1.projectAs(arcpy.SpatialReference(out_srid));
      
      return pnt_2;   
      
   #...........................................................................
   def etl_fc_load(
       self
      ,datasetid
      ,boo_testdata
      ,p_truncate
      ,shape_long        = None
      ,shape_lat         = None
      ,shape_in_srid     = None
      ,shape_out_srid    = None
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      if 'sde_conn' not in self.env:
         raise Exception('error, no sde_conn in .env file');
         
      if not arcpy.Exists(self.env['sde_conn']):
         raise Exception('error, sde in .env not found');
      
      src = os.path.join(self.env['sde_conn'],self.g_config["datasets"][datasetid]["etlsrc"]);
      trg = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc);
      
      if p_truncate:
         arcpy.management.TruncateTable(trg);
      
      cnt_inserted = 0;
      arcpy.AddMessage("Exporting " + str(src) + "...");
      bef_cnt = arcpy.management.GetCount(src)[0];     
      arcpy.AddMessage(".  Database has " + str(bef_cnt) + " records.");
      
      etl_dict = self.lkup(datasetid,'etl','etl',aprx=aprx,wrkspc=wrkspc);

      if shape_long is None:
         inflds  = self.etl_flds(datasetid,aprx=aprx,wrkspc=wrkspc) + ["SHAPE@"];
         outflds = self.flds(datasetid,aprx=aprx,wrkspc=wrkspc,match_etl=True) + ["SHAPE@"]
      else:
         inflds = self.etl_flds(datasetid,aprx=aprx,wrkspc=wrkspc);
         outflds = self.flds(datasetid,aprx=aprx,wrkspc=wrkspc,match_etl=True) + ["SHAPE@"];
      
      with arcpy.da.InsertCursor(
          in_table     = trg
         ,field_names  = outflds
      ) as icursor:
         
         with arcpy.da.SearchCursor(
             in_table     = src
            ,field_names  = inflds
         ) as scursor:
            
            for row in scursor:
               
               if shape_long is None:      
                  icursor.insertRow(row);
                  cnt_inserted = cnt_inserted + 1;
                  
                  if boo_testdata and cnt_inserted >= 100:
                     break;
                  
               else:
                  shape = ConfigDZ.coord2shape(
                      p_x      = row[etl_dict[shape_long]]
                     ,p_y      = row[etl_dict[shape_lat]]
                     ,int_srid = shape_in_srid
                     ,out_srid = shape_out_srid                  
                  );
                  row2 = list(row);
                  row2.append(shape);
               
                  #if shape is not None:
                  if 1==1:
                     icursor.insertRow(row2);
                     cnt_inserted = cnt_inserted + 1;
                     
                     if boo_testdata and cnt_inserted >= 100:
                        break;               
               
      arcpy.AddMessage(".  " + str(cnt_inserted) + " records inserted.");
      if boo_testdata:
         bef_cnt = 100;
      aft_cnt = arcpy.management.GetCount(trg)[0];
      arcpy.AddMessage(".  Target table has " + str(aft_cnt) + " records.");
      if int(bef_cnt) != int(aft_cnt):
         raise Exception("counts failed to reconcile " + str(bef_cnt) + " <> " + str(aft_cnt));

   #...........................................................................
   def etl_tbl_load(
       self
      ,datasetid
      ,boo_testdata
      ,p_truncate
      ,aprx              = None
      ,wrkspc            = None
   ):

      if aprx is None:
         aprx = self.aprx;
         
      if wrkspc is None:
         if self.wrkspc is None:
            wrkspc = aprx.defaultGeodatabase;
         else:
            wrkspc = self.wrkspc;
      
      arcpy.env.workspace = wrkspc;

      if 'sde_conn' not in self.env:
         raise Exception('error, no sde_conn in .env file');
         
      if not arcpy.Exists(self.env['sde_conn']):
         raise Exception('error, sde in .env not found');
      
      src = os.path.join(self.env['sde_conn'],self.g_config["datasets"][datasetid]["etlsrc"]);
      trg = self.datasource(datasetid,aprx=aprx,wrkspc=wrkspc);
      
      if p_truncate:
         arcpy.management.TruncateTable(trg);
      
      cnt_inserted = 0;
      arcpy.AddMessage("Exporting " + str(src) + "...");
      bef_cnt = arcpy.management.GetCount(src)[0];     
      arcpy.AddMessage(".  Database has " + str(bef_cnt) + " records.");
      
      etl_dict = self.lkup(datasetid,'etl','etl',aprx=aprx,wrkspc=wrkspc);

      inflds = self.etl_flds(datasetid,aprx=aprx,wrkspc=wrkspc);
      outflds = self.flds(datasetid,aprx=aprx,wrkspc=wrkspc,match_etl=True);
      
      with arcpy.da.InsertCursor(
          in_table     = trg
         ,field_names  = outflds
      ) as icursor:
         
         with arcpy.da.SearchCursor(
             in_table     = src
            ,field_names  = inflds
         ) as scursor:
            
            for row in scursor:
               
               icursor.insertRow(row);
               cnt_inserted = cnt_inserted + 1;
                  
               if boo_testdata and cnt_inserted >= 100:
                  break;             
               
      arcpy.AddMessage(".  " + str(cnt_inserted) + " records inserted.");
      if boo_testdata:
         bef_cnt = 100;
      aft_cnt = arcpy.management.GetCount(trg)[0];
      arcpy.AddMessage(".  Target table has " + str(aft_cnt) + " records.");
      if int(bef_cnt) != int(aft_cnt):
         raise Exception("counts failed to reconcile " + str(bef_cnt) + " <> " + str(aft_cnt));
         
   #...........................................................................
   def layer_name(
       self
      ,mapid
      ,layerid
   ):
      
      if mapid not in self.g_config['maps']:
         raise Exception("mapid " + str(mapid) + " not found");
      
      if layerid not in self.g_config['maps'][mapid]['layers']:
         raise Exception("layerid " + str(layerid) + " for mapid " + str(mapid) + " not found");
         
      return self.g_config['maps'][mapid]['layers'][layerid]['name'];
      
   #...........................................................................
   def relationshipclass_name(
       self
      ,relationshipclassid
   ):
      
      if relationshipclassid not in self.g_config['relationshipclasses']:
         raise Exception("relationshipclasses " + str(mapid) + " not found");

      return self.g_config['relationshipclasses'][relationshipclassid]['name'];
      