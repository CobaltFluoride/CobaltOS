# CobaltOS
Just another operating system!

Issues:
When run on real hardware, some UEFI bios vendors do some trickery causing CobaltOS not to be recognized as a bootable medium.
If this is the case, just run in it QEMU.

Complation:
nasm -f bin bootloader.asm -o bootloader.img

Virtualizaton (QEMU):
qemu-system-i386 bootloader.img
