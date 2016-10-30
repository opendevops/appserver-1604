# = Class: dashboard:config
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
# $dashboardDomain = 'dashboard'
# $projectsFolder = '/vagrant/www/projects'
# $interface = 'enp0s3'
# dashboard::config { 'dashboard_config': path => "$projectsFolder/$dashboardDomain", interface => $interface }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define dashboard::config (
  $path = '/vagrant/www/projects/appserver1604',
  $php_info  = true,
  $monitor   = true,
  $interface = 'eth1',
  $opcache   = true,
  $memcached = true,
  $redis     = false,
) {

  # Ensure dashboard path exists
  if ! defined (File[$path]) {
    file { "$path":
      ensure => 'directory',
      recurse => true,
    }
  }

  if $php_info {
    $php_info_link = '<li><a href="/info.php">php info</a></li>'
    file { "$path/info.php":
      ensure  => file,
      path    => "$path/info.php",
      source  => "puppet:///modules/dashboard/info.php",
    }
  } else {
    $php_info_link = ''
  }

  if $monitor {
    $monitor_link = '<li><a href="/monitor.php">monitor</a></li>'
    file { "$path/monitor.html":
      ensure    => file,
      path      => "$path/monitor.php",
      content   => template('dashboard/monitor.php.erb'),
    }

    file { "$path/monitor.py":
      ensure    => file,
      path      => "$path/monitor.py",
      content   => template('dashboard/monitor.py.erb'),
    }

    # copy the start monitor script
    file { "$path/start-monitor.sh":
      ensure  => file,
      path    => "$path/start-monitor.sh",
      source  => "puppet:///modules/dashboard/start-monitor.sh",
      require => File["$path/monitor.py"],
    }


  } else {
    $monitor_link = ''
  }

  if $opcache {
    $opcache_link = '<li><a href="/opcache.php">opcache</a></li>'

    file { "$path/opcache.php":
      ensure  => file,
      path    => "$path/opcache.php",
      source  => "puppet:///modules/dashboard/opcache.php",
      # require => Package["apache2"],
      # subscribe => Package["apache2"],
    }
  } else {
    $opcache_link = ''
  }

  if $memcached {
    $memcached_link = '<li><a href="/memcached.php">memcached</a></li>'

    file { "$path/memcached.php":
      ensure  => file,
      path    => "$path/memcached.php",
      source  => "puppet:///modules/dashboard/memcached.php",
      # require => Package["apache2"],
      # subscribe => Package["apache2"],
    }
  } else {
    $memcached_link = ''
  }

  if $redis {
    $redis_link = '<li><a href="/redis.php">redis</a></li>'
  } else {
    $redis_link = ''
  }


  file { "$path/index.html":
    ensure    => file,
    path      => "$path/index.html",
    content   => template('dashboard/index.html.erb'),
  }
}
