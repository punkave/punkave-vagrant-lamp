class php5 {
  # Setup PHP with all the fun stuff
  package {   
    ['php5-common']:
      ensure => present;
    ['php5-cli', 'php5-suhosin', 'php5-curl', 'php5-cgi', 'php5-gd', 'php-apc', 'php5-imap', 'php5-intl', 'php5-mcrypt', 'php5-xsl', 'php5-sqlite', 'php-soap', 'php5-xdebug']:
      ensure => present,
      require => Package['php5-common'];
    ['php-pear']:
      ensure => present,
      require => Package['php5-cli']
    }
  
  # Setup PEAR
  Package['php-pear'] -> Exec['pear upgrade pear'] -> File['/tmp/pear/temp'] ->  Exec["pear auto_discover"] 
    # -> Exec["pear update-channels" ] 
    -> Exec['pear add channel phpseclib.sourceforge.net'] 
    -> Exec['pear install Net_SFTP']

  file { "/tmp/pear/temp":
    ensure => "directory",
    owner => "root",
    group => "root",
    mode => 777
  }

  exec {
    'pear upgrade pear':
      command => 'pear upgrade PEAR',
      returns => [ 0, '', ' '];
    "pear auto_discover" :
      command => "/usr/bin/pear config-set auto_discover 1";
    # "pear update-channels" :
    #   command => "/usr/bin/pear update-channels";
    'pear add channel phpseclib.sourceforge.net':
      command => 'pear channel-discover phpseclib.sourceforge.net',
      unless => 'pear list-channels | grep phpseclib.sourceforge.net';
    'pear install Net_SFTP':
      command => 'pear install phpseclib/Net_SFTP',
      unless=> 'pear list -a | grep Net_SFTP';
  }

  file { 
    # This is an attocity byt can't seem to get the conf file to wait until the dir is there
    ['/etc/php5','/etc/php5/apache2/','/etc/php5/apache2/conf.d/']:
      ensure => directory;
    '/etc/php5/apache2/conf.d/optimal.ini':
      ensure => present,
      mode => 644,
      owner => root,
      group => root,
      source => '/vagrant/provision/files/php/optimal.ini',
      require => File['/etc/php5/apache2/conf.d/'],
      notify  => Service['httpd']
  }
}