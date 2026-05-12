# Migration

## Full Custom Resource Migration

`windows_ad` no longer ships public recipes. The former `windows_ad::default` behavior is now exposed through the `windows_ad_features` custom resource.

Before:

```ruby
include_recipe 'windows_ad::default'
```

After:

```ruby
windows_ad_features 'default'
```

The cookbook has no `attributes/` API. Configure behavior with resource properties in wrapper cookbooks or test cookbook recipes.

## Test Cookbook Examples

Executable examples live under `test/cookbooks/test/recipes/`. Kitchen suites now run `recipe[test::default]`, `recipe[test::setup_forest]`, and the object-management recipes.

## Domain Credentials

`windows_ad_domain` only requires `domain_user` and `domain_pass` when creating a domain, replica, or read-only domain controller that needs credentials. Creating a new forest on modern Windows Server can omit those properties.
