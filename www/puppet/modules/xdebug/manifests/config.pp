# = Class: xdebug::config
#
# Description
#
# === Parameters
#
# Also see http://xdebug.org/docs/all_settings
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
#  class { 'xdebug':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define xdebug::config (
  $project = $title,
  $default_enable          = 1,
  $remote_autostart        = 0,
  $remote_connect_back     = 1, # default = 0
  $remote_enable           = 1,
  $remote_handler          = 'dbgp',
  $remote_host             = 'localhost', # default = localhost
  $remote_mode             = 'req',
  $remote_port             = 9000,
  $show_exception_trace    = 0,
  $show_local_vars         = 0,
  $var_display_max_data    = 10000,
  $var_display_max_depth   = 20,
  $max_nesting_level       = 250,
  $profiler_enable         = 1, # default = 0
  $profiler_enable_trigger = 1,
  $profiler_output_name    = "cachegrind.out.%t.%p",
  $profiler_output_dir     = '/var/www/profiler_output',
  $idekey                  = 'ide-xdebug'
) {

  $settings = {
    default_enable          => $default_enable,
    remote_autostart        => $remote_autostart,
    remote_connect_back     => $remote_connect_back,
    remote_enable           => $remote_enable,
    remote_handler          => $remote_handler,
    remote_host             => $remote_host,
    remote_mode             => $remote_mode,
    remote_port             => $remote_port,
    show_exception_trace    => $show_exception_trace,
    show_local_vars         => $show_local_vars,
    var_display_max_data    => $var_display_max_data,
    var_display_max_depth   => $var_display_max_depth,
    max_nesting_level       => $max_nesting_level,
    profiler_enable         => $profiler_enable,
    profiler_enable_trigger => $profiler_enable_trigger,
    profiler_output_name    => $profiler_output_name,
    profiler_output_dir     => $profiler_output_dir,
    idekey                  => $idekey
  }

  $template = 'xdebug/ini.erb'
  $ensure   = 'present'

  file { '/etc/php/7.0/mods-available/xdebug.ini':
    ensure  => 'present',
    content => template($template),
    require => Package['xdebug'],
    notify => Service['php7.0-fpm']
  }

}
