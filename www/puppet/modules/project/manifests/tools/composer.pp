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
define project::tools::composer (
  # eg. /home/ubuntu/repos/healthkit
  $project_folder = $title,
  $exec_require   = '',
) {



  #
  # * UPDATE BRANCH
  #
  if !defined(Exec["composer-install-$project_folder"]) {
    exec { "composer-install-$project_folder":
      user        => $project::user,
      command     => "/usr/local/bin/composer install --no-scripts --optimize-autoloader",
      cwd         => $project_folder,
      environment => "HOME=$project::user_home",
      timeout     => '300',
      require     => $exec_require,
    }
  }
}
