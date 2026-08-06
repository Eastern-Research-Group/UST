import os
import csv
    
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

def main():
    try:
        import pyproj
        import utm
    except ModuleNotFoundError as exc:
        raise ModuleNotFoundError('convert_utm requires the utm and pyproj packages to be installed.') from exc

    t_4326_to_4269 = pyproj.Transformer.from_crs(
         crs_from  = "EPSG:4326"
        ,crs_to    = pyproj.crs.CRS('+proj=longlat +datum=NAD83 +towgs84=0.9956,-1.9013,-0.5215,0.025915,0.009426,0.0011599,0.00062 +no_defs')
        ,always_xy = True
    )

    indx_easting = None
    indx_northing = None
    indx_datum = None
    indx_utm_zone = None

    with open(os.path.join('convert', targetfile), 'w', newline='', encoding='utf-8') as write_obj:
        writer = csv.writer(write_obj, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        with open(os.path.join('convert', sourcefile), 'r') as read_obj:
            csv_reader = csv.reader(read_obj)
            header = next(csv_reader)

            for i, col in enumerate(header):
                if col.upper() == easting_column.upper():
                    indx_easting = i
                if col.upper() == northing_column.upper():
                    indx_northing = i
                if col.upper() == datum_column.upper():
                    indx_datum = i
                if col.upper() == utm_zone_column.upper():
                    indx_utm_zone = i

                if col.upper() == new_longitude_column.upper():
                    raise Exception("output column " + new_longitude_column + " already exists!")
                if col.upper() == new_latitude_column.upper():
                    raise Exception("output column " + new_latitude_column + " already exists!")

            writer.writerow(header + [new_longitude_column, new_latitude_column])

            indx = 0
            for row in csv_reader:
                easting = row[indx_easting]
                northing = row[indx_northing]
                datum = row[indx_datum]
                utm_zone = str(row[indx_utm_zone])

                if datum is None or datum == "":
                    datum = datum_assumption
                elif datum.upper() == "NAD83":
                    datum = 4269
                elif datum.upper() == "WGS84":
                    datum = 4326
                else:
                    raise Exception("unknown datum " + datum)

                if utm_zone is None or utm_zone == "":
                    utm_zone = utm_zone_assumption
                    northern = northern_assumption
                else:
                    if utm_zone.upper().find("NORTH") > -1:
                        northern = True
                        utm_zone = utm_zone.upper().replace(" NORTH", "")
                    elif utm_zone.upper().find("SOUTH") > -1:
                        northern = False
                        utm_zone = utm_zone.upper().replace(" SOUTH", "")
                    else:
                        northern = northern_assumption
                    utm_zone = int(utm_zone)

                if easting is None or easting == "" or easting == "0" or easting == "0.0" or northing is None or northing == "" or northing == "0" or northing == "0.0":
                    writer.writerow(row + [None, None])
                else:
                    easting = float(easting)
                    northing = float(northing)
                    try:
                        lat, long = utm.to_latlon(easting=easting, northing=northing, zone_number=utm_zone, northern=northern)
                    except utm.error.OutOfRangeError as e:
                        print(e)
                        print('easting = ' + str(easting))
                        print('northing = ' + str(northing))
                        print('zone_number = ' + str(utm_zone))
                        print('northern = ' + str(northern))
                        exit()

                    if datum == 4326:
                        long, lat = t_4326_to_4269.transform(long, lat)
                    elif datum != 4269:
                        raise Exception("unknown datum " + str(datum))

                    writer.writerow(row + [long, lat])

                indx += 1

    print(str(indx) + ' rows processed.')


if __name__ == '__main__':
    main()
