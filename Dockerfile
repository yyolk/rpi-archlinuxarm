FROM base/arch

RUN mkdir /run/shm
RUN pacman -Syy  --noconfirm docker arch-install-scripts expect
RUN pacman -Syyu --noconfirm
RUN pacman-db-upgrade
RUN pacman -S --noconfirm base-devel

COPY start.sh /start.sh
# RUN /start.sh


VOLUME ["/app"]
WORKDIR /app

ENV ROOTFS /var/pacstrap

CMD ["/app/mkimage-arch.sh"]