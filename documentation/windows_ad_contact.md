# windows_ad_contact

Manage an Active Directory contact object using the directory service command-line tools.

## Actions

`:create`, `:modify`, `:move`, `:delete`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `domain_name` | `String` | `nil` | Domain FQDN. |
| `ou` | `String` | `nil` | Parent OU path, separated by /; standard containers such as Users and Computers are also accepted for objects. |
| `options` | `Hash` | `{}` | Additional options passed to the underlying directory tool. Option names and values must be trusted cookbook input. |
| `cmd_user` | `String` | `nil` | Account used to execute directory commands; defaults to the Chef process account. |
| `cmd_pass` | `String` | `nil` | Sensitive password for cmd_user. |
| `cmd_domain` | `String` | `nil` | Domain for cmd_user. |

## Example

```ruby
windows_ad_contact 'Engineering' do
  domain_name 'contoso.local'
end
```

Creation and deletion check existence first. Explicit modify and move actions execute when the object exists; they do not compare every directory attribute.
