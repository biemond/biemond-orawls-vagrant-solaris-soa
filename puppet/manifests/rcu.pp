node 'rcunod.example.com'  {
   include os
   include rcu
}


# operating settings for Middleware
class os {

  notice "class os ${operatingsystem}"

  $default_params = {}
  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances, $default_params)

  # exec { "create swap file":
  #   command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192",
  #   creates => "/var/swap.1",
  # }

  # exec { "attach swap file":
  #   command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
  #   require => Exec["create swap file"],
  #   unless => "/sbin/swapon -s | grep /var/swap.1",
  # }

  # #add swap file entry to fstab
  # exec {"add swapfile entry to fstab":
  #   command => "/bin/echo >>/etc/fstab /var/swap.1 swap swap defaults 0 0",
  #   require => Exec["attach swap file"],
  #   user => root,
  #   unless => "/bin/grep '^/var/swap.1' /etc/fstab 2>/dev/null",
  # }

  service { iptables:
        enable    => false,
        ensure    => false,
        hasstatus => true,
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']

  package { $install:
    ensure  => present,
  }

  # class { 'limits':
  #   config => {
  #              '*'     => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
  #                            'nproc'   => { soft => '2048'   , hard => '16384',   },
  #                            'memlock' => { soft => '1048576', hard => '1048576',},
  #                            'stack'   => { soft => '10240'  ,},},
  #              },
  #   use_hiera => false,
  # }

  # sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  # sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  # sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  # sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  # sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  # sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  # sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  # sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  # sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  # sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  # sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  # sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  # sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  # sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  # sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  # sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  # sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

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
                 puppetDownloadMntPoint => '/vagrant',
                 remoteFile       => false,
                 logoutput        => true,
  }

}  