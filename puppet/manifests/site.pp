Exec{
  path	=> [ '/usr/local/bin/','/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
  logoutput   => on_failure,
}

node default {

  include puppetmaster
  include foreman

}