#!/bin/sh

# Points every enabled network service on this Mac (Wi-Fi, Ethernet,
# etc.) at Cloudflare's DNS resolvers: 1.1.1.1, with 1.0.0.1 as the
# backup. Fleet runs this as root.

PRIMARY_DNS="1.1.1.1"
SECONDARY_DNS="1.0.0.1"

failed=0

# The first line of the list is a note about disabled services, and
# disabled services are prefixed with "*". Skip both.
/usr/sbin/networksetup -listallnetworkservices | /usr/bin/tail -n +2 | while IFS= read -r service; do
  case "$service" in
    \**) continue ;;
    "") continue ;;
  esac

  if /usr/sbin/networksetup -setdnsservers "$service" "$PRIMARY_DNS" "$SECONDARY_DNS"; then
    echo "Set DNS for \"$service\" to $PRIMARY_DNS, $SECONDARY_DNS"
  else
    echo "Failed to set DNS for \"$service\"" >&2
    exit 1
  fi
done || failed=1

# Clear cached lookups so the new resolvers are used right away.
/usr/bin/dscacheutil -flushcache
/usr/bin/killall -HUP mDNSResponder 2>/dev/null

if [ "$failed" -ne 0 ]; then
  echo "DNS could not be set on one or more network services." >&2
  exit 1
fi

echo "DNS now resolves through Cloudflare."
exit 0
