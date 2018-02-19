CHR=/home/debian-wheezy

# mount needed directories for chroot environment                                                 
mount -t proc proc $CHR/proc
mount -t sysfs none $CHR/sys
mount --bind /dev $CHR/dev
mount -t tmpfs tmpfs $CHR/dev/shm
mount -t devpts /dev/pts $CHR/dev/pts
mkdir -p $CHR/lib/modules/2.6.35.9-32-sigma
mount --bind /lib/modules/2.6.35.9-32-sigma $CHR/lib/modules/2.6.35.9-32-sigma
mount --bind /home/opt $CHR/home

# start chrooted ssh and 3 arma2 servers
chroot $CHR service ssh start
chroot $CHR /sbin/rpcbind
chroot $CHR /usr/sbin/rpc.nfsd
chroot $CHR service nfs-kernel-server start
chroot $CHR service samba start
