# == Class: pyapp::user
#
# Class for creating user/group for pyapp service.
#
class pyapp::user {
  group { $pyapp::group:
    gid => $pyapp::gid,
  }

  user { $pyapp::user:
    home  => $pyapp::venv,
    uid   => $pyapp::uid,
    gid   => $pyapp::gid,
    shell => '/bin/bash',
  }
}
