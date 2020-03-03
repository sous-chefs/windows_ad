# TESTING #

The [ChefDK](https://docs.chef.io/about_chefdk.html) contains all the tools required to test and develop for this cookbook. A `project.toml` file is provided so that all testing commands can be run using the `delivery local` cli that comes with ChefDK.

### Style Testing ###
Run `delivery local lint` to run cookstyle and `delivery local syntax` to run foodcritic.

### Spec Testing ###
Run `delivery local unit` to run [ChefSpec](https://github.com/chefspec/chefspec) tests.

### Combined Style + Spec Testing ###
All cookstyle, foodcritic and Chefspec tests can be run in a single command using `delivery local verify`

### Integration Testing ###
Integration testing with [Test Kitchen](https://docs.chef.io/kitchen.html) can also be done using the delivery cli. To execute all stages of testing with test kitchen you can run either `delivery local acceptance` or `kitchen test`

Test Kitchen is configured to use vagrant by default and uses [inspec](https://www.inspec.io/) to verify.

## Private Images

Some operating systems have specific licenses that prevent us from making those images available freely. We either comment these the .kitchen.yml or create a separate .kitchen.vmware.yml file for Chef internal use.

Images include:

- Windows Server 2008
- Windows Server 2012
- Windows Server 2016
- Windows Server 2019
- Windows 7 Professional
- Windows 8.1 Professional
- Mac OS X 10.7-10.12
- SLES 12 / 12SP1
- Solaris 10.11

Windows Images: https://atlas.hashicorp.com/boxes/search?order=desc&page=1&provider=virtualbox&q=windows&sort=updated&utf8=%E2%9C%93