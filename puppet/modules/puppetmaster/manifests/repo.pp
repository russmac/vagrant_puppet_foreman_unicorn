class puppetmaster::repo(
  $puppet_envs,
  $puppet_envs_key,
  $remote
) {

  package{['r10k']:
    provider => gem,
  }

  file{'/var/lib/puppet/.ssh':
    ensure => directory,
    owner  => puppet,
    group  => puppet,
    mode   => 600,
  } ->
  file{'/var/lib/puppet/.ssh/id_rsa':
    ensure => file,
    owner  => puppet,
    group  => puppet,
    content => $puppet_envs_key,
    mode    => 600,
  } ->
  exec{"ssh-keyscan ${remote} >> /var/lib/puppet/.ssh/known_hosts":
    user    => puppet,
    creates => '/var/lib/puppet/.ssh/known_hosts'
  } ->
  file{"/etc/puppet/environments":
    ensure => directory,
    owner  => puppet,
    group  => puppet,
    mode   => 2751,
  } ->
  file{["/etc/puppet/r10k","/etc/puppet/r10k/cache"]:
    ensure => directory,
    owner  => puppet,
    group  => puppet,
    mode   => 2751,
  } ->
  file{"/etc/r10k.yaml":
    ensure => file,
    owner  => puppet,
    group  => puppet,
    mode   => '0641',
    content => template('puppetmaster/etc/r10k.yaml.erb')
  } ~>
  exec{"Build environments with r10k":
    command     => '/usr/local/bin/r10k deploy environment -p',
    user        => puppet,
    #refreshonly => true,
  }

  cron { "Run r10k":
    command => "/usr/local/bin/r10k deploy environment -p",
    user    => puppet,
    minute  => '*/1'
  }

}