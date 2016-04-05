class puppetmaster::params {

  $app_name='puppetmaster_unicorn'
  $app_root='/usr/share/puppet/ext/rack'
  $app_socket="$app_root/tmp/$app_name.socket"
  $pid_file="$app_root/tmp/$app_name.pid"
  $puppetmaster_packages=['puppetmaster','git']

}