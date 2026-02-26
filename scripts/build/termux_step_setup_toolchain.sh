termux_step_setup_toolchain() {
	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
		[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

		# Bump TERMUX_STANDALONE_TOOLCHAIN if a change is made in
		# toolchain setup to ensure that everyone gets an updated
		# toolchain
		if [ "${TERMUX_NDK_VERSION}" = "27c" ]; then
			TERMUX_STANDALONE_TOOLCHAIN+="-v1"
			termux_setup_toolchain_27c
		elif [ "${TERMUX_NDK_VERSION}" = 23c ]; then
			TERMUX_STANDALONE_TOOLCHAIN+="-v8"
			termux_setup_toolchain_23c
		else
			termux_error_exit "We do not have a setup_toolchain function for NDK version $TERMUX_NDK_VERSION"
		fi
	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_PREFIX"
		else
			TERMUX_STANDALONE_TOOLCHAIN="${CGCT_DIR}/${TERMUX_ARCH}"
		fi
		termux_setup_toolchain_gnu
	fi
	# ===== 在这里添加：去除调试路径 =====
  # 去除 -g 调试标志
  # 去除 -g 调试标志，并清理多余空格
  CFLAGS="${CFLAGS//-g/}"
  CFLAGS="${CFLAGS//  / }"
  CFLAGS="${CFLAGS# }"
  CFLAGS="${CFLAGS% }"

  CXXFLAGS="${CXXFLAGS//-g/}"
  CXXFLAGS="${CXXFLAGS//  / }"
  CXXFLAGS="${CXXFLAGS# }"
  CXXFLAGS="${CXXFLAGS% }"

  # 路径重映射（使用变量更灵活）
  local BUILD_ROOT="${TERMUX_TOPDIR:-/home/runner/.termux-build}"
  # 合并为一个 flag 减少命令行长度
  CFLAGS+=" -ffile-prefix-map=$BUILD_ROOT= -ffile-prefix-map=$HOME=~"
  CXXFLAGS+=" -ffile-prefix-map=$BUILD_ROOT= -ffile-prefix-map=$HOME=~"
  export CFLAGS CXXFLAGS
}
