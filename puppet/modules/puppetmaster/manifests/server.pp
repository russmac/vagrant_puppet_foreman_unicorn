class puppetmaster::server(
  $app_root,
  $app_socket,
  $puppet_envs,
  $puppetmaster_packages
) {
 require puppetmaster::apt

  host{'pm0.graphenic.com.au':
    ensure => present,
    ip     => '127.0.1.1',
  }

  package{$puppetmaster_packages:
    ensure => present,
  } ->
  service{ 'puppetmaster':
    ensure   => stopped,
    enable   => false,
  }

  class{ 'puppetmaster::server::config':
    app_root   => $app_root,
    app_socket => $app_socket,
    require => Package['puppetmaster'],
  }

  $puppet_envs_keys=keys($puppet_envs)

  puppetmaster::repo{ $puppet_envs_keys:
    puppet_envs => $puppet_envs,
  }

}

