# == Class: project::build
#
# Full description of class projects here.
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
#  class { 'projects':
#    servers  => [ 'pool.ntp.org', 'ntp.tools.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
define project::tools::htaccess (
  # eg. /var/www/tools, /var/www/healthkit
  $webroot  = $title,
  # eg. tools
  $template = '',

) {

  if !defined(Project::Tools::Mkdir[$webroot]) {
    project::tools::mkdir { $webroot: mode => '0775' }

  }

  file { "$webroot/.htaccess":
    ensure  => present,
    path    => "$webroot/.htaccess",
    owner   => $project::user,
    group   => $project::apache_user,
    content => template("project/htaccess/$template.erb"),
    require => Project::Tools::Mkdir[$webroot],
  }


}
