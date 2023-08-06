# get shiny server and R from the rocker project
FROM rocker/shiny-verse:latest

# system libraries
# Try to only install system libraries you actually need
# Package Manager is a good resource to help discover system deps
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev \
    libv8-dev \
    zlib1g-dev \
    libicu-dev \
    make \
    pandoc
  
# install R packages required 
RUN R -e 'install.packages(c("shiny","shinydashboard","ggplot2", "markdown", "rstan", "prophet","dygraphs","shinythemes","dplyr","shinycssloaders"), \
            repos="http://cran.rstudio.com/"\
          )'

# copy the app directory into the image
COPY ./shiny-app/* /srv/shiny-server/

EXPOSE 3838

# run app
CMD ["/usr/bin/shiny-server"]
