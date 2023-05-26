FROM htcondor/mini:latest

RUN yum -y update

# Required for python3-scitokens
RUN yum -y install https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el8-release-latest.rpm

RUN yum -y install condor-credmon-oauth

COPY config.d /etc/condor/config.d
COPY test-jobs /opt/test-jobs
