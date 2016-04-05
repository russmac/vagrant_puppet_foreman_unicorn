class foreman::server(
  $app_root,
  $app_socket,
  $foreman_envs,
  $rails_env,
  $admin_password,
  $foreman_packages,
  $gem_packages,
){
  require foreman::apt

  package{$foreman_packages:
    ensure => present,
  } ->
  service{'foreman':
    ensure => stopped,
    enable => false
  }

  user{'foreman':
    groups => 'puppet'
  }

  package{$gem_packages:
    ensure   => present,
    provider => gem,
  }

  class{'foreman::server::config':
    app_root            => $app_root,
    app_socket          => $app_socket,
    foreman_envs        => $foreman_envs,
    require             => [Package['nginx'],Package[$foreman_packages],Package[$gem_packages]]
  }

  class { 'foreman::server::db':
    rails_env      => $rails_env,
    foreman_envs   => $foreman_envs,
    admin_password => $admin_password,
    require        => Package[$foreman_packages]
  }

}