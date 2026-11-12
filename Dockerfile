FROM ohdsi/broadsea-shiny:1.2.0

ARG DEBIAN_FRONTEND=noninteractive
ARG CRAN=https://packagemanager.posit.co/cran/__linux__/focal/latest
ARG JAVA_PARAMS=-Xss100m

ENV DATABASECONNECTOR_JAR_FOLDER=/root
ENV R_LIBS=/usr/local/lib/R/site-library

RUN apt-get update && \
    apt-get install -y openjdk-8-jre libicu-dev icu-devtools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "options(repos=c(CRAN='$CRAN'))" >> /root/.Rprofile
RUN echo "options(java.parameters = '$JAVA_PARAMS')" >> /root/.Rprofile

RUN R -e 'install.packages(c("remotes", "rJava", "dplyr", "DatabaseConnector", "shiny", "stringi", "RSQLite", "pak"))'
RUN R CMD javareconf
RUN R -e "remove.packages('stringi'); install.packages('stringi', type='source')"

# JDBC driver is baked into the image so no download is needed at runtime
RUN R -e "DatabaseConnector::downloadJdbcDrivers('postgresql', pathToDriver='/root')"

RUN R -e "remotes::install_github('OHDSI/ResultModelManager', update='always')"
RUN R -e "remotes::install_github('OHDSI/OhdsiReportGenerator')"
RUN R -e "remotes::install_github('OHDSI/OhdsiShinyModules'); if (!require('OhdsiShinyModules', quietly = TRUE)) stop('OhdsiShinyModules failed')"
RUN R -e "remotes::install_github('OHDSI/OhdsiShinyAppBuilder'); if (!require('OhdsiShinyAppBuilder', quietly = TRUE)) stop('OhdsiShinyAppBuilder failed')"

WORKDIR /srv/shiny-server/
RUN chmod a+rx /root

COPY app.R ./

EXPOSE 3838

# ShinyProxy overrides this with container-cmd; app.R returns a shiny app object
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/', host='0.0.0.0', port=3838)"]
