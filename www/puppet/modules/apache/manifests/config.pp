# = Class: apache::mods
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
define apache::config (
  #
  # * Apache performance config
  #
  # https://httpd.apache.org/docs/2.4/mod/mpm_common.html#serverlimit
  # http://www.devside.net/articles/apache-performance-tuning
  # http://oxpedia.org/wiki/index.php?title=Tune_apache2_for_more_concurrent_connections
  # http://docs.escenic.com/ece-server-admin-guide/5.3/why_a_web_server_tuning.html


  #
  # * apache2.conf
  #
  # Timeout 300,
  $timeout                   = 300,
  # KeepAlive On,
  $keep_alive                = 'On',
  # default: MaxKeepAliveRequests 100,
  $max_keep_alive_requests   = 10000,
  # KeepAliveTimeout 5,
  # When using AWS ELB, ensure this value is higher than ELB timeout
  $keep_alive_timeout        = 300,
  # eg. worker or event
  $mpm_module                = 'worker',


  #
  # * mpm_worker.conf
  #
  # Declares the maximum number of running apache processes. If you change this value you have to restart the daemon.
  $server_limit              = 250,
  # StartServers 2,
  # The number of processes to start initially when starting the apache daemon.
  $start_servers             = 40,
  # MinSpareThreads 25,
  # This regulates how many threads may stay idle without being killed. Apache regulates this on its own very well with default values.
  $min_spare_threads         = 75,
  # MaxSpareThreads 75,
  # This regulates how many threads may stay idle without being killed. Apache regulates this on its own very well with default values.
  $max_spare_threads         = 250,
  # ThreadLimit 64,
  # ThreadsPerChild can be configured as high as this value during runtime. If you change this value you have to restart the daemon.
  $thread_limit              = 64,
  # ThreadsPerChild 25,
  # How many threads can be created per process. Can be changed during a reload.
  $threads_per_child         = 32,
  # MaxRequestWorkers 150,
  # (aka MaxClients) - This declares how many concurrent connections we provide. Devided by ThreadsPerChild you get the suitable ServerLimit value. May be less than ServerLimit * ThreadsPerChild to reserve some resources that can be engaged during runtime with increasing MaxClients and reloading the configuration.
  $max_request_workers       = 8000,
  # Defines the number of Connections that a process can handle during its lifetime (keep-alives are counted once). After that it will be killed. This can be used to prevent possible apache memory leaks. If set to 0 the lifetime is infinite.
  $max_connections_per_child = 16000,
) {


  file { '/etc/apache2/apache2.conf':
    ensure    => file,
    path      => '/etc/apache2/apache2.conf',
    content   => template('apache/apache2.conf.erb'),
    require   => Package["apache2"],
    subscribe => Package["apache2"],
  }


  # Disable MPM_PREFORK module
  exec { "a2dismod mpm_prefork":
    notify => Service['apache2'],
    require => Package['apache2'],
  }



  if $mpm_module == 'worker' {
    # Disable MPM_EVENT module
    exec { "a2dismod mpm_event":
      notify => Service['apache2'],
      require => Package['apache2'],
    }

    # Enable MPM_WORKER module (faster than prefork + same as event with ssl)
    exec { "a2enmod mpm_worker":
      notify => Service['apache2'],
      require => Exec['a2dismod mpm_prefork', 'a2dismod mpm_event'],
    }

    file { '/etc/apache2/mods-available/mpm_worker.conf':
      ensure    => file,
      path      => '/etc/apache2/mods-available/mpm_worker.conf',
      content   => template('apache/mpm_worker.conf.erb'),
      require   => Package["apache2"],
      subscribe => Package["apache2"],
    }

  } else {
    # else use mpm_event

    # Disable MPM_WORKER module
    exec { "a2dismod mpm_worker":
      notify => Service['apache2'],
      require => Package['apache2'],
    }

    # Enable MPM_EVENT module (faster than prefork + same as event with ssl)
    exec { "a2enmod mpm_event":
      notify  => Service['apache2'],
      require => Exec['a2dismod mpm_prefork', 'a2dismod mpm_event'],
    }


    file { '/etc/apache2/mods-available/mpm_event.conf':
      ensure    => file,
      path      => '/etc/apache2/mods-available/mpm_event.conf',
      content   => template('apache/mpm_event.conf.erb'),
      require   => Package["apache2"],
      subscribe => Package["apache2"],
    }

  }

}
