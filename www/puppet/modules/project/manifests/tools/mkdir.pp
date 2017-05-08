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
define project::tools::mkdir (
  # eg. $project::www_folder/cache/local
  $folder = $title,
  # eg. $project::www_folder/cache
  $parent = $project::www_folder,
  $mode   = '0775',

) {


  #
  # * ensure parent folder exists
  #
  if !defined(File[$parent]) {
    file { $parent:
      ensure => directory,
      owner  => $project::user,
      group  => $project::apache_user,
      mode   => $mode,
      # require => File[$parent],
    }
  }


  #
  # * ensure folder exists
  #
  if !defined(File[$folder]) {
    file { $folder:
      ensure  => directory,
      owner   => $project::user,
      group   => $project::apache_user,
      mode    => $mode,
      require => File[$parent],
    }
  }

}
