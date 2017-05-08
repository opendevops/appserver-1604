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
#     githubPath => '/vagrant/www/githubs'
#   }
#
# === Authors
#
# Matthew Hansen
#
define github::repo (
  # adaptor
  $repo         = '',
  # eg. /home/ubuntu/projects/integration
  $repo_folder = $project::projects_folder,
) {

  #
  # * ensure github has been setup / credentials etc
  #
  if !defined(Github::Credentials[$project::user]) {
    github::credentials { $project::user: }
  }



  #
  # * github ssh path
  #
  # git@github.com:healthkit/adaptor.git
  $ssh_path = "${project::git_ssh}:${project::repo_team}/$repo.git"


  # alreday created here: www/puppet/modules/project/manifests/init.pp
  if !defined(File[$repo_folder]) {
    file { "$repo_folder":
      # path => $github_path,
      ensure => 'directory',
      mode   => '0755',
      # recurse => true,
      owner  => $project::user,
      group  => $project::apache_user,
    }
  }

  # extract compressed file
  exec { "clone-$repo_folder/$repo":
    # unless  => "ssh -T git@github.com",
    # unless  => "test -f $user_home/.ssh/id_rsa.pub",
    # /usr/bin/git clone git@github.com:healthkit/fe2.git
    cwd     => $repo_folder,
    command => "sudo -u $project::user /usr/bin/git clone $ssh_path",
    # user    => $user,
    creates => "$repo_folder/$repo",
    timeout => '180',
    require => [Github::Credentials[$project::user], File["$repo_folder"]],
    # require => File["$repo_folder"],
    # require => Github::Repo[$repo],
  }

}