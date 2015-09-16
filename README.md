windows_ad Cookbook
=================
This cookbook installs Active Directory Domain Services on Windows Server 2012 including all necessary roles and features.

Requirements
============

Platform
--------

* Windows Server 2008 R2
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
- :join: Joins computer to domain and restarts the machine.
- :unjoin: Removes computer from domain and restarts the machine.

### Attribute Parameters

- name: name attribute.  Name of the forest/domain to operate against.
- type: type of install. Valid values: forest, domain, read-only.
- safe_mode_pass: safe mode administrative password.
- domain_user: User account to join the domain or to create a domain controller. **Required**: for `:create` except on `type` `forest` on windows 2012 and above.
- domain_pass: User password to join the domain or to create a domain controller. **Required**: for `:create` except on `type` `forest` on windows 2012 and above.
- local_pass: Local Administrator Password for removing domain controller.
- replica_type: For Windows Server 2008, specifies installing new or additional domain controller.  Valid values: domain, replica.
- ou: When joining to a domain, specify the OU to place the computer in. *Optional*
- options: additional options as needed by AD DS Deployment http://technet.microsoft.com/en-us/library/cc732887.aspx for Windows Server 2008 and http://technet.microsoft.com/en-us/library/hh974719.aspx for Windows Server 2012.  Single parameters use nil for key value, see example below.

### Examples

    # Create Contoso.com forest
    windows_ad_domain "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
    end

    # Create Contoso.com replica
    windows_ad_domain "contoso.com" do
      action :create
      type "replica"
      safe_mode_pass "Passw0rd"
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

    # Create Contoso.com forest with DNS, Win2008 R2 Operational Mode Windows Server 2008 R2
    windows_ad_domain "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
      options ({ "domainlevel" => "4",
                 "forestlevel" => "4",
                 "InstallDNS" => "yes"
               })
    end

    # Create Contoso.com forest with DNS, Win2008 Operational Mode Windows Server 2012
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

    # Join Contoso.com domain without restart
    windows_ad_domain "contoso.com" do
      action :join
      domain_pass "Passw0rd"
      domain_user "Administrator"
      restart false
    end

    # Join Contoso.com domain with OU
    windows_ad_domain "contoso.com" do
      action :join
      domain_pass "Passw0rd"
      domain_user "Administrator"
      ou "Servers/Web"
    end

    # Unjoin Contoso.com domain
    windows_ad_domain "contoso.com" do
      action :unjoin
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

    # Unjoin Contoso.com domain without restart
    windows_ad_domain "contoso.com" do
      action :unjoin
      domain_pass "Passw0rd"
      domain_user "Administrator"
      restart false
    end

`computer`
--------

### Actions
- :create: Adds a computer object to Active Directory
- :modify: Modifies an existing computer object.
- :move:  Rename a computer object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove a computer object from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the computer object.
- domain_name: FQDN
- ou: Organization Unit path where object is to be located.
- options: ability to pass additional options http://technet.microsoft.com/en-us/library/cc754539.aspx
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)


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

    # Create computer "workstation1" in the Computers OU using domain admin account
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.com"
      ou "computers"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end

`contact`
---------

### Actions
- :create: Adds a contact object to Active Directory
- :modify: Modifies an existing contact object.
- :move:  Rename a contact object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove a contact object from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the contact object.
- domain_name: FQDN
- ou: Organization Unit path where object is to be located.
- options: ability to pass additional options http://technet.microsoft.com/en-us/library/cc771883.aspx
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)


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

    # Create contact "Bob Smith" in the Users OU with firstname "Bob" and lastname "Smith"
    # using domain admin account
    windows_ad_contact "Bob Smith" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "fn" => "Bob",
                 "ln" => "Smith"
               })
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end

`group`
-------

### Actions
- :create: Adds a group object to Active Directory
- :modify: Modifies a group object.
- :move:  Rename a group object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove a group object from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the group object.
- domain_name: FQDN
- ou: Organization Unit path where object is to be located.
- options: ability to pass additional options http://technet.microsoft.com/en-us/library/cc754037.aspx
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)


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

    # Create group "IT" in the Users OU using domain admin account
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.com"
      ou "users"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end

`ou`
----

