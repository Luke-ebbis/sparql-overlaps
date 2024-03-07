#! /usr/bin/env bash
echo "Setting up the server."
rm data/store -r
oxigraph_server load -l data/store -f "data/triple.ttl"
oxigraph_server serve -l data/store
