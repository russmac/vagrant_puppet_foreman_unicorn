class foreman::server::proxy(

) {

  file{'/etc/foreman-proxy/settings.yml':
    content => template('foreman/etc/foreman-proxy/settings.yml.erb'),
    notify => Service['foreman-proxy']
  }

  file{'/etc/foreman-proxy/settings.d/puppet.yml':
    content => template('foreman/etc/foreman-proxy/settings.d/puppet.yml.erb'),
    notify  => Service['foreman-proxy']
  }

  file{'/etc/foreman-proxy/settings.d/puppetca.yml':
    content => template('foreman/etc/foreman-proxy/settings.d/puppetca.yml.erb'),
    notify  => Service['foreman-proxy']
  }

  user{'foreman-proxy':
    groups => 'puppet'
  } ->
  exec{'create foreman-proxy ca signed cert':
    command => "puppet cert generate foreman-proxy.${::domain}",
    creates => "/var/lib/puppet/ssl/private_keys/foreman-proxy.${::domain}.pem",
    logoutput => true,
  } ->
  service{ 'foreman-proxy':
    enable => true,
    ensure => running,
    require => [File['/etc/foreman-proxy/settings.yml'],File['/etc/foreman-proxy/settings.d/puppet.yml']]
  }


}