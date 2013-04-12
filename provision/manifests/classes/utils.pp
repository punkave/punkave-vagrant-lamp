class utils{
  package { 
    [ 
      "tmux", 
      "screen", 
      "tcpdump", 
      "telnet", 
      "wget", 
      "git-core", 
      "subversion", 
      "htop", 
      "iotop"
    ]: 
      ensure => installed;
  }
}
