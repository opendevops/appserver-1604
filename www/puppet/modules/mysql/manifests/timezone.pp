# = Class: mysql::database
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
define mysql::timezone (
  $user          = $title,
  $user_password = '',
  $domain        = 'localhost',
) {

  #
  # * Load the Time Zone Tables
  #
  # see https://dev.mysql.com/doc/refman/5.7/en/mysql-tzinfo-to-sql.html


  exec { "mysql-timezone-${title}":
    command  => "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u $user -h $domain mysql -p$user_password",
    provider => 'shell',
    path     => ['/bin', '/sbin', '/usr/bin' ],
    require  => Exec["create-mysql_user-${user}"],
  }
}
