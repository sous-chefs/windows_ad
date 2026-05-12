# windows_ad_domain

Creates or removes Active Directory forests, domains, and domain controllers.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates a forest, domain, replica, or read-only domain controller. Default. |
| `:delete` | Removes a domain controller. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `domain_user` | String | `nil` | Credential user for non-forest create operations. |
| `domain_pass` | String | `nil` | Credential password for non-forest create operations. |
| `restart` | true, false | `true` | Allows Windows to restart after promotion. |
| `type` | String | `'forest'` | One of `forest`, `domain`, `replica`, or `read-only`. |
| `safe_mode_pass` | String | required | Directory Services Restore Mode password. |
| `options` | Hash | `{}` | Additional AD DS deployment options. |
| `local_pass` | String | `nil` | Local Administrator password for demotion. |
| `replica_type` | String | `'domain'` | Windows Server 2008 replica type. |

## Examples

```ruby
windows_ad_domain 'contoso.local' do
  type 'forest'
  safe_mode_pass 'Passw0rd'
  restart false
end
```
