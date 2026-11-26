# windows_ad_ou_2012

Retained public name for the PowerShell OU provider. Creates an OU under a domain or parent OU.

## Actions

`:create`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `path` | `String` | `nil` | Parent OU path, separated by /; omitting it uses the domain root. |
| `domain_name` | `String` | `nil` | Domain FQDN. |
| `options` | `Hash` | `{}` | Additional options passed to the underlying directory tool. Option names and values must be trusted cookbook input. |
| `cmd_user` | `String` | `nil` | Account used to execute directory commands; defaults to the Chef process account. |
| `cmd_pass` | `String` | `nil` | Sensitive password for cmd_user. |
| `cmd_domain` | `String` | `nil` | Domain for cmd_user. |

## Example

```ruby
windows_ad_ou_2012 'Engineering' do
  domain_name 'contoso.local'
end
```
