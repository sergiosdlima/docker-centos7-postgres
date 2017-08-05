FROM centos:7
MAINTAINER Sérgio Lima "sergiosdlima@gmail.com"

# Install some tools
RUN yum -y update && yum install -y \
    curl \
    wget \
  && yum clean all

# Add postgresql.org repo and install postgres server
RUN yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
  && yum install -y postgresql96-server \
    postgresql96 \
    postgresql96-contrib \
  && rm -rf /var/tmp/*

# Reinstall glibc to provide suport to pt_BR locale
RUN yum reinstall -y glibc-common \
  && localedef -i pt_BR -f UTF-8 pt_BR.UTF-8

# Initialize DB data files
RUN su -c - postgres '/usr/pgsql-9.6/bin/initdb -E UTF8 --locale=pt_BR.UTF-8 --username=postgres -D /var/lib/pgsql/data' \
  # open up tcp access for all
  && echo "host all all all trust" > /var/lib/pgsql/data/pg_hba.conf \
  # needed to createuser below
  && echo "local all postgres trust" >> /var/lib/pgsql/data/pg_hba.conf \
  #listen on all interfaces
  && echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf

EXPOSE 5432

# Start postgres service
ENTRYPOINT ["su", "postgres", "-c", "/usr/pgsql-9.6/bin/postgres -D /var/lib/pgsql/data"]
