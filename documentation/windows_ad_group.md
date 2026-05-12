# windows_ad_group

Manages Active Directory group objects.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates a group object. Default. |
| `:modify` | Modifies a group object. |
| `:move` | Moves or renames a group object. |
| `:delete` | Removes a group object. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | String | `nil` | Target domain FQDN. |
| `ou` | String | `nil` | OU or container path. |
| `options` | Hash | `{}` | Additional dsadd/dsmod/dsmove options. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_group 'Developers' do
  domain_name 'contoso.local'
  ou 'Users'
end
```
