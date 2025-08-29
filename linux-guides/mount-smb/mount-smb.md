## mount-smb

## Storing credentials

Create a credential file in a location like
_/etc/samba/credentials/{share}-{permission}_

```
nano /etc/samba/credentials/files-write
```

```
username=service-files-write
password=supperSecure
```

Then lock the file down

```
chmod 600 /etc/samba/credentials/files-write
shown root:root /etc/samba/credentials/files-write
```

## Create mount directory

Create a path for your SMB share to be mounted like

```
mkdir -p /mnt/shares/nas01/files_write
```

## Edit _fstab_ file to mount on boot

```
nano /etc/fstab
```

At the bottom, add in this line to set your SMB mount path and location.
Make sure to check the UID and GID are correct for your device.

```
//{address}/{share} /mnt/shares/nas01/files_write cifs credentials=/etc/samba/credentials/files-write,iocharset=utf8,uid=1000,gid=1000,file_mode=0770,dir_mode=0770,nofail,x-systemd.automount 0 0
```

## Mount for current session

To avoid rebooting for the initial setup, run this command to trigger the mount action.

```
mount -a
```

## Troubleshooting

### Configuration is correct, but SMB not being mounted.

Most distros already enable Samba services, but check with:

```
sudo systemctl enable smbd
sudo systemctl enable nmbd
```
