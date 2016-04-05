class foreman::params {

  $app_name='foreman_unicorn'
  $app_root='/usr/share/foreman'
  $foreman_packages=['foreman-postgresql',
    'foreman',
    'libpq-dev']
  $gem_packages= ['activerecord-postgresql-adapter',]
  $app_socket="$app_root/tmp/$app_name.socket"
  $pid_file="$app_root/tmp/$app_name.pid"

}