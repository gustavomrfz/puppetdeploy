class puppet {
  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/puppet/papply.sh',
    mode => '0755',
  }
  file { '/usr/local/bin/puppet-deploy':
    source => 'puppet:///modules/puppet/puppet-deploy.sh',
    mode => '0755',
  }
}
