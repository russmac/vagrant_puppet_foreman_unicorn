#!/bin/bash
which puppet
if [ $? -ne 0 ];then
echo "This script requires a 3.x puppet-common package"
exit 1
fi
puppet module --modulepath puppet/modules install puppetlabs-apt
puppet module --modulepath puppet/modules install puppetlabs-postgresql
puppet module --modulepath puppet/modules install puppetlabs-vcsrepo
puppet module --modulepath puppet/modules install russmac-unicorn
