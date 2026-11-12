# windows_ad_install

Install the AD DS server role, Group Policy Management and AD administration tools. Promotion is a separate operation.

## Actions

`:install`.

## Properties

| Property | Type | Default | Behaviour |
| --- | --- | --- | --- |
| `name` | String | Resource name | Directory object or operation name. |
| `features` | `Array` | `%w(AD-Domain-Services GPMC RSAT-AD-Tools)` | Feature names. Defaults to AD-Domain-Services, GPMC and RSAT-AD-Tools. |

## Example

```ruby
windows_ad_install 'AD DS'
```
