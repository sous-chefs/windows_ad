# windows_ad_features

Installs Windows features required for Active Directory Domain Services.

## Actions

| Action | Description |
|--------|-------------|
| `:install` | Installs AD DS features. Default. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `features` | Array | platform defaults | Windows feature names to install. |
| `all` | true, false | platform default | Passes the `all` flag to `windows_feature`. |

## Examples

```ruby
windows_ad_features 'default'
```
