case "$(uname)" in
	Darwin)
		# To mitigate the macOS permissions hellscape,
		# open Fiji through LaunchServices, while keeping
		# the console output in the launching terminal.
		_fiji() {
			open -W -a "${FIJI_DIR:-$HOME/Applications/Fiji}"/Fiji.app \
				--stdout "$(tty)" --stderr "$(tty)" --args "$@"
		}
		;;
	*)
		_fiji() {
			"${FIJI_DIR:-$HOME/Applications/Fiji}"/fiji "$@"
		}
		;;
esac

fj() {
	if [ "$JAVA_HOME" ]; then
		_fiji --java-home "$JAVA_HOME" "$@"
	else
		_fiji "$@"
	fi
}
