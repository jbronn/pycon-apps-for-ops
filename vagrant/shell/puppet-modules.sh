#!/bin/bash
set -e

# Required modules for `pyapp`.
PUPPET_MODULES="counsyl-python counsyl-nginx counsyl-redis"

# Module path -- this is the `modules` directory relative to the Vagrantfile.
MODULEPATH=/vagrant/modules

# Install prerequisite Puppet modules in $MODULEPATH,
# if they aren't already using the `puppet module` tool.
for module in $PUPPET_MODULES
do
    # Test for existence of module (portion of module name after '-')
    # before trying to run `puppet module install`.
    test -d $MODULEPATH/${module#*-} || puppet module install --modulepath $MODULEPATH $module
done
