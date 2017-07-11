FROM centos:7
MAINTAINER Sérgio Lima "sergiosdlima@gmail.com"

RUN yum -y update

# install some tools
RUN yum install -y curl wget

# add postgresql.org repo
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

# install postgres
RUN yum -y install postgresql96-server postgresql96 postgresql96-contrib

# reinstall glibc to provide suport to pt_BR locale
RUN yum reinstall -y glibc-common
RUN localedef -i pt_BR -f UTF-8 pt_BR.UTF-8

# initialize DB data files
RUN su -c - postgres '/usr/pgsql-9.6/bin/initdb -E UTF8 --locale=pt_BR.UTF-8 --username=postgres -D /var/lib/pgsql/data'

# open up tcp access for all
RUN echo "host all all all trust" > /var/lib/pgsql/data/pg_hba.conf
# needed to createuser below
RUN echo "local all postgres trust" >> /var/lib/pgsql/data/pg_hba.conf

#listen on all interfaces
RUN echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf

# CLEAN UP
RUN yum clean all

EXPOSE 5432

# Start postgres service
ENTRYPOINT ["su", "postgres", "-c", "/usr/pgsql-9.6/bin/postgres -D /var/lib/pgsql/data"]
