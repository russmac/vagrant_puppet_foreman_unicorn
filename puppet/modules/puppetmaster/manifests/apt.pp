class puppetmaster::apt (
){

  apt::source { 'puppetlabs':
    location    => 'http://apt.puppetlabs.com ',
    release     => 'trusty',
    repos       => 'main dependencies',
    key         => {
                      id => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
                      server => 'keyserver.ubuntu.com', },
      include => {
                      src => false, },
  } ->
  exec{'apt-get update puppetmaster':
    command     => 'apt-get update',
    logoutput   => on_failure,
    refreshonly => true,
  }


}
