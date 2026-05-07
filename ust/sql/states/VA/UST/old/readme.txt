Purpose: Instructions to download and process the VA UST data.


1- Go to https://geohub-vadeq.hub.arcgis.com/pages/16b992debdff41cd945f48d348e17c59 and download the Petroleum Registered Tank Facilities CSV file.

2 - Go to https://www.deq.virginia.gov/our-programs/land-waste/petroleum-tanks/underground-storage-tanks and download "UST registration data here." zip file.  

3 - Load the data from #1 and #2 above into the database into the va_ust schema. The table names should match the field names.  Truncate and reload the tables, it might be a good idea to create a backup of the old data first. For #2, only load the owner, register, tanks, ustpipematerials,uststankmaterials, and usttankpipereleasedectection files.

4 - Execute the load_facility.sql file to insert the facility data.

5 - Execute the load_tanks.sql file to insert the tank data.

6 - Execute the load_compartment.sql file to insert the compartment data.

7 - Execute the load_pipe.sql file to insert the piping data.