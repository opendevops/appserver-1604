# == Class: xdebug
#
# Full description of class xdebug here.
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
# include xdebug
# xdebug::config { 'local_xdebug': default_enable => '1' }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class xdebug ($service = 'apache2') {
  package { 'xdebug':
    name    => 'php-xdebug',
    ensure  => installed,
    require => Package['php7.0-fpm'],
    # notify  => Service[$service]
    notify  => Service['php7.0-fpm']
  }

}
