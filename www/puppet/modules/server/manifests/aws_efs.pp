# = Class: server::aws_efs
#
# This class
#
# == Variables:
#
# Refer to
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
define server::aws_efs (
  # eg. efs_endpoint = fs-9a0ce9a3.efs.ap-southeast-2.amazonaws.com
  $efs_endpoint = $title,
  $efs_folder   = '/var/www/efs',
  $mount_params = 'nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2',
) {

  # install for AWS Elastic File System
  package { 'nfs-common':
    ensure  => latest,
    require => Exec['apt-update'],
  }

  # Ensure folder exists
  file { "/var/www/efs":
    owner   => $project::user,
    group   => $project::user,
    mode    => '0700',
    ensure  => directory,
    recurse => true,
  }

  #
  # * mount efs
  #
  exec { 'mount-efs':
    # don't run if file already exists
    unless  => "test -f $target_dir/wkhtmltoimage",
    # eg. mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2:/ /var/www/efs
    command => "mount -t nfs4 -o $mount_params $efs_endpoint:/ $efs_folder",
    user    => $project::user,
    creates => "$target_dir/wkhtmltoimage",
    timeout => '30',
    require => Exec['install-aws-cli'],
  }

}
