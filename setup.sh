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

select_operation() {
	echo "Select your operation:"
	echo "1) Install	2) Uninstall"
	read -p "Operation: " OPERATION
	case $OPERATION in
		1)  MET="add" ;;
		2)  MET="del" ;;
		*)  select_operation ;;
	esac
	export MET && select_flavor
}

select_flavor() {
	echo "Select the following KDE Plasma Desktop Flavor:"
	echo "nano, lite, common, browser, full"
	read -p "Select your Flavor [? for details, empty to back]: " flavor

	case $flavor in
		nano)  PACKAGES="plasma-desktop dbus-x11" ;;
		lite)  PACKAGES="plasma" ;;
		common)  PACKAGES="plasma konsole dolphin" ;;
		browser)  select_browser ;;
		full)  PACKAGES="plasma kde-applications konqueror" ;;
		?)  show_help ;;
		*)  select_operation ;;
	esac

	apk $MET -i $PACKAGES
	[ $? != 0 ] && select_flavor
	check_services
}

select_browser() {
	read -p "Select your browser [? for list, empty to back]: " browser
	case $browser in
		firefox|chromium|falkon|konqueror|aura-browser)  PACKAGES="plasma konsole dolphin $browser" ;;
		?)  echo "firefox, chromium, falkon, konqueror, aura-browser" && select_browser ;;
		*)  select_flavor ;;
	esac

	apk $MET -i $PACKAGES
	[ $? != 0 ] && select_browser
	check_services
}

check_services() {
	[ $MET != "add" ] && exit
	[ ! -x /sbin/rc ] && echo "Setup completed. To launch desktop, do:" && echo "  DISPLAY=<display> dbus-launch startplasma-x11" && exit
	echo "Add sddm service during startup? [y/n]: " confirm
	[ $confirm != "y" ] && exit
	rc-update add sddm
	echo "Setup completed. To launch desktop, do:"
	echo "  rc-service sddm start\n"
	exit
}

select_operation
