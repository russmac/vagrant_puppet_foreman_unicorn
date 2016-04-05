define foreman::server::db::generate(
  $foreman_envs
) {

  postgresql::server::role { "${foreman_envs[$name][db_user]}":
    password_hash => postgresql_password("${foreman_envs[$name][db_user]}", "${foreman_envs[$name][db_password]}"),
    superuser => true,
  } ->
  postgresql::server::database { "${foreman_envs[$name][db_name]}":
    owner    => "${foreman_envs[$name][db_user]}",
  } ->
  postgresql::server::database_grant { "grant_foreman_$name":
    privilege => 'ALL',
    db        => "${foreman_envs[$name][db_name]}",
    role      => "${foreman_envs[$name][db_user]}",
  }

  postgresql::server::pg_hba_rule { "foreman_$name":
    description => "foreman $name access",
    type        => 'host',
    database    => "${foreman_envs[$name][db_name]}",
    user        => "${foreman_envs[$name][db_user]}",
    address     => '127.0.0.1/32',
    auth_method => 'md5',
  }

}