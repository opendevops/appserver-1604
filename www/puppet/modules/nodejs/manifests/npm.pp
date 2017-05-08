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
define nodejs::npm (
  $project = $title
) {


  # install less - Compiled CSS
  # https://www.npmjs.com/package/less
  exec { 'install_less':
    command => 'npm install -g less',
    creates => "/usr/local/bin/lessc",
    user    => 'root',
    require => Package['npm']
  }

  #TODO: removing because there are errors: https://github.com/healthkit/server-build/issues/108
  # # used for fe2 deploy
  # # install minifier - JavaScript/css minifier using minifycss and minifyjs
  # # https://github.com/fizker/minifier
  # # https://www.npmjs.com/package/minifier
  # exec { 'install_minifier':
  #   command => 'npm install -g minifier',
  #   creates => "/usr/local/bin/minify",
  #   user    => 'root',
  #   require => Package['npm']
  # }

  # symfony assetic compress js
  # see http://symfony.com/doc/current/assetic/uglifyjs.html
  exec { 'install_uglifyjs':
    command => 'npm install -g uglify-js',
    creates => "/usr/local/bin/uglifyjs",
    user    => 'root',
    require => Package['npm']
  }

  # symfony assetic compress css
  # see http://symfony.com/doc/current/assetic/uglifyjs.html#install-configure-and-use-uglifycss
  exec { 'install_uglifycss':
    command => 'npm install -g uglifycss',
    creates => "/usr/local/bin/uglifycss",
    user    => 'root',
    require => Package['npm']
  }

  # install gulp - Streaming build system
  # https://www.npmjs.com/package/gulp
  exec { 'install_gulp':
    command => 'npm install -g gulp',
    creates => "/usr/local/bin/gulp",
    user    => 'root',
    require => Package['npm'],
  }
}
