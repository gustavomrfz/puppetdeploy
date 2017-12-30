#!/bin/bash

BRANCH=$(git symbolic-ref HEAD 2>/dev/null | awk  'BEGIN { FS="/"; } { print $3; }')
PUPPET='puppetmaster'
git push origin ${BRANCH} \
&& ssh puppetdeploy@${PUPPET} "sudo puppet-deploy"
