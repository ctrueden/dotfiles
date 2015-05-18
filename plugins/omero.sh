export CODE_OMERO="$CODE_BASE/ome/openmicroscopy"
export PATH_OMERO_DIST="$CODE_OMERO/dist"
if [ -d "$PATH_OMERO_DIST" ]
then
	export OMERO_PREFIX="$PATH_OMERO_DIST"
else
	export OMERO_PREFIX="$HOME/apps/OMERO.server"
fi
export ICE_CONFIG="$OMERO_PREFIX/etc/ice.config"
case "$(uname)" in
	Linux)
		export ICE_HOME=/usr/share/Ice-3.4.2
		export POSTGRES_HOME=/usr/lib/postgresql/9.1
		export PYTHONPATH=/usr/lib/pymodules/python2.7:$PYTHONPATH
		export LD_LIBRARY_PATH=/usr/share/java:/usr/lib:$LD_LIBRARY_PATH
		;;
	Darwin)
		export ICE_HOME="$(brew --prefix ice)"
		export SLICEPATH="$ICE_HOME/share/Ice-3.5/slice"
		export PYTHONPATH="$OMERO_PREFIX/lib/python:/usr/local/lib/python2.7/site-packages"
		;;
esac
export PATH="$OMERO_PREFIX/bin:$PATH"
alias goome='cd "$OMERO_PREFIX"'
alias fix-omero='omero admin ice "server stop Processor-0"'
