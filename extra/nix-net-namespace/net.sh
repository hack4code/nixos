#!/usr/bin/env bash


ip netns add nixos
ip link add nix type veth peer name eth0
ip link set eth0 netns nixos
ip addr add 192.168.2.1/24 dev nix
ip link set dev nix up

ip netns exec nixos ip addr add 192.168.2.2/24 dev eth0
ip netns exec nixos ip link set dev eth0 up
ip netns exec nixos ip link set dev lo up
ip netns exec nixos ip route add default via 192.168.2.1
ip rule add from 192.168.2.0/24 lookup main
nft -f nix.nft
ip netns exec nixos ping 8.8.8.8


# vim: ts=4 sw=4 sts=4 ft=bash et:
