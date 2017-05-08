# = Class: php::config
#
# Description
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
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define php::config (
  # default: listen = /run/php/php7.0-fpm.sock
  $php_fpm_listen         = '127.0.0.1:9000',

  #
  # * Timeouts
  #
  # default: max_execution_time = 30
  $max_execution_time     = 300,
  # default: max_input_time = 60,
  $max_input_time         = 300,
  # default: default_socket_timeout = 60 (Default timeout for socket based streams)
  $default_socket_timeout = 300,
  # default: process_idle_timeout = 10s (only used only when pm is set to 'ondemand')
  $process_idle_timeout   = '300s',

  #
  # * PHP info config
  #
  # default: memory_limit = -1,
  $memory_limit           = '2048M',
  # default: display_errors = Off
  $display_errors         = 'Off',
  # default: display_startup_errors = Off
  $display_startup_errors = 'Off',
  # default: file_uploads = On
  $file_uploads           = 'On',
  # default: upload_max_filesize = 2M
  $upload_max_filesize    = '20M',
  # default: post_max_size = 8M
  $post_max_size          = '20M',
  # default: max_file_uploads = 20
  $max_file_uploads       = 20,
  # default: session_entropy_length = 32
  $session_entropy_length = 64,
  # default: realpath_cache_size = 32
  $realpath_cache_size    = '4096k',
  # default: realpath_cache_ttl = 120
  $realpath_cache_ttl     = '600',
  # default: gc_probability = 0
  $gc_probability         = 1,
  # default: gc_divisor = 1000
  $gc_divisor             = 100000,
  # default: gc_maxlifetime = 1440
  $gc_maxlifetime         = 604800,

  #
  # * PHP performance config
  #
  # https://serversforhackers.com/video/php-fpm-process-management
  #
  $process_manager        = 'dynamic',
  # The hard-limit total number of processes allowed
  $max_children           = '250',
  # When apache starts, have this many processes waiting for requests
  $start_servers          = '40',
  # Number spare processes apache will create
  $min_spare_servers      = '20',
  # Number spare processes attempted to create
  $max_spare_servers      = '40',
  # The number of requests each child process should execute before respawning.
  $max_requests           = '10000',
) {

  # copy php7.0-fpm config
  # modifys listen to "listen 127.0.0.1:9000" for php-fpm
  file { '/etc/php/7.0/fpm/pool.d/www.conf':
    ensure  => file,
    path    => '/etc/php/7.0/fpm/pool.d/www.conf',
    content => template('php/www.conf.erb'),
    notify  => Service['php7.0-fpm'],
    require => Package['php7.0-fpm'],
  }

  # PHP-FPM > PHP.INI
  file { '/etc/php/7.0/fpm/php.ini':
    # ensure      => file,
    path    => '/etc/php/7.0/fpm/php.ini',
    content => template('php/php.ini.erb'),
    notify  => Service['php7.0-fpm'],
    require => Package['php7.0-fpm'],
  }

  # PHP FPM CONF
  file { '/etc/php/7.0/fpm/php-fpm.conf':
    # ensure      => file,
    path    => '/etc/php/7.0/fpm/php-fpm.conf',
    content => template('php/php-fpm.conf.erb'),
    notify  => Service['php7.0-fpm'],
    require => Package['php7.0-fpm'],
  }

  # PHP CLI > PHP.INI
  file { '/etc/php/7.0/cli/php.ini':
    # ensure      => file,
    path    => '/etc/php/7.0/cli/php.ini',
    content => template('php/php.ini.erb'),
    notify  => Service['php7.0-fpm'],
    require => Package['php7.0-fpm'],
  }

}
