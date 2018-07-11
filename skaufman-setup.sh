#!/bin/bash
host=$1
cat <<EOS | ssh -t skaufman@$host
$( ./setup.sh )
EOS
