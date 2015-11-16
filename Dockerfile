FROM ubuntu

MAINTAINER Marcia Goetsch "marcia.goetsch@channing.harvard.edu"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ed \
    less \
    vim-tiny \
    wget \
    locales \
    ca-certificates 

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Download and install libssl 
RUN apt-get install -y --no-install-recommends \
    libssl0.9.8 

# download and install R
ENV R_BASE_VERSION 3.2.2

RUN echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-backports main restricted universe" >> /etc/apt/sources.list
RUN (echo "deb http://watson.nci.nih.gov/cran_mirror/bin/linux/ubuntu $(lsb_release -sc)/" >> /etc/apt/sources.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9)
RUN apt-get update && apt-get install -y -q r-base  \
    r-base=${R_BASE_VERSION}* \
    r-base-dev=${R_BASE_VERSION}* \
    r-recommended=${R_BASE_VERSION}* \
    && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site  \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

CMD ["R"]

