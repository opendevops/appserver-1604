# = Class: server::logrotate_d
#
# This class
#
# == Variables:
#
# Refer to
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
define server::logrotate_d (
  $logrotate_file = $title,
) {


  file { "/etc/logrotate.d/$logrotate_file":
    mode    => "0600",
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/server/logrotate/$logrotate_file",
    require => Package['logrotate'],
  }

}
