# windows_ad_computer

Manages Active Directory computer objects.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates a computer object. Default. |
| `:modify` | Modifies a computer object. |
| `:move` | Moves or renames a computer object. |
| `:delete` | Removes a computer object. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_name` | String | `nil` | Target domain FQDN. |
| `domain_user` | String | `nil` | Domain user for domain queries. |
| `domain_pass` | String | `nil` | Domain password for domain queries. |
| `ou` | String | `nil` | OU or container path. |
| `options` | Hash | `{}` | Additional dsadd/dsmod/dsmove options. |
| `cmd_user` | String | `nil` | Command execution user. |
| `cmd_pass` | String | `nil` | Command execution password. |
| `cmd_domain` | String | `nil` | Command execution domain. |
| `restart` | true, false | required | Reboot behavior for domain operations. |

## Examples

```ruby
windows_ad_computer 'workstation1' do
  domain_name 'contoso.local'
  ou 'Computers'
  restart false
end
```
