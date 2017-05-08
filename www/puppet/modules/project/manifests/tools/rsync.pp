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
define project::tools::rsync (
  # eg. integration/healthkit, integration/fe2, integration/tools, user-manuals/au
  $project_folder = $title,
  # eg. healthkit, fe2, dashboard
  $repo_name      = '',
  $exec_require   = '',
) {


  #
  # * Copy healthkit repo to project folder
  #
  # rsync -rt /home/ubuntu/repos/healthkit/ /home/ubuntu/projects/integration/healthkit/
  # copy repo to project folder
  exec { "rsync-repo-$title":
    # unless  => "test -f $project::projects_folder/user-manuals/$title/",
    # -r is recursive and -t is preserve modification times
    command => "sudo /usr/bin/rsync -rt $project::project_folder/$repo_name/ $project::projects_folder/$project_folder",
    user    => $project::user,
    # eg. /home/ubuntu/projects/user-manual/au/.git
    # creates => "$project::projects_folder/$project_folder/.git",
    timeout => '90',
    # require => Exec["git-pull-$project::project_folder/$repo_name"],
    require => $exec_require,
  }


  #
  # * Project permissions
  #
  exec { "chown-project-$title":
    # eg. sudo /bin/chown -R www-data:ubuntu /home/ubuntu/projects/integration/dashboard
    command => "sudo /bin/chown -R $project::user:$project::apache_user $project::projects_folder/$project_folder",
    user    => $project::user,
    require => Exec["rsync-repo-$title"],
  }

}
