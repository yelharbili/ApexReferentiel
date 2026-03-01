prompt --application/plugin_settings
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>2707318103396070
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'ORASSADM'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3424886214470565)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attribute_01=>'Y'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3425063993470592)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attribute_01=>'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON'
,p_attribute_02=>'VISIBLE'
,p_attribute_03=>'15'
,p_attribute_04=>'FOCUS'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3425346680470593)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attribute_01=>'RELAX_HOUSE_NUMBER'
,p_attribute_02=>'N'
,p_attribute_03=>'POPUP:ITEM'
,p_attribute_04=>'default'
,p_attribute_06=>'LIST'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3425659986470595)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attribute_01=>'Y'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3425901464470596)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3426256074470596)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3426545982470600)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attribute_01=>'IG'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3426897925470600)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attribute_01=>'FULL'
,p_attribute_02=>'POPUP'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3427119388470601)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attribute_01=>'fa-star'
,p_attribute_04=>'#VALUE#'
,p_version_scn=>3262611
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(3427451146470603)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attribute_01=>'Y'
,p_attribute_03=>'N'
,p_attribute_05=>'SWITCH_CB'
,p_version_scn=>3262611
);
wwv_flow_imp.component_end;
end;
/
