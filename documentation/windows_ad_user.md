# windows_ad_user

Manages Active Directory user objects.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates a user object. Default. |
| `:modify` | Modifies a user object. |
| `:move` | Moves or renames a user object. |
| `:delete` | Removes a user object. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | String | required | Target domain FQDN. |
| `ou` | String | `nil` | OU or container path. |
| `options` | Hash | `{}` | Additional dsadd/dsmod/dsmove options. |
| `reverse` | String | `nil` | Reverses first and last name handling when set to `'true'`. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_user 'Jane Doe' do
  domain_name 'contoso.local'
  ou 'Users'
end
```
