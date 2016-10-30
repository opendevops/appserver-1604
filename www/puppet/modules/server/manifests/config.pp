# = Class: server::logrotate
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
define server::config (
  $iptables_forward_drop = true,
  # default: #net.ipv4.conf.all.accept_redirects = 0
  $acceptRedirectsIpv4 = 'net.ipv4.conf.all.accept_redirects = 0',
  # default: #net.ipv6.conf.all.accept_redirects = 0
  $acceptRedirectsIpv6 = 'net.ipv6.conf.all.accept_redirects = 0',
  # default: # net.ipv4.conf.all.secure_redirects = 1
  $secureRedirectsIpv4 = 'net.ipv4.conf.all.secure_redirects = 0',
  # weekly
  $rotationInterval = 'weekly',
  # 4
  $rotateCount = '4',
  # compress
  $compress = 'compress',
  # default: ''
  $delayCompress = 'deplaycompress',
) {


  # Change the default policy for "forward" to drop
  if $iptables_forward_drop {
    exec { 'iptables-forward-drop':
      command => "iptables -P FORWARD DROP",
      user    => 'root',
      # creates => $robo_full_path,
      # timeout => $download_timeout,
    }
  }


  # LOGROTATE
  $systemSpecificConfig = ''
  file { '/etc/logrotate.conf':
    path    => "/etc/logrotate.conf",
    # this sets up the relationship
    # notify  => Service['sshd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
    content => template('server/logrotate.conf.erb'),
  }

  # SYSCTL
  # Do not accept ICMP redirects (prevent MITM attacks)
  # Disable secure redirects
  file { '/etc/sysctl.conf':
    path    => "/etc/sysctl.conf",
    # this sets up the relationship
    # notify  => Service['sshd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    # require => Package['logrotate'],
    content => template('server/sysctl.conf.erb'),
  }
}
