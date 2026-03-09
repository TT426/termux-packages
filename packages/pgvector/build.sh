TERMUX_PKG_HOMEPAGE=https://github.com/pgvector/pgvector
TERMUX_PKG_DESCRIPTION="Open-source vector similarity search for PostgreSQL"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_MAINTAINER="@xpmall"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://github.com/pgvector/pgvector/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=867a2c328d4928a5a9d6f052cd3bc78c7d60228a9b914ad32aa3db88e9de27b0
TERMUX_PKG_DEPENDS="postgresql"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_CONFIGURE=true

termux_step_pre_configure() {
    if $TERMUX_ON_DEVICE_BUILD; then
        termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
    fi

    export PATH="${TERMUX_PREFIX}/bin:${PATH}"

    if ! command -v pg_config &>/dev/null; then
        termux_error_exit "pg_config not found — make sure 'postgresql' is built first."
    fi

    CFLAGS+=" -DUSE_UNNAMED_POSIX_SEMAPHORES=1"

    CFLAGS+=" -Wno-error"
}

termux_step_make() {
    make -j "${TERMUX_PKG_MAKE_PROCESSES}" \
        USE_PGXS=1 \
        PG_CONFIG="${TERMUX_PREFIX}/bin/pg_config" \
        CC="${CC}" \
        CFLAGS="${CFLAGS}"
}

termux_step_make_install() {
    make install \
        USE_PGXS=1 \
        PG_CONFIG="${TERMUX_PREFIX}/bin/pg_config" \
        DESTDIR="${TERMUX_PKG_DESTDIR}"
}