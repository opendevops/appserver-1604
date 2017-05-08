# = Class: server::log
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
define project::logrotate (
  $project_name   = $title,
  # eg. $log_path = integration/healthkit/app/logs
  $log_path       = '',
  # '' = always compress, 'delay_compress' = Postpone compression of the previous log file to the next rotation cycle
  $delay_compress = '',
) {


  #
  # * project monitored log rotates
  #
  if !defined(File["monitored_$log_path"]) {
    file { "monitored_$log_path":
      path    => "/etc/logrotate.d/$project_name-monitored",
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('project/logrotate.d.erb'),
      require => Package['logrotate'],
    }
  }


  #
  # * project hourly log rotates
  #
  if !defined(File["/etc/logrotate.hourly"]) {
    file { "/etc/logrotate.hourly":
      ensure  => directory,
      mode    => '0755',
      owner   => 'root',
      require => Package['logrotate'],
    }
  }

  if !defined(File["hourly_$log_path"]) {
    file { "hourly_$log_path":
      path    => "/etc/logrotate.hourly/$project_name",
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('project/logrotate.hourly.erb'),
      require => File["/etc/logrotate.hourly"],
    }
  }
}
