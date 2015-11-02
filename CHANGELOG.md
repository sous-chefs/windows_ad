# CHANGELOG for windows_ad

## 0.4.5

* Rubocop and foodcritic
* Add success return codes for installing DC.

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





