
#http://docs.oracle.com/cd/E28280_01/core.1111/e12036/target_appendix_soa.htm

WLHOME='/opt/oracle/middleware11g/wlserver_10.3'
DOMAIN_PATH='/opt/oracle/middleware11g/user_projects/domains/soa_basedomain'
DOMAIN='soa_basedomain'

SOAClusterName = 'SoaCluster'
BAMClusterName = 'BamCluster'
SoaBam         = 'SoaCluster,BamCluster'
SoaAdmin       = 'SoaCluster,AdminServer'
BamAdmin       = 'BamCluster,AdminServer'
All            = 'SoaCluster,BamCluster,AdminServer'
Admin          = 'AdminServer'

readDomain(DOMAIN_PATH)

delete('soa_server1', 'Server')
delete('bam_server1', 'Server')

delete('SOAJMSModule'        , 'JMSSystemResource')
delete('UMSJMSSystemResource', 'JMSSystemResource')
delete('BAMJmsSystemResource', 'JMSSystemResource')

delete('UMSJMSServer','JMSServer')
delete('SOAJMSServer','JMSServer')
delete('BAMJMSServer','JMSServer')

unassign('StartupClass'      ,'*', 'Target' , All)
unassign('ShutdownClass'     ,'*', 'Target' , All)
unassign('Library'           ,'*', 'Target' , All)
unassign('AppDeployment'     ,'*', 'Target' , All)
unassign('JdbcSystemResource','*', 'Target' , All)
unassign('WldfSystemResource','*', 'Target' , All)
unassign('JmsSystemResource' ,'*', 'Target' , All)


assign('AppDeployment', 'AqAdapter'                  , 'Target', SOAClusterName)
assign('AppDeployment', 'DbAdapter'                  , 'Target', SOAClusterName)
assign('AppDeployment', 'FileAdapter'                , 'Target', SOAClusterName)
assign('AppDeployment', 'FtpAdapter'                 , 'Target', SOAClusterName)
assign('AppDeployment', 'JmsAdapter'                 , 'Target', SOAClusterName)
assign('AppDeployment', 'MQSeriesAdapter'            , 'Target', SOAClusterName)
assign('AppDeployment', 'OracleAppsAdapter'          , 'Target', SOAClusterName)
assign('AppDeployment', 'OracleBamAdapter'           , 'Target', SOAClusterName)
assign('AppDeployment', 'SocketAdapter'              , 'Target', SOAClusterName)
assign('AppDeployment', 'UMSAdapter'                 , 'Target', SOAClusterName)


assign('AppDeployment', 'b2bui'                      , 'Target', SOAClusterName)
assign('AppDeployment', 'BPMComposer'                , 'Target', SOAClusterName)
assign('AppDeployment', 'composer'                   , 'Target', SOAClusterName)
assign('AppDeployment', 'DefaultToDoTaskFlow'        , 'Target', SOAClusterName)
assign('AppDeployment', 'frevvo'                     , 'Target', SOAClusterName)
assign('AppDeployment', 'oracle-bam#11.1.1'          , 'Target', BAMClusterName)
assign('AppDeployment', 'OracleBPMComposerRolesApp'  , 'Target', SOAClusterName)
assign('AppDeployment', 'OracleBPMProcessRolesApp'   , 'Target', SOAClusterName)
assign('AppDeployment', 'OracleBPMWorkspace'         , 'Target', SOAClusterName)
assign('AppDeployment', 'SimpleApprovalTaskFlow'     , 'Target', SOAClusterName)
assign('AppDeployment', 'soa-infra'                  , 'Target', SOAClusterName)
assign('AppDeployment', 'worklistapp'                , 'Target', SOAClusterName)
assign('AppDeployment', 'DMS Application#11.1.1.1.0' , 'Target', All)
assign('AppDeployment', 'wsil-wls'                   , 'Target', All)
assign('AppDeployment', 'wsm-pm'                     , 'Target', SoaBam)
assign('AppDeployment', 'usermessagingdriver-email'  , 'Target', SoaBam)
assign('AppDeployment', 'usermessagingserver'        , 'Target', SoaBam)

assign('AppDeployment', 'em'                                     , 'Target', Admin)
assign('AppDeployment', 'FMW Welcome Page Application#11.1.0.0.0', 'Target', Admin)

assign('Library', 'emai'                                   , 'Target', Admin)
assign('Library', 'oracle.webcenter.skin#11.1.1@11.1.1'    , 'Target', Admin)
assign('Library', 'oracle.webcenter.composer#11.1.1@11.1.1', 'Target', Admin)
assign('Library', 'emas'                                   , 'Target', Admin)
assign('Library', 'emcore'                                 , 'Target', Admin)


assign('Library', 'adf.oracle.businesseditor#1.0@11.1.1.2.0'  , 'Target', All)
assign('Library', 'adf.oracle.domain#1.0@11.1.1.2.0'          , 'Target', All)
assign('Library', 'adf.oracle.domain.webapp#1.0@11.1.1.2.0'   , 'Target', All)

assign('Library', 'jsf#1.2@1.2.9.0' , 'Target', All)
assign('Library', 'jstl#1.2@1.2.0.1', 'Target', All)
assign('Library', 'ohw-rcf#5@5.0'   , 'Target', All)
assign('Library', 'ohw-uix#5@5.0'   , 'Target', All)

assign('Library', 'oracle.adf.desktopintegration.model#1.0@11.1.1.2.0', 'Target', All)
assign('Library', 'oracle.adf.desktopintegration#1.0@11.1.1.2.0'      , 'Target', All)
assign('Library', 'oracle.adf.dconfigbeans#1.0@11.1.1.2.0'            , 'Target', All)
assign('Library', 'oracle.adf.management#1.0@11.1.1.2.0'              , 'Target', All)

