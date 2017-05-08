# == Class: github
#
# Full description of class github here.
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
# include github
#
# === Authors
#
# Matthew Hansen
#
define github::credentials (
  $user        = $title,
  $github_file = 'github-ssh.tar.bz2',
) {

  $source = "$project::bucket/ssh/$project::env/$github_file"
  $target = "$project::user_home/$github_file"

  # download from s3
  exec { 'download-github-credentials':
    unless  => "test -f $project::user_home/.ssh/id_rsa.pub",
    # unless  => "ssh -T git@github.com 2>/dev/null",
    command => "/usr/local/bin/aws s3 cp s3://$source $target --profile build_script",
    #user    => $project::user,
    creates => "$project::user_home/$github_file",
    timeout => '90',
    require => Exec['install-aws-cli'],
  }

  # extract compressed file
  exec { 'extract-github-credentials':
    # unless  => "ssh -T git@github.com",
    unless  => "test -f $project::user_home/.ssh/id_rsa.pub",
    cwd     => $project::user_home,
    command => "/bin/tar jxvf $project::user_home/$github_file",
    user    => $project::user,
    creates => "$project::user_home/.ssh/id_rsa.pub",
    timeout => '90',
    require => Exec['download-github-credentials'],
  }

  # remove compressed file
  exec { 'remove-github-credentials':
    cwd     => $project::user_home,
    command => "/bin/rm -rf $project::user_home/$github_file",
    user    => $project::user,
    require => Exec['extract-github-credentials'],
  }

  # # permissions
  file { 'git-ssh-permissions':
    path    => "$project::user_home/.ssh",
    # ensure => directory,
    # TODO: sudo chmod 600 /home/ubuntu/.ssh/*
    mode    => '600',
    recurse => true,
    owner   => $project::user,
    require => Exec['extract-github-credentials'],

  }

  exec { 'git-user-name':
    # this will run as root user unless we set the user (eg. ubuntu)
    user        => $project::user,
    command     => "/usr/bin/git config --global user.name '$project::git_username'",
    environment => "HOME=$project::user_home",
    require     => File['git-ssh-permissions'],
  }


  exec { 'git-user-email':
    # this will run as root user unless we set the user (eg. ubuntu)
    user        => $project::user,
    command     => "/usr/bin/git config --global user.email '$project::git_email'",
    environment => "HOME=$project::user_home",
    require     => Exec['git-user-name'],
  }



  $ssh_path = "${project::git_ssh}:${project::repo_team}/$project::server_build_repo.git"
  exec { 'server-build-remote-url':
    # this will run as root user unless we set the user (eg. ubuntu)
    user        => $project::user,
    command     => "/usr/bin/git remote set-url origin $ssh_path",
    cwd         => "$project::projects_folder/$project::server_build_repo",
    environment => "HOME=$project::user_home",
    require     => Exec['git-user-email'],
  }

  exec { 'server-build-git-pull':
    # this will run as root user unless we set the user (eg. ubuntu)
    user        => $project::user,
    command     => "/usr/bin/git pull",
    cwd         => "$project::projects_folder/$project::server_build_repo",
    environment => "HOME=$project::user_home",
    require     => Exec['server-build-remote-url'],
  }



  # file { 'ssh-folder-permissions':
  #   path => "$project::user_home/.ssh",
  #   ensure => directory,
  #   mode   => '700',
  #   owner  => $project::user,
  #   require => File['git-ssh-permissions'],
  #
  # }
}

