import "classes/*.pp"

class { 'apt':
  always_apt_update    => true
}

# Need to specify this so php installs actually work
exec {'apt-update':
  command => '/usr/bin/apt-get update',
  # onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
}

class {'utils':}

class {'php5':}

#                 Mysql 
# - - - - - - - - - - - - - - - - - - - - - - -
class { 'mysql::php': }
class { 'mysql::server':
  config_hash => { 'root_password' => 'root' }
}

mysql::server::config { 'basic_config':
    settings => {
      'mysqld' => {
        'query_cache_limit'             => '8M',
        'query_cache_size'              => '256M',
        'slow_query_log '               => '/var/log/mysql/mysql-slow.log',
        'long_query_time '              => '10',
        'log-queries-not-using-indexes' => true,
        'wait_timeout'                  => '60',
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