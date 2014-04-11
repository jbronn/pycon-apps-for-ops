# == Class: pyapp::django_admin
#
# Run the django-admin syncdb/collect static scripts.
#
class pyapp::django_admin(
  $environment,
) {
  $django_admin = "${pyapp::venv}/bin/django-admin.py"
  
  exec { 'pyapp-syncdb':
    command     => "${django_admin} syncdb --noinput",
    user        => $pyapp::user,
    environment => $environment,
    refreshonly => true,
  }

  exec { 'pyapp-collectstatic':
    command     => "${django_admin} collectstatic --noinput",
    user        => $pyapp::user,
    environment => $environment,
    refreshonly => true,
  }
}
