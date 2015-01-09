rpi-archlinuxarm
================

## :sparkles::sparkles::star:Builds Daily:star::sparkles::sparkles:

Builds daily on a Raspberry Pi B+ daily package updates with `pacstrap`


base docker image of archlinux arm



essentially the same as [`base/archlinux`](https://registry.hub.docker.com/u/base/archlinux/) (minimal installation) for raspberry pi (ARM)

with the added bonus of:

- updates
- bash
- `pacman.conf`
  - `Color`
  - `ILoveCandy` enabled by default

![](http://i.imgur.com/r6vxHFB.png)


build off this image to get a `base` install of arch linux for ARM


### Grab the latest

    docker pull yyolk/rpi-archlinuxarm:latest

### Grab a certain date

The format is __YYYY__ __MM__ __DD__

    docker pull yyolk/rpi-archlinuxarm:20140106
