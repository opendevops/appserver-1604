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
#    servers  => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
#
define project::site (
  # eg. www.test.dev
  $domain        = $title,
  $vhost_webroot = '',
  # # eg. /vagrant/www/projects
  # $projects_folder = $project::projects_folder,
  # # eg. test/webroot (relative to project folder)
  # $project_folder         = '',
  # # eg. /var/www/logs
  # $document_root   = '',
  # eg. scripts/setup.sh
  $script_cwd    = '',
  $setup_script  = '',
  # $create_vhost     = true,
  # $use_combined_log = false,
  $access_log    = '',
  $error_log     = '',
) {


  #
  # * VHOST - eg. www.test.dev
  #
  if !defined(Apache::Vhost[$domain]) {
    apache::vhost { $domain:
      vhost_webroot => $vhost_webroot,
      access_log    => $access_log,
      error_log     => $error_log,
    }
  }


  #
  # * Setup Script
  #
  if $setup_script != '' {
    $script = "$vhost_webroot/$setup_script"
    if !defined(Exec["$vhost_webroot/$setup_script"]) {
      exec { "$vhost_webroot/$setup_script":
        # this will run as root user unless we set the user (eg. ubuntu)
        user    => $project::user,
        command => "$vhost_webroot/$setup_script",
        cwd     => $vhost_webroot,
        # environment => "HOME=$project::user_home",
        # require     => Github::Repo["$repo_name"],
      }
    }
  }

}
