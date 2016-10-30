# = Class: nodejs::npm
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
define nodejs::npm ($project = $title) {


  # install less - Compiled CSS
  # https://www.npmjs.com/package/less
  exec { 'install_less':
    command => 'npm install -g less',
    creates => '/usr/local/lib/node_modules/less',
    require => Package['npm']
  }

  # install uglifyjs - JavaScript parser, mangler/compressor and beautifier toolkit
  # https://www.npmjs.com/package/uglify-js
  exec { 'install_uglifyjs':
    command => 'npm install -g uglifyjs',
    creates => '/usr/local/lib/node_modules/uglifyjs/',
    require => Package['npm']
  }

  # install gulp - Streaming build system
  # https://www.npmjs.com/package/gulp
  exec { 'install_gulp':
    command => 'npm install -g gulp',
    require => Package['npm']
  }
}
