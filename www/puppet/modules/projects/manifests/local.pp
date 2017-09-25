# == Class: projects::build
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
#    servers  => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Opendevops
#
# === Copyright
#
# Copyright 2016 Opendevops
#
define projects::local(
  # eg. appserver.dev
  $project_name      = $title,
  # $domain            = 'www.appserver1604.dev',
  $projects_root     = '/vagrant/www/projects',
  # $project_path      = '/vagrant/www/projects/appserver',
  # $project_webroot   = '/vagrant/www/projects/appserver/web',
  # $symlinked_webroot = '/var/www/appserver',
  $user              = 'vagrant',
  $group             = 'www-data',
  $repo              = 'appserver',
  $branch            = 'master',
) {

  apache::vhost { 'appserver1604.dev':
    domain            => 'appserver1604.dev',
    project_webroot   => "$projects_root/appserver/web",
    project_path      => "$projects_root/appserver",
    projects_root     => $projects_root,
    ensure            => 'directory',
  }

  apache::vhost { 'www.invoice.dev':
    domain            => 'www.invoice.dev',
    project_webroot   => "$projects_root/apps/invoice",
    project_path      => "$projects_root/apps/invoice",
    projects_root     => $projects_root,
    ensure            => 'directory',
  }

  apache::vhost { 'www.angular4.dev':
    domain            => 'www.angular4.dev',
    project_webroot   => "$projects_root/study/angular4",
    project_path      => "$projects_root/study/angular4",
    projects_root     => $projects_root,
    ensure            => 'directory',
  }


  #
  # apache::vhost { 'www.dashboard.dev':
  #   domain            => 'www.dashboard.dev',
  #   project_webroot   => "$projects_root/dashboard/ui-angular2/dist/prod",
  #   project_path      => "$projects_root/dashboard/ui-angular2",
  #   projects_root     => $projects_root,
  #   ensure            => 'directory',
  # }
  #
  # apache::vhost { 'api.hiphiparray.dev':
  #   domain            => 'api.hiphiparray.dev',
  #   project_webroot   => "$projects_root/hiphiparray/api-symfony3/web",
  #   project_path      => "$projects_root/hiphiparray/api-symfony3",
  #   projects_root     => $projects_root,
  #   ensure            => 'directory',
  # }
  #
  # apache::vhost { 'react.hiphiparray.dev':
  #   domain            => 'react.hiphiparray.dev',
  #   project_webroot   => "$projects_root/hiphiparray/ui-react/public",
  #   project_path      => "$projects_root/hiphiparray/ui-react/public",
  #   projects_root     => $projects_root,
  #   ensure            => 'directory',
  # }
  # apache::vhost { 'angular2.hiphiparray.dev':
  #   domain            => 'angular2.hiphiparray.dev',
  #   project_webroot   => "$projects_root/hiphiparray/ui-angular2",
  #   project_path      => "$projects_root/hiphiparray/ui-angular2",
  #   projects_root     => $projects_root,
  #   ensure            => 'directory',
  # }

}