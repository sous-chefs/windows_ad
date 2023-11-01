# windows_ad Cookbook

This cookbook installs Active Directory Domain Services on Windows Server including all necessary roles and features.

## Requirements

### Platform

* Windows Server 2012 Family
* Windows Server 2016 Family
* Windows Server 2019 Family

## Usage

This is a library style cookbook that provides a set of resources to install and configure Windows ADDS in a composable way. It is intended to be used in your own wrapper cookbook suited to your specific needs. You can see example usage in the recipes of the [windows_ad_test](https://github.com/TAMUarch/cookbook.windows_ad/blob/master/test/cookbooks/windows_ad_test/recipes/) cookbook that is included in this repo. These recipes are used as part of integration testing.

* add `depends 'windows_ad'` to the metadata.rb for your cookbook.
* use the provided resources in your cookbook

## Testing

For more details look at the [TESTING.md](./TESTING.md).

## Recipes

### windows_ad::default

The windows_ad::default recipe installs the required roles and features to support a domain controller.

## Resource/Provider

### `computer`

**NOTE** joining and unjoining computers from a domain has been removed from this cookbook, [windows_ad_join](https://docs.chef.io/resources/windows_ad_join/) should be used instead as it is part of Chef Infra Client 14.0.

#### Actions

* :create: Adds a computer object to Active Directory
* :delete: Remove a computer object from Active Directory.
* :modify: Modifies an existing computer object.
* :move: Rename a computer object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.

#### Property Parameters

* name: name property.  Name of the computer object.
* domain_name: FQDN
* domain_pass: domain password
* domain_user: domain user
* ou: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc754539.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)
* restart: allows preventing reboot after join or unjoin action. Default true to reboot.  **Required**

#### Examples

    ```rb
    # Create computer "workstation1" in the Computers OU
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.local"
      ou "computers"
    end

    # Create computer "workstation1" in the Computers OU with description of "Computer"
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.local"
      ou "computers"
      options ({ "desc" => "computer" })
    end

    # Create computer "workstation1" in the Computers OU using domain admin account
    windows_ad_computer "workstation1" do
      action :create
      domain_name "contoso.local"
      ou "computers"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

### `contact`

#### Actions

* :create: Adds a contact object to Active Directory
* :delete:  Remove a contact object from Active Directory.
* :modify: Modifies an existing contact object.
* :move:  Rename a contact object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.

#### Property Parameters

* name: name property.  Name of the contact object.
* domain_name: FQDN
* ou: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc771883.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

#### Examples

    ```rb
    # Create contact "Bob Smith" in the Users OU with firstname "Bob" and lastname "Smith"
    windows_ad_contact "Bob Smith" do
      action :create
      domain_name "contoso.local"
      ou "users"
      options ({ "fn" => "Bob",
                 "ln" => "Smith"
               })
    end

    # Create contact "Bob Smith" in the Users OU with firstname "Bob" and lastname "Smith"
    # using domain admin account
    windows_ad_contact "Bob Smith" do
      action :create
      domain_name "contoso.local"
      ou "users"
      options ({ "fn" => "Bob",
                 "ln" => "Smith"
               })
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

### `domain`

#### Actions

* :create: Installs a forest, domain, or domain controller
* :delete: Removes a domain controller from domain

#### Property Parameters

* name: name property.  Name of the forest/domain to operate against.
* type: type of install. Valid values: forest, domain, read-only.
* safe_mode_pass: safe mode administrative password.
* domain_user: User account to join the domain or to create a domain controller. **Required**: for `:create` except on `type` `forest` on windows 2012 and above.
* domain_pass: User password to join the domain or to create a domain controller. **Required**: for `:create` except on `type` `forest` on windows 2012 and above.
* local_pass: Local Administrator Password for removing domain controller.
* replica_type: For Windows Server 2008, specifies installing new or additional domain controller.  Valid values: domain, replica.
* restart: when creating domain, will prevent Windows from automatically restarting. If not specified, defaults to true (which queues the restart). Valid values: true, false.
* options: additional options as needed by AD DS Deployment <http://technet.microsoft.com/en-us/library/cc732887.aspx> for Windows Server 2008 and <http://technet.microsoft.com/en-us/library/hh974719.aspx> for Windows Server 2012.  Single parameters use nil for key value, see example below.

#### Examples

    ```rb
    # Create Contoso.com forest
    windows_ad_domain "contoso.local" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
    end

    # Create Contoso.com forest and don't restart Windows
    windows_ad_domain "contoso.local" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
      restart false
    end

    # Create Contoso.com replica
    windows_ad_domain "contoso.local" do
      action :create
      type "replica"
      safe_mode_pass "Passw0rd"
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

    # Create Contoso.com forest with DNS, Win2008 R2 Operational Mode Windows Server 2008 R2
    windows_ad_domain "contoso.local" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
      options ({ "domainlevel" => "4",
                 "forestlevel" => "4",
                 "InstallDNS" => "yes"
               })
    end

    # Create Contoso.com forest with DNS, Win2008 Operational Mode Windows Server 2012
    windows_ad_domain "contoso.local" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
      options ({ "ForestMode" => "Win2008",
                 "InstallDNS" => nil
               })
    end

    # Remove Domain Controller
    windows_ad_domain "contoso.local" do
      action :delete
      local_pass "Passw0rd"
    end
    ```

### `group`

#### Actions

* :create: Adds a group object to Active Directory
* :modify: Modifies a group object.
* :move:  Rename a group object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
* :delete:  Remove a group object from Active Directory.

#### Property Parameters

* name: name property.  Name of the group object.
* domain_name: FQDN
* ou: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc754037.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

#### Examples

    ```rb
    # Create group "IT" in the Users OU
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.local"
      ou "users"
    end

    # Create group "IT" in the Users OU with Description "Information Technology Security Group"
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.local"
      ou "users"
      options ({ "desc" => "Information Technology Security Group"
               })
    end

    # Create group "IT" in the Users OU using domain admin account
    windows_ad_group "IT" do
      action :create
      domain_name "contoso.local"
      ou "users"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

### `group_member`

#### Actions

* :add: Adds a user to a group.
* :remove: Removes a user from a group.

#### Property Parameters

* user_name: user name property. Name of the user object.
* group_name: group name property. Name of the group object.
* domain_name: FQDN.
* user_ou: Organization Unit path where user object is located.
* group_ou: Organization Unit path where group object is located.
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

#### Examples

    ```rb
    # Add user "Joe Smith" in the Users OU to group "Admins" in OU "AD/Groups"
    windows_ad_group_member 'Joe Smith' do
      action :add
      group_name  'Admins'
      domain_name 'contoso.local'
      user_ou 'users'
      group_ou 'AD/Groups'
    end

    # Add user "Joe Smith" in the Users OU to group "Admins" in OU "AD/Groups" using domain admin account
    windows_ad_group_member 'Joe Smith' do
      action :add
      group_name  'Admins'
      domain_name 'contoso.local'
      user_ou 'users'
      group_ou 'AD/Groups'
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

### `ou`

Note: Chef 12 Custom Resource WIP.
ou provider will call `ou_2008` or `ou_2012` based on OS version.
Warning: Data bags can be used, however OU names must be unique (restriction of data bags)

#### Actions

* :create: Adds organizational units to Active Directory.
* :modify: Modifies an organizational unit.
* :move:  Rename an organizational unit object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
* :delete:  Remove an organizational unit object from Active Directory.

#### Property Parameters

* name: name property.  Name of the Organization Unit object.
* domain_name: FQDN
* ou: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc770883.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

#### Examples

    ```rb
    # Create Organizational Unit "Departments" in the root
    windows_ad_ou "Departments" do
      action :create
      domain_name "contoso.local"
    end

    # Create Organizational Unit "IT" in the "Department" OUroot
    windows_ad_ou "IT" do
      action :create
      domain_name "contoso.local"
      ou "Departments"
    end

    # Create Organizational Unit "Departments" in the root using domain admin account
    windows_ad_ou "Departments" do
      action :create
      domain_name "contoso.local"
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

### 'ou_2008'

#### Actions

* :create: Adds organizational units to Active Directory.
WIP:
* :modify: Modifies an organizational unit.
* :move:  Rename an organizational unit object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
* :delete:  Remove an organizational unit object from Active Directory.

#### Property Parameters

* name: name property.  Name of the Organization Unit object.
* domain_name: FQDN
* ou: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc770883.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

### 'ou_2012'

#### Actions

* :create: Adds organizational units to Active Directory.
WIP:
* :modify: Modifies an organizational unit.
* :move:  Rename an organizational unit object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
* :delete:  Remove an organizational unit object from Active Directory.

#### Property Parameters

* name: name property.  Name of the Organization Unit object.
* domain_name: FQDN
* path: Organization Unit path where object is to be located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc770883.aspx>
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

### `users`

#### Actions

* :create: Adds a user object to Active Directory.
* :modify: Modifies an user object.
* :move:  Rename an user object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
* :delete:  Remove an user object from Active Directory.

#### Property Parameters

* name: name property.  Name of the user object.
* domain_name: FQDN
* ou: Organization Unit path where object is located.
* options: ability to pass additional options <http://technet.microsoft.com/en-us/library/cc731279.aspx>
* reverse: allows the reversing of "First Name Last Name" to "Last Name, First Name"
* cmd_user: user under which the interaction with AD should happen
* cmd_pass: password for user specified in cmd_user (only needed if user requires password)
* cmd_domain: domain of the user specified in cmd_user (only needed if user is a domain account)

#### Examples

    ```rb
    # Create user "Joe Smith" in the Users OU
    windows_ad_user "Joe Smith" do
      action :create
      domain_name "contoso.local"
      ou "users"
      options ({ "samid" => "JSmith",
             "upn" => "JSmith@contoso.local",
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
      domain_name "contoso.local"
      ou "users"
      options ({ "samid" => "JSmith",
             "upn" => "JSmith@contoso.local",
             "fn" => "Joe",
             "ln" => "Smith",
             "display" => "Smith, Joe",
             "disabled" => "no",
             "pwd" => "Passw0rd"
           })
      cmd_user "Administrator"
      cmd_pass "password"
      cmd_domain "contoso.local"
    end
    ```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors:: Derek Groh (<dgroh@github.com>)
          Richard Guin
          Miroslav Kyurchev (<mkyurchev@gmail.com>)
          Matt Wrock (<matt@mattwrock.com>)
          Miguel Ferreira (<miguelferreira@me.com>)
