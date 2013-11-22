# pypi-salt

**note**

data in `provisioning/salt/roots/pillar` is strictly for development environments.

## OSX Setup

- Download and Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads).

- Download and Install [Vagrant](http://downloads.vagrantup.com/) version 1.3.0 or greater.

- Start some servers!
  - pypi: `vagrant up pypi`
    - navigate to http://192.168.57.11/pypi and check it out!
  - pypi-mirror: `vagrant up mirror`
    - navigate to http://192.168.57.20/simple and check it out!

