#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

SRC='/usr/manifests/production'
DEST='/etc/puppetlabs/code/environments/production'
PUPPET='/opt/puppetlabs/bin/puppet'
REPO=''
SUBJECT='Integration to Puppet Master'
RECEIVER='receiver@fqdn'
SERVER_PORT='smtp.server.com:587'
SENDER='sender@fqdn'
USER='mail@fqdn'
PASSWORD=''

[[ ! -d ${DEST} ]] && mkdir ${DEST}

function overwriterepo {
  while true; do
    echo "Do you want to overwrite puppetmaster repository?"
    echo "THIS WILL DESTROY OLD RECIPES! (N/y)"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) cp -Rpfv ${SRC}/. ${DEST}/. \
              && chown -R puppet:puppet ${DEST} \
              && echo "applying puppet recipes" \
              && ${PUPPET} apply ${DEST}/manifests/site.pp --debug \
              && sendemail
              exit 1
        ;;
        No ) exit 1
        ;;
        * ) echo "Please, answer Y or N"
        ;;
      esac
    done
  done
}

function pullrepo {
   (cd ${SRC} && git status)
   git pull --git-dir=${SRC}/.git --work-dir=${SRC}
   GIT_DIR=${SRC}/.git GIT_WORK_TREE=${SRC} git status
}

function sendemail {
  swaks --to $RECEIVER --from $SENDER --server $SERVER_PORT --auth LOGIN --auth-user  $USER --auth-password $PASSWORD -tls --data "Date: %DATE%\nTo: %TO_ADDRESS%\nFrom:  %FROM_ADDRESS%\nSubject: $SUBJECT %DATE%\nX-Mailer: %NEW_HEADERS%\n ${dif} \n"$
}

function start {
  dif=$(colordiff -ENwbur ${DEST} ${SRC})
  echo ''
  echo 'These will be the changes on puppetmaster:'
  if [[ ${dif} != '' ]]; then
    echo "${dif}"
    echo "Simulate (--noop)?"
    select yn in "Yes" "No"; do
      case $yn in
        Yes ) ${PUPPET} apply --noop ${SRC}/manifests/site.pp \
              --modulepath=${SRC}/modules --debug --noop;\
              [[ $? == 0 ]] && overwriterepo
        ;;
        No ) overwriterepo
        ;;
      esac
    done
  else
    echo "Nothing changes in repository. Exit"
  fi
}
pullrepo && start
exit 0
