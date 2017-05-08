# = Class: server::packages::misc_useful
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
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
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class server::packages::misc_useful {

  $packages = [
    # send http/https requests
    'curl',
    # version control
    'git',
    # random password generator
    'pwgen',
    # simple MTA (mail transfer agent) and sendmail command provider which simply dumps your email output forward to SMTP service
    #'nullmailer',
    # tool for manipulating PDF documents (for online claiming provider agreement)
    'pdftk',

    # run 32bit programs in 64bit OS - ensure `dpkg --add-architecture i386 && apt-get update` has been run first
    'libc6-i386',

    # required by medicare adaptor to avoid this error: libz.so.1: cannot open shared object file: No such file or directory
    'zlib1g:i386',
    # required by medicare adaptor to avoid this error: libstdc++.so.5: cannot open shared object file: No such file or directory
    'libstdc++5:i386',

  ]

  package { $packages:
    ensure  => latest,
    require => Exec['apt-update'],
  }

}
