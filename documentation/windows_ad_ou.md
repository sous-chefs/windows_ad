# windows_ad_ou

Manages Active Directory organizational units and delegates to the platform-specific OU resources.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates an organizational unit. Default. |
| `:modify` | Modifies an organizational unit. |
| `:move` | Moves or renames an organizational unit. |
| `:delete` | Removes an organizational unit. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | String | `nil` | Target domain FQDN. |
| `ou` | String | `nil` | Parent OU path. |
| `options` | Hash | `{}` | Additional command options. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_ou 'Hardware' do
  domain_name 'contoso.local'
end
```
