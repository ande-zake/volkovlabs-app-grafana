FROM grafana/grafana:9.5.1

##################################################################
## CONFIGURATION
##################################################################

## Set Grafana options
ENV GF_ENABLE_GZIP=true
ENV GF_USERS_DEFAULT_THEME=light

## Enable Anonymous Authentication
ENV GF_AUTH_ANONYMOUS_ENABLED=true
ENV GF_AUTH_BASIC_ENABLED=false

## Disable Sanitize
ENV GF_PANELS_DISABLE_SANITIZE_HTML=true

## Disable Explore
ENV GF_EXPLORE_ENABLED=false

## Set Home Dashboard
ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/news.json

## Paths
ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"
ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"

##################################################################
## COPY ARTIFACTS
## Required for the Application plugin
##################################################################

COPY --chown=grafana:root dist /app
COPY entrypoint.sh /

## Copy Provisioning
COPY --chown=grafana:root provisioning $GF_PATHS_PROVISIONING

##################################################################
## Customization depends on the Grafana version
## May work or not work for the version different from the current
## Check GitHub file history for the previous Grafana versions
##################################################################
USER root

##################################################################
## VISUAL
##################################################################

## Replace Favicon
COPY img/fav32.png /usr/share/grafana/public/img

## Replace Logo
COPY src/img/logo.svg /usr/share/grafana/public/img/grafana_icon.svg

## Update Background
COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
COPY img/background.svg /usr/share/grafana/public/img/g8_login_light.svg

##################################################################
## HANDS-ON
##################################################################

# Update Title
RUN sed -i 's|<title>\[\[.AppTitle\]\]</title>|<title>Volkov Labs</title>|g' /usr/share/grafana/public/views/index.html

# Disable Connections
RUN sed -i 's|# feature2 = false|dataConnectionsConsole = false|g' /usr/share/grafana/conf/defaults.ini

## Update Help menu
RUN sed -i "s|\[\[.NavTree\]\],|nav,|g; \
    s|window.grafanaBootData = {| \
    let nav = [[.NavTree]]; \
    nav[nav.length -1]['subTitle'] = 'Application'; \
    window.grafanaBootData = {|g" \
    /usr/share/grafana/public/views/index.html

## Update Title
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|AppTitle="Grafana"|AppTitle="Volkov Labs"|g' {} \;

## Update Login Title
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|LoginTitle="Welcome to Grafana"|LoginTitle="Welcome to Volkov Labs"|g' {} \;

## Remove Documentation, Support, Community in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|\[{target:"_blank",id:"documentation".*grafana_footer"}\]|\[\]|g' {} \;

## Remove Edition in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|({target:"_blank",id:"license",.*licenseUrl})|()|g' {} \;

## Remove Version in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|({target:"_blank",id:"version",.*CHANGELOG.md":void 0})|()|g' {} \;

## Remove New Version is available in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|({target:"_blank",id:"updateVersion",.*grafana_footer"})|()|g' {} \;

##################################################################
## CLEANING Remove Native Data Sources
##################################################################

## Time series databases / Elasticsearch
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/elasticsearch
RUN rm -rf /usr/share/grafana/public/build/elasticsearch*

## Time series databases / Graphite
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/graphite
RUN rm -rf /usr/share/grafana/public/build/graphite*

## Time series databases / OpenTSDB
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/opentsdb
RUN rm -rf /usr/share/grafana/public/build/opentsdb*

## Time series databases / InfluxDB
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/influxdb
RUN rm -rf /usr/share/grafana/public/build/influxdb*

## SQL / Microsoft SQL Server
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/mssql
RUN rm -rf /usr/share/grafana/public/build/mssql*

## SQL / MySQL
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/mysql
RUN rm -rf /usr/share/grafana/public/build/mysql*

## Distributed tracing / Tempo
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/tempo
RUN rm -rf /usr/share/grafana/public/build/tempo*

## Distributed tracing / Jaeger
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/jaeger
RUN rm -rf /usr/share/grafana/public/build/jaeger*

## Distributed tracing / Zipkin
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/zipkin
RUN rm -rf /usr/share/grafana/public/build/zipkin*

## Cloud / Azure Monitor
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/azuremonitor
RUN rm -rf /usr/share/grafana/public/build/azureMonitor*

## Cloud / CloudWatch
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/cloudwatch
RUN rm -rf /usr/share/grafana/public/build/cloudwatch*

## Cloud / Google Cloud Monitoring
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/cloud-monitoring
RUN rm -rf /usr/share/grafana/public/build/cloudMonitoring*

## Profiling / Parca
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/parca
RUN rm -rf /usr/share/grafana/public/build/parca*

## Profiling / Phlare
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/phlare
RUN rm -rf /usr/share/grafana/public/build/phlare*

## Others / Alertmanager
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/alertmanager
RUN rm -rf /usr/share/grafana/public/build/alertmanager*

## Others / TestData
RUN rm -rf /usr/share/grafana/public/app/plugins/datasource/testdata
RUN rm -rf /usr/share/grafana/public/build/testData*

## Remove Cloud and Enterprise categories
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|t.id==="enterprise"|t.id==="notanenterprise"|g' {} \;
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|t.id==="cloud"|t.id==="notacloud"|g' {} \;

##################################################################
## CLEANING Remove Native Panels
##################################################################

## Alert list
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/alertlist

## Annotations list
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/annolist

## Dashboard list
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/dashlist

## News
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/news

## Geomap
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/geomap

## Table (old)
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/table-old

## Traces
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/traces

## Candlestick
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/candlestick

## Node Graph
RUN rm -rf /usr/share/grafana/public/app/plugins/panel/nodeGraph

##################################################################

USER grafana

## Entrypoint
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
