# vagrant_puppet_foreman
Update common.yaml settings then `vagrant up` to have a fully operational Puppetmaster/Foreman box tracking a remote repo for code changes and running as an agent against itself.

1.
Run install_dependencies.sh to use `puppet module install` to install the three require puppetlabs modules and their dependencies

2.
Configure hieradata/common.yaml to your settings

3.
Add a host record for your chosen vagrant IP/hostname
x.x.x.x host.example.com host

4.
Run `vagrant up`

Browse to https://host.example.com where the build run will be displayed in the dashboard

Puppet agent will continue to run the node against the checked out puppet code base which should include these classes.

If you wish to reassign the agent node (the masters agent) in site.pp the certname is <%= @hostname %>-agent

Foreman puppet smart-proxy enabled features:
 - puppet
 - puppetca
