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
#5 Fuel Oil & #2 Fuel Oil
#6 fuel
#6 fuel oil
?
0
acetone
alcohol & solvent
ant. free
antifreeze
asphalt oil
av-gas
av-gas 100 low-lead
av fuels
av gas
AV Gas & Jet Fuel
av. gas
ave-gas
ave - gas
avgas
avgas (100 octane)
aviation & jet fuel
aviation fuel
aviation fuel ?
aviation fuel/gasoli
aviation gas
Aviation Gas
aviation gas/gasolin
aviation gasoline
bad fuel
benzene
black printing ink
btex
btex/pce/tce
Bunker C
bunker c fuel oil
bunker oil
butonone
clear diesel
Clear Diesel
condensate
condensate & waste o
deisel fuel
dgasoline/diesel
diesel
Diesel
diesel-fuel oil
Diesel-Low Sulfur
diesel 
diesel #2
diesel & gas
Diesel & gas
diesel & gasoline
Diesel & Kerosene
diesel & used oil
diesel & waste oil
diesel & water
diesel (#2)
diesel (red dye)
diesel / gasoline
diesel and gas
Diesel and Gasoline
diesel fue
Diesel Fuel
diesel fuel #2
diesel fuel & gas
diesel fuel & gasoli
Diesel Fuel & Gasoline
diesel fuel (#2)
diesel fuel oil
diesel fuel/gasoline
diesel fuel/motor oi
diesel no 2
diesel or kerosene
diesel,
diesel,gasoline
diesel,kerosene,gaso
diesel,waste oil
diesel/ gas
diesel/#2 fuel oil
diesel/fuel oil
Diesel/Gas?
diesel/gasoline
Diesel/gasoline
Diesel/Kerosene
diesel/waste oil
diesel?
dissolved gas
drip oil
Dyed Diesel
Dyed diesel fuel
E15 - 15% Ethanol
ehtyl?
ethyl/gasoline
fuel
fuel-diesel
fuel oil
Fuel Oil
fuel oil #2
fuel oil #6
fuel oil (diesel)
fuel oil ?
fuel oil/ gas
Fuel oil/diesel
fuel oil?
fuel,kerosen,solvent
ga
gas
Gas
Gas-Diesel
gas-waste oil
gas  & diesel
gas & diesel
Gas & Diesel
gas & diesel fuel
Gas & Oil
gas & possibly diese
gas & used motor oil
gas & waste oil
gas (old)
gas ?
gas and diesel
Gas and Diesel
gas and used oil
Gas and/or diesel
gas or diesel
gas or solv napthe
gas&possibly diesel
gas,
gas,diesel
gas,diesel,waste oil
gas/diesel
Gas/Diesel
gas/diesel/kerosene
gas/diesel/used oil
gas/diesel/waste oil
gas/used oil
gas; diesel
gas?
gas0line
gasline
gasohol
Gasohol
gasohol/kerosene
gasoine
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
gasoline & #2 diesel
gasoline & ?
gasoline & diesel
Gasoline & Diesel
gasoline & fuel oil
gasoline & hydraulic
gasoline & kerosene
gasoline & kerosine
gasoline & oil
Gasoline & Oil
Gasoline & Used Oil
gasoline & waste oil
gasoline &/or diesel
gasoline (kerosene?)
gasoline (premium)
Gasoline (Premium)
gasoline (unleaded)
gasoline / diesel
gasoline /diesel
gasoline 50
gasoline and diesel
Gasoline and diesel
Gasoline and Diesel
gasoline diesel
gasoline from lines
gasoline or diesel
gasoline suspected
gasoline w/ diesel
gasoline,diesel
gasoline,heating oil
gasoline,kerosene
gasoline,waste oil
gasoline/ waste oil
gasoline/?
gasoline/diesel
Gasoline/diesel
Gasoline/Diesel
gasoline/diesel ??
gasoline/diesel fuel
gasoline/diesel/oil?
gasoline/fuel oil
gasoline/heating oil
gasoline/kerosene
Gasoline/Kerosene
gasoline/kerosine
gasoline/poss diesel
gasoline/used oil
Gasoline/used oil
Gasoline/Used Oil
gasoline/waste oil
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
Jet A-aviation fuel
jet a fuel
jet fue
jet fuel
Jet Fuel
jet/aviation fuel
jp-4
jp-4 jet fuel
kerosene
Kerosene
kerosene or diesel
kerosene/gasoline
kerosene?
kerosine
kerosine & gasoline
leaded gasoline
low lead ave gas
lube and waste oil
lube oil
lube oil & fuel
mabye kerosene
methylmethacrylite m
Mid-Grade Gas
mid-grade gasoline
mid-grade unleaded
mineral spirits
mixed petroleum
mogas
mogas/diesel/gas
motor oil
Motor Oil
Motor oil & diesel
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
oil&condensate&water
Other
overfill/spilled
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
solvent,gasoline
solvents
stoddard solvent
super unleaded
ukwn
Ultra low sulfur
Undetermined oil
unknown
Unknown
unknown/possibly gas
unkown
unlead gasoline
unleaded
Unleaded (Premium)
unleaded gas
unleaded gas/leaded
unleaded mid-grade
unleaded&gasoline
used engine oil
used motor oil
Used motor oil
used oil
Used oil
Used Oil
used oil and diesel
used oil gasoline
used oil,trans fluid
Used Oil/Gasoline
various avia fuel
various avia. fuels
w.o. ?
waste compressor oil
waste motor oil
waste oil
Waste Oil
waste oil & antifree
waste oil & fuel oil
waste oil & gas
waste oil & gasoline
waste oil & solvent
waste oil/condensate
waste oil/gasoline
waste oil/solvent
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
values (575, '#2 diesel fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#2 Fuel Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#5 fuel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#5 Fuel Oil & #2 Fuel Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, '#6 fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'alcohol & solvent', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'ant. free', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'AV Gas & Jet Fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'aviation fuel/gasoli', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Aviation Gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'aviation gas/gasolin', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'clear diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Clear Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'condensate & waste o', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'deisel fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'dgasoline/diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel ', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel #2', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel & gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel & gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel & gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel & Kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel & used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel & waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel & water', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel / gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel and gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel and Gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fue', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel Fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel #2', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel & gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel & gasoli', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel Fuel & Gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel/gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel fuel/motor oi', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel or kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel,', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel,gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel,kerosene,gaso', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel,waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel/ gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel/#2 fuel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel/fuel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel/Gas?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel/gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel/gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Diesel/Kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel/waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'diesel?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Dyed Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Fuel Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil (diesel)', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil ?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil/ gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Fuel oil/diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel oil?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'fuel,kerosen,solvent', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas-Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas-waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas  & diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas & diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas & Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas & diesel fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas & Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas & possibly diese', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas & used motor oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas & waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas ?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas and diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas and Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas and used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas and/or diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas or diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas or solv napthe', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas&possibly diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas,', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas,diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas,diesel,waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas/diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gas/Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas/diesel/kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas/diesel/used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas/diesel/waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas/used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas; diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gas?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasohol', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasohol/kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoine', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline-Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-diesel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline-kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline - diesel fu', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & #2 diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & ?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline & Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & fuel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & hydraulic', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & kerosine', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline & Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline & Used Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline & waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline &/or diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline (kerosene?)', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline (premium)', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline (Premium)', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline / diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline /diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline 50', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline and diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline and diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline and Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline from lines', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline or diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline suspected', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline w/ diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline,diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline,heating oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline,kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline,waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/ waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline/diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline/Diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/diesel ??', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/diesel fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/diesel/oil?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/fuel oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/heating oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline/Kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/kerosine', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/poss diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline/used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Gasoline/Used Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline/waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline\\diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'gasoline0', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'heating fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heating oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heating Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Heavy Oil (Unknown)', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Jet Fuel', 'Jet fuel A', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'jp-4 jet fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene', 'Kerosene', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene or diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene/gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosene?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'kerosine & gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'lube and waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'lube oil & fuel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'mabye kerosene', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'mogas/diesel/gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Motor Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Motor oil & diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'none', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Oil', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Petroleum', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'petroleum naptha', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Petroluem', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'possibly diesel', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Premium', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Premium Unleaded', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'reg. gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'regular gas', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'regular gasoline', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'See attached', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'solvent,gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Ultra low sulfur', 'Gasoline (unknown type)', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Unknown', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unknown/possibly gas', 'Unknown', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded gas', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded gas/leaded', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded mid-grade', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'unleaded&gasoline', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used motor oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'used oil and diesel', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'used oil gasoline', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'used oil,trans fluid', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Used Oil/Gasoline', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'w.o. ?', '', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste compressor oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'Waste Oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil & antifree', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil & fuel oil', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil & gas', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil & gasoline', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil & solvent', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil/condensate', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil/gasoline', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil/solvent', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'waste oil\\solvent\\fu', 'Used oil/waste oil', null);
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (575, 'xylene', '', null);

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
--ust_release_source.source_id

--select distinct "source" from ks_release."erg_source_deagg" where "source" is not null order by 1;
/* Organization values are:

Delivery
Dispenser
Other
Piping
Spill
Spill/Overfill
Sump pump area
Tank
Unknown
 */

/*
 * Go through each of the following SQL statements and insert the value for the epa_value column, then run all of the SQL to peform the inserts.
 * If you have any questions about the mapping, replace "null" with your question or comment. See below for a list of the valid EPA values.
 */
insert into public.release_element_value_mapping (release_element_mapping_id, organization_value, epa_value, programmer_comments)
values (573, 'Spill', '', null);

--select source from public.sources;
/* Valid EPA values are:

Dispenser
Piping
Submersible turbine pump
Tank
Other
Unknown
Delivery problem

 * Need some additional help with the mapping? See how similar fields have been mapped in other organizations.
 * Change the XXXX in the query below the organization value, or a substring thereof, that you are trying to map.

select distinct organization_value, epa_value
from public.v_release_element_mapping
where epa_column_name = 'source_id'
and lower(organization_value) like lower('%XXXX%')
order by 1, 2;

 * You can also review the mapping from the pilot using a query similar to the above, looking in archive.v_lust_element_mapping.
 * Beware, however, that some of the lookup values have changed since the pilot so if you do use archive.v_lust_element_mapping
 * to do mapping, check public.sources to find the updated epa_value.
 */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
