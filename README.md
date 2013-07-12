Windows_AD Cookbook
=================
This cookbook installs Active Directory Domain Services on Windows 2012 including all necessary roles and features.

Requirements
============

Platform
--------

* Windows Server 2012 Core
* Windows Server 2012 Standard
* Windows Server 2012 Enterprise

Cookbooks
---------

- Windows - Official windows cookbook from opscode

Attributes
==========

Resource/Provider
=================

`domain`
--------

### Actions
- :create: Installs a forest, domain, or domain controller
- :delete: Removes a domain controller from domain

### Attribute Parameters

- name: name attribute.  Name of the forest/domain to operate against.
- type: type of install. Valid values: forest, domain, child/replica, read-only/RO.
- safe_mode_pass: safe mode administrative password.
- force: ensures command executes when run through powershell.
- options: additional options as needed by AD DS Deployment Cmdlets http://technet.microsoft.com/en-us/library/hh974719.aspx.  Single parameters use nil for key value, see example below.


### Examples

    # Create Contoso.com forest
	windows_ad_domain "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
    end
	
	# Create Contoso.com forest with DNS, Win2008 Operational Mode
	windows_ad_domain "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
	  options ({ "ForestMode" => "Win2008",
	             "InstallDNS" => nil
			   })
    end
	
	# Create partners.contoso child domain
	windows_ad_domain "partners.contoso.com" do
      action :create
      type "domain"
      safe_mode_pass "Passw0rd"
    end
	
	# Remove Domain Controller
	windows_ad_domain "contoso.com" do
      action :delete
      local_pass "Passw0rd"
    end
	

Usage
=====
#### windows_ad::default
Just include `windows_ad` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[windows_ad]"
  ]
}
```

Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
===================

Authors:: Derek Groh (<dgroh@arch.tamu.edu>)
