------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ust_release_substance.substance_id

--select distinct "substance" from ks_release."erg_substance_datarows_deagg" where "substance" is not null order by 1;
/* Organization values are:


#2 diesel
#2 diesel fuel
#2 diesel oil
#2 fuel oil
#2 Fuel Oil
#5 fuel oil
#5 Fuel Oil
#6 fuel
#6 fuel oil
?
0
a
acetone
alcohol
ant. free
antifree
antifreeze
asphalt oil
av-gas
av-gas 100 low-lead
av fuels
av gas
AV Gas
av. gas
ave-gas
ave - gas
avgas
avgas (100 octane)
aviation
aviation fuel
aviation fuel ?
aviation gas
Aviation Gas
aviation gasoline
bad fuel
benzene
black printing ink
btex
Bunker C
bunker c fuel oil
bunker oil
butonone
clear diesel
Clear Diesel
condensate
deisel fuel
dgasoline
diesel
Diesel
diesel-fuel oil
Diesel-Low Sulfur
diesel #2
diesel (#2)
diesel (red dye)
diesel ??
diesel fue
diesel fuel
Diesel Fuel
diesel fuel #2
diesel fuel (#2)
diesel fuel oil
diesel no 2
diesel or kerosene
diesel,
diesel?
dissolved gas
drip oil
Dyed Diesel
Dyed diesel fuel
E15 - 15% Ethanol
ehtyl?
fuel
fuel-diesel
fuel oil
Fuel oil
Fuel Oil
fuel oil #2
fuel oil #6
fuel oil (diesel)
fuel oil ?
fuel oil?
ga
gas
Gas
Gas-Diesel
gas-waste oil
gas (old)
gas ?
Gas and
gas or diesel
gas or solv napthe
gas?
Gas?
gas0line
gasline
gaso
gasohol
Gasohol
gasoine
gasoli
gasolinbe
gasoline
Gasoline
gasoline-diesel
Gasoline-Diesel
gasoline-diesel fuel
gasoline-diesel oil
gasoline-kerosene
gasoline-prem ul
gasoline-unleaded
gasoline - diesel fu
gasoline (kerosene?)
gasoline (premium)
Gasoline (Premium)
gasoline (unleaded)
gasoline 50
gasoline diesel
gasoline from lines
gasoline or diesel
gasoline suspected
gasoline?
gasoline\diesel
gasoline0
Gasolone
gassy smelling water
gsasoline
heating fuel
Heating fuel oil
heating oil
Heating oil
Heating Oil
Heavy Oil (Unknown)
hexane
high sulphur diesel
hydraulic
Jet A-aviation fuel
jet a fuel
jet fue
jet fuel
Jet Fuel
jp-4
jp-4 jet fuel
kerosen
kerosene
Kerosene
kerosene or diesel
kerosene?
kerosine
leaded
leaded gasoline
low lead ave gas
lube
lube oil
mabye kerosene
methylmethacrylite m
Mid-Grade Gas
mid-grade gasoline
mid-grade unleaded
mineral spirits
mixed petroleum
mogas
motor oi
motor oil
Motor oil
Motor Oil
n/a
nat gas condensate
natural gas condensa
navgas
new oil
nl gasoline
no lead gasoline
none
oil
Oil
oil?
or diesel
Other
petro hydrocarbons
petro product
petro products
petrol hydrocarbons
petroleum
Petroleum
Petroleum (gasoline)
Petroleum hydrocarbons
petroleum naptha
petroleum products
Petroluem
poss diesel
possibly diese
possibly diesel
prem unleaded
Premium
Premium Diesel
Premium Fuel
Premium Gas
premium unleaded
Premium Unleaded
Premium Unleaded Gas
refined petrol.
refined petroleum
reg. gasoline
regular gas
regular gasoline
See attached
solvent
solvents
stoddard solvent
super unleaded
trans fluid
ukwn
Ultra low sulfur
Undetermined oil
unknown
Unknown
unkown
unlead gasoline
unleaded
Unleaded (Premium)
unleaded gas
unleaded mid-grade
used engine oil
used motor oil
Used motor oil
used oil
Used oil
Used Oil
used oil gasoline
various avia fuel
various avia. fuels
w.o. ?
waste compressor oil
waste motor oil
waste o
waste oil
Waste Oil
waste oil\solvent\fu
waster oil
water
water into tank
weathered petroleum
wo
xylene
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */

insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline\diesel', 'Diesel fuel (b-unknown)', null);

update ks_release.erg_substance_datarows_deagg set substance = 'gasoline\diesel' where substance = 'gasoline\\diesel'

delete from ks_release.erg_substance_datarows_deagg where substance = '';

--select substance from public.substances order by substance_group, substance;
/* Valid EPA values are:

Aviation biofuel
Aviation gasoline
Biojet (diesel)
Jet fuel A
Jet fuel B
Sustainable aviation fuel/aviation fuel blend
Unknown aviation gas or jet fuel
100% biodiesel (B100, not federally regulated)
80% renewable diesel, 20% biodiesel
95% renewable diesel, 5% biodiesel
99.9 percent renewable diesel, 0.01% biodiesel
ASTM D975 diesel (known 100% renewable diesel)
Diesel blend containing 99% to less than 100% biodiesel
Diesel blend containing greater than 20% and less than 99% biodiesel
Diesel blends containing greater than 5% and up to 20% or less biodiesel
Diesel fuel (ASTM D975), can contain 0-5% biodiesel
Diesel fuel (b-unknown)
Diesel fuel (known to contain 0% biodiesel)
Off-road diesel/dyed diesel
Other unlisted blend containing any other mixture of diesel, renewable diesel, or 20% biodiesel or less
Other unlisted blend containing any other mixture of diesel, renewable diesel, or more than 20% biodiesel
E-85/Flex Fuel (E51-E83)
Ethanol blend gasoline (e-unknown)
Gasoline (non-ethanol)
Gasoline (unknown type)
Gasoline E-10 (E1-E10)
Gasoline E-15 (E-11-E15)
Gasoline/ethanol blend containing more than 83% and less than 98% ethanol
Gasoline/ethanol blends E16-E50
Leaded gasoline
Racing fuel
Biofuel/bioheat
Heating oil/fuel oil 1
Heating oil/fuel oil 2
Heating oil/fuel oil 4
Heating oil/fuel oil 5
Heating oil/fuel oil 6
Heating/fuel oil # unknown
Hydraulic oil
Lube/motor oil (new)
Used oil/waste oil
Antifreeze
Denatured ethanol (98%)
Diesel exhaust fluid (DEF, not federally regulated)
Hazardous substance
Kerosene
Marine fuel
MTBE
Non-federally regulated substance (general)
Other or mixture
Petroleum product
Solvent
Unknown

 * NOTE: Hazardous substances can be found in view public.v_hazardous_substances.
 * If the state included a CAS No., you can also try mapping it to public.v_casno.

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'substance_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.substances to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
