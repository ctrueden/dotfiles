#!/bin/bash

#User Settings
MAILFILE=${1}
GMAILTO="ctrueden.wisc@gmail.com"

#Commands
python ~/bin/gml.py mbox "${MAILFILE}" ${GMAILTO}
#mkdir -p ~/gmailed/`dirname "${MAILFILE}"`
#mv "${MAILFILE}" ~/gmailed/`dirname "${MAILFILE}"`
