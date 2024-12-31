update vt_ust.compartment
set "CompartmentStatus" = 'PULLED'
where "FacilityID" = 1692;

update vt_ust.compartment 
set "CompartmentStatus" = 'PULLED'
where "TankID" = 19482
	or "TankID" = 19483;

update vt_ust.tank 
set "TankStatus" = 'PULLED'
where "FacilityID" = 1901;

delete from vt_ust.compartment
where "FacilityID" = 1901;

delete from vt_ust.compartment 
where "FacilityID" = 5551153;

delete from vt_ust.facility
where "FacilityID" = 5554926;

delete from vt_ust.tank 
where "FacilityID" = 5554926;

delete from vt_ust.compartment 
where "FacilityID" = 5554926;

delete from vt_ust.piping 
where "FacilityID" = 5554926;

delete from vt_ust.compartment 
where "FacilityID" = 5559095;

update vt_ust.compartment 
set "CompartmentStatus" = 'PULLED'
where "TankID" = 19479
	or "TankID" = 19480;
