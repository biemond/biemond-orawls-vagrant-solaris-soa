import sys
import getopt
import string


WLHOME='/opt/oracle/middleware11g/wlserver_10.3'
DOMAIN_PATH='/opt/oracle/middleware11g/user_projects/domains/soa_basedomain'
DOMAIN='soa_basedomain'

soacluster = 'SoaCluster'
Admin      = 'AdminServer'


def createJMSServers(cluster, track, currentServerCnt):
    print ' '
    print "Creating JMS Servers for the cluster :- ", cluster
    s = ls('/Server')
    print ' '
    clustername = " "
    serverCnt = currentServerCnt
    for token in s.split("drw-"):
        token=token.strip().lstrip().rstrip()
        path="/Server/"+token
        cd(path)
        if not token == 'AdminServer' and not token == '':
            clustername = get('Cluster')
            print "Cluster Associated with the Server [",token,"] :- ",clustername
            print ' '
            searchClusterStr = cluster+":"
            clusterNameStr = str(clustername)
            print "searchClusterStr = ",searchClusterStr
            print "clusterNameStr = ",clusterNameStr
            if not clusterNameStr.find(searchClusterStr) == -1:
                print token, " is associated with ", cluster    
                print ' '
                print "Creating JMS Servers for ", track
                print ' '
                cd('/')

                if track == 'bpm':
                    jmsServerName = 'BPMJMSServer_auto_'+str(serverCnt)
                elif track == 'ag':
                    jmsServerName = 'AGJMSServer_auto_'+str(serverCnt)
                elif track == 'ps6soa':
                    jmsServerName = 'PS6SOAJMSServer_auto_'+str(serverCnt)

                create(jmsServerName, 'JMSServer')
                print "Created JMS Server :- ", jmsServerName
                print ' '
                assign('JMSServer', jmsServerName, 'Target', token)
                print jmsServerName, " assigned to server :- ", token 
                print ' '
                serverCnt = serverCnt + 1


readDomain(DOMAIN_PATH)

delete('BPMJMSServer'   ,'JMSSystemResource')
delete('BPMJMSModule'   ,'JMSServer')

createJMSServers(soacluster, 'bpm', 1)

cd('/')
create('BPMJMSModuleUDDs','JMSSystemResource')
     
cd('/')
cd('JMSSystemResource/BPMJMSModuleUDDs')
assign('JMSSystemResource', 'BPMJMSModuleUDDs', 'Target', soacluster)

cd('/')
cd('JMSSystemResource/BPMJMSModuleUDDs')
create('BPMJMSSubDM', 'SubDeployment')

cd('/')
cd('JMSSystemResource/BPMJMSModuleUDDs/SubDeployments/BPMJMSSubDM')

print ' '
print ("*** Listing SOA JMS Servers ***")
s = ls('/JMSServers')
soaJMSServerStr=''
for token in s.split("drw-"):
    token=token.strip().lstrip().rstrip()
    if not token.find("BPMJMSServer_auto") == -1:
        soaJMSServerStr = soaJMSServerStr + token +","
    print token

soaJMSSrvCnt=string.count(s, 'BPMJMSServer_auto')
print ' '
print "Number of BPM JMS Servers := ", soaJMSSrvCnt
print ' '
print "soaJMSServerStr := ", soaJMSServerStr
print ' '

print ("*** Setting JMS SubModule for SOA JMS Server's target***")
assign('JMSSystemResource.SubDeployment', 'BPMJMSModuleUDDs.BPMJMSSubDM', 'Target', soaJMSServerStr) 

delete('AGJMSServer'    ,'JMSSystemResource')
delete('AGJMSModule'    ,'JMSServer')
createJMSServers(soacluster, 'ag', 1)

cd('/')
create('AGJMSModuleUDDs','JMSSystemResource')
     
cd('/')
cd('JMSSystemResource/AGJMSModuleUDDs')
assign('JMSSystemResource', 'AGJMSModuleUDDs', 'Target', soacluster)

cd('/')
cd('JMSSystemResource/AGJMSModuleUDDs')
create('AGJMSSubDM', 'SubDeployment')

cd('/')
cd('JMSSystemResource/AGJMSModuleUDDs/SubDeployments/AGJMSSubDM')

print ' '
print ("*** Listing SOA JMS Servers ***")
s = ls('/JMSServers')
soaJMSServerStr=''
for token in s.split("drw-"):
    token=token.strip().lstrip().rstrip()
    if not token.find("AGJMSServer_auto") == -1:
        soaJMSServerStr = soaJMSServerStr + token +","
    print token

soaJMSSrvCnt=string.count(s, 'AGJMSServer_auto')
print ' '
print "Number of AG JMS Servers := ", soaJMSSrvCnt
print ' '
print "soaJMSServerStr := ", soaJMSServerStr
print ' '

print ("*** Setting JMS SubModule for SOA JMS Server's target***")
assign('JMSSystemResource.SubDeployment', 'AGJMSModuleUDDs.AGJMSSubDM', 'Target', soaJMSServerStr) 


delete('PS6SOAJMSServer','JMSSystemResource')
delete('PS6SOAJMSModule','JMSServer')
createJMSServers(soacluster, 'ps6soa', 1)

cd('/')
create('PS6SOAJMSModuleUDDs','JMSSystemResource')
     
cd('/')
cd('JMSSystemResource/PS6SOAJMSModuleUDDs')
assign('JMSSystemResource', 'PS6SOAJMSModuleUDDs', 'Target', soacluster)

cd('/')
cd('JMSSystemResource/PS6SOAJMSModuleUDDs')
create('PS6SOAJMSSubDM', 'SubDeployment')

cd('/')
cd('JMSSystemResource/PS6SOAJMSModuleUDDs/SubDeployments/PS6SOAJMSSubDM')

print ' '
print ("*** Listing SOA JMS Servers ***")
s = ls('/JMSServers')
soaJMSServerStr=''
for token in s.split("drw-"):
    token=token.strip().lstrip().rstrip()
    if not token.find("PS6SOAJMSServer_auto") == -1:
        soaJMSServerStr = soaJMSServerStr + token +","
    print token

soaJMSSrvCnt=string.count(s, 'PS6SOAJMSServer_auto')
print ' '
print "Number of PS6SOA JMS Servers := ", soaJMSSrvCnt
print ' '
print "soaJMSServerStr := ", soaJMSServerStr
print ' '

print ("*** Setting JMS SubModule for SOA JMS Server's target***")
assign('JMSSystemResource.SubDeployment', 'PS6SOAJMSModuleUDDs.PS6SOAJMSSubDM', 'Target', soaJMSServerStr) 




dumpStack()

updateDomain()
dumpStack();

print 'Successfully Updated SOA Domain.'

closeDomain() 