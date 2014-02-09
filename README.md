biemond-orawls-vagrant-solaris
==============================

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux,solaris and the use of Hiera  

creates a patched 10.3.6 SOA Suite WebLogic cluster ( adminsol, nodesol1 , nodesol2 )
creates an Oracle Database 12.1 ( dbsol )
creates an Linux RCU Host ( rcunod )

Tested with 
- vagrant 1.35
- virtualbox 4.3.5

follow these steps
- download all the software
- vagrant up dbsol
- vagrant up rcunod ( just for installing the RCU Soa Suite)
- vagrant destroy rcunod
- vagrant up adminsol
- vagrant up nodesol1
- vagrant up nodesol2

site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant-solaris-soa/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant-solaris-soa/tree/master/puppet/hieradata

This box uses the following software

Add the all the Oracle binaris to /software, edit Vagrantfile and update all entries like
- adminsol.vm.synced_folder "/Users/edwin/software", "/software"
- dbsol.vm.synced_folder "/Users/edwin/software", "/software"



JDK 7
- jdk-7u45-solaris-i586.tar.gz
- jdk-7u45-solaris-x64.tar.gz

Database 12.1
- solaris.x64_12cR1_database_1of2.zip
- solaris.x64_12cR1_database_2of2.zip

WebLogic 10.3.6
- wls1036_generic.jar
- p17071663_1036_Generic.zip

FMW 11 PS6
- ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip
- ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip

FWM 11 PS6 SOA Suite 11g Opatch
- p17014142_111170_Generic.zip

RCU Linux 64
- ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip

optional

Sun solaris 10 x86 64bits DVD iso, from edelivery.oracle.com
- V36435-01.iso

FMW 11 PS6
- ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip

Using the following facts

- environment => "development"
- vm_type     => "vagrant"

also need to set "--parser future" to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two

Detailed vagrant steps (setup) can be found here:

http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

For Mac Users.  The procedure has been and run tested on Mac.
