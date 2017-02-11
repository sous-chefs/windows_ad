# Cookbook TESTING doc

This document describes the process for testing Chef community cookbooks using ChefDK. Cookbooks can be tested using the test dependencies defined in cookbook Gemfiles alone, but that process will not be covered in this document in order to maintain simplicity.

## Testing Prerequisites

A working ChefDK installation set as your system's default ruby. ChefDK can be downloaded at <https://downloads.chef.io/chef-dk/>

Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for integration testing.

## Installing dependencies

Cookbooks may require additional testing dependencies that do not ship with ChefDK directly. These can be installed into the ChefDK ruby environment with the following commands

Install dependencies:

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

## Style Testing

Ruby style tests can be performed by Rubocop by issuing either

```shell
chef exec rubocop --auto-gen-config
```

Chef style/correctness tests can be performed with Foodcritic by issuing either

```shell
chef exec foodcritic .
```

## Spec Testing

Unit testing is done by running Rspec examples. Rspec will test any libraries, then test recipes using ChefSpec. This works by compiling a recipe (but not converging it), and allowing the user to make assertions about the resource_collection.

## Integration Testing

Integration testing is performed by Test Kitchen. After a successful converge, tests are uploaded and ran out of band of Chef. Tests should be designed to ensure that a recipe has accomplished its goal.

To see a list of available test instances run:

```shell
kitchen list
```

To test specific instance run:

```shell
kitchen test INSTANCE_NAME
```

## Integration Testing using Vagrant

Integration tests can be performed on a local workstation using either Virtualbox or VMWare as the virtualization hypervisor. To run tests against all available instances run:

To test specific instance run:

```shell
vagrant up INSTANCE_NAME
```

## Private Images

Some operating systems have specific licenses that prevent us from making those images available freely. We either comment these the .kitchen.yml or create a separate .kitchen.vmware.yml file for Chef internal use.

Images include:

- Windows Server 2008
- Windows Server 2012
- Windows Server 2016
- Windows 7 Professional
- Windows 8.1 Professional
- Mac OS X 10.7-10.12
- SLES 12 / 12SP1
- Solaris 10.11

Otherwise if you are not a Chef employee, in order to test these operating systems you will need to obtain the appropriate licenses and images as needed.

Windows Images: https://atlas.hashicorp.com/boxes/search?order=desc&page=1&provider=virtualbox&q=windows&sort=updated&utf8=%E2%9C%93