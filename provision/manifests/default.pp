# Imports
import "classes/*.pp"

# Some smart defaults
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# Hacks to make sure apt update runs before any package is installed
class { 'apt': always_apt_update    => true }
exec { "apt-update": command => "/usr/bin/apt-get update" }
Exec["apt-update"] -> Package <| |>


# Disable AppArmor
# sudo update-rc.d -f apparmor remove


# Load useful utilities
class {'utils':}
package { "vim": ensure => installed; }

# Load php settings
class {'php5':}

#                 Mysql 
# - - - - - - - - - - - - - - - - - - - - - - -
# Class['mysql::server'] -> Database_user['root@localhost'] -> Database_user['root@%'] -> Database_grant['root@%']

class { 'mysql::php': }
class { 'mysql::server':
  config_hash => { 
    'root_password' => 'root',
    'bind_address' => '0.0.0.0'
  }
}

# # Make sure root can connect from another server
# # This took a while to figure out. http://stackoverflow.com/a/1559992/109589
database_user { 'root@localhost':
  password_hash => mysql_password('root'),
  require => [Class['mysql::server'], Exec['set_mysql_rootpw']];
}
database_user { 'root@%':
  password_hash => mysql_password('root'),
  require => Database_user['root@localhost'] ;
}
database_grant { 'root@%':
  privileges => ['all'],
  require => Database_user['root@%'] ;
}

# LIGHTING
mysql::server::config { 'performance_tuning':
    settings => {
      'mysqld' => {
        'query_cache_limit'             => '8M',
        'query_cache_size'              => '256M',
        'log_slow_queries '             => true,
        'slow_query_log '               => '/var/log/mysql/mysql-slow.log',
        'long_query_time '              => '10',
        'log-queries-not-using-indexes' => true,
        'wait_timeout'                  => '1800',
        'connect_timeout'               => '10',    #Increase connect_timeout from 5 to 10',
        'interactive_timeout'           => '120',   #Decrease interactive_timeout from 28800 to 120',
        'innodb_buffer_pool_size '      => '128M',
        'join_buffer_size'              => '2M',   #Increase join_buffer_size from 131072 to 2M',
        'key_buffer_size '              => '64M',
        'read_buffer_size'              => '2M',     #Increase read buffer size from 1M',
        'read_rnd_buffer_size'          => '4M',     #Increase read_rnd_buffer_size to 4M',
        'myisam_sort_buffer_size'       => '64M',
        'sort_buffer_size'              => '2M',   #Increase sort buffer size from 1M',
        'table_cache'                   => '4096',    #Increase table cache cache from 256 to 2048',
        'thread_cache_size'             => '8',
        'thread_concurrency'            => '4',  # Try number of CPU's*2 for thread_concurrency',
        'tmp_table_size'                => '128M',
        'max_heap_table_size'           => '128M',
        'max_allowed_packet'            => '16M',    #Increase max allowed packet size from 1M to 16M',
        'open_files_limit'              => '3072'
      }
    }
  }

#                 Apache 
# - - - - - - - - - - - - - - - - - - - - - - -
class {'apache': }
class {'apache::mod::php': }

apache::mod{'rewrite': }
apache::mod{'vhost_alias': }

apache::vhost { 'dev':
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    override        => 'All',
    docroot         => '/var/www',
    template        => '/vagrant/provision/templates/apache/vhost-virtual.conf.erb'
}