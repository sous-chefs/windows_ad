# windows_ad_ou_2012

Creates Active Directory organizational units with PowerShell AD cmdlets.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates an organizational unit. Default. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `path` | String | `nil` | Parent OU path. |
| `domain_name` | String | `nil` | Target domain FQDN. |
| `options` | Hash | `{}` | Reserved for additional options. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_ou_2012 'Hardware' do
  domain_name 'contoso.local'
end
```
