# Ignore these services, do not copy them over to the new root
arkdep_systemd_service_migrate_ignore=(
	'NetworkManager-wait-online.service'
	'NetworkManager.service'
	'apparmor.service'
	'arkane-flatpak-init.service'
	'bluetooth.service'
	'cups.path'
	'cups.service'
	'cups.socket'
	'dbus-org.bluez.service'
	'dbus-org.freedesktop.nm-dispatcher.service'
	'display-manager.service'
	'fstrim.timer'
	'getty@tty1.service'
	'paccache.timer'
	'remote-fs.target'
	'switcheroo-control.service'
	'systemd-boot-update.service'
	'systemd-timesyncd.service'
	'systemd-userdbd.socket'
)

printf '\e[1;32m-->\e[0m\e[1m Migrating systemd services to new deployment\e[0m\n'

# Get a list of all services
declare -r services=($(find /etc/systemd/system -type f,l))

for service in ${services[@]}; do

	# Check if service is in ignore list
	for ignore in ${arkdep_systemd_service_migrate_ignore[@]}; do
		if [[ $service == *$ignore ]]; then
			break_the_loop=1
			continue
		fi
	done

	# If service was determined to be on ignore list, skip it
	if [[ $break_the_loop -eq 1 ]]; then
		break_the_loop=0
		continue
	fi

	# Ensure the parent directories exist
	mkdir -pv $arkdep_dir/deployments/${data[0]}/rootfs/${service%/*}

	# Copy service to new deployment
	cp -v $service $arkdep_dir/deployments/${data[0]}/rootfs/$service

done
