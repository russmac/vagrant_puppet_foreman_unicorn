## Puppet 3.x & Foreman served efficiently by Nginx & Unicorn. 

Clones your repo and immediately serves the manifests on bootstrapping running against itself as an agent.

If you want to manage the master/foreman configuration make sure the repo you configure in common.yaml contains these modules (and the includes).

Your checked out repo is responsible for the first agent runs, use '<%= hostname %>-agent.<%= domain %>' for your node definition foreman will produce vague errors if their is no node definition.

Foreman puppet smart-proxy enabled features:
 - puppetca

1. Use librarian-puppet install from the puppet/ directory 

2. Configure hieradata/common.yaml to your settings

3. Add a host record for your chosen vagrant IP/hostname 
```
x.x.x.x host.example.com host
```

4. Run `vagrant up`

5. Browse to https://host.example.com where the build run will be displayed in the dashboard
Foreman can take some time to process reports correctly after bootstrapping, The agent will eventually re-run or you can 'vagrant ssh' and 'puppet agent -t' to force.
Use chrome for the nontrusted ssl cert nginx serves.
 
6. Add the PuppetCA through the dashboard smart proxy using your chosen hostname in this format https://host.example.com:8443

## Bugs
* Accessing dashboard after bootstrapping sometimes shows an error page, Until reloading page once and never showing it again. Searching for stack exception produces no well known issues.
* Sometimes the first puppet run fails waiting for the agent to run again or vagrant ssh and forcing it resolves.
* Spurious stack exceptions can be seen in the foreman log with no visible effect on operation.

### Why
I wanted to custom craft something for my own use and at the same time understand Foreman better.
I was not aware of any other foreman installers which use unicorn.