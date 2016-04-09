## Puppet 3.x & Foreman served efficiently by Nginx & Unicorn. 

Clones your repo and immediately serves the manifests on bootstrapping running against itself as an agent.

If you want to manage the master/foreman configuration make sure the repo you configure in common.yaml contains these modules (and the includes).

Your checked out repo is responsible for the first agent runs, use '<%= hostname %>-agent.<%= domain %>' foreman will produce vague errors if their is no node definition.

Foreman puppet smart-proxy enabled features:
 - puppetca

1. Run install_dependencies.sh to use `puppet module install` to install the three require puppetlabs modules and their dependencies

2. Configure hieradata/common.yaml to your settings

3. Add a host record for your chosen vagrant IP/hostname 
```
x.x.x.x host.example.com host
```

4. Run `vagrant up`

5. Browse to https://host.example.com where the build run will be displayed in the dashboard
Foreman can take some time to process reports correctly after bootstrapping, The agent will eventually re-run or you can 'vagrant ssh' and 'puppet agent -t' to force.
 
6. Add the PuppetCA smart proxy using your chosen hostname https://host.example.com/smart_proxies:8443


Puppet agent will continue to run the node against the checked out puppet code base which should include these classes.
If you wish to reassign the agent node (the masters agent) in site.pp the certname is <%= @hostname %>-agent
 

## Bugs
Foreman can behave differently on every vagrant up, Sometimes the dashboard requires one reload to run perfectly sometimes I have to force the puppet run sometimes I dont.
Spurious stack exceptions can be seen in the foreman log.

### Why
I wanted to custom craft something for my own use and at the same time understand Foreman better.
I was not aware of any other foreman installers which use unicorn.