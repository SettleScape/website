Please go to this URL for sysctl settings:  https://github.com/MilesBHuff/Dotfiles/tree/master/Linux/etc/sysctl.d

The following items differ from upstream:

**Names:**

* To better fit the constraints proffered by RedHat's README, the network settings are in the 70s instead of the 50s, and the other settings are in the 80s instead of the 60s.

**`70-net-core.conf`:**

* `kernel.domainname` is set to `settlescape.org`.

* `net.core.bpf_jit_enable=0` is commented-out, because it doesn't exist on Oracle Linux.

**`74-net-ipv4.conf`:**

* `net.ipv4.icmp_echo_ignore_all` is set to `0` so that the server can receive pings.

* `net.ipv4.conf.all.shared_media` is set to `0` for security.

**`81-io.conf`:**

* `vm.dirty_*` are set for a SATA III HDD.
