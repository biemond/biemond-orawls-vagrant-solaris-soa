define orawls::utils::migratesecuritystore (
  $version                    = hiera('wls_version'               , 1111),  # 1036|1111|1211|1212
  $weblogic_home_dir          = hiera('wls_weblogic_home_dir'     , undef), # /opt/oracle/middleware11gR1/wlserver_103
  $middleware_home_dir        = hiera('wls_middleware_home_dir'   , undef), # /opt/oracle/middleware11gR1
  $jdk_home_dir               = hiera('wls_jdk_home_dir'          , undef), # /usr/java/jdk1.7.0_45
  $fmw_product                = undef,                                      # adf|soa|osb
  $domain_name                = hiera('domain_name'               , undef),
  $domain_dir                 = undef,
  $adminserver_name           = hiera('domain_adminserver'        , "AdminServer"),
  $adminserver_address        = hiera('domain_adminserver_address', "localhost"),
  $adminserver_port           = hiera('domain_adminserver_port'   , 7001),
  $weblogic_user              = hiera('wls_weblogic_user'         , "weblogic"),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  $os_user                    = hiera('wls_os_user'               , undef), # oracle
  $os_group                   = hiera('wls_os_group'              , undef), # dba
  $download_dir               = hiera('wls_download_dir'          , undef), # /data/install
  $log_output                 = false, # true|false
)
{
     if ( $fmw_product == "soa" or $fmw_product == "adf"  ) {

        # the domain.py used by the wlst
        file { "migrateSecurityStore.py ${domain_name} ${title}":
          path    => "${download_dir}/migrateSecurityStore_${domain_name}.py",
          content => template("orawls/wlst/wlstexec/fmw/migrateSecurityStore.py.erb"),
          ensure  => present,
          replace => true,
          backup  => false,
          mode    => 0775,
          owner   => $os_user,
          group   => $os_group,
        }

        exec { "execwlst create OPSS store ${domain} ${title}":
          command     => "${wlstPath}/wlst.sh ${download_dir}/migrateSecurityStore_${domain_name}.py",
          environment => ["JAVA_HOME=${jdk_home_dir}"],
          require     => File["migrateSecurityStore.py ${domain_name} ${title}"],
          timeout     => 0,
        }

    }

}