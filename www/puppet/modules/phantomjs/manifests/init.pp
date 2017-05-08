# == Class: phantomjs
#
# Full description of class phantomjs here.
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
# ::phantomjs{ 'phantomjs': version => '2.1.1', force_update => false }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define phantomjs (
  $package_version = '1.9.8',
  $target_dir      = '/opt',
  $install_dir     = '/usr/local/bin',
  $force_update    = false,
  $timeout         = 90,
) {


  $packages = [
    # Package['curl'],
    Package['bzip2'],
    Package['libfontconfig1']
  ]


  $s3_folder = "${project::bucket}/phantomjs/$package_version"
  $phantomjs_file = "phantomjs.tar.bz2"

  $source = "$s3_folder/$phantomjs_file"
  $target = "$target_dir/$phantomjs_file"

  # download phantomjs from s3
  exec { 'download-phantomjs':
    # don't run if file already exists
    unless  => "test -f $target_dir/phantomjs",
    command => "/usr/local/bin/aws s3 cp s3://$source $target --profile build_script",
    #user    => $project::user,
    # dont run if phantomjs_file file exist
    creates => "$target_dir/$phantomjs_file",
    timeout => $timeout,
    require => Exec['install-aws-cli'],
  }

  exec { 'create-phantomjs-folder':
    command => "mkdir ${target_dir}/phantomjs",
    user    => 'root',
    creates => "${target_dir}/phantomjs",
    require => Exec['download-phantomjs'],
  }

  # extract compressed file
  $tar_file = "--file=${target_dir}/phantomjs.tar.bz2"
  $tar_directory = "--directory=${target_dir}/phantomjs"
  exec { 'extract-phantomjs':
    unless  => "test -f $target_dir/phantomjs/bin/phantomjs",
    cwd     => $xero_folder,
    # eg. tar --extract --file=/opt/phantomjs.tar.bz2 --strip-components=1 --directory=/opt/phantomjs
    command => "tar --extract $tar_file --strip-components=1 $tar_directory",
    user    => 'root',
    creates => "$target_dir/phantomjs/bin/phantomjs",
    timeout => $timeout,
    require => [$packages, Exec['create-phantomjs-folder']],
  }

  file { "${install_dir}/phantomjs":
    ensure => link,
    owner  => $project::user,
    target => "$target_dir/phantomjs/bin/phantomjs",
    force  => true,
  }

  #
  # * only remove compressed file when we want to update phantomjs
  #
  if $force_update {
    # remove compressed file
    exec { 'remove-phantomjs-compressed-file':
      cwd     => $target_dir,
      command => "/bin/rm -rf $target_dir/$phantomjs_file",
      user    => 'root',
      require => Exec['extract-phantomjs'],
      notify  => Exec[ 'download-phantomjs' ],
    }
  }

}
