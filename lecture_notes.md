Lecture Notes
=============

Some notes to accompany my talk.  I first got into Puppet at PyCon 2011 in Atlanta, thanks to
Robert Crowley's talk: ["Dependency Management with Puppet"](http://pyvideo.org/video/431/pycon-2011--dependency-management-with-puppet).
The `pip` provider became a component of Puppet itself afterwards.

Why Puppet?
-----------

For some entertaining reading on Salt's cryptography stack, I recommend the [commit](https://github.com/saltstack/salt/commit/5dd3042)
where they fixed their RSA key generation.  We're *still* finding catastrophic bugs in OpenSSL, imagine what lurks in newer crypto stacks.

Puppet *was* GPL licensed until version 2.7, when it [switched](http://puppetlabs.com/blog/relicensing-puppet-to-apache-2-0) to the Apache 2 license.

Installing Puppet
-----------------

When using `gem`, you can speed up your installs by adding `--no-rdoc --no-ri` to the installation command.

Package Links:

* Debian/Ubuntu: http://apt.puppetlabs.com/
* RedHat: http://yum.puppetlabs.com/
* Mac: http://downloads.puppetlabs.com/mac/
* Windows: https://downloads.puppetlabs.com/windows/
 * The [windows installation documentation](http://docs.puppetlabs.com/windows/installing.html) is a very good resource if you're unfortunate enough manage Windows.


Resources
---------

For all the native resource types in Puppet, I recommend consulting their type reference:

http://docs.puppetlabs.com/references/latest/type.html

This cheat sheet is extremely useful.

Puppet Basics
-------------

The Puppet langauge is *not* Ruby; just because they share a similar native regex type, does not mean they're equivalent.

The selectors in `case` statements are case-insensitive, e.g., the following still matches "Debian" and "OpenBSD" (because literals are interpreted as strings in the langauge):

```puppet
case $::osfamily {
  debian: {
  }
  openbsd: {
  }
}
```

Facts
-----

All facts are global variables, thus the `$::` is shorthand for saying "the global namespace."


Installing Modules
------------------

Browse and search for modules at: https://forge.puppetlabs.com

Module Structure
----------------

The `Modulefile` contains metadata in another pseudo-DSL (Ruby programmer answer to everything).

The `lib` directory is where you extend Puppet code.  When Puppet is running on a node, it knows to load up data from this path -- 
here is where you can have your custom Puppet types, providers, and even facts.  If you ever need stray down this road,
I recommend the book: [*Puppet Types and Providers*](http://shop.oreilly.com/product/0636920026860.do).

Writing Modules for Python
--------------------------

### Mix & Match

You don't have to use my modules, but you absolutely should be using the [`stdlib`](https://github.com/puppetlabs/puppetlabs-stdlib) module from Puppet Labs.

### `pipx`

The [`install_options`](http://docs.puppetlabs.com/references/latest/type.html#package-attribute-install_options) package attribute was added to Puppet's `package` type to deal with the complexities of Windows package management.  I created the [`pipx`](https://github.com/counsyl/puppet-python/#pipx) for the reason to add this option (really needed to download from an alternative PyPI mirror).

### `venv` / `venv_package`

If set, the `owner` parameter is used by `venv_package` when installing packages -- Puppet will `su` down to that user when invoking `pip`.  This is meant to add little bit of extra protection against potentially malicious packages on PyPI.

Running Puppet
--------------

I'm really glancing over the Puppetmaster setup.