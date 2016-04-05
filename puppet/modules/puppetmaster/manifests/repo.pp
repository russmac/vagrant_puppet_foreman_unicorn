define puppetmaster::repo(
  $puppet_envs,
  $branch=$name,
  $specific_tag=false,
  $remote=$puppet_envs[$name][remote]
) {

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
    content => $puppet_envs[$name][key],
    mode    => 600,
  } ->
  exec{"ssh-keyscan $remote > /var/lib/puppet/.ssh/known_hosts":
    user    => puppet,
    creates => '/var/lib/puppet/.ssh/known_hosts'
  } ->
  file{"/etc/puppet/environments":
    ensure => directory,
    owner  => puppet,
    group  => puppet,
    mode   => 2755,
  } ->
  exec{'rm -rf /etc/puppet/environments/production':
    unless => 'test -d /etc/puppet/environments/production/.git'
  } ->
  vcsrepo{"/etc/puppet/environments/$name":
    user      => puppet,
    provider  => git,
    source    => $puppet_envs[$name][repo],
    revision  => $branch,
  }

  if $specific_tag == false {
    cron { "$branch git pull":
      command => "cd /etc/puppet/environments/$branch && git reset HEAD --hard && git fetch && git pull",
      user    => puppet,
      minute  => '*/1'
    }
  } else {
    cron { "$branch checkout $specific_tag":
      command => "cd /etc/puppet/environments/$branch && git reset HEAD --hard && git fetch && git checkout $specific_tag",
      user    => puppet,
      minute  => '*/1'
    }
  }

}