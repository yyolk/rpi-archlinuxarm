FROM base/arch

RUN mkdir /run/shm
RUN pacman -Syyu --noconfirm docker arch-install-scripts expect base-devel

USER

VOLUME ["/app"]

WORKDIR /app

ENV ROOTFS /var/pacstrap

CMD ["/app/mkimage-arch.sh"]