main() {
	case "$(wsl-version)" in
		1)
			wsl-init
			wsl-v1-init
			;;
		2)
			wsl-init
			;;
	esac

	unset -f main
}

wsl-version() {
	if [ -z "$WSL_DISTRO_NAME" ]; then
		return 0
	fi
	if [ -z "$WSL_INTEROP" ]; then
		echo 1
		return 0
	fi

	echo 2
}

wsl-init() {
	wsl-create-conf
}

wsl-v1-init() {
	export DOCKER_HOST=tcp://0.0.0.0:2375
}

wsl-v2-init() {
	: # todo: Setup workaround for git performance https://github.com/microsoft/WSL/issues/4401
}

# https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-settings-with-wslconfig-and-wslconf
wsl-create-conf() {
	# Do not overwrite existing config
	if [ -e /etc/wsl.conf ]; then
		return 0
	fi
	{
		echo '[automount]'
		# Enable docker mount compatibility
		# https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
		echo 'root = /'

		# Disable mounting files with executable flag
		echo 'options = "metadata,umask=22,fmask=111"'
	} > /etc/wsl.conf
}

main
