# = Class: ruby::gems
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
#  class { 'ruby':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define ruby::gems ($project = $title) {

  $gems = [
    # chunky_png
    'chunky_png',
    # compass
    'compass',
    # compass-validator
    'compass-validator',
    # fssm
    'fssm',
    # sass
    'sass',
    # sass-globbing
    'sass-globbing',
    # deep_merge
    'deep_merge',
    # activesupport
    'activesupport',
    # vine
    'vine',
  ]

  package { $gems:
    ensure   => latest,
    provider => 'gem',
    require  => Package['rails'],
  }

}
