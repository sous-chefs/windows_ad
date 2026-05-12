# windows_ad_contact

Manages Active Directory contact objects.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates a contact object. Default. |
| `:modify` | Modifies a contact object. |
| `:move` | Moves or renames a contact object. |
| `:delete` | Removes a contact object. |

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
windows_ad_contact 'Jane Doe' do
  domain_name 'contoso.local'
  ou 'Users'
end
```
