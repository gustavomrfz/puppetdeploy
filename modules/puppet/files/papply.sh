#!/bin/bash

SITE='/etc/puppetlabs/code/environments/production'
MODULES='/etc/puppetlabs/code/environments/production/modules'
PUPPET='/opt/puppetlabs/bin/puppet'

sudo ${PUPPET} apply ${SITE} --modulepath=${MODULES} $*
