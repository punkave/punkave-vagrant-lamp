class utils{
  package { 
    [ "build-essential", "curl", "tmux", "tcpdump", "telnet", "wget", "git-core", "subversion", "htop", "iotop"]: 
      ensure => installed
  }
}
