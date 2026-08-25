YES_NO_RECIPE_COLUMNS = {
    'dispenser_udc': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0']},
    'federally_regulated': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0']},
    'emergency_generator': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0']},
    'multiple_tanks': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0']},
    'spill_bucket_installed': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0']},
    'airport_hydrant_system': {'truthy_values': ['true', 't', 'yes', 'y', '1', '1.0', 'airport hydrant system']},
}


GREATER_THAN_ONE_YES_NO_COLUMNS = {'compartmentalized_ust'}


YES_NULL_BUCKET_RECIPE_COLUMNS = {
    'tank_interstitial_monitoring': {'match_type': 'equals_any', 'values': ['secondary containment', 'double walled', 'interstitial monitoring', 'concrete vault']},
    'tank_automatic_tank_gauging_release_detection': {'match_type': 'equals_any', 'values': ['in-tank monitor', 'automatic tank gauging']},
    'tank_manual_tank_gauging': {'match_type': 'equals_any', 'values': ['manual gauging']},
    'tank_statistical_inventory_reconciliation': {'match_type': 'equals_any', 'values': ['s.i.r.']},
    'tank_tightness_testing': {'match_type': 'equals_any', 'values': ['tightness testing', 'tanktightnesstesting']},
    'tank_inventory_control': {'match_type': 'equals_any', 'values': ['inventory control']},
    'tank_groundwater_monitoring': {'match_type': 'equals_any', 'values': ['groundwater monitoring']},
    'tank_vapor_monitoring': {'match_type': 'equals_any', 'values': ['vapor monitoring']},
    'tank_other_release_detection': {'match_type': 'equals_any', 'values': ['other']},
    'piping_material_frp': {'match_type': 'like_any', 'values': ['%fiberglass%']},
    'piping_material_gal_steel': {'match_type': 'equals_any', 'values': ['galvanized steel', 'steel - bare/galv']},
    'piping_material_stainless_steel': {'match_type': 'equals_any', 'values': ['stainless steel', 'pipingmaterialstainlesssteel']},
    'piping_material_steel': {'match_type': 'equals_any', 'values': ['black steel', 'cath. protection', 'cath. steel', 'coated steel', 'steel', 'steel/aboveground', 'steel/cont', 'bare steel', 'steel isolated']},
    'piping_material_copper': {'match_type': 'equals_any', 'values': ['copper', 'copper -corr. prot.', 'copper isolated']},
    'piping_material_flex': {'match_type': 'equals_any', 'values': ['dw ameron', 'dw apt', 'dw environ', 'dw flex', 'dw marinaflex', 'dw opw', 'dw poly', 'sw ameron', 'sw apt', 'sw flex', 'total containment', 'flexible', 'flexible plastic', 'flex piping']},
    'piping_material_no_piping': {'match_type': 'equals_any', 'values': ['none', 'not applicable', 'pipingmaterialnopiping', 'no piping']},
    'piping_material_unknown': {'match_type': 'equals_any', 'values': ['unknown']},
    'piping_corrosion_protection_sacrificial_anode': {'match_type': 'equals_any', 'values': ['cath. protection', 'cath. steel']},
    'piping_line_leak_detector': {'match_type': 'equals_any', 'values': ['campo/miller lld', 'electronic lld', 'incon lld', 'mechanical lld', 'ppm 4000']},
    'piping_line_test_annual': {'match_type': 'equals_any', 'values': ['tightness testing']},
    'piping_groundwater_monitoring': {'match_type': 'equals_any', 'values': ['groundwater monitoring']},
    'piping_vapor_monitoring': {'match_type': 'equals_any', 'values': ['vapor monitoring']},
    'piping_interstitial_monitoring': {'match_type': 'equals_any', 'values': ['secondary containment', 'sump sensor']},
    'piping_statistical_inventory_reconciliation': {'match_type': 'equals_any', 'values': ['s.i.r.']},
    'piping_release_detection_other': {'match_type': 'equals_any', 'values': ['double walled']},
    'pipe_secondary_containment_other': {'match_type': 'equals_any', 'values': ['secondary containment', 'concrete containment']},
    'pipe_secondary_containment_unknown': {'match_type': 'equals_any', 'values': ['unknown']},
}


RECIPE_FAMILY_LABELS = {
    'yes_no': 'yes/no',
    'greater_than_one_yes_no': 'greater-than-one yes/no',
    'yes_null_bucket': 'yes/null bucket',
}


def get_recipe_family(epa_column_name):
    if epa_column_name in YES_NO_RECIPE_COLUMNS:
        return 'yes_no'
    if epa_column_name in GREATER_THAN_ONE_YES_NO_COLUMNS:
        return 'greater_than_one_yes_no'
    if epa_column_name in YES_NULL_BUCKET_RECIPE_COLUMNS:
        return 'yes_null_bucket'
    return None