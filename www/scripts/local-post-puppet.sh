#!/usr/bin/env bash






# MAILPARSE

#PHP Warning:  PHP Startup: Unable to load dynamic library '/usr/lib/php/20151012/mailparse.so' - /usr/lib/php/20151012/mailparse.so
#sudo pecl install mailparse


# DISABLE IPV6

#sudo nano /etc/sysctl.conf
#insert the following lines at the end:
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1

#sudo sysctl -p



