#!/bin/sh
wl-mirror $(niri msg outputs | grep '^Output' | cut -d'(' -f 2 | cut -d')' -f 1 | fuzzel --dmenu --prompt 'src? ')
