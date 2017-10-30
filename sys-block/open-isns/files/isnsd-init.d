#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	need net
}

checkconfig() {
    getent services isns >/dev/null
	if [ $? -ne 0 ]; then
		eerror "No isns port number in /etc/services!"
		return 1
	fi
}

start() {
	checkconfig || return 1
	ebegin "Starting isnsd"
	start-stop-daemon --start --quiet --exec /usr/sbin/isnsd --pidfile /var/run/isnsd.pid
	eend $?
}

stop() {
	ebegin "Stopping isnsd"
	start-stop-daemon --stop --quiet --pidfile /var/run/isnsd.pid
	eend $?
}
