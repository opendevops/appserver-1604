# == Class: phpmetrics
#
# Full description of class phpmetrics here.
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
#   ::phpmetrics{ 'phpmetrics': target_dir => '/usr/local/bin', force_update => false}
#
# === Authors
#
# Matthew Hansen
#
define phpmetrics (
  $target_dir      = "/usr/local/bin",
  $version         = '2.0.0',
  $phpmetrics_file = 'phpmetrics',
  $timeout         = 60,
) {

  $s3_folder = "$project::bucket/phpmetrics/$version"
  $source = "$s3_folder/$phpmetrics_file.phar"
  $target = "$target_dir/$phpmetrics_file"

  # download phpmetrics from s3
  exec { 'download-phpmetrics':
    # don't run if file already exists
    unless  => "test -f $target_dir/$phpmetrics_file",
    command => "/usr/local/bin/aws s3 cp s3://$source $target --profile build_script",
    #user    => $project::apache_user,
    # dont run if phpmetrics file exists
    creates => "$target_dir/$phpmetrics_file",
    timeout => $timeout,
    require => Exec['install-aws-cli'],
  }

}