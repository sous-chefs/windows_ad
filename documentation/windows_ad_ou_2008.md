# windows_ad_ou_2008

Retained public name for the dsadd OU provider. The name does not imply support for Windows Server 2008.

## Actions

`:create`.

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
windows_ad_ou_2008 'Engineering' do
  domain_name 'contoso.local'
end
```
