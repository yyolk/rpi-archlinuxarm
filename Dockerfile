FROM base/arch

RUN pacman -Syy --noconfirm docker arch-install-scripts expect devtmpfs

VOLUME ["/app"]

WORKDIR /app

ENV ROOTFS /var/pacstrap

CMD ["/app/mkimage-arch.sh"]