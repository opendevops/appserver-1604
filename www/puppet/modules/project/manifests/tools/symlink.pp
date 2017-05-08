# == Class: project::tools::symlink
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
define project::tools::symlink (
  # eg. integration/healthkit, integration/fe2, integration/tools
  $link_path   = $title,
  # eg. healthkit, fe2, dashboard
  $target_path = '',

) {


  #
  # * create link
  #
  if !defined(File[$link_path]) {
    file { $link_path:
      ensure => link,
      owner  => $project::apache_user,
      group  => $project::user,
      # target   => "/home/$user/fe",
      target => $target_path,
      # require => Project::Tools::Mkdir[$target_path],
      # require => [VCSREPO["$projectsFolder/$repo"], File[$symlinked_webroot]],
    }
  }

}
