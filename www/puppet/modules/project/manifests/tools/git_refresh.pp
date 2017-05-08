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
define project::tools::git_refresh (
  # eg. /home/ubuntu/repos/healthkit
  $project_folder   = $title,
  $repo_name        = '',
  $branch           = '',
  $checkout_require = '',
) {

  #
  # * git checkout require
  #
  if $checkout_require == '' {
    $git_checkout_require = Github::Repo["$repo_name"]
  } else {
    $git_checkout_require = $checkout_require
  }


  #
  # * UPDATE BRANCH
  #
  if !defined(Exec["git-checkout-$project_folder"]) {
    exec { "git-checkout-$project_folder":
      # this will run as root user unless we set the user (eg. ubuntu)
      user        => $project::user,
      command     => "/usr/bin/git checkout $branch",
      cwd         => $project_folder,
      environment => "HOME=$project::user_home",
      require     => $git_checkout_require,
    }
  }
  if !defined(Exec["git-pull-$project_folder"]) {
    exec { "git-pull-$project_folder":
      # this will run as root user unless we set the user (eg. ubuntu)
      user        => $project::user,
      command     => "/usr/bin/git pull",
      cwd         => $project_folder,
      environment => "HOME=$project::user_home",
      require     => Exec["git-checkout-$project_folder"],
    }
  }

}
