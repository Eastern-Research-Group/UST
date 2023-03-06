import os
import csv
import utm
import pyproj
    
# sourcefile      = "../data/_tblGeoSite__202211171348.csv";
sourcefile = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\NY\NY_utm_conversion.csv'
targetfile      = "../data/NY_converted.csv";

easting_column  = "EASTING";
northing_column = "NORTHING";
datum_column    = "HDATUMNAME";
utm_zone_column = "UTM_ZONE";

new_longitude_column = "CONVERTED_LONG";
new_latitude_column  = "CONVERTED_LAT";

datum_assumption     = 4269;
northern_assumption  = True;
utm_zone_assumption  = 15;



# this transformer uses the Esri WGS_1984_(ITRF00)_To_NAD_83 transformation parameters
t_4326_to_4269 = pyproj.Transformer.from_crs(
     crs_from  = "EPSG:4326"
    ,crs_to    = pyproj.crs.CRS('+proj=longlat +datum=NAD83 +towgs84=0.9956,-1.9013,-0.5215,0.025915,0.009426,0.0011599,0.00062 +no_defs')
    ,always_xy = True
);

results = [];
indx_easting  = None;
indx_northing = None;
indx_datum    = None;
indx_utm_zone = None;

# Open the target to writing
with open(
     os.path.join('convert',targetfile)
    ,'w'
    ,newline  = ''
    ,encoding = 'utf-8'
) as write_obj:
    writer = csv.writer(
         write_obj
        ,delimiter = ','
        ,quotechar = '"'
        ,quoting   = csv.QUOTE_MINIMAL
    );

    # Open the source file for reading
    with open(
         os.path.join('convert',sourcefile)
        ,'r'
    ) as read_obj:
        csv_reader = csv.reader(read_obj);
        
        # Get the input data indices and verify header does not already contain conversion columns
        header = next(csv_reader);

        for i,col in enumerate(header):
            if col.upper() == easting_column.upper():
                indx_easting = i;
            if col.upper() == northing_column.upper():
                indx_northing = i;
            if col.upper() == datum_column.upper():
                indx_datum = i;
            if col.upper() == utm_zone_column.upper():
                indx_utm_zone = i;

            if col.upper() == new_longitude_column.upper():
                raise Exception("output column " + new_longitude_column + " already exists!");
            if col.upper() == new_latitude_column.upper():
                raise Exception("output column " + new_latitude_column + " already exists!");

        # Write out the new header with appended conversion columns
        writer.writerow(header + [new_longitude_column,new_latitude_column]);
        
        # Loop through the data
        indx = 0;
        for row in csv_reader:
            easting  = row[indx_easting];
            northing = row[indx_northing];
            datum    = row[indx_datum];
            utm_zone = str(row[indx_utm_zone]);
            
            # If datum is null, use the assumption
            if datum is None or datum == "":
                datum = datum_assumption;
            
            else:
                if datum.upper() == "NAD83":
                    datum = 4269;
                
                elif datum.upper() == "WGS84":
                    datum = 4326;
                    
                else:
                    raise Exception("unknown datum " + datum);

            # If utm zone is null, use the assumption
            if utm_zone is None or utm_zone == "":
                utm_zone = utm_zone_assumption;
                northern = northern_assumption;

            else:
                # Remove North or South indicators from utm zone
                if utm_zone.upper().find("NORTH") > -1:
                    northern = True;
                    utm_zone = utm_zone.upper().replace(" NORTH","");
                
                elif utm_zone.upper().find("SOUTH") > -1:
                    northern = False;
                    utm_zone = utm_zone.upper().replace(" SOUTH","");
                
                # If no hemisphere provided, use the assumption
                else:
                    northern = northern_assumption;

                # This should fail is utm zone is garbage
                utm_zone = int(utm_zone);

            # Write empty values if easting and/or northing is empty
            if easting  is None or easting  == "" or easting  == "0" or easting == "0.0" \
            or northing is None or northing == "" or northing == "0" or northing == "0.0":
                writer.writerow(row + [None,None]);

            else:
                # Use utm package to convert easting and northing to lat/long
                easting  = float(easting);
                northing = float(northing);
               
                try:
                    (lat,long) = utm.to_latlon(
                         easting     = easting
                        ,northing    = northing
                        ,zone_number = utm_zone
                        ,northern    = northern
                    );
                except utm.error.OutOfRangeError as e:
                    print(e)
                    print('easting = ' + str(easting))
                    print('northing = ' + str(northing))
                    print('zone_number = ' + str(utm_zone))
                    print('northern = ' + str(northern))
                    exit()
                    
                # If datum is not 4269, convert to 4269
                if datum == 4269:
                    None;
                    
                elif datum == 4326:
                    (long,lat) = t_4326_to_4269.transform(long,lat);
  
                else:
                    raise Exception("unknown datum " + str(datum));

                writer.writerow(row + [long,lat]);

            indx = indx + 1;
    
print(str(indx) + ' rows processed.');
