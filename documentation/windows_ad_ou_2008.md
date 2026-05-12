# windows_ad_ou_2008

Creates Active Directory organizational units with legacy `dsadd` tooling.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates an organizational unit. Default. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | String | `nil` | Target domain FQDN. |
| `ou` | String | `nil` | Parent OU path. |
| `options` | Hash | `{}` | Additional dsadd options. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_ou_2008 'Hardware' do
  domain_name 'contoso.local'
end
```
