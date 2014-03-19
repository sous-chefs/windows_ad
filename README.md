windows_ad Cookbook
=================
This cookbook installs Active Directory Domain Services on Windows 2012 including all necessary roles and features.

Requirements
============

Platform
--------

* Windows Server 2008 R2 (features only)
* Windows Server 2012 Family

Cookbooks
---------

- Windows - Official windows cookbook from opscode https://github.com/opscode-cookbooks/windows.git

Usage
==========
#### windows_ad::default
The windows_ad::default recipe installs the required roles and features to support a domain controller. 

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[windows_ad]"
  ]
}
```

Resource/Provider
=================

`domain`
--------

### Actions
- :create: Installs a forest, domain, or domain controller
- :delete: Removes a domain controller from domain
- :join: Joins computer to domain
- :unjoin: Removes computer from domain

### Attribute Parameters

- name: name attribute.  Name of the forest/domain to operate against.
- type: type of install. Valid values: forest, domain, read-only.
- safe_mode_pass: safe mode administrative password.
- domain_user: User account to join the domain.
- domain_pass: User password to join the domain.
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
    
    # Remove Domain Controller
    windows_ad_domain "contoso.com" do
      action :delete
      local_pass "Passw0rd"
    end
    
    # Join Contoso.com domain
    windows_ad_domain "contoso.com" do
      action :join
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end
    
    # Unjoin Contoso.com domain
    windows_ad_domain "contoso.com" do
      action :unjoin
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

`computer`
--------

### Actions
- :create: Adds computers to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the computer object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

    # Create computer "workstation1" in the Computers OU
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.com"
      ou "computers"
    end
    
    # Create computer "workstation1" in the Computers OU with description of "Computer"
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.com"
      ou "computers"
      options ({ "desc" => "computer" })
    end

`contact`
---------

### Actions
- :create: Adds computers to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the computer object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

    # Create contact "Bob Smith" in the Users OU with firstname "Bob" and lastname "Smith"
    windows_ad_contact "Bob Smith" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "fn" => "Bob", 
                 "ln" => "Smith"
               })
    end
    
`group`
-------

### Actions
- :create: Adds groups to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the group object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

    # Create group "IT" in the Users OU
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.com"
      ou "users"
    end
    
    # Create group "IT" in the Users OU with Description "Information Technology Security Group"
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "desc" => "Information Technology Security Group"
               })
    end
    
`ou`
----

### Actions
- :create: Adds organizational units to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the Organization Unit object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

    # Create Organizational Unit "Departments" in the root
    windows_ad_ou "Departments" do
      action :create
      domain_name "contoso.com"
    end
    
    # Create Organizational Unit "IT" in the "Department" OUroot
    windows_ad_ou "IT" do
      action :create
      domain_name "contoso.com"
      ou "Departments"
    end
    
`users`
-------

### Actions
- :create: Adds users to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the user object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options
- reverse: allows the reversing of "First Name Last Name" to "Last Name, First Name"

### Examples

    # Create user "Joe Smith" in the Users OU
    windows_ad_user "Joe Smith" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "samid" => "JSmith",
             "upn" => "JSmith@contoso.com",
             "fn" => "Joe",
             "ln" => "Smith",
             "display" => "Smith, Joe",
             "disabled" => "no",
             "pwd" => "Passw0rd"
           })
    end
    

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
