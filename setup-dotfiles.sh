#!/bin/bash

vagrant ssh -c "
(
  git clone git@github.com:mattmcmanus/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  echo 'O' | script/bootstrap
  rm ~/.bash_prompt
)"