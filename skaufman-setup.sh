#!/bin/bash
host=$1
cat <<EOS | ssh -t skaufman@$host
$( cat _setup.sh )
EOS
