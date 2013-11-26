
/etc/pki/rpm-gpg/RPM-GPG-KEY-GLUSTER:
  file.managed:
    - source: salt://glusterfs/config/RPM-GPG-KEY-GLUSTER
    - user: root
    - group: root
    - mode: 444

gluster-el6:
  pkgrepo.managed:
    - humanname: GlusterFS $releasever
    - baseurl: http://download.gluster.org/pub/gluster/glusterfs/3.3/3.3.2/RHEL/epel-6/x86_64/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-GLUSTER
    - require:
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-GLUSTER
