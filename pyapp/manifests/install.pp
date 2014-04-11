# == Class: pyapp::install
#
# Install prerequisite system packages for `pyapp`.
#
class pyapp::install {
  include python
  include python::virtualenv
  include sys::git
}
