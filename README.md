# u2fval-cookbook

## Usage
1. Install [CHEFDK](https://downloads.chef.io/chefdk/)
2. Install [VirtualBox](https://www.virtualbox.org/)
3. Install [Vagrant](https://www.vagrantup.com/downloads.html)
4. Clone cookbook

    git clone git@github.com:outofjungle/u2fval-cookbook.git
    cd u2fval-cookbook

5. Converge and run test

    kitchen converge
    kitchen verify

## TODO

* Make all resources idempotnet
* Pin all binaries
* Write chefspec tests
* Support centos-7, ubuntu-12, ubuntu-14
