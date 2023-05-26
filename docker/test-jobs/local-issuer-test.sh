#!/bin/bash

TOKEN_NAME="scitokens"
CLUSTER=$1
PROCESS=$2

if [ -z "$_CONDOR_CREDS" ]; then
    >&2 echo "_CONDOR_CREDS was not set or was blank!"
    >&2 echo "Current environment:"
    >&2 env
    exit 1
fi

if [ ! -d "$_CONDOR_CREDS" ]; then
    >&2 echo "_CONDOR_CREDS directory ($_CONDOR_CREDS) does not exist!"
    >&2 echo "Current directory ($(pwd)) contents:"
    >&2 ls -la
    exit 1
fi

CREDFILE="$_CONDOR_CREDS/$TOKEN_NAME.use"

if [ ! -f "$CREDFILE" ]; then
    >&2 echo "$CREDFILE file does not exist!"
    >&2 echo "_CONDOR_CREDS directory ($_CONDOR_CREDS) contents:"
    >&2 ls -la "$_CONDOR_CREDS"
    >&2 echo "Current directory ($(pwd)) contents:"
    >&2 ls -la
    exit 1
fi

if [ ! -s "$CREDFILE" ]; then
    >&2 echo "$CREDFILE is empty!"
    >&2 echo "Current condor_version:"
    >&2 condor_version
    exit 1
fi

echo "Contents of $CREDFILE:"
echo "Header:"
jq -R 'split(".") | .[0] | @base64d | fromjson' < "$CREDFILE" || echo "Error while decoding header"
echo "Payload:"
jq -R 'split(".") | .[1] | @base64d | fromjson' < "$CREDFILE" || echo "Error while decoding payload"
echo "Signature"
jq -R 'split(".") | .[2]' < "$CREDFILE" || echo "Error while decoding signature"

cp "$CREDFILE" "$TOKEN_NAME.$CLUSTER.$PROCESS.use"
