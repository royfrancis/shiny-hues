FROM rocker/shiny:4.3.2
LABEL Description="Docker image for shiny-hues"
LABEL authors="Roy Francis"
LABEL org.opencontainers.image.source="https://github.com/royfrancis/shiny-hues"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    install2.r --error --skipinstalled remotes && \
    Rscript -e 'remotes::install_github("rstudio/bslib");remotes::install_github("johnbaums/hues")' && \
    rm -rf /tmp/downloaded_packages \
    rm -rf /srv/shiny-server/*

COPY . /srv/shiny-server/
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
USER shiny
EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
# ENTRYPOINT ["R", "-e", "shiny::runApp('/srv/shiny-server/app/', host = '0.0.0.0', port = 3838)"]
