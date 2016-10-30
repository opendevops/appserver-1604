# = Class: python::pip
#
# Description
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define python::pip ($project = $title) {

  # install php-fpm package
  package { 'python-dev':
    require => Package['python'],
    ensure  => installed,
  }

  # install php-fpm package
  package { 'python-pip':
    require => Package['python'],
    ensure  => installed,
  }

  exec { "pip-upgrade":
    path    => "/bin:/usr/bin",
    command => "pip install --upgrade pip",
    require => Package['python-pip'],
  }

  exec { "psutil":
    path    => "/bin:/usr/bin",
    command => "pip install psutil",
    # require  => Package['python-pip'],
    require => Exec['pip-upgrade'],
  }

  exec { "pip install psutil --upgrade":
    path    => "/bin:/usr/bin",
    command => "pip install psutil --upgrade",
    # require => Package['psutil'],
    require => Exec['psutil'],
  }
}
