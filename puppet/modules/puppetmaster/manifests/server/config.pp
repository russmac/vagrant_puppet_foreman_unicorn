class puppetmaster::server::config(
  $app_root,
  $app_socket,
){

  file{ '/usr/share/puppet/ext/rack/tmp':
    ensure => directory,
    owner  => puppet,
    group  => puppet,
  }

  file{ '/etc/puppet/puppet.conf':
    ensure  => file,
    owner  => puppet,
    group  => puppet,
    content => template('puppetmaster/etc/puppet/puppet.conf.erb')
  }

  file{ '/etc/puppet/autosign.conf':
    ensure  => file,
    owner  => puppet,
    group  => puppet,
    content => template('puppetmaster/etc/puppet/autosign.conf.erb')
  }

  file{'/etc/nginx/sites-available/puppetmaster.conf':
    ensure  => present,
    content => template('puppetmaster/etc/nginx/sites-available/puppetmaster.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx']
  } ->
  file{'/etc/nginx/sites-enabled/puppetmaster.conf':
    ensure => link,
    target => '/etc/nginx/sites-available/puppetmaster.conf',
    notify  => Service['nginx'],
    require => Package['nginx']
  }

}