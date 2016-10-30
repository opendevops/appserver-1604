# == Class: ruby
#
# Full description of class ruby here.
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
# include ruby
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class ruby () {

  $packages = [
    'git-core',
    'zlib1g-dev',
    'build-essential',
    'libssl-dev',
    'libreadline-dev',
    'libyaml-dev',
    'libsqlite3-dev',
    'sqlite3',
    'libxml2-dev',
    'libxslt1-dev',
    'libcurl4-openssl-dev',
    'python-software-properties',
    'libffi-dev',
  ]

  # install packages
  package { $packages:
    ensure  => present,
    require => Exec['apt-update']
  }

  # install rails
  package { 'rails':
    ensure  => present,
    require => Package['build-essential']
  }

  # install gems
  ruby::gems{ 'ruby-gems': }

}

