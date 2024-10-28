#!/bin/bash
read -p "Enter your username ($(whoami)): " username || username=$(whoami)
username=${username:-$(whoami)}
read -p "Enter your public key (~/.ssh/id_ed25519.pub): " pub_key
pub_key=${pub_key:-~/.ssh/id_ed25519.pub}
pub_key=$(cat $pub_key)
hash="$(openssl passwd -6)" yq '.passwd.users.0.password_hash=env(hash)' < $1 \
  | username=$username yq '.passwd.users.0.name=env(username)' \
  | pub_key=$pub_key yq '.passwd.users.0.ssh_authorized_keys.0=env(pub_key)'
