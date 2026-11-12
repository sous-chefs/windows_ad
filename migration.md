# Migrating to windows_ad 1.0

The full migration removes the root `windows_ad::default` recipe. Replace its
run-list entry with a wrapper recipe containing `windows_ad_install 'AD DS'`.
There are no root attributes to migrate. The existing directory resource names
remain available, including the historically named OU providers.

Chef Infra Client 16 or later is required. Windows Server 2016 and 2019 remain
supported; the hosted CI matrix also checks Windows Server 2022 and 2025.
Windows Server 2008, 2008 R2, 2012 and 2012 R2 are outside support and their
legacy dcpromo/OS-detection paths are removed.

The install resource uses Server Manager feature names and includes management
tools. It does not promote or demote a domain. Keep those operations explicit.
The `restart` property is honoured for both domain creation and demotion.
Demotion now validates that `local_pass` is supplied. Passwords are sensitive
and single quotes in ADDS passwords are escaped.

The computer resource now queries the named computer object before creating it;
reaching a domain controller no longer incorrectly suppresses object creation.
The generic OU forwards credentials and options to the PowerShell provider;
an OU without a parent is created under the supplied domain root.

Explicit modify and move actions keep their command behaviour. They can report
an update on every converge. Object create/delete and membership add/remove are
guarded against repeating a completed operation.

The feature PR keeps the current metadata version. Its breaking conventional
commit causes Release Please to replace the pending patch release with 1.0.0
after the feature reaches main.
