# windows_ad contributor notes

## Confirmed scope

The owner selected a full custom-resource migration and replacement of the
pending patch release with a major release. Root recipes and attributes must
not remain. Existing public object APIs and non-EOL platforms must be preserved.
Work lands through a feature PR to main, followed by Release Please generation.

## Design and research

AD DS promotion/demotion requires Windows Server and can require a reboot.
Windows Server 2016/2019 remain local integration targets; native hosted role
tests run on actual Windows 2022 and 2025 runners. Historical OU resource names
remain public aliases to their respective directory tools, not old OS support.

Primary references:

- [Microsoft AD DS installation](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- [ADDSDeployment](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/)
- [Chef windows_feature](https://docs.chef.io/resources/windows_feature/)
- [PowerShell module path inheritance](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Use unified mode, frozen string literals, action_class helpers and native Chef
resources. Direct directory mutations use converge_by for why-run and update
reporting. Keep passwords sensitive and out of command logs.

## Verification

Run `chef install Policyfile.rb`, `chef exec rspec`, `cookstyle`, and InSpec
profile checks. Every custom resource needs meaningful step_into action tests.
Hosted exec CI validates role installation twice, with idempotency enforced.
It cannot validate a rebooting domain controller. Forest, objects and demotion
need an isolated reboot-capable Windows VM before full migration acceptance.
Do not describe hosted role-only tests as full domain acceptance.

## Local workflow exception

The local lint-unit reusable workflow copies sous-chefs/.github 9.0.1 exactly,
with only the metadata licence input set to MIT. The shared workflow exposes no
licence input and otherwise incorrectly requires Apache-2.0. Keep the caller and
inner job names unchanged to preserve required branch-protection contexts.
Return to the shared workflow when it supports the existing MIT licence.
