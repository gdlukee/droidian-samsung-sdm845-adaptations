#!/bin/bash
# High-speed HWC cleanup for SDM845

# Force kill and quick wait
lxc-attach -n android -- /bin/pkill -9 -f "composer@2.3-service" 2>/dev/null || true
sleep 0.8

# Permissions and socket cleanup (Instant)
chmod 666 /dev/dri/card0 /dev/dri/renderD128 2>/dev/null || true
rm -f /run/user/32011/wayland-*.lock /run/user/32011/wayland-* 2>/dev/null || true

# Restart driver and give it just enough time to breathe
lxc-attach -n android -- /bin/setprop ctl.restart vendor.hwcomposer-2-3
sleep 1.5

# Final check (only once, to avoid loop overhead)
if lxc-attach -n android -- /bin/pgrep -f "composer@2.3-service" >/dev/null; then
    exit 0
fi

exit 1
