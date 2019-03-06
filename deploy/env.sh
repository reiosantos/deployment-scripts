#!/usr/bin/env bash

get_var() {
    local name="$1"
    curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${name}"
}
export PORT="$(get_var "PORT")"
export NODE_ENV="$(get_var "NODE_ENV")"
