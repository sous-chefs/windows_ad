# Limitations

## Package Availability

`windows_ad` manages Microsoft Active Directory Domain Services through Windows Server roles, features, PowerShell cmdlets, and directory command-line tools. There are no APT, DNF/YUM, or Zypper packages for this cookbook.

## Platform Support

Microsoft lifecycle data shows:

* Windows Server 2012 and 2012 R2 extended support ended on October 10, 2023. ESU year 3 ends on October 13, 2026.
* Windows Server 2016 extended support ends on January 12, 2027.
* Windows Server 2019 extended support ends on January 9, 2029.
* Windows Server 2022 extended support ends on October 14, 2031.
* Windows Server 2025 extended support ends on November 14, 2034.

This cookbook supports Windows Server 2016 and newer. The local Kitchen strategy uses Windows/Vagrant boxes for domain-controller workflows; Dokken/Linux containers are not compatible with Active Directory Domain Services.

## Architecture Limitations

Active Directory Domain Services is managed on Windows Server hosts only. Linux, macOS, and container platforms are not supported targets.

## Source/Compiled Installation

No source build is performed. The cookbook installs Windows roles/features and runs Windows-native AD DS tooling.

## Known Issues

Domain controller promotion and object management require privileged Windows hosts. Local integration tests require a working Windows hypervisor/Vagrant environment, and CI should use Windows runners rather than Dokken.
