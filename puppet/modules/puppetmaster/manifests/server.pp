class puppetmaster::server(
  $app_root,
  $app_socket,
  $puppet_envs,
  $puppet_envs_key,
  $puppetmaster_packages,
  $remote,
) {
 require puppetmaster::apt

  user{'puppet':
    ensure => present,
  }

  host{$::fqdn:
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

  class{"puppetmaster::repo":
    puppet_envs     => $puppet_envs,
    puppet_envs_key => $puppet_envs_key,
    remote          => $remote
  }

}

