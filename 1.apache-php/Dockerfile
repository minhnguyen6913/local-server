FROM centos:centos7.9.2009

# Install Apache
RUN yum -y update
RUN yum -y install httpd httpd-tools

#fix perfomance
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udasev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install EPEL Repo
RUN  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 &&  rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Install PHP
RUN yum --enablerepo=remi-php74 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
    php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip

# Update Apache Configuration

EXPOSE 80
COPY /conf/*.conf /etc/httpd/conf.d/*.conf


# Install libreoffice
## install common tools
RUN yum install -y wget unzip which
## Install libreoffice
RUN wget -q https://download.documentfoundation.org/libreoffice/stable/7.1.7/rpm/x86_64/LibreOffice_7.1.7_Linux_x86-64_rpm.tar.gz
RUN mkdir /tmp/LibreOffice 
RUN tar -xzf LibreOffice_7.1.7_Linux_x86-64_rpm.tar.gz -C /tmp/LibreOffice
RUN yum localinstall -y /tmp/LibreOffice/LibreOffice_7.1.7.2_Linux_x86-64_rpm/RPMS/*
RUN rm -rf /tmp/LibreOffice
## Copy sh for run convert pdf
RUN mkdir /selinux/ 
ADD doc2pdf.sh /selinux/


VOLUME /etc/httpd/
# Start Apache
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
