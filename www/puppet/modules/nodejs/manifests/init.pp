# == Class: nodejs
#
# Full description of class nodejs here.
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
# include nodejs
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class nodejs () {

  # install nodejs package
  package { 'nodejs':
    require => Exec['apt-update'],
    ensure  => installed,
  }

  # install npm package
  package { 'npm':
    require => Package['nodejs'],
    ensure  => installed,
  }


  # Use update-alternatives to ensure the node executable is available
  # http://stackoverflow.com/a/24592328
  # sudo update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100
  exec { 'nodejs_update_alternatives':
    path     => '/bin:/usr/bin',
    command  => 'update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100',
    require => Package['nodejs']
  }

  nodejs::npm{ 'nodejs_npm': }

}
