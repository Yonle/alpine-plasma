#!/usr/bin/env sh

[ $(id -u) != 0 ] && echo "Please run this script under root." && exit 6
[ -x /sbin/setup-xorg-base ] && setup-xorg-base

show_help() {
	echo "nano     - A flavor with it's Desktop only."
	echo "lite     - A flavor with some common desktop package"
	echo "common   - A flavor with common package like konsole and dolphin"
	echo "browser  - A flavor with packed browser"
	echo "full     - A flavor with full KDE applications"
	select_flavor
}

select_flavor() {
	echo "Select the following KDE Plasma Desktop Flavor:"
	echo "nano, lite, common, browser, full"
	read -p "Select your Flavor [? for details]: " flavor

	case $flavor in
		nano)  PACKAGES="plasma-desktop" ;;
		lite)  PACKAGES="plasma" ;;
		common)  PACKAGES="plasma konsole dolphin" ;;
		browser)  select_browser ;;
		full)  PACKAGES="plasma kde-applications firefox" ;;
		?)  show_help ;;
		*)  select_flavor ;;
	esac

	apk add -i $PACKAGES
	[ $? != 0 ] && select_flavor
	check_services
}

select_browser() {
	read -p "Select your browser [firefox, chromium]: " browser
	case $browser in
		firefox|chromium)  PACKAGES="plasma konsole dolphin $browser" ;;
		*)  select_flavor ;;
	esac

	apk add -i $PACKAGES
	[ $? != 0 ] && select_flavor
	check_services
}

check_services() {
	[ ! -x /sbin/rc ] && exit
	echo "Add sddm service during startup? [y/n]: " confirm
	[ $confirm != "y" ] && exit
	rc-update add sddm
	echo "Setup completed. To launch desktop, do:"
	echo "  rc-service sddm start\n"
	exit
}

select_flavor
