class php5 {
  # Setup PHP with all the fun stuff
  package {   
    ['php5-common']:
      ensure => present,
      require => Exec['apt-update'];
    ['php5-cli', 'php5-suhosin', 'php5-curl', 'php5-cgi', 'php5-gd', 'php-apc', 'php5-imap', 'php5-intl', 'php5-mcrypt', 'php5-xsl', 'php5-sqlite', 'php-soap', 'php5-xdebug']:
      ensure => present,
      require => Package['php5-common'];
    ['php-pear']:
      ensure => present,
      require => Package['php5-cli']
    }

  # # Prepare PEAR
  # file {
  #   'pear.tmpdirfix.prepare':
  #     ensure  => directory,
  #     path    => '/tmp/pear',
  #     require => Package['php-pear'];
  #   'pear.tmpdirfix':
  #     ensure  => directory,
  #     path    => '/tmp/pear/cache',
  #     mode    => 777,
  #     require => File['pear.tmpdirfix.prepare']
  # }
  # # Setup PEAR
  # exec {
  #   'pear.upgrade.pear':
  #     path => '/bin:/usr/bin:/usr/sbin',
  #     command => 'pear upgrade PEAR',
  #     require => File['pear.tmpdirfix']
  # }

  file { "/etc/php5/apache2/conf.d/optimal.ini":
    mode => 644,
    owner => root,
    group => root,
    source => "/vagrant/provision/files/php/php.ini",
    notify  => Service['httpd']
  }
}

# git-core mod_fastcgi mysql5-server 
# 
# php5-apc php5-curl php5-exif php5-gd php5-iconv php5-posix php5-imap php5-intl php5-mbstring php5-mcrypt php5-mysql php5-openssl php5-soap php5-xsl php5-mongo php5-sqlite 

# unrar wget mongodb sqlite3 nodejs npm redis