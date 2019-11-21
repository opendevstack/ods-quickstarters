FROM ubuntu:16.04

MAINTAINER Piotr Radkowski <piotr.radkowski@ardigen.com>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Dockerize container
RUN echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' > /etc/apt/apt.conf.d/00no-cache && \
    /usr/bin/dpkg-divert --local --rename --add /usr/bin/ischroot && \
    rm -f /usr/bin/ischroot && \
    ln -s /bin/true /usr/bin/ischroot && \
    /usr/bin/dpkg-divert --local --rename --add /sbin/initctl && \
    rm -f /sbin/initctl && \
    ln -s /bin/true /sbin/initctl

# Setup locales
RUN apt-get update && \
    apt-get install -yqq locales apt-transport-https && \
    /usr/sbin/locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANGUAGE en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Add CRAN apt repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    echo 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' > /etc/apt/sources.list.d/cran.list

# Add Cloudera apt repo
RUN apt-key adv --fetch-keys http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key && \
    echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list

# Install dependencies
RUN apt-get update && \
    apt-get install -yqq \
        gdebi-core \
        libcairo2-dev \
        libcurl4-gnutls-dev \
        libxt-dev \
        pandoc \
        pandoc-citeproc \
        hive-jdbc \
        r-base \
        r-base-dev \
        r-cran-rjava

# Install Shiny
RUN R -e 'install.packages(c("shiny", "rmarkdown"), repos="https://cran.rstudio.com/")'

# Install RJDBC and other deps from CRAN
RUN R -e 'install.packages(c("RJDBC", "shinythemes", "d3heatmap"), repos="http://cran.uni-muenster.de/")'

# Cleanup apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup app
WORKDIR /app
ADD app.R /app
EXPOSE 8080

# Run app
CMD ["R", "-e", "shiny::runApp(appDir='/app', port=8080, host='0.0.0.0', quiet=F, display.mode='normal')"]
