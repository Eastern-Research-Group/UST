select distinct "TANK_CONFIGURATION" from permitted_ust_tanks;

One in a Compartmented Unit
Stand Alone Tank

select count(*) from permitted_ust_tanks where "TANK_CONFIGURATION" = 'Stand Alone Tank' and "TANK_NUM_OF_COMPARTMENTS" > 1;
159
select count(*) from permitted_ust_tanks where "TANK_CONFIGURATION" = 'One in a Compartmented Unit' and "TANK_NUM_OF_COMPARTMENTS" = 1;
194
