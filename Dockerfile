FROM base/arch

RUN pacman -Syy --noconfirm docker arch-install-scripts expect

VOLUME ["/app"]

WORKDIR /app

CMD ["/app/mkimage-arch.sh"]