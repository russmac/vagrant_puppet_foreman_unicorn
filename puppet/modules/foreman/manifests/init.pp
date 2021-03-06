class foreman(
  $worker_processes=hiera('foreman::worker_processes'),
  $backlog=hiera('foreman::backlog'),
  $timeout=hiera('foreman::timeout'),
  $user=hiera('foreman::user'),
  $postgresql_db_password=hiera('foreman::postgresql_db_password'),
  $foreman_envs=hiera('foreman::foreman_envs'),
  $rails_env=hiera('foreman::rails_env'),
  $admin_password=hiera('foreman::admin_password'),
) inherits foreman::params {
  require apt
  require unicorn

  class{'foreman::server':
    app_root            => $app_root,
    app_socket          => $app_socket,
    foreman_envs        => $foreman_envs,
    rails_env           => $rails_env,
    admin_password      => $admin_password,
    foreman_packages    => $foreman_packages,
    gem_packages        => $gem_packages,
  }

  class{'foreman::server::proxy':
    require => Class['foreman::server']
  }

  unicorn::generate{  $app_name:
    user              => $user,
    rails_env         => $rails_env,
    bundle            => true,
    app_root          => $app_root,
    worker_processes  => $worker_processes,
    backlog           => $backlog,
    timeout           => $timeout,
    require           => [Class['foreman::server'],Service['foreman']]
  }

  realize Package[nginx]

  realize Service[nginx]

}
