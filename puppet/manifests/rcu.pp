node 'rcunod.example.com'  {
   include os
   include rcu
}

# operating settings for Middleware
class os {

  $default_params = {}
  $host_instances = hiera('hosts', {})
  create_resources('host',$host_instances, $default_params)

  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']

  package { $install:
    ensure  => present,
  }

  file { "/install":
      ensure              => directory,
      recurse             => false,
      replace             => false,
  }

}

class rcu {
  require os

  oradb::rcu{  'DEV_PS6':
                 rcuFile          => 'ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip',
                 product          => 'soasuite',
                 version          => '11.1.1.7',
                 user             => 'root',
                 group            => 'root',
                 downloadDir      => '/install',
                 action           => 'create',
                 dbServer         => 'dbsol.example.com:1521',
                 dbService        => 'test.oracle.com',
                 sysPassword      => 'Welcome01',
                 schemaPrefix     => 'DEV',
                 reposPassword    => 'Welcome01',
                 tempTablespace   => 'TEMP',
                 puppetDownloadMntPoint => '/software',
                 remoteFile       => false,
                 logoutput        => true,
  }

}  