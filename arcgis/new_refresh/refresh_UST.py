import arcpy,os,sys;
import arcgis;
import requests;
from importlib.util import spec_from_loader, module_from_spec;
from importlib.machinery import SourceFileLoader;

###############################################################################
# Define aprx
###############################################################################
project_root = os.path.dirname(os.path.realpath(__file__));
aprx_source = os.path.join(
    project_root
   ,'new_refresh.aprx'
);
aprx = arcpy.mp.ArcGISProject(aprx_source);
arcpy.AddMessage(". using aprx at " + str(aprx_source));

###############################################################################
# Validate .env file
###############################################################################
sys.path.append(project_root);
from configdz import ConfigDZ;

env = ConfigDZ.get_env_data(os.path.join(
    os.path.dirname(os.path.realpath(__file__))
   ,'.env'
));

if 'ngst_lib' not in env:
   raise Exception('error, no ngst_lib in .env file');
if not arcpy.Exists(env['ngst_lib']):
   raise Exception('err, ngst_lib not found at ' + str(env['ngst_lib']));
arcpy.AddMessage(". env seems valid");

sys.path.append(env['ngst_lib']);
import Geoplatform_Publishing3.GPOPublisher;
import Geoplatform_Publishing3.Utilities;
import Geoplatform_Utilities3.ScriptLogger;
import Geoplatform_Utilities3.SendEmail;
arcpy.AddMessage(". ngst libs loaded");

###############################################################################
# Set up email
###############################################################################
finalExtraEmailMessage= ""
#place to store non catastrophic errors that won't stop publishing if GDB was updated without error
extraErrorMessages=""

#set up logger
sl = Geoplatform_Utilities3.ScriptLogger.ScriptLogger('ECHOFGDB', emailLevel="DEBUG", logLevel="DEBUG");
sl.sender = "nccpythoninfo@epa.gov"
#Error messages will have different sender to help separate out emails in outlook
sl.errorSender = "nccpythonerrors@epa.gov"
# OC has requested to add Nick Spalt to the emails
#sl.recipients = ["Spalt.Nicholas@epa.gov","hultgren.torrin@epa.gov","Paul.Dziemiela@erg.com"]
sl.recipients = ["hultgren.torrin@epa.gov"]
sl.logger.info(". ngst logging and email setup");

try:
   
   ###############################################################################
   # Side load the project toolbox
   ###############################################################################
   toolbx = os.path.join(
       project_root
      ,'new_refresh.pyt'
   );
   sl.logger.info(". sideloading toolbox from " + toolbx);
   spec = spec_from_loader(
       'tlbx_sideloaded'
      ,SourceFileLoader(
          'tlbx_sideloaded'
         ,toolbx
       )
   );
   module = module_from_spec(spec);
   spec.loader.exec_module(module);
   sys.modules['tlbx_sideloaded'] = module;
   import tlbx_sideloaded;
   
   tlbx_sideloaded.g_config = ConfigDZ(
       config_file = "ust.json"
      ,aprx        = aprx
   );

   if not arcpy.Exists(aprx.defaultGeodatabase):
      arcpy.management.CreateMobileGDB(
          out_folder_path = os.path.dirname(aprx.defaultGeodatabase)
         ,out_name        = os.path.basename(aprx.defaultGeodatabase)
      );
      
   ###############################################################################
   sl.logger.info("--- Step 01: Rebuilding UST tables");

   st = tlbx_sideloaded.RebuildSystemUST();
   parameters = st.getParameterInfo();
   messages = None;
   rez = st.execute(parameters,messages);
          
   ###############################################################################
   sl.logger.info("--- Step 02: Reloading from UST AGO");

   st = tlbx_sideloaded.ReloadFromAGOUST();
   parameters = st.getParameterInfo();
   parameters[0].value = '5a3ae0ed53564b6fa519f08e30e79e93';
   # Toggling this switch will limit export to 100 records for testing purposes
   parameters[1].value = False;
   messages = None;
   rez = st.execute(parameters,messages);
   
   ###############################################################################
   sl.logger.info("--- Step 03: Normalizing UST data");

   st = tlbx_sideloaded.NormalizeAGOUST();
   parameters = st.getParameterInfo();
   messages = None;
   rez = st.execute(parameters,messages);
   
   ###############################################################################
   sl.logger.info("--- Step 04: Load Tribal CSV data");

   st = tlbx_sideloaded.LoadTribalCSVsUST();
   parameters = st.getParameterInfo();
   parameters[0].value = os.path.join(aprx.homeFolder,'TrUSTD UST Facilities 11-19-25.csv');
   parameters[1].value = os.path.join(aprx.homeFolder,'TrUSTD LUST UF1 11-19-25.csv');
   parameters[2].value = os.path.join(aprx.homeFolder,'TrUSTD USTs UF1 11-19-25.csv');
   parameters[3].value = os.path.join(aprx.homeFolder,'TrUSTD Release Report list for FY25 NFA letter 508 compliance and linking to UF.csv');
   messages = None;
   rez = st.execute(parameters,messages);
   
   ###############################################################################
   sl.logger.info("--- Step 05: Geocode Tribal CSV data");

   st = tlbx_sideloaded.GeocodeTribalUST();
   parameters = st.getParameterInfo();
   messages = None;
   rez = st.execute(parameters,messages);
   
   ###############################################################################
   sl.logger.info("--- Step 06: Upsert Tribal data into UST");

   st = tlbx_sideloaded.UpsertTribalDataUST();
   parameters = st.getParameterInfo();
   messages = None;
   rez = st.execute(parameters,messages);

   ###############################################################################
   sl.logger.info("--- Step 07: Rebuilding UST map");
      
   st = tlbx_sideloaded.RebuildMapsUST();
   parameters = st.getParameterInfo();
   messages = None;
   rez = st.execute(parameters,messages); 

except(Exception):
   #send error email
   sl.handleExceptionOutput(sys.exc_info(),sender=sl.errorSender, message=extraErrorMessages)
   raise;

###############################################################################
service_lookup = {
    "UST_Finder_Feature_Layer_2": "Facilities"
   ,"UST_Finder_Feature_Layer_2": "Releases"
   ,"UST_Finder_Feature_Layer_2": "Facilities_by_County"
   ,"UST_Finder_Feature_Layer_2": "Release_by_County"
   ,"UST_Finder_Feature_Layer_2": "USTs"
}

###############################################################################
# Beyond this is Geoservices code
###############################################################################
sys.exit(0)

for map_source in service_lookup:
   try:
      pub1 = Geoplatform_Publishing3.GPOPublisher.Publisher(
          sl=sl
         ,PROJECT_FILE = aprx.filePath
         ,SERVICE_NAME = service_lookup[map_source]
         ,GPOLOGIN     = "OECA_EPA"
         ,MAPNAME      = map_source
      );
      pub1.check_schemas = True;
      #pub1.publish()
      pub1.newOverwrite()
      finalExtraEmailMessage += gpo_target + " hosted feature service updated successfully.\n"

   except(Exception):
      #send error email
      sl.handleExceptionOutput(
          sys.exc_info()
         ,sender  = sl.errorSender
         ,message = extraErrorMessages
      );

Geoplatform_Utilities3.SendEmail.send(
   sender      = sl.errorSender
  ,recipients  = sl.recipients
  ,subject     = "ECHO AGO FGDB refresh"
  ,body        = finalExtraEmailMessage
  ,contentType = "text/plain"
  ,attachments = None
);

###############################################################################
# Refresh complete
###############################################################################
sl.logger.info("   refresh complete");

sl.handleFinalOutput(finalExtraEmailMessage)
 
  