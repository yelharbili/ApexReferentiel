prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 102
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>2707318103396070
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'ORASSADM'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(3694850650472534)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_default_page_template=>wwv_flow_imp.id(3454852417470881)
,p_default_dialog_template=>wwv_flow_imp.id(3449623392470865)
,p_error_template=>wwv_flow_imp.id(3439642740470823)
,p_printer_friendly_template=>wwv_flow_imp.id(3454852417470881)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(3439642740470823)
,p_default_button_template=>wwv_flow_imp.id(3604712615471417)
,p_default_region_template=>wwv_flow_imp.id(3531599178471112)
,p_default_chart_template=>wwv_flow_imp.id(3531599178471112)
,p_default_form_template=>wwv_flow_imp.id(3531599178471112)
,p_default_reportr_template=>wwv_flow_imp.id(3531599178471112)
,p_default_tabform_template=>wwv_flow_imp.id(3531599178471112)
,p_default_wizard_template=>wwv_flow_imp.id(3531599178471112)
,p_default_menur_template=>wwv_flow_imp.id(3543981091471142)
,p_default_listr_template=>wwv_flow_imp.id(3531599178471112)
,p_default_irr_template=>wwv_flow_imp.id(3521737664471084)
,p_default_report_template=>wwv_flow_imp.id(3567154425471217)
,p_default_label_template=>wwv_flow_imp.id(3602277812471390)
,p_default_menu_template=>wwv_flow_imp.id(3606359988471423)
,p_default_calendar_template=>wwv_flow_imp.id(3606477695471435)
,p_default_list_template=>wwv_flow_imp.id(3600354741471373)
,p_default_nav_list_template=>wwv_flow_imp.id(3591371003471346)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(3591371003471346)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(3589581057471335)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(3467781436470943)
,p_default_dialogr_template=>wwv_flow_imp.id(3464920942470935)
,p_default_option_label=>wwv_flow_imp.id(3602277812471390)
,p_default_required_label=>wwv_flow_imp.id(3603524685471398)
,p_default_navbar_list_template=>wwv_flow_imp.id(3592308556471348)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#APEX_FILES#themes/theme_42/23.2/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APEX_FILES#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_FILES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_FILES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_imp.component_end;
end;
/
