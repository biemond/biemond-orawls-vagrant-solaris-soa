node 'dbsol.example.com'  {
   include os
   include db12c
}

# operating settings for Database & Middleware
class os {

  $default_params = {}
  $host_instances = hiera('hosts', [])
  create_resources('host',$host_instances, $default_params)


# vagrant
# vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 0, '--device', 1, '--type', 'dvddrive', '--medium',  "/Users/edwin/Downloads/V36435-01.iso"]
#
# mount cdrom
# ls -al /dev/sr* |awk '{print "/" $11}'
# mkdir -p /cdrom/unnamed_cdrom
# mount -F hsfs -o ro /dev/dsk/c0t1d0s2 /cdrom/unnamed_cdrom
#

  exec { "create /cdrom/unnamed_cdrom":
    command => "/usr/bin/mkdir -p /cdrom/unnamed_cdrom",
    creates => "/cdrom/unnamed_cdrom",
  }

  mount { "/cdrom/unnamed_cdrom":
    device   => "/dev/dsk/c0t1d0s2",
    fstype   => "hsfs",
    ensure   => "mounted",
    options  => "ro",
    atboot   => true,
    remounts => false,
    require  => Exec["create /cdrom/unnamed_cdrom"],
  }

  $install = [ 
               'SUNWarc','SUNWbtool','SUNWcsl',
               'SUNWdtrc','SUNWeu8os','SUNWhea',
               'SUNWi1cs', 'SUNWi15cs',
               'SUNWlibC','SUNWlibm','SUNWlibms',
               'SUNWsprot',
               'SUNWtoo',
               'SUNWxwfnt'
              ]
               
  package { $install:
    ensure    => present,
    adminfile => "/vagrant/pkgadd_response",
    source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
    require   => [Exec["create /cdrom/unnamed_cdrom"],
                  Mount["/cdrom/unnamed_cdrom"]
                 ],  
  }
  package { 'SUNWi1of':
    ensure    => present,
    adminfile => "/vagrant/pkgadd_response",
    source    => "/cdrom/unnamed_cdrom/Solaris_10/Product/",
    require   => Package[$install],  
  }


# pkginfo -i SUNWarc SUNWbtool SUNWhea SUNWlibC SUNWlibm SUNWlibms SUNWsprot SUNWtoo SUNWi1of SUNWi1cs SUNWi15cs SUNWxwfnt SUNWcsl SUNWdtrc
# pkgadd -d /cdrom/unnamed_cdrom/Solaris_10/Product/ -r response -a response SUNWarc SUNWbtool SUNWhea SUNWlibC SUNWlibm SUNWlibms SUNWsprot SUNWtoo SUNWi1of SUNWi1cs SUNWi15cs SUNWxwfnt SUNWcsl SUNWdtrc

  exec { "remove localhost":
    command => "/usr/bin/sed -e '/'127.0.0.1'/ d' /etc/hosts >/etc/hosts",
    unless  => "/usr/bin/grep -c ${hostname} /etc/hosts",
  }

  exec { "add localhost":
    command => "/bin/echo '127.0.0.1 localhost ${fqdn} ${hostname}' >>/etc/hosts",
    unless  => "/usr/bin/grep -c ${hostname} /etc/hosts",
    require => Exec["remove localhost"],
  }


# On Oracle Solaris 10, you are not required to make changes to the /etc/system file to 
# implement the System V IPC. 
# Oracle Solaris 10 uses the resource control facility for its implementation.

# project.max-sem-ids 100
# process.max-sem-nsems 256
# project.max-shm-memory  This value varies according to the RAM size. See General Server Minimum Requirements for minimum values.
# project.max-shm-ids 100
# tcp_smallest_anon_port  9000
# tcp_largest_anon_port 65500
# udp_smallest_anon_port  9000
# udp_largest_anon_port 65500

# prctl -n project.max-shm-memory -v 6gb -r -i project group.dba
# To modify the value of max-sem-ids to 256:
# prctl -n project.max-sem-ids -v 256 -r -i project group.dba
# Table 6 Requirement for Resource Control project.max-shm-memory
#
# prctl -n project.max-shm-memory -i project default
#RAM project.max-shm-memory setting
# 4 GB 2 GB
# 4 GB to 8 GB  Half the size of the physical memory
# Greater than 8 GB  8 GB



#The ulimit settings determine process memory related resource limits. Verify that the shell limits displayed in the following table are set to the values shown:
#Shell Limit Description Soft Limit (KB) Hard Limit (KB)
#STACK Size of the stack segment of the process  at most 10240 at most 32768
#NOFILES Open file descriptors at least 1024 at least 65536
#MAXUPRC or MAXPROC  Maximum user processes  at least 2047 at least 16384
#To display the current value specified for these shell limits enter the following commands:
#
#ulimit -s
#ulimit -n


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
            user                   => 'oracle',
            group                  => 'dba',
            downloadDir            => '/install',
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

   oradb::listener{'start listener':
            oracleBase   => '/oracle',
            oracleHome   => '/oracle/product/12.1/db',
            user         => 'oracle',
            group        => 'dba',
            action       => 'start',  
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

