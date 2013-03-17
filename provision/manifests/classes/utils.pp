class utils{
  package { 
    [ 
      "curl", 
      "tmux", 
      "screen", 
      "vim", 
      "tcpdump", 
      "telnet", 
      "wget", 
      "git-core", 
      "subversion", 
      "htop", 
      "iotop"
    ]: 
      ensure => installed,
      require => Exec['apt-update'];
  }
}
