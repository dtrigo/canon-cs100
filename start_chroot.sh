CHR=/home/debian-wheezy

# mount needed directories for chroot environment                                                 
mount -t proc proc $CHR/proc
mount -t sysfs none $CHR/sys
mount --bind /dev $CHR/dev
mount -t tmpfs tmpfs $CHR/dev/shm
mount -t devpts /dev/pts $CHR/dev/pts
# mount /lib/modules if you prefer and don't create the folder inside $CHR
mkdir -p $CHR/lib/modules/2.6.35.9-32-sigma
mount --bind /lib/modules/2.6.35.9-32-sigma $CHR/lib/modules/2.6.35.9-32-sigma
# mount something inside home or home as is the largest partition...
mount --bind /home $CHR/home

# start chrooted ssh and other services
chroot $CHR service ssh start
# You need extra modules to load nfsd
chroot $CHR /sbin/rpcbind
chroot $CHR /usr/sbin/rpc.nfsd
chroot $CHR service nfs-kernel-server start
# Samba performs quite well! And you don't need extra modules
chroot $CHR service samba start
