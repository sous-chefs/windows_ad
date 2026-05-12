# windows_ad_group_member

Adds or removes users from Active Directory groups.

## Actions

| Action | Description |
|--------|-------------|
| `:add` | Adds a user to a group. Default. |
| `:remove` | Removes a user from a group. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user_name` | String | name property | User name. |
| `group_name` | String | required | Group name. |
| `domain_name` | String | `nil` | Target domain FQDN. |
| `user_ou` | String | `nil` | User OU or container path. |
| `group_ou` | String | `nil` | Group OU or container path. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |

## Examples

```ruby
windows_ad_group_member 'Jane Doe' do
  group_name 'Developers'
  domain_name 'contoso.local'
  user_ou 'Users'
  group_ou 'Users'
end
```
