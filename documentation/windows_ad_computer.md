# windows_ad_computer

Manage an Active Directory computer object. Use the native windows_ad_join resource to join or leave a domain.

## Actions

`:create`, `:modify`, `:move`, `:delete`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `domain_name` | `String` | `nil` | Domain FQDN. |
| `domain_user` | `String` | `nil` | Account used to authenticate domain operations. |
| `domain_pass` | `String` | `nil` | Sensitive domain account password. |
| `ou` | `String` | `nil` | Parent OU path, separated by /; standard containers such as Users and Computers are also accepted for objects. |
| `options` | `Hash` | `{}` | Additional options passed to the underlying directory tool. Option names and values must be trusted cookbook input. |
| `cmd_user` | `String` | `nil` | Account used to execute directory commands; defaults to the Chef process account. |
| `cmd_pass` | `String` | `nil` | Sensitive password for cmd_user. |
| `cmd_domain` | `String` | `nil` | Domain for cmd_user. |
| `restart` | `[true, false]` | `Required` | Whether the domain operation may reboot. Required. Computer object operations retain this property for API compatibility and do not join or reboot a host. Required. |

## Example

```ruby
windows_ad_computer 'Engineering' do
  domain_name 'contoso.local'
  restart false
end
```

Creation and deletion check existence first. Explicit modify and move actions execute when the object exists; they do not compare every directory attribute.
