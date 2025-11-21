-- Suggested steps to manipulate the raw data provided by TRUSTD EPA and inserting back into the facility and release layers.

-- #1 - Download the existing tribal data from the feature service in the UST facility and releases layers somewhere you confomrtable with joining and maniulating the data. This for any record in the 2 layers where tribe_name is not null.  

-- #2 - Take the data in the excel files provided from EPA and join their Location ID to facility ID in #1. I want to say there are IDs reused so you might need to manually adjust some of these to make sure they join right. 


-- #3 - Create a new view/table/file for facilities and releases from the joined data that will be used to map back into the  UST facility and releases layers.  In general, you want to use the data from EPA provided excel files but here is logic/business rules EPA has directed us to use when building this updated data set.

/*

Reverse geocode new lat/longs for null, 0, and bad longitude values showing up in Asia/Europe using the ESRI world geocoder if possible.  If not, then check to see if the record from #1 has a good lat/long populated and use that.  If there are remaning coordinate issues then talk to EPA to see what they want to do about it.

update the Facility and release status values from the data in #1 so it matches what the app expects. Here is the crossswalk of TRUSTD to UST app statuses:

Releases data 
- Change the “closed” status in releases to “no further action” 

UST facility data 
-	Open UST(s) = non-operating, Abandoned, Operating, Temporary Closed 
-	Closed UST(s) - Permanent Closed 
-	Filter out blank and non-regulated

Trim the facility names so they don't go above 255 to avoid an app issue

For any fields not provided by EPA in the excel files, retain the values from the version of the record from #1. Some examples are  SPA, WHPA, Population, etc.

The NFA values provided are sometimes only incremental changes and need the current NFA values must be retained.  

*/


-- #4 - Pull the USTs (tanks) table from the feature service  ArcGIS pro locally.  Remove the data in that table that is linked to a tribal record based on the ID.

-- #5 - Pull the new data generated in #3 into ArcGIS pro locally.  Remove the existing tribal data from the layers and append the updated data from #3 to the layers. Keep the non-tribal data the way it is.

-- #6 - Pull data from the UST excel file provided by EPA into ArcGIS pro locally.  Append the data into the  USTs (tanks) table. I think a relationship needs to be created between this table and the facilities layer.

-- #7 - Push to a test service and test in a test app/web map.

-- #8 - Once testing is done, truncate the production facility/release layers/USTs table and append the full datasets into them.