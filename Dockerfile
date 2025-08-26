FROM centos:centos7.6.1810
USER root
RUN sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.6.1810|g" \
    -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.6.1810|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo

RUN yum update -y &&  yum install git g++ binutils autoconf automake libtool make  pkg-config electric-fence  \
    gdb gdbserver   openssh-server  net-tools lsof telnet passwd \
    libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget  libconfig-dev libvncserver-dev   -y && \
     yum clean all

RUN mkdir /var/run/sshd 
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
