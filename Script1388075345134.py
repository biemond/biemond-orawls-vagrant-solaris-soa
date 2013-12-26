
cd('/SelfTuning/soa_basedomain/WorkManagers/wm/SOAWorkManager')
set('Targets', jarray.array([ObjectName('com.bea:Name=SoaCluster,Type=Cluster')], ObjectName))

cd('/SelfTuning/soa_basedomain/WorkManagers/weblogic.wsee.mdb.DispatchPolicy')
set('Targets', jarray.array([ObjectName('com.bea:Name=OsbCluster,Type=Cluster')], ObjectName))