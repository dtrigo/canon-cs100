# Chroot Debian on a canon cs100 
CAUTION: USE AT YOUR OWN RISK, we didn't take any r esponsibility about this procedure. It is given as is.

(this document is based on the firmware 2.5.2)

To prepare the chroot you need a debian/ubuntu computer, an external 2.5" disk adaptor...

* You need to enable the telnet access to your cs100:

```
-Take off the disk from the device and connect it to a linux computer
-Mount first partition and look for /etc/rc.d/rcS, around line 200 you should find something like "allow_telnet=no", change it to "allow_telnet=yes".
-Put it back to your cs100 and start the station

```
* On the debian/ubuntu computer:

```
apt-get install debootstrap
cd ~
mkdir debian-wheezy
debootstrap --arch mipsel --foreign wheezy ~/debian-wheezy

```
* Now you need to transfer the directory to the cs100, here you have (at least) two options:
1) Copy files from your debian/ubuntu to the cs100 disk using the adapter...
2) On the cs100, connect trhough telnet, find the device IP, start netcat:

```
cd /home
nc -l -p 1234 > debian-wheezy.tar.gz

```
* On the Debian/Ubuntu computer:

```
tar czvf ~/debian-wheezy.tar.gz ~/debian-wheezy
nc -w 3 [cs100 IP] 1234 < debian-wheezy.tar.gz

```
* Once the file is transfered, on the cs100:

```
tar xzvf debian-wheezy.tar.gz
mount -t proc debian-wheezy/proc
cp /etc/resolv.conf debian-wheezy/etc
cp /etc/hosts debian-wheezy/etc
chroot debian-wheezy
debootstrap/debootstrap --second-stage
apt-get update && apt-get install openssh-server 
# <and other services you want to install>
#add root password
passwd 

```

  * You can use the start_chroot.sh to automount/start the chrooted debian (I assumed installation of nfs-kernel-server and samba), add/edit services you need (Also I attached the kernel modules to install/use nfsd):

```
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

chroot $CHR service ssh start
chroot $CHR service <another service> start
```
