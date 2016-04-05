class foreman::server::db(
  $foreman_envs,
  $rails_env,
  $admin_password,
){

  class { 'postgresql::server':
    listen_addresses           => 'localhost',
    # This creates a changed resource every run due to salt
    #postgres_password          => postgresql_password('postgres', "$postgresql_db_password"),
    postgres_password          => "$postgresql_db_password",
  }

  $foreman_env_keys=keys($foreman_envs)

  foreman::server::db::generate{$foreman_env_keys:
    foreman_envs => $foreman_envs,
  } ->
  file{'/etc/foreman/database.yml':
    content => template('foreman/etc/foreman/database.yml.erb'),
  } ~>
  exec{'bundle exec rake db:migrate':
    user        => foreman,
    cwd         => '/usr/share/foreman',
    refreshonly => true,
    environment => ["RAILS_ENV=$rails_env"],
  } ~>
  exec{'bundle exec rake db:seed':
    user        => foreman,
    cwd         => '/usr/share/foreman',
    refreshonly => true,
    environment => ["RAILS_ENV=$rails_env"],
  } ~>
  exec{'bundle exec rake apipie:cache':
    user        => foreman,
    cwd         => '/usr/share/foreman',
    refreshonly => true,
    environment => ["RAILS_ENV=$rails_env"],
  } ~>
  exec{"bundle exec rake permissions:reset password=$admin_password":
    user        => foreman,
    cwd         => '/usr/share/foreman',
    refreshonly => true,
    environment => ["RAILS_ENV=$rails_env"],
    notify      => Service['foreman_unicorn'],
  }

}