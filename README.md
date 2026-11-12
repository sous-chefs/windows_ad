# windows_ad cookbook

Manage AD DS roles, domains and directory objects with custom resources.
Requires Chef Infra Client 16 or later and Windows Server 2016, 2019, 2022 or 2025.

Add `depends 'windows_ad'` to your wrapper cookbook and declare:

```ruby
windows_ad_install 'AD DS'
```

Installing the role does not promote a domain controller. Declare domain and
directory resources separately. Domain promotion and demotion can reboot the server.

## Resources

- [windows_ad_install](documentation/windows_ad_install.md): Install the AD DS server role, Group Policy Management and AD administration tools. Promotion is a separate operation.
- [windows_ad_computer](documentation/windows_ad_computer.md): Manage an Active Directory computer object. Use the native windows_ad_join resource to join or leave a domain.
- [windows_ad_contact](documentation/windows_ad_contact.md): Manage an Active Directory contact object using the directory service command-line tools.
- [windows_ad_group](documentation/windows_ad_group.md): Manage an Active Directory group object using the directory service command-line tools.
- [windows_ad_group_member](documentation/windows_ad_group_member.md): Add or remove a user DN from an Active Directory group.
- [windows_ad_user](documentation/windows_ad_user.md): Manage an Active Directory user object using the directory service command-line tools.
- [windows_ad_ou](documentation/windows_ad_ou.md): Manage an organisational unit. Creation delegates to the PowerShell provider on supported Windows Server versions.
- [windows_ad_ou_2008](documentation/windows_ad_ou_2008.md): Retained public name for the dsadd OU provider. The name does not imply support for Windows Server 2008.
- [windows_ad_ou_2012](documentation/windows_ad_ou_2012.md): Retained public name for the PowerShell OU provider. Creates an OU under a domain or parent OU.
- [windows_ad_domain](documentation/windows_ad_domain.md): Promote or demote an AD DS domain controller. Run only on a Windows Server host dedicated to that domain operation.

See the [migration guide](documentation/migration.md),
[test fixtures](test/cookbooks/test/recipes) and [testing instructions](TESTING.md).

## Licence

MIT. Original authors include Derek Groh, Richard Guin, Miroslav Kyurchev,
Matt Wrock and Miguel Ferreira. Maintained by Sous Chefs.
