class foreman::apt {

  apt::source { 'theforeman-repository':
    location    => 'http://deb.theforeman.org/',
    release     => 'jessie',
    repos       => '1.10',
    key         => {
                      id => '7059542D5AEA367F78732D02B3484CB71AA043B8',
                  server => 'keyserver.ubuntu.com', },
    include => {
                  src => false, },
  } ~>
  exec{'apt-get update foreman':
    command     => 'apt-get update',
    logoutput   => on_failure,
    refreshonly => true,
  }

}
