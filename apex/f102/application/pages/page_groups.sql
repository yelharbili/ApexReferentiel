prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 102
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>2707318103396070
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'ORASSADM'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(3721426110472837)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
