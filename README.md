# alpine-plasma
A simple KDE plasma setup script that can used for both Alpinelinux system and container.

## Launch setup
Just do `sh setup.sh`. Or,

```sh
sh -c "$(wget -qO - git.io/alpine-plasma)"
```

## Flavor comparison and size
```
nano     - A flavor with it's Desktop only.
lite     - A flavor with some common desktop package
common   - A flavor with common package like konsole and dolphin
browser  - A flavor with packed browser
full     - A flavor with full KDE applications
```

### Installation Size
```
nano: 1129 MiB
lite: 1393 MiB
common: 1398 MiB
browser:
  konqueror: 1403 MiB
  falkon: 1404 MiB
  aura-browser: 1418 MiB
  chromium: 1576 MiB
  firefox: 1584 MiB

full: 2378 MiB
```
