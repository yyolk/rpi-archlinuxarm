#!/usr/bin/env bash
# Generate a minimal filesystem for archlinux and load it into the local
# Modifid by yyolk from https://github.com/docker/docker/blob/d04debddd983b3aa48ad38659d2c3debe794d374/contrib/mkimage-arch.sh
# docker as "yyolk/rpi-archlinuxarm"
# requires root, and an archlinux install
set -xe

hash docker &>/dev/null || {
	echo "Could not find docker. Run pacman -S docker"
	exit 1
}

hash pacstrap &>/dev/null || {
	echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
	exit 1
}

hash expect &>/dev/null || {
	echo "Could not find expect. Run pacman -S expect"
	exit 1
}

# mount /tmp $ROOTFS/tmp -o bind
# mount /lib/modules $ROOTFS/lib/modules -o bind
# mount proc $ROOTFS/proc -t proc -o nosuid,noexec,nodev
# mount sysfs $ROOTFS/sys -t sysfs -o nosuid,noexec,nodev
# mount devtmpfs $ROOTFS/dev -t devtmpfs -o mode=0755,nosuid
# mount devpts $ROOTFS/dev/pts -t devpts -o gid=5,mode=620
# cp -a /etc/resolv.conf $ROOTFS/etc/resolv.conf

# # udev doesn't work in containers, rebuild /dev
# DEV=$ROOTFS/dev
# rm -rf $DEV
# mkdir -p $DEV
# mknod -m 666 $DEV/null c 1 3
# mknod -m 666 $DEV/zero c 1 5
# mknod -m 666 $DEV/random c 1 8
# mknod -m 666 $DEV/urandom c 1 9
# mkdir -m 755 $DEV/pts
# mkdir -m 1777 $DEV/shm
# mknod -m 666 $DEV/tty c 5 0
# mknod -m 600 $DEV/console c 5 1
# mknod -m 666 $DEV/tty0 c 4 0
# mknod -m 666 $DEV/full c 1 7
# mknod -m 600 $DEV/initctl p
# mknod -m 666 $DEV/ptmx c 5 2
# ln -sf /proc/self/fd $DEV/fd

# mount -t proc none /proc
# mount -o bind /dev /dev
# packages to ignore for space savings
ROOTFS=${ROOTFS:-$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-archlinux-XXXXXXXXXX)}
echo "Creating ROOTFS with $ROOTFS"

chmod 755 $ROOTFS


PKGIGNORE=linux,jfsutils,lvm2,cryptsetup,groff,man-db,man-pages,mdadm,pciutils,pcmciautils,reiserfsprogs,s-nail,xfsprogs,initscripts

expect <<EOF
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- \$arg
	}
	set timeout 30000

	spawn pacstrap -C ./mkimage-arch-pacman.conf -c -d -G -i $ROOTFS base haveged --ignore $PKGIGNORE
	expect {
		-exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
		-exact "(default=all): " { send -- "\r"; exp_continue }
		-exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
	}
EOF



arch-chroot $ROOTFS /bin/sh -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate archlinux; pkill gpg-agent"
arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen
arch-chroot $ROOTFS /bin/sh -c 'echo "Server = http://mirror.archlinuxarm.org/\$arch/\$repo" > /etc/pacman.d/mirrorlist'

tar --numeric-owner --xattrs --acls -C $ROOTFS -c . | docker import - yyolk/rpi-archlinuxarm
docker run --rm -it yyolk/rpi-archlinuxarm echo -e '\n\nSuccess.\n'
TIMESTAMP=$(date "+%Y%m%d")
docker tag yyolk/rpi-archlinuxarm yyolk/rpi-archlinuxarm:$TIMESTAMP
docker run --rm -it yyolk/rpi-archlinuxarm:$TIMESTAMP echo -e "\n\nSuccessfully tagged!\n"
# docker tag yyolk/rpi-archlinuxarm:$TIMESTAMP yyolk/rpi-archlinuxarm:latest

echo "Pushing to hub..."

rm -rf $ROOTFS


docker push yyolk/rpi-archlinuxarm
