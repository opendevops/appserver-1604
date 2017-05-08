# = Class: server::packages::monitor
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
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
class server::packages::monitor {

  $packages = [
    # for I/O monitoring with iostat
    'sysstat',
    # monitors network traffic and bandwidth usage
    'nload',
    # system-monitor process-viewer
    'htop',
    # I/O monitoring
    'iotop',
    # apachetop
    'apachetop',

  ]

  package { $packages:
    ensure  => latest,
    require => Exec['apt-update'],
  }

}
