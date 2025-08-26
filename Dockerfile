FROM centos/devtoolset-7-toolchain-centos7
# RUN apt-get -y   -q   update && apt-get  install  -y   -q  apt-transport-https ca-certificates  
RUN  yum update &&  yum  install  -y   -q   ca-certificates x11-xserver-utils  dbus-x11  libcanberra-gtk3-module    libpci3 libgl1 && \
    yum install -yq  fonts-arphic-ukai  fonts-arphic-uming  fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp  fonts-arphic-gkai00mp  fonts-wqy-zenhei  latex-cjk-chinese-arphic-bkai00mp  latex-cjk-chinese-arphic-bsmi00lp  latex-cjk-chinese-arphic-gbsn00lp  latex-cjk-chinese-arphic-gkai00mp  xfonts-intl-chinese  xfonts-intl-chinese-big fonts-cns11643-kai  fonts-cns11643-sung  fonts-moe-standard-kai  fonts-moe-standard-song && \
    yum install git g++ binutils autoconf automake libtool make cmake pkg-config electric-fence   -yq && \
    yum install libgtk2.0-dev  -yq && \
    yum install libjpeg-dev libpng-dev libfreetype6-dev libharfbuzz-dev  -yq && \
    yum install libinput-dev libdrm-dev libsqlite3-dev libxml2-dev  sudo  libssl-dev -yq &&  \
    yum install  libconfig-dev  -yq && \
    yum install  openssh-server -yq  && \
yum install  gdb gdbserver -yq  && \
   yum install libpq-dev -yq && \
    yum install busybox -yq && \
    yum clean && yum autoremove   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

RUN   git clone https://gitlab.fmsoft.cn/VincentWei/build-minigui-5.0  && \
      cd build-minigui-5.0/ && cp config.sh myconfig.sh && ./fetch-all.sh   && \
    #   sed -i -e 's/mg-tests mg-samples mg-demos cell-phone-ux-demo/mg-samples mg-demos cell-phone-ux-demo/g' build-minigui.sh && \
      ./build-deps.sh && ./build-minigui.sh ths &&  \
      cd .. && rm  ./build-minigui-5.0 -rf

 
RUN cd ~/ && \
	wget https://curl.haxx.se/download/curl-7.67.0.tar.gz && \
	tar xzf curl-7.67.0.tar.gz &&  cd ~/curl-7.67.0/ && \
	./buildconf && ./configure  && make  && make install && \
    rm  ~/curl-7.67.0/ -rf


RUN mkdir /var/run/sshd 
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
