import "classes/*.pp"
# import "modules.pp"

class { 'apt':
  always_apt_update    => true
}

# Need to specify this so php installs actually work
exec {'apt-update':
  command => '/usr/bin/apt-get update',
  onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
}

class {'utils':}

class {'php5':}

class { 'mysql::php': }
class { 'mysql::server':
  config_hash => { 'root_password' => 'root' }
}

class {'apache': }
class {'apache::mod::php': }

apache::mod{'rewrite': }

apache::vhost { 'dev':
    priority        => '10',
    vhost_name      => '*',
    port            => '80',
    docroot         => '/var/www',
    template        => '/vagrant/provision/templates/apache/vhost-virtual.conf.erb'
}