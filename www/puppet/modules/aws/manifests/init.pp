# == Class: aws
#
# Full description of class aws here.
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
# include aws
#
# === Authors
#
# Matthew Hansen
#
class aws (
  $source_url = 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip',
  $source_dir = '/opt/',
  $install_dir = '/usr/local/bin',
  $timeout = 90,
) {

  $packages = [
    Package['curl'],
    Package['unzip'],
  ]

  # download aws cli
  exec { 'get-aws-cli':
    # command => "sudo /usr/bin/curl --silent --show-error --fail --location ${source_url} --output ${source_dir} awscli-bundle.zip",
    command     => "/usr/bin/wget --quiet $source_url",
    cwd         => $source_dir,
    creates     => "${source_dir}awscli-bundle.zip",
    user        => 'root',
    require     => $packages,
    timeout     => $timeout
  }
  # unzip downloaded cli
  exec { 'unzip-aws-cli':
    command => "sudo /usr/bin/unzip ${source_dir}awscli-bundle.zip -d ${source_dir}",
    user    => 'root',
    creates => "${source_dir}awscli-bundle/",
    require => Exec['get-aws-cli'],
  }
  # install aws cli to usr/local/bin
  exec { 'install-aws-cli':
    command => "sudo ${source_dir}awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws",
    user    => 'root',
    creates => "/usr/local/bin/aws",
    require => Exec['unzip-aws-cli'],
  }

  #
  # * User AWS CLI credentials (for S3)
  #
  file { "/home/$project::user/.aws":
    ensure => directory,
    mode   => '0700',
    owner  => $project::user,
    group  => $project::user,
  }
  file { "/home/$project::user/.aws/credentials":
    mode   => "0600",
    owner  => $project::user,
    group  => $project::user,
    source => "puppet:///modules/aws/credentials",
    require => File["/home/$project::user/.aws"],
  }
  file { "/home/$project::user/.aws/config":
    mode    => "0600",
    owner   => $project::user,
    group   => $project::user,
    source  => "puppet:///modules/aws/config",
    require => File["/home/$project::user/.aws/credentials"],
  }

  #
  # * Root AWS CLI credentials (for S3)
  #
  file { "/root/.aws":
    ensure => directory,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }
  file { "/root/.aws/credentials":
    mode    => "0600",
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/aws/credentials",
    require => File["/root/.aws"],
  }
  file { "/root/.aws/config":
    mode    => "0600",
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/aws/config",
    require => [File["/root/.aws/credentials"], File["/home/$project::user/.aws/config"]],
  }
}
