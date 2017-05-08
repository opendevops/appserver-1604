# == Class: cron
#
# Full description of class cron here.
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
#  class { 'cron':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
class cron (
  # eg. local, prod, prod-cron, staging
  $env = $title,

) {

    file { "/etc/cron.d/$env-server":
      mode   => "0600",
      owner  => 'root',
      source => "puppet:///modules/cron/$env/$env-server",
    }

}