assign('Library', 'oracle.applcore.config#0.1@11.1.1.0.0', 'Target', SOAClusterName)
assign('Library', 'oracle.applcore.model#0.1@11.1.1.0.0' , 'Target', SOAClusterName)
assign('Library', 'oracle.applcore.view#0.1@11.1.1.0.0'  , 'Target', SOAClusterName)

assign('Library', 'oracle.bam.library#11.1.1@11.1.1'     , 'Target', BamAdmin)


assign('Library', 'oracle.bi.jbips#11.1.1@0.1'                 , 'Target', All)
assign('Library', 'oracle.bi.composer#11.1.1@0.1'              , 'Target', All)
assign('Library', 'oracle.bi.adf.model.slib#1.0@11.1.1.2.0'    , 'Target', All)
assign('Library', 'oracle.bi.adf.view.slib#1.0@11.1.1.2.0'     , 'Target', All)
assign('Library', 'oracle.bi.adf.webcenter.slib#1.0@11.1.1.2.0', 'Target', All)

assign('Library', 'oracle.bpm.client#11.1.1@11.1.1'        , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.composerlib#11.1.1@11.1.1'   , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.mgmt#11.1.1@11.1.1'          , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.projectlib#11.1.1@11.1.1'    , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.runtime#11.1.1@11.1.1'       , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.webapp.common#11.1.1@11.1.1' , 'Target', SoaAdmin)
assign('Library', 'oracle.bpm.workspace#11.1.1@11.1.1'     , 'Target', SoaAdmin)

assign('Library', 'oracle.dconfig-infra#11@11.1.1.1.0', 'Target', All)
assign('Library', 'oracle.jrf.system.filter'          , 'Target', All)
assign('Library', 'oracle.jsp.next#11.1.1@11.1.1'     , 'Target', All)
assign('Library', 'oracle.pwdgen#11.1.1@11.1.1.2.0'   , 'Target', All)
assign('Library', 'oracle.rules#11.1.1@11.1.1'        , 'Target', All)

assign('Library', 'oracle.sdp.client#11.1.1@11.1.1'                , 'Target', All)
assign('Library', 'oracle.sdp.messaging#11.1.1@11.1.1'             , 'Target', All)

assign('Library', 'oracle.soa.workflow.wc#11.1.1@11.1.1'           , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.worklist.webapp#11.1.1@11.1.1'       , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.rules_editor_dc.webapp#11.1.1@11.1.1', 'Target', SOAClusterName)
assign('Library', 'oracle.soa.rules_dict_dc.webapp#11.1.1@11.1.1'  , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.worklist#11.1.1@11.1.1'       , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.bpel#11.1.1@11.1.1'           , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.workflow#11.1.1@11.1.1'       , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.mediator#11.1.1@11.1.1'       , 'Target', SOAClusterName)
assign('Library', 'oracle.soa.composer.webapp#11.1.1@11.1.1', 'Target', SOAClusterName)
assign('Library', 'oracle.soa.ext#11.1.1@11.1.1'            , 'Target', SOAClusterName)

assign('Library', 'oracle.wsm.seedpolicies#11.1.1@11.1.1', 'Target', All)
assign('Library', 'orai18n-adf#11@11.1.1.1.0'            , 'Target', All)
assign('Library', 'UIX#11@11.1.1.1.0'                    , 'Target', All)


dumpStack();

#assign('SelfTuning.WorkManager', 'wm/SOAWorkManager', 'Target', SOAClusterName)
#dumpStack();

assign('ShutdownClass', 'JOC-Shutdown'                         , 'Target', All)
assign('ShutdownClass', 'DMSShutdown'                          , 'Target', All)
assign('StartupClass' , 'JRF Startup Class'                    , 'Target', All)
assign('StartupClass' , 'JPS Startup Class'                    , 'Target', All)
assign('StartupClass' , 'ODL-Startup'                          , 'Target', All)
#assign('StartupClass' , 'Audit Loader Startup Class'           , 'Target', All)
assign('StartupClass' , 'AWT Application Context Startup Class', 'Target', All)
assign('StartupClass' , 'JMX Framework Startup Class'          , 'Target', All)
assign('StartupClass' , 'Web Services Startup Class'           , 'Target', All)
assign('StartupClass' , 'JOC-Startup'                          , 'Target', All)
assign('StartupClass' , 'DMS-Startup'                          , 'Target', All)
assign('StartupClass' , 'SOAStartupClass'                      , 'Target', SOAClusterName)


dumpStack();

assign('WldfSystemResource', 'Module-FMWDFW'       , 'Target', All)

assign('JdbcSystemResource', 'BAMDataSource'       , 'Target', BAMClusterName)
assign('JdbcSystemResource', 'mds-owsm'            , 'Target', All)
assign('JdbcSystemResource', 'OraSDPMDataSource'   , 'Target', SoaBam)
assign('JdbcSystemResource', 'SOADataSource'       , 'Target', SOAClusterName)
assign('JdbcSystemResource', 'EDNDataSource'       , 'Target', SOAClusterName)
assign('JdbcSystemResource', 'EDNLocalTxDataSource', 'Target', SOAClusterName)
assign('JdbcSystemResource', 'SOALocalTxDataSource', 'Target', SOAClusterName)
assign('JdbcSystemResource', 'mds-soa'             , 'Target', SoaAdmin)

dumpStack()

updateDomain()
dumpStack();

print 'Successfully Updated SOA Domain.'

closeDomain() 