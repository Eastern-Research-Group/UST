These files can be used to load the Tier 2 AST dataset from https://cameo.noaa.gov/epcra_tier2/data_standard/v1.

Add the password in the database.ini file.
Run the load_data.py file.
Run the script.sql file in the ast_tx schema.


Notes -
I had to break up the XML file into smaller pieces to avoid the memory/timeout issues.  I used 1 file for the contact object and 4 for the facility objects. Som eof th

