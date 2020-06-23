FROM fedora:30
ENV container=docker

RUN dnf makecache && dnf -y update && dnf clean all

RUN dnf makecache \
    && dnf -y install \
    ansible \
    bash \
    systemd \
    sudo \
    which \
    python3 \
    python3-dnf \
    python3-pip \
    && dnf clean all && \
  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;\
  pip3 install q epdb

RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

RUN echo -e "localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/sbin/init"]
