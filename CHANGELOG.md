# CHANGELOG for windows_ad

## Unreleased

## 0.7.8 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 0.7.7 - *2023-04-01*

## 0.7.6 - *2023-04-01*

## 0.7.5 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 0.7.4 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 0.7.3 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management


## 0.7.2

* Add compatibility for Chef 16
* Update README.md to match resource options (removal of `:join` & `:unjoin` actions for `:windows_ad_computer`) and windows cookbook dependency.
* Use `:powershell` resource for inspec tests.
* Change supported platform to `>= 6.2` (Windows 2012) to match README.md.

## 0.7.1

* Corrects the removal of the name_property in the group_members resource
* Clean up delivery testing
* github templates and actions

## 0.7.0

* Remove depends on 'windows' cookbook, features are now part of chef core.
* Improved test kitchen tests and subcommand flow without need to run each subcommand.

## 0.6.4

* Corrects .kitchen file to allow Converge, verify, and test to complete successfully with additional recipes after system reboot.

## 0.6.3

* Issue 121 - https://github.com/TAMUArch/cookbook.windows_ad/issues/121 allow use of spaces in Distinguished Name.

## 0.6.2

* Group resource not using library CmdHelper not checking user with domain.

## 0.6.1

* Install dependency windows features.

## 0.6.0

* Allow compatibility with windows cookbook 3.0.0 changes.

## 0.5.5

* Hotfix for locking the version of the windows cookbook as it has recently been rewritten.  A refactor is required to use the latest version.

## 0.5.4

* Issue 100 - https://github.com/TAMUArch/cookbook.windows_ad/issues/100 initial support for Windows 2016.
* Quality changes - chefignore, default recipe uses float to compare os_version.

## 0.5.3

* Issue 87 - https://github.com/TAMUArch/cookbook.windows_ad/issues/87 revert Robocop edits on providers

## 0.5.2

* Issue 85 - https://github.com/TAMUArch/cookbook.windows_ad/issues/85 revert Robocop edits on dsquery

## 0.5.1

* Quality of life edits

## 0.5.0

* Join and unjoin actions from domain provider moved to computer provider - https://github.com/TAMUArch/cookbook.windows_ad/pull/77
* Correct user action to address dsmod error - https://github.com/TAMUArch/cookbook.windows_ad/issues/71
* Fixed bug in join ou that always reported that the resource was updated
* Gitter badger added - https://github.com/TAMUArch/cookbook.windows_ad/pull/66
* Proper formattign for pre-win2012 systems - https://github.com/TAMUArch/cookbook.windows_ad/pull/70 and https://github.com/TAMUArch/cookbook.windows_ad/pull/74

## 0.4.5

* Rubocop and foodcritic - https://github.com/TAMUArch/cookbook.windows_ad/issues/2
* Add success return codes for installing DC. - https://github.com/TAMUArch/cookbook.windows_ad/issues/1

## 0.4.4

* Correct versioning for Supermarket, required unsharing, bumping version and then sharing once again.

## 0.4.3

* Community contributions - Add restart parameter, Testing with vagrant, Added domain prefix and updated ou_dn method, powershell requires quotes around OU

## 0.4.2

* Community contributions - add_domain_join_ou

## 0.4.1

* Community contributions - fix-string-comparison, case-insensitive-comparison, and decompose-nested-ou

## 0.4.0

* Community contributions - chef_spec support.

## 0.3.9

* Community contributions - enum and numeric values in command options, user existence check, group member provider, allow use of CN=Users in DN.

## 0.3.8

* Moved :join and :unjoin actions for computer from :domain provider to :computer provider.

## 0.3.7

* Mark attributes as required for :domain resource
* Fixed regression on install forest with unnecessary credentials 

## 0.3.6

* Attempt to upload to supermarket

## 0.3.4

* Corrected domain join for Windows Server 2008

## 0.3.3

* Formatting changes - remove tabs

## 0.3.2:

* Logic change to ensure server 2012 is still works correctly

## 0.3.0:

* Support for Windows Server 2008 R2 for domain provider

## 0.2.1:

* Community contributions - nested ou support

## 0.2.0:

* AD Object Support

## 0.1.0:

* Initial release of active-directory





