# = Class: robo::params
#
# This class defines default parameters used by the main module class robo.
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
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class robo::params {
  $robo_repo = 'https://github.com/consolidation/Robo/releases/download/'
  $version = '1.0.0-RC3'
  $filename = '/robo.phar'
  $phar_location = "$robo_repo/$version/$filename"
  $target_dir    = '/usr/local/bin'
  $command_name  = 'robo'
  $user          = 'root'
}
