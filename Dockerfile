ARG IMAGE=store/intersystems/iris-community:2020.1.0.204.0
ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.2.0.204.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.3.0.200.0-zpm
ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
FROM $IMAGE

USER root

WORKDIR /opt/feeder
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/feeder

USER irisowner

COPY  Installer.cls .
COPY  src src
COPY csp /usr/irissys/csp/feeder
COPY iris.script /tmp/iris.script
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /usr/irissys/csp/feeder

# run iris and initial 
RUN iris start IRIS \
    && iris session IRIS -U %SYS < /tmp/iris.script \
    && iris stop IRIS quietly
