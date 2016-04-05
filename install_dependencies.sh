#!/bin/bash
which puppet
if [ $? -ne 0 ];then
echo "This script require a 3.x puppet-common"
exit 1
fi
puppet module --modulepath puppet/modules install puppetlabs-apt
puppet module --modulepath puppet/modules install puppetlabs-postgresql
puppet module --modulepath puppet/modules install puppetlabs-vcsrepo
git clone https://github.com/russmac/russmac-unicorn puppet/modules/unicorn
