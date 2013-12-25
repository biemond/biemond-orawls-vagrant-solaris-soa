node 'dbsol.example.com'  {
   include os
   include db12c
}

# operating settings for Database & Middleware
class os {

  $default_params = {}
  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances, $default_params)

  # exec { "create /cdrom/unnamed_cdrom":
  #   command => "/usr/bin/mkdir -p /cdrom/unnamed_cdrom",
  #   creates => "/cdrom/unnamed_cdrom",
  # }

  # mount { "/cdrom/unnamed_cdrom":
  #   device   => "/dev/dsk/c0t1d0s2",
  #   fstype   => "hsfs",
  #   ensure   => "mounted",
  #   options  => "ro",
  #   atboot   => true,
  #   remounts => false,
  #   require  => Exec["create /cdrom/unnamed_cdrom"],
  # }

  # $install = [ 
  #              'SUNWarc','SUNWbtool','SUNWcsl',
  #              'SUNWdtrc','SUNWeu8os','SUNWhea',
  #              'SUNWi1cs', 'SUNWi15cs',
  #              'SUNWlibC','SUNWlibm','SUNWlibms',
  #              'SUNWsprot','SUNWpool','SUNWpoolr',
  #              'SUNWtoo','SUNWxwfnt'
  #             ]
               
  # package { $install:
  #   ensure    => present,
  #   adminfile => "/vagrant/pkgadd_response",
  #   source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
  #   require   => [Exec["create /cdrom/unnamed_cdrom"],
  #                 Mount["/cdrom/unnamed_cdrom"]
  #                ],  
  # }
  # package { 'SUNWi1of':
  #   ensure    => present,
  #   adminfile => "/vagrant/pkgadd_response",
  #   source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
  #   require   => Package[$install],  
  # }

  exec { "remove localhost":
    command => "/usr/bin/sed -e '/'127.0.0.1'/ d' /etc/hosts > /tmp/hosts.tmp && mv /tmp/hosts.tmp /etc/hosts",
    unless  => "/usr/bin/grep -c ${hostname} /etc/hosts",
  }

  exec { "add localhost":
    command => "/bin/echo '10.10.10.5 localhost ${fqdn} ${hostname}' >>/etc/hosts",
    unless  => "/usr/bin/grep -c ${hostname} /etc/hosts",
    require => Exec["remove localhost"],
  }

  group { 'dba' :
    ensure      => present,
  }

  user { 'oracle' :
    ensure      => present,
    gid         => 'dba',  
    groups      => 'dba',
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/export/home/oracle",
    comment     => "This user ${user} was created by Puppet",
    require     => Group['dba'],
    managehome  => true,
  }

  $execPath     = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:"

  exec { "projadd max-shm-memory":
    command => "projadd -p 102  -c 'ORADB' -U oracle -G dba  -K 'project.max-shm-memory=(privileged,4G,deny)' ORADB",
    require => [ User["oracle"],
#                 Package['SUNWi1of'],
#                 Package[$install],
               ],
    unless  => "projects -l | grep -c ORADB",           
    path    => $execPath,
  }

  exec { "projmod max-sem-ids":
    command     => "projmod -s -K 'project.max-sem-ids=(privileged,100,deny)' ORADB",
    subscribe   => Exec["projadd max-shm-memory"],
    require     => Exec["projadd max-shm-memory"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-shm-ids":
    command     => "projmod -s -K 'project.max-shm-ids=(privileged,100,deny)' ORADB",
    require     => Exec["projmod max-sem-ids"],
    subscribe   => Exec["projmod max-sem-ids"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-sem-nsems":
    command     => "projmod -s -K 'process.max-sem-nsems=(privileged,256,deny)' ORADB",
    require     => Exec["projmod max-shm-ids"],
    subscribe   => Exec["projmod max-shm-ids"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-file-descriptor":
    command     => "projmod -s -K 'process.max-file-descriptor=(basic,65536,deny)' ORADB",
    require     => Exec["projmod max-sem-nsems"],
    subscribe   => Exec["projmod max-sem-nsems"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "projmod max-stack-size":
    command     => "projmod -s -K 'process.max-stack-size=(privileged,32MB,deny)' ORADB",
    require     => Exec["projmod max-file-descriptor"],
    subscribe   => Exec["projmod max-file-descriptor"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "usermod oracle":
    command     => "usermod -K project=ORADB oracle",
    require     => Exec["projmod max-stack-size"],
    subscribe   => Exec["projmod max-stack-size"],
    refreshonly => true, 
    path        => $execPath,
  }

  exec { "ndd 1":
    command => "ndd -set /dev/tcp tcp_smallest_anon_port 9000",
    require => Exec["usermod oracle"],
    path    => $execPath,
  }
  exec { "ndd 2":
    command => "ndd -set /dev/tcp tcp_largest_anon_port 65500",
    require => Exec["ndd 1"],
    path    => $execPath,
  }

  exec { "ndd 3":
    command => "ndd -set /dev/udp udp_smallest_anon_port 9000",
    require => Exec["ndd 2"],
    path    => $execPath,
  }

  exec { "ndd 4":
    command => "ndd -set /dev/udp udp_largest_anon_port 65500",
    require => Exec["ndd 3"],
    path    => $execPath,
  }    

  exec { "ulimit -S":
    command => "ulimit -S -n 4096",
    require => Exec["ndd 4"],
    path    => $execPath,
  }

  exec { "ulimit -H":
    command => "ulimit -H -n 65536",
    require => Exec["ulimit -S"],
    path    => $execPath,
  }  


}

class db12c {
  require os

    oradb::installdb{ '12.1_solaris-x64':
            version                => '12.1.0.1',
            file                   => 'solaris.x64_12cR1_database',
            databaseType           => 'SE',
            oracleBase             => '/oracle',
            oracleHome             => '/oracle/product/12.1/db',
            userBaseDir            => '/export/home',
            createUser             => false,
            user                   => 'oracle',
            group                  => 'dba',
            downloadDir            => '/install',
            remoteFile             => false,
            puppetDownloadMntPoint => "/vagrant",  
    }

   oradb::net{ 'config net8':
            oracleHome   => '/oracle/product/12.1/db',
            version      => '12.1',
            user         => 'oracle',
            group        => 'dba',
            downloadDir  => '/install',
            require      => Oradb::Installdb['12.1_solaris-x64'],
   }

#   exec { "replace localhost listener.ora":
#        command     => "/bin/sed -e's/localhost/0.0.0.0/g' /oracle/product/12.1/db/network/admin/listener.ora > /tmp/ora.tmp && mv /tmp/ora.tmp /oracle/product/12.1/db/network/admin/listener.ora" ,
#        require     => Oradb::Net['config net8'],
#        onlyif      => "/bin/grep -c localhost /oracle/product/12.1/db/network/admin/listener.ora",
#        user        => 'oracle',
#        group       => 'dba',
#   }


   oradb::listener{'start listener':
            oracleBase   => '/oracle',
            oracleHome   => '/oracle/product/12.1/db',
            user         => 'oracle',
            group        => 'dba',
            action       => 'start',  
#            require      => Exec["replace localhost listener.ora"],
            require      => Oradb::Net['config net8'],
   }

   oradb::database{ 'testDb': 
                    oracleBase              => '/oracle',
                    oracleHome              => '/oracle/product/12.1/db',
                    version                 => '12.1',
                    user                    => 'oracle',
                    group                   => 'dba',
                    downloadDir             => '/install',
                    action                  => 'create',
                    dbName                  => 'test',
                    dbDomain                => 'oracle.com',
                    sysPassword             => 'Welcome01',
                    systemPassword          => 'Welcome01',
                    dataFileDestination     => "/oracle/oradata",
                    recoveryAreaDestination => "/oracle/flash_recovery_area",
                    characterSet            => "AL32UTF8",
                    nationalCharacterSet    => "UTF8",
                    initParams              => "open_cursors=1000,processes=600,job_queue_processes=4,compatible=12.1.0.0.0",
                    sampleSchema            => 'TRUE',
                    memoryPercentage        => "40",
                    memoryTotal             => "800",
                    databaseType            => "MULTIPURPOSE",                         
                    require                 => Oradb::Listener['start listener'],
   }

   oradb::dbactions{ 'start testDb': 
                   oracleHome              => '/oracle/product/12.1/db',
                   user                    => 'oracle',
                   group                   => 'dba',
                   action                  => 'start',
                   dbName                  => 'test',
                   require                 => Oradb::Database['testDb'],
   }

   # oradb::autostartdatabase{ 'autostart oracle': 
   #                 oracleHome              => '/oracle/product/12.1/db',
   #                 user                    => 'oracle',
   #                 dbName                  => 'test',
   #                 require                 => Oradb::Dbactions['start testDb'],
   # }
}

