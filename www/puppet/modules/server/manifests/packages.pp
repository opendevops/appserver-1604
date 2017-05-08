# = Class: server::packages
#
# Description
#
# === Parameters
#
# [*compression*]
#   zip, bzip2
#
# [*logrotate*]
#   logrotate
#
# [*misc_useful*]
#   curl, git, pwgen, libc6-i386
#
# [*monitor*]
#   helps to manage your log files
#
# [*security*]
#   sysstat, nload, htop
#
# [*text_editor*]
#   nano, vim
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
#
# === Authors
#
# Matthew Hansen
#
define server::packages (
  $compression = true,
  $log         = true,
  $misc_useful = true,
  $monitor     = true,
  $security    = true,
  $fonts       = true,
  $text_editor = true,
) {

  if $compression {
    include server::packages::compression
  }

  if $fonts {
    include server::packages::fonts
  }

  if $log {
    include server::packages::log
  }

  if $monitor {
    include server::packages::monitor
  }

  if $misc_useful {
    include server::packages::misc_useful
  }

  if $security {
    include server::packages::security
  }

  if $text_editor {
    include server::packages::text_editor
  }
}
