class puppetmaster(
    $worker_processes=hiera('puppetmaster::worker_processes'),
    $backlog=hiera('puppetmaster::backlog'),
    $timeout=hiera('puppetmaster::timeout'),
    $puppet_envs=hiera('puppetmaster::puppet_envs'),
    $puppet_envs_key=hiera('puppetmaster::puppet_envs::key'),
    $remote=hiera('puppetmaster::puppet_envs::remote'),
  ) inherits puppetmaster::params {
    require apt
    require unicorn

    class{'puppetmaster::server':
      app_root              => $app_root,
      app_socket            => $app_socket,
      puppet_envs           => $puppet_envs,
      puppet_envs_key       => $puppet_envs_key,
      puppetmaster_packages => $puppetmaster_packages,
      remote                => $remote
    }

    unicorn::generate{  $app_name:
      user              => puppet,
      app_root          => $app_root,
      worker_processes  => $worker_processes,
      backlog           => $backlog,
      timeout           => $timeout,
      require           => [Service['puppetmaster']]
    }

    @package{'nginx':
      ensure => present,
    }
    realize Package[nginx]

    @service{'nginx':
      enable  => true,
      ensure  => running,
      require => Service[$app_name]
    }

    realize Service[nginx]

    file{'/etc/default/puppet':
      content => "START=yes"
    } ~>
    exec{'puppet agent --enable':
      refreshonly => true,
    } ~>
    service{'puppet':
      enable  => true,
      ensure  => running,
      require => Service['nginx']
    } ~>
    exec{"sleep 60; puppet cert sign ${::hostname}-agent":
      refreshonly => true,
      require     => [Service['puppet'],Service['nginx']]
    }
    # We sleep 60 because of the startup delay , Master starts after this resource executes in system log.

}