### Actions
- :create: Adds organizational units to Active Directory.
- :modify: Modifies an organizational unit.
- :move:  Rename an organizational unit object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove an organizational unit object from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the Organization Unit object.
- domain_name: FQDN
- ou: Organization Unit path where object is to be located.
- options: ability to pass additional options http://technet.microsoft.com/en-us/library/cc770883.aspx
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)


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

    # Create Organizational Unit "Departments" in the root using domain admin account
    windows_ad_ou "Departments" do
      action :create
      domain_name "contoso.com"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end

`users`
-------

### Actions
- :create: Adds a user object to Active Directory.
- :modify: Modifies an user object.
- :move:  Rename an user object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove an user object from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the user object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options http://technet.microsoft.com/en-us/library/cc731279.aspx
- reverse: allows the reversing of "First Name Last Name" to "Last Name, First Name"
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

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

    # Create user "Joe Smith" in the Users OU using domain admin account
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
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end

`group_member`
-------

### Actions
- :add: Adds a user to a group.
- :remove: Removes a user from a group.

### Attribute Parameters

- user_name: user name attribute. Name of the user object.
- group_name: group name attribute. Name of the group object.
- domain_name: FQDN.
- user_ou: Organization Unit path where user object is located.
- group_ou: Organization Unit path where group object is located.
- cmd_user: user under which the interaction with AD should happen
- cmd_pass: password for user specified in cmd_user (only needed if user requires password)
- cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

### Examples

    # Add user "Joe Smith" in the Users OU to group "Admins" in OU "AD/Groups"
    windows_ad_group_member 'Joe Smith' do
      action :add
      group_name  'Admins'
      domain_name 'contoso.com'
      user_ou 'users'
      grou_ou 'AD/Groups'
    end

    # Add user "Joe Smith" in the Users OU to group "Admins" in OU "AD/Groups" using domain admin account
    windows_ad_group_member 'Joe Smith' do
      action :add
      group_name  'Admins'
      domain_name 'contoso.com'
      user_ou 'users'
      group_ou 'AD/Groups'
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.com"
    end


Testing
=======

## RSpec

The libraries provided with the cookbook can be tested using RSpec and the tests in `spec/`.
```bash
rspec spec/
```

## Vagrant

The cookbook contains a Vagrantfile that can be used to spin up two VMs: (1) a domain controller; (2) a domain member.
There is also a test cookbook with two recipes that map to the two VMs. This cookbook is called `test_windows_ad` and can be found under `test/fixtures/test_cookbooks`

Each recipe will make use of a few of the providers that the cookbook exposes to converge the VMs into the desired state.
As of now there is no additional testing being done, i.e., if both machines converge successfully, then the current test has passed.

### Requirements
* Vagrant
* A windows vagrant box (that is prepared to regenerate SUID on first boot)
* Vagrant plugins
  * vagrant-chef-zero
  * vagrant-omnibus
  * vagrant-winrm
* Berkshelf

### Usage

The vagrant box mentioned in the commands bellow is just meant as an example. It was obtained from https://vagrantcloud.com
The virtualbox vagrant provider is also meant as an example, although changing that will require adaptations to the Vagrantfile as well. That is because the Vagrantfile contains configuration specific for that provider.

#### Linux & MacOS X

```bash
# Install a vagrant box (only need to do that once)
vagrant box add kensykora/windows_2012_r2_standard

# export variable that will be used in Vagrantfile
export VAGRANT_TEST_BOX='kensykora/windows_2012_r2_standard'

# Bundle required cookbooks (this step needs to be repeated eveytime the cookbooks or a dependency changes)
berks install
berks vendor test/fixtures/cookbooks 

# Spin up domain controller
vagrant up test-dc           # this will trigger a VM reboot
vagrant provision test-dc    # this will run chef-client one more time to converge the VM

# Spin up domain member
vagrant up test-dm
```

#### Windows

TBD

### Other vagrant actions

List available VMs
```bash
vagrant status
```

Converge an already up (and possible converged VM)
```bash
vagrant provision <vm-name>
```

Destroy a VM
```bash
vagrant destroy <vm-name>
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
          Richard Guin
          Miroslav Kyurchev (<mkyurchev@gmail.com>)
		  Matt Wrock (<matt@mattwrock.com>)
		  Miguel Ferreira (<miguelferreira@me.com>)
