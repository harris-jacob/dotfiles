# wsl-caveats

## Xserver not running
There seems to be a bug in the current WSL/WSLg which means some symlinks don't get
setup correctly. To fix I created a systemd service to create the link on boot:

To create the service:

```
sudo nvim /etc/systemd/system/setup-x11-symlink.service
```

And add the following:
```
[Unit]
Description=Setup X11 Symlink

[Service]
Type=oneshot
ExecStartPre=/bin/rm -rf /tmp/.X11-unix
ExecStart=/bin/ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
WantedBy=graphical.target

```

To enable the service:
```
sudo systemctl enable setup-x11-symlink.service
```

To start the service:
```
sudo systemctl start setup-x11-symlink.service
```


### Wayland apps not working
This one was annoying because I couldn't use a systemd service to create the link since the user
directory is created dynamically. I had to add this to my `.zshenv`:

```zsh
function create_wayland_symlink() {
    ln -sf /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/
}

```
