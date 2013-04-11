# P'unk Ave's Vagrant LAMP setup

This project aims to have an isolated, repeated and disposable development environment that closely reflects production servers.

## Installation

1. `cd` to where ever you would like to keep vagrant dev environments. *I like `~/dev`*
2. `git clone git@github.com:punkave/punkave-vagrant-lamp.git vagrant-lamp`
3. `cd vagrant-lamp`
4. `git submodule init`
5. `git submodule update`
6. `vagrant up`

### Assumptions

* The latest Vagrant and Virtual Box is installed
* That your projects are standard symfony sites and that the files are in `~/www`. *For example: `~/www/waytohealth/web`*

## Technical Specs

* A VM with 2 CPUs, 4GB of ram and 80GB HD
* PHP, Apache and mysql optimally configured. See [the default manifest](/punkave/punkave-vagrant-lamp/blob/master/provision/manifests/default.pp) for more details
