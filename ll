#!/bin/bash

#
# ll: a script for reporting line length violations (>80 characters)
#

java -cp $CP LineLength -locihacks "$@"
