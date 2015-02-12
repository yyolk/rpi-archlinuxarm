FROM base/arch

RUN mkdir /run/shm
RUN pacman -Syy --noconfirm docker arch-install-scripts expect

VOLUME ["/app"]

WORKDIR /app

ENV ROOTFS /var/pacstrap

CMD ["/app/mkimage-arch.sh"]