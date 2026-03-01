prompt --workspace/remote_servers/192_168_108_134_ords_api_assurance
begin
--   Manifest
--     REMOTE SERVER: 192-168-108-134-ords-api-assurance
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>2707318103396070
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'ORASSADM'
);
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(3731739581503467)
,p_name=>'192-168-108-134-ords-api-assurance'
,p_static_id=>'192_168_108_134_ords_api_assurance'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('192_168_108_134_ords_api_assurance'),'http://192.168.108.134:8080/ords/api-assurance/')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('192_168_108_134_ords_api_assurance'),'')
,p_server_type=>'WEB_SERVICE'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('192_168_108_134_ords_api_assurance'),'')
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('192_168_108_134_ords_api_assurance'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('192_168_108_134_ords_api_assurance'),'')
,p_prompt_on_install=>false
);
wwv_flow_imp.component_end;
end;
/
