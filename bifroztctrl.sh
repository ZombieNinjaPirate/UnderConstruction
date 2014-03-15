#!/usr/bin/env bash


#
#   Bifrozt control and configuration script.
#
#   Date:     2014, March 15
#   Version:  PA-0.0.1
#
#
#   Copyright (c) 2014, Black September - Honeypot Development
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

#
# -------------------------------------------------- System configuration
#
function system_config()
{
clear

cat << _EOF_

        ------==== System Configuration ====------

                   1) Local keyboard layout.
                   2) Time zone settings.
                   3) Cronjobs.

                   M) Main menu.
                   Q) Quit.                

_EOF_

while true
do
    read -p '    Please make a selection: ' C1
    case $C1 in
        1)
            keyboard_config
            ;;
        2)
            timezone_config
            ;;
        3)
            cronjob_config
            ;;
        M)
            main_menu
            ;;
        Q)
            echo -e '\Bye bye!\n'
            exit 0
            ;;
        *)
            echo '    That is not a valid choice!!'
            ;;
    esac
done
}


# ---------- KEYBOARD
function keyboard_config()
{
}


# ---------- TIMEZONE
function timezone_config()
{
}


# ---------- CRONJOB
function cronjob_config()
{
}




#
# -------------------------------------------------- Network configuration
#
function network_config()
{
clear

cat << _EOF_

        ------==== System Configuration ====------

                   1) DHCP server.
                   2) Firewall.
                   3) Data control.

                   M) Main menu.
                   Q) Quit.

_EOF_

while true
do
    read -p '    Please make a selection: ' C
    case $C in
        1)
            dhcp_config
            ;;
        2)
            firewall_config
            ;;
        3)
            datactrl_config
            ;;
        M)
            main_menu
            ;;
        Q)
            echo -e '\Bye bye!\n'
            exit 0
            ;;
        *)
            echo '    That is not a valid choice!!'
            ;;
    esac
done
}


# ---------- DHCP
function dhcp_config()
{
}


# ---------- FIREWALL
function firewall_config()
{
}


# ---------- DATA CONTROL
function datactrl_config
{
}




#
# -------------------------------------------------- HonSSH Configuration
#
function honssh_config()
{
clear

cat << _EOF_

          ------==== HonSSH Configuration ====------

                     1) Edit honssh.cfg.
                     2) Create public/private keys.
                     3) Tarball - malware files.
                     4) Tarball - tty files.
                     5) Tarball - log files.
                     6) Start HonSSH at boot.
                     7) Update HonSSH.

                     M) Main menu.
                     Q) Quit.

_EOF_

while true
do
    read -p '    Please make a selection: ' C
    case $C in
        1)
            honssh_cfg
            ;;
        2)
            generate_keys
            ;;
        3)
            tar_malware
            ;;
        4)
            tar_tty
            ;;
        5)
            tar_log
            ;;
        6)
            honssh_boot
            ;;
        7)
            honssh_update
            ;;
        Q)
            echo -e '\Bye bye!\n'
            exit 0
            ;;
        *)
            echo '    That is not a valid choice!!'
            ;;
    esac
done
}


# ---------- HONSSH.CFG
#
function honssh_cfg()
{
    # - create a template file thats parsed by sed
    # - sed 's/FIELD_IN_CFG/USER_VALUE/g'
}


# ---------- GENERATE KEYS
#
function generate_keys()
{
}


# ---------- TARBALL - MALWARE
#
function tar_malware()
{
    # - create tarball in /Backups/MALWARE/YYYYMMDD_HHMMSS_honssh_malware.tar.gz
    # - compare md5sum against existing tarballs
    # - delete newest tarball if matching md5sum
}


# ---------- TARBALL - TTY
#
function tar_tty()
{
    # - create tarball in /Backups/TTY/YYYYMMDD_HHMMSS_honssh_tty.tar.gz
    # - compare md5sum against existing tarballs
    # - delete newest tarball if matching md5sum
}


# ---------- TARBALL - LOG
#
function tar_log()
{
    # - create tarball in /Backups/LOGS/YYYYMMDD_HHMMSS_honssh_log.tar.gz
    # - compare md5sum against existing tarballs
    # - delete newest tarball if matching md5sum
}


# ---------- START AT BOOT
#
function honssh_boot()
{
    # - add variable in menu that shows if this is active or not
}


# ---------- HONSSH UPDATE
#
function honssh_update()
{
    # - store md5sum of the first files that are pulled down
    #   and use the md5sums to compare against the new version
    #   thats cloned into the temp directory
}


#
# -------------------------------------------------- Main menu
#
function main_menu()
{
clear

cat << _EOF_

          ------==== Bifrozt Main Menu ====------

                     1) System.
                     2) Network.
                     3) HonSSH.

                     A) About.
                     Q) Quit.

_EOF_

while true
do
    read -p '    Please make a selection: ' C0
    case $C0 in
        1)
            system_config
            ;;
        2)
            network_config
            ;;
        3)
            honssh_config
            ;;
        Q)
            echo -e '\Bye bye!\n'
            exit 0
            ;;
        *)
            echo '    That is not a valid choice!!'
            ;;
    esac
done
}


exit 0
