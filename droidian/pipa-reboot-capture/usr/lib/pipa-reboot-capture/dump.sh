#!/bin/sh
# Dump kernel log to persist before reboot/shutdown (warm restart capture).
set -eu

PERSIST_DEV=""
for cand in /dev/block/sda22 /dev/block/by-name/persist \
	/dev/disk/by-partlabel/persist /dev/block/bootdevice/by-name/persist; do
	[ -e "$cand" ] && { PERSIST_DEV="$cand"; break; }
done
[ -n "$PERSIST_DEV" ] || exit 0

mkdir -p /pipa-persist
mount -t ext4 -o rw "$PERSIST_DEV" /pipa-persist 2>/dev/null || exit 0

LOG=/pipa-persist/pipa-pre-reboot.log
{
	echo "===== pipa pre-reboot log ====="
	date -Iseconds 2>/dev/null || date
	echo "--- reason: ${1:-shutdown} ---"
	echo "--- /proc/cmdline ---"
	cat /proc/cmdline 2>/dev/null
	echo
	echo "--- uptime ---"
	cat /proc/uptime 2>/dev/null
	echo
	echo "--- dmesg (drm/display/touch/reboot) ---"
	dmesg 2>/dev/null | grep -iE 'drm|dsi|cont_splash|msm|sde|panel|reboot|restart|NVT|touch|blank|suspend|resume|fb0' || true
	echo
	echo "--- dmesg (full) ---"
	dmesg 2>/dev/null
} > "$LOG" 2>&1
sync
umount /pipa-persist 2>/dev/null || true
