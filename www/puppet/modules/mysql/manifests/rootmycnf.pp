# = Class: mysql::config
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
define mysql::rootmycnf (
  $password  = '',
  $db_host   = '',
  $root_user = 'root',
) {


  if $project::mysql_enabled == true {
    # .my.cnf for mysql database password
    file { "/root/.my.cnf":
      ensure  => file,
      owner   => 'root',
      mode    => '0644',
      path    => '/root/.my.cnf',
      content => template('mysql/.my.cnf.erb'),
      notify  => Service['mysql'],
      require => Package['mysql-server'],
    }
  } else {
    # .my.cnf for mysql database password
    file { "/root/.my.cnf":
      ensure  => file,
      owner   => 'root',
      mode    => '0644',
      path    => '/root/.my.cnf',
      content => template('mysql/.my.cnf.erb'),
    }
  }
}