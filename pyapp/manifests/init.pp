# == Class: pyapp
#
# Puppet module for installing a toy Python web application.
#
class pyapp(
  $venv          = '/srv/pyapp',
  $uid           = '450',
  $user          = 'pyapp',
  $gid           = '33', # www-data on Ubuntu platforms
  $group         = 'www-data',
  $gunicorn_bind = '127.0.0.1:8000',
  $debug         = false,
  $package       = 'pyapp',
  $secret_key    = 'secret',
  $service       = 'pyapp',
  $source        = 'git+https://github.com/jbronn/pycon-pyapp.git',
  $version       = '0.1.0',
) {
  # Install prerequisite packages, local Redis instance, and Nginx.
  include pyapp::install
  include nginx
  include redis

  # Create a user / group to run the service.
  include pyapp::user

  # Create a virtualenv owned by the user.
  venv { $venv:
    owner => $user,
    group => $group,
  }

  # Site-packages inside virtualenv, and path to settings.
  $site_packages = "${venv}/lib/python2.7/site-packages"
  $settings = "${site_packages}/pyapp_settings.py"

  # Paths to database, static media.
  $data = "${venv}/data"
  $db = "${data}/pyapp.db"
  $static = "${venv}/static"

  # Create a data and static media directory inside the virtualenv.
  file { [$data, $static]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    require => Venv[$venv],
  }

  # Install Django, Celery, and gunicorn inside the virtualenv.
  # Use `suffix` function from the puppetlabs-stdlib so that
  # package titles are fit for `venv_package`.
  $requirements = suffix(
    ['celery', 'Django', 'gunicorn', 'redis'],
    "@${venv}"
  )

  # Install requirements, depend on prerequisite packages.
  venv_package { $requirements:
    ensure  => installed,
    require => Class['pyapp::install'],
  }

  # Install pyapp via git.
  $pyapp_package = "${package}@${venv}"
  venv_package { $pyapp_package:
    ensure  => $version,
    source  => $source,
    require => Venv_package[$requirements],
  }

  # pyapp's settings file -- don't backup to puppet's file bucket
  # because it has the SECRET_KEY.
  file { $settings:
    ensure  => file,
    backup  => false,
    owner   => $user,
    group   => $group,
    content => template('pyapp/settings.py.erb'),
    require => Venv_package[$pyapp_package],
  }

  $pyapp_env = ['DJANGO_SETTINGS_MODULE=pyapp_settings']
  class { 'pyapp::django_admin':
    environment => $pyapp_env,
    subscribe   => [File[$settings], Venv_package[$pyapp_package]],
  }

  # Configure pyapp service.
  $pyapp_upstart = "/etc/init/${service}.conf"
  file { $pyapp_upstart:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pyapp/pyapp.conf.erb'),
    require => Class['pyapp::django_admin'],
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [Class['pyapp::django_admin'], File[$pyapp_upstart]],
  }

  # Configure nginx.
  nginx::site { 'default':
    ensure => disabled,
  }

  nginx::site { 'pyapp':
    ensure  => enabled,
    content => template('pyapp/nginx.conf.erb'),
    require => Service[$service],
  }

  # TODO: Celery.
}
