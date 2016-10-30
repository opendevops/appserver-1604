# Troubleshooting


### "vboxsf" is not available

Vagrant was unable to mount VirtualBox shared folders. This is usually
because the filesystem "vboxsf" is not available.

**solution**
```
vagrant plugin install vagrant-vbguest
vagrant reload
```


see: http://stackoverflow.com/a/23752848


### Running vagrant as admin

Ensure `idea.exe` is running as admin (right click > Compatibility > Run this program as an administrator) 



### NFS problems

**Inappropriate ioctl for device**
```
mesg: ttyname failed: Inappropriate ioctl for device
```
see 
- https://github.com/geerlingguy/drupal-vm/issues/681
- https://github.com/mitchellh/vagrant/issues/7155
- https://github.com/mitchellh/vagrant/issues/6871


**mount.nfs: access denied**
```
mount.nfs: access denied by server while mounting 192.168.56.1
```


### Also see

see https://github.com/mitchellh/vagrant/issues/6871
see https://github.com/mitchellh/vagrant/issues/7155
