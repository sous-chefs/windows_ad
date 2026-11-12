# windows_ad_group_member

Add or remove a user DN from an Active Directory group.

## Actions

`:add`, `:remove`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `user_name` | `String` | `Resource name` | User name; defaults to the resource name. |
| `group_name` | `String` | `Required` | Target group name. Required. |
| `domain_name` | `String` | `nil` | Domain FQDN. |
| `user_ou` | `String` | `nil` | Parent OU or container for the user. |
| `group_ou` | `String` | `nil` | Parent OU or container for the group. |
| `cmd_user` | `String` | `nil` | Account used to execute directory commands; defaults to the Chef process account. |
| `cmd_pass` | `String` | `nil` | Sensitive password for cmd_user. |
| `cmd_domain` | `String` | `nil` | Domain for cmd_user. |

## Example

```ruby
windows_ad_group_member 'alice' do
  domain_name 'contoso.local'
  group_name 'developers'
  user_ou 'Users'
  group_ou 'Engineering'
end
```
