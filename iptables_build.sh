#!/bin/bash

#
#   Developer:      Are Hansen
#   Date:           2014, May 5
#
#   Usage:
#   This script is executed by the debconf installer and takes care of configuration,
#   package installation, updating and upgrading of Bifrozt during installation.
#
#   Copyright (c) 2014, Are Hansen - Honeypot Development
# 
#   All rights reserved.
# 
#   Redistribution and use in source and binary forms, with or without modification, are
#   permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice, this list
#   of conditions and the following disclaimer.
# 
#   2. Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND AN
#   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#   OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
#   SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
#   STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
#   THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

declare -rx ipt="/sbin/iptables"

# - IP addresses
declare loopback="127.0.0.1/32"
declare multicast="224.0.0.1/32"
declare network="10.199.115.0/24"
declare gateway="10.199.115.1/32"
declare broadcast="10.199.115.255/32"

# - Macros
declare drop_new="-m state --state NEW -m recent --update"
declare state_new="-m state --state NEW -m recent --set -m limit"
declare tcp_frwd="$ipt -A FORWARD -s $network -o eth0 -p tcp -m tcp"
declare udp_frwd="$ipt -A FORWARD -s $network -o eth0 -p udp -m udp"

# - Clear out existing rules
$ipt -F
$ipt -F INPUT
$ipt -F OUTPUT
$ipt -F FORWARD
$ipt -F -t mangle
$ipt -F -t nat
$ipt -X

# - Default policies
$ipt -P INPUT DROP
$ipt -P OUTPUT ACCEPT
$ipt -P FORWARD ACCEPT

# ================ INPUT
$ipt -A INPUT -i lo -j ACCEPT
$ipt -A INPUT -d $multicast -j DROP
$ipt -A INPUT -s $network -i eth1 -j ACCEPT
$ipt -A INPUT -d $broadcast -i eth1 -j ACCEPT
$ipt -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
$ipt -A INPUT -i eth0 -p tcp -j ACCEPT
$ipt -A INPUT -i eth0 -p udp -j ACCEPT
$ipt -A INPUT -i eth0 -p icmp -j ACCEPT
$ipt -A INPUT -s $network -d $gateway -i eth1 -p tcp -m tcp --dport 22 -j DROP
$ipt -A INPUT -i eth0 -p tcp -m tcp --dport 22 -j LOG --log-prefix "BIFROZT - HonSSH: " --log-level 7
$ipt -A INPUT -i eth0 -p tcp -m tcp --dport 60037 -j ACCEPT

# ================ FORWARD
$tcp_frwd --dport 20:21 $state_new --limit 6/sec --limit-burst 6 -j LOG --log-prefix "BIFROZT - FTP: " --log-level 7
$tcp_frwd --dport 20:21 $drop_new --seconds 1 --hitcount 6 -j DROP
$udp_frwd --dport 53 $state_new --limit 12/sec --limit-burst 12 -j LOG --log-prefix "BIFROZT - DNS udp: " --log-level 7
$udp_frwd --dport 53 $drop_new --seconds 1 --hitcount 12 -j DROP
$tcp_frwd --dport 80 $state_new --limit 6/sec --limit-burst 6 -j LOG --log-prefix "BIFROZT - HTTP: " --log-level 7
$tcp_frwd --dport 80 $drop_new --seconds 1 --hitcount 6 -j DROP
$tcp_frwd --dport 443 $state_new --limit 6/sec --limit-burst 6 -j LOG --log-prefix "BIFROZT - HTTPS: " --log-level 7
$tcp_frwd --dport 443 $drop_new --seconds 1 --hitcount 6 -j DROP
$tcp_frwd --dport 6660:6667 $state_new --limit 6/sec --limit-burst 6 -j LOG --log-prefix "BIFROZT - IRC: " --log-level 7
$tcp_frwd --dport 6660:6667 $drop_new --seconds 1 --hitcount 6 -j DROP
$tcp_frwd $state_new --limit 15/min --limit-burst 6 -j LOG --log-prefix "BIFROZT - Data control TCP: " --log-level 7
$tcp_frwd $drop_new --seconds 60 --hitcount 15 -j DROP
$udp_frwd $state_new --limit 15/min --limit-burst 6 -j LOG --log-prefix "BIFROZT - Data control UDP: " --log-level 7
$udp_frwd $drop_new --seconds 60 --hitcount 15 -j DROP

$ipt -A FORWARD -i eth1 -p tcp -j ACCEPT
$ipt -A FORWARD -i eth1 -p udp -j ACCEPT
$ipt -A FORWARD -i eth1 -j ACCEPT
$ipt -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# ================ OUTPUT
$ipt -A OUTPUT -s $loopback -j ACCEPT
$ipt -A OUTPUT -o lo -j ACCEPT
$ipt -A OUTPUT -s $gateway -j ACCEPT
$ipt -A OUTPUT -o eth1 -j ACCEPT
$ipt -A OUTPUT -o eth0 -j ACCEPT

