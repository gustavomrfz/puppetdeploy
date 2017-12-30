# Puppet Deploy Scripts

## For What
Deploy Puppet manifests for Puppet Master itself from remote.
This is for concept.

Any operator launchs a remote script that simulates application of last commit of puppet manifests at master branch, changes manifests in production, shows diffs at screen and reports them via email.

## Steps

* Clone repository in somewhere like */usr/manifests/*
* Define your own variables in the following files:
  * puppet-deploy.sh
  * papply.sh
  * site.pp

Execute puppet-deploy.sh at server or copy it by hand to /usr/local/bin/puppet-deploy file

## And then
Any operator who has a pulled repositoy with Puppet manifests should have commit-to-puppet.sh file at root path of the repository. When operator commit changes, this script push them to git and send via ssh a command to execute puppet-deploy into master.

Gustavo Moreno
