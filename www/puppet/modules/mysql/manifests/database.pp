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
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define mysql::database ($database_name = $title, $user) {


  # eg.
  # $db_user           = ''
  # $db_password       = ''
  $charset = 'utf8'


  exec { "create-database-${database_name}":
    command  => "mysql -e 'CREATE DATABASE ${database_name} character SET utf8; GRANT ALL on *.* to ${user}@localhost; FLUSH PRIVILEGES;' -uroot -p`cat /root/.passwd/db/mysql`",
    provider => 'shell',
    path     => ['/bin', '/sbin', '/usr/bin' ],
    require  => Exec["create-mysql_user-$user"],
    unless   => "mysql -e 'SHOW DATABASES LIKE \"${database_name}\"' -uroot -p`cat /root/.passwd/db/mysql` | grep -q ${database_name}",
  }
}
