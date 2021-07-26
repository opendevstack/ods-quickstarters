FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANGUAGE en
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Dockerize container and setup required OS dependencies
RUN echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' > /etc/apt/apt.conf.d/00no-cache && \
    /usr/bin/dpkg-divert --local --rename --add /usr/bin/ischroot && \
    rm -f /usr/bin/ischroot && \
    ln -s /bin/true /usr/bin/ischroot && \
    /usr/bin/dpkg-divert --local --rename --add /sbin/initctl && \
    rm -f /sbin/initctl && \
    ln -s /bin/true /sbin/initctl && \
    # Setup locales
    apt-get update && \
    apt-get install -yqq locales apt-transport-https ca-certificates gnupg && \
    /usr/sbin/locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    # Add CRAN apt repo / focal (Ubuntu 20.04) R/4.0
    if [ -n "$HTTP_PROXY" ]; then \
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --keyserver-options http-proxy=$HTTP_PROXY --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9; \
    else \
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9; \
    fi && \
    echo 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' > /etc/apt/sources.list.d/cran.list && \
    # Install dependencies
    apt-get update && \
    apt-get install -yqq \
        gdebi-core \
        libcairo2-dev \
        libcurl4-gnutls-dev \
        libxt-dev \
        pandoc \
        pandoc-citeproc \
        libssl-dev && \
    apt-get install -yqq \
        r-base \
        r-base-core \
        r-recommended \
        r-base-dev && \
    # Cleanup apt
    apt-get autoremove --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Install Shiny
RUN R -e 'install.packages(c("shiny", "rmarkdown"), repos="https://cloud.r-project.org/")'

# Install app dependencies and fail if any missing
RUN R -e 'packages = c("shinythemes", "ggplot2", "reshape2"); \
    install.packages(packages, repos="https://cloud.r-project.org/"); \
    package.check <- lapply(packages, FUN = function(p) { if(!require(p, character.only = TRUE)) { stop("package not found!") } })'

# Setup app
RUN mkdir /app
WORKDIR /app
ADD app.R /app
EXPOSE 8080

# Run app
CMD ["R", "--quiet", "--no-save", "--no-restore", "-e", "setwd('/app'); shiny::runApp(appDir='.', port=8080, host='0.0.0.0', quiet=F, display.mode='normal')"]
