# pypi-salt

**note**

data in `provisioning/salt/roots/pillar` is strictly for development environments.

## OSX Setup

- Download and Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads).

- Download and Install [Vagrant](http://downloads.vagrantup.com/) version 1.3.0 or greater.

- Start some servers!
  - An all in one PyPI development instance:
    - `vagrant up`
    - navigate to http://192.168.57.9/pypi
    - to hop into the environment:
      - `vagrant ssh`
      - `sudo -u devpypi -i`
      - `cd src`
