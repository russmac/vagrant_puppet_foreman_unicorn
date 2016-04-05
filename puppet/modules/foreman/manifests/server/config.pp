class foreman::server::config(
 $app_root,
 $app_socket,
 $foreman_envs,
 ) {
  require foreman::apt

  file{'/etc/puppet/foreman.yaml':
    owner   => foreman,
    content => template('foreman/etc/puppet/foreman.yaml.erb'),
  }

  # Node classifier
  file{'/etc/puppet/node.rb':
    owner => puppet,
    group => puppet,
    source => 'puppet:///modules/foreman/etc/puppet/node.rb',
  }

  # Report handler
  file{'/usr/lib/ruby/vendor_ruby/puppet/reports/foreman.rb':
    source => 'puppet:///modules/foreman/usr/lib/ruby/vendor_ruby/puppet/reports/foreman.rb',
  }

  file_line { 'Allow localhost API access to foreman':
    path => '/etc/foreman/settings.yaml',
    line => ":trusted_puppetmaster_hosts: ['localhost','${::fqdn}']",
    match => ":trusted_puppetmaster_hosts:"
  }

  file_line { 'Set foreman URL for proxypass':
    path => '/etc/foreman/settings.yaml',
    line => ":foreman_url: 'https://${::fqdn}'",
    match => ":foreman_url:"
  }

  file_line { 'Set foreman fqdn':
    path => '/etc/foreman/settings.yaml',
    line => ":fqdn: '${::fqdn}'",
    match => ":fqdn:"
  }

  file_line { 'Set foreman domain':
    path => '/etc/foreman/settings.yaml',
    line => ":domain: '${::domain}'",
    match => ":domain:"
  }

  file{'/etc/nginx/sites-available/foreman.conf':
    ensure => present,
    content => template('foreman/etc/nginx/sites-available/foreman.conf.erb'),
    notify  => Service['nginx'],
  }

  file{'/etc/nginx/sites-enabled/foreman.conf':
    ensure => link,
    target => '/etc/nginx/sites-available/foreman.conf',
    notify  => Service['nginx'],
  }


}