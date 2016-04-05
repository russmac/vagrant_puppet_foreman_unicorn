class puppetmaster(
    $worker_processes=hiera('puppetmaster::worker_processes'),
    $backlog=hiera('puppetmaster::backlog'),
    $timeout=hiera('puppetmaster::timeout'),
    $puppet_envs=hiera('puppetmaster::puppet_envs'),
  ) inherits puppetmaster::params {
    require apt
    require unicorn

    class{'puppetmaster::server':
      app_root              => $app_root,
      app_socket            => $app_socket,
      puppet_envs           => $puppet_envs,
      puppetmaster_packages => $puppetmaster_packages,
    }

    unicorn::generate{  $app_name:
      user              => puppet,
      app_root          => $app_root,
      app_socket        => $app_socket,
      pid_file          => $pid_file,
      worker_processes  => $worker_processes,
      backlog           => $backlog,
      timeout           => $timeout,
      require           => Class['puppetmaster::server']
    }

    exec{"PUP-5972 workaround $app_name":
      command  => "systemctl enable $app_name",
      unless   => "test -f /etc/rc3.d/S01$app_name",
      require  => [Class['puppetmaster::server'],Unicorn::Generate[$app_name],Service['puppetmaster']],
    } ->
    service{$app_name:
      ensure   => running,
      enable   => true,
      require  => [Class['puppetmaster::server'],Unicorn::Generate[$app_name],Service['puppetmaster']]
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
    # We sleep 10 because of the startup delay , Master starts after this resource executes in system log.

}