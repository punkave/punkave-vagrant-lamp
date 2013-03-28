class utils{
  package { 
    [ 
      "curl", 
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
