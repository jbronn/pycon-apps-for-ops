Vagrant for `pyapp`
===================

This directory houses a Vagrant configuration for testing out the [`pyapp`](../pyapp)
module discussed in my PyCon presentation.

To use, you'll need both [Vagrant](http://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
installed for your platform.  Once you have those installed, simply type:

```
$ vagrant up
```

This will download a minimal base box (~230MB) of Ubuntu 12.04.4 with Puppet from my DropBox account.
This box was generated with my [packer-vagrant](https://github.com/jbronn/packer-vagrant) repository with
the `precise64` template.  After doing some initial configuration, Vagrant will provision by
downloading prerequisite Puppet modules from the [Forge](https://forge.puppetlabs.com), and then
provision itself by running `puppet apply` on the [`default.pp`](manifests/default.pp) manifest.

Once it's done provisioning, you should be able to visit http://localhost:8000/admin/ and see
the Django admin from the [`pyapp`](https://github.com/jbronn/pycon-pyapp) application.
