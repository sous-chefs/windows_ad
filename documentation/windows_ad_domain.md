# windows_ad_domain

Promote or demote an AD DS domain controller. Run only on a Windows Server host dedicated to that domain operation.

## Actions

`:create`, `:delete`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `domain_user` | `String` | `Required` | Account used to authenticate domain operations. Required. |
| `domain_pass` | `String` | `Required` | Sensitive domain account password. Required. |
| `restart` | `[true, false]` | `Required` | Whether the domain operation may reboot. Required. Computer object operations retain this property for API compatibility and do not join or reboot a host. Required. |
| `type` | `String` | `'forest'` | forest, domain, replica, or read-only. The read-only operation creates a pre-staged read-only DC account. |
| `safe_mode_pass` | `String` | `Required` | Sensitive Directory Services Restore Mode password. Required. |
| `options` | `Hash` | `{}` | Additional options passed to the underlying directory tool. Option names and values must be trusted cookbook input. |
| `local_pass` | `String` | `nil` | Sensitive local Administrator password. Required for demotion. |
| `replica_type` | `String` | `'domain'` | Retained for API compatibility; supported Windows uses type and ADDSDeployment instead of dcpromo. |

## Example

```ruby
windows_ad_domain 'contoso.local' do
  domain_user 'CONTOSO\\Administrator'
  domain_pass secret('domain_password')
  safe_mode_pass secret('dsrm_password')
  restart false
end
```

Use your secret store in place of the illustrative `secret` helper.
