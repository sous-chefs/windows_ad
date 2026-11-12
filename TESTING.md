# Testing windows_ad

Run `chef install Policyfile.rb`, `chef exec rspec` and `cookstyle` locally.
Resource specs step into every custom resource and mock only Windows command
boundaries. They exercise commands and guards without creating a domain.

The default Kitchen suite installs roles and verifies a second unchanged
converge. Hosted CI runs it on Windows Server 2022 and 2025 with the exec driver.
The Vagrant configuration retains Windows Server 2016 and 2019 and adds 2022.

Run `chef exec kitchen test forest-windows-2022` and
`chef exec kitchen test objects-windows-2022` on an x64 Windows-capable Vagrant
host. These suites create a test forest, reboot and verify directory objects.
They must run only on disposable isolated VMs. Run
`chef exec kitchen test demotion-windows-2022` to create a disposable forest,
reboot, demote its controller, reboot again and verify the server role. A fixture
marker prevents recreating the forest after its final reboot.

On a Mac ARM host, x64 Windows Vagrant guests cannot provide native acceptance.
Hosted role installation alone is insufficient for domain lifecycle acceptance.
