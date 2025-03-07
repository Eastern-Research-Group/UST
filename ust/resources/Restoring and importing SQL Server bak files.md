# Importing SQL Server .bak file into ERG UST database

### 1) Restoring a SQL Server .bak file locally

1. If you don't have a SQL Server installation on your machine, install SQL Sever Express.  
2. Install SQL Server Management Studio (SSMS) on your machine. 
3. Save the .bak file to be restored to C:\Program Files\Microsoft SQL Server\MSSQLxx.SQLEXPRESS\MSSQL\Backup, where xx is the SQL Server Express version (or whatever the correct path to this directory is on your machine). SSMS will only restore files that are located in this directory. NOTE: you will need elevated privileges to copy into this directory. 
4. Open SSMS. In Object Explorer, right click on Databases and select Restore Database. 
5. Select Device and click on the "..." icon to open the file browser. 
6. Click the Add button and select the .bak file. Click Add again to add it to the Backup Media box. 
7. Click OK to begin the restoration process. 
8. The database is now available in SSMS. 
9. To find the connection properties that you will need to connect to the database in DBeaver, right click on the database name and select Properties, then click on the View Connection Properties link under Connection. Find the value for Server Name, which should look something like YOUR-COMPUTER-NAME\SQLEXPRESS. Copy this connection information and save it, as you will be rebooting your computer in a later step.
10. Also verify the Authentication Method, which you will need for making the connection in DBeaver. 

###  2) Prepare database for remote connections from DBeaver (if using SQL Server Express)

1. TCP/IP is not enabled by default in SQL Server Express. To enable it, run SQL Server Configuration Manager (if it doesn't appear in your Start menu, type "SQLServerManagerxx.msc", where xx is the version number, into the Run box). 
2. Under SQL Server Network Configuration --> Protocols for SQLEXPRESS, right click on TCP/IP and click Enable. 
3. Right click on TCP/IP again and select Properties. Click on the IP Addresses tab. Scroll down to IPAll. Delete any values from TCP Dynamic Ports and leave it blank. Type 1433 into TCP Port. 
4. Open a command prompt as administrator and enter the following command:
netsh int ip reset
5. Restart your computer.  

### 3) Connect to restored SQL Server database in DBeaver. 

1. In the Database Navigator, right click (on nothing) and select Create --> Connection. 
2. Choose Microsoft SQL Server and click Next. 
3. For the Host, enter the Server Name from Step 9 above.
4. For Authentication, select the Authentication Method from Step 10 above. This probably defaults to Windows Authentication, which means you will not have to enter a username and password. 


### 4) Copy relevant tables into UGSTank database. 

1. If it doesn't exist, create the state schema in the ERG postgres database. 
2. In the Database Navigator in DBeaver, in the state database, select the tables you want to copy into the ERG database. If the state database is not huge, you can select all tables and worry about figuring out which ones you need later. If the state database if very large, you can do some querying first to decide which tables are relevant and limit your selection to those. 
3. Right click on the table(s) to export in the state database and select Export Data.
4. For the Export Target, select Database | Database table(s) and click Next. 
5. Click on the Choose button to the right of the Target Container field. Find the UGSTank database connection and then the state schema you wish to import into, then click OK. Verify that the Target Container correctly identifies the UGSTank database and the schema you want. Click Next. 
6. Accept the defaults for Extraction Settings. Click Next. 
7. Accept the defaults for Data Load Settings. Click Next. 
8. Look over the settings on the Confirm page and click Proceed. 
9. Depending on the amount of data, the export process may take a while. When complete, examine the state schema to ensure the tables were imported. 