# Offline driver bundles

Each archive is tied to the exact Linux kernel version in its filename. The `setup` command copies a matching archive into Lima and installs it before attempting any online package installation.

Do not rename a bundle for a different kernel. Kernel modules must match `uname -r` exactly.
