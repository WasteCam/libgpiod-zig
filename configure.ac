# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: 2017-2022 Bartosz Golaszewski <brgl@bgdev.pl>
# SPDX-FileCopyrightText: 2025 WasteCam Contributors

# YES = we need to find a Zig build system equivalent
# NO = we have alternatives in Zig, but we need to keep it in Autoconf

# NO (autoconf minimum version)
AC_PREREQ([2.71])

# YES/NO - we don't need the repo URL
AC_INIT([libgpiod], [2.3], [], [],
	[https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/])
AC_SUBST(EXTRA_VERSION, [-devel])

# YES (defines a C macro with the version string, ideally you can do it without config.h)
AC_DEFINE_UNQUOTED([GPIOD_VERSION_STR],
			["$PACKAGE_VERSION$EXTRA_VERSION"],
			[Full library version string.])

# NO (libtool ABI version)
# Define the libtool version as (C.R.A)
# NOTE: this version only applies to the core C library.
AC_SUBST(ABI_VERSION, [4.1.1])

# NO (Autotools stores its helper scripts and m4 files here instead of in the root directory)
AC_CONFIG_AUX_DIR([autostuff])
AC_CONFIG_MACRO_DIRS([m4])

# NO (doesn't enforce GNU project directory structure and builds objects in their subdirectories)
AM_INIT_AUTOMAKE([foreign subdir-objects])

# NO (silent rules just makes build less verbose)
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
m4_pattern_forbid([^AX_],
	[Unexpanded AX_ macro found. Please install GNU autoconf-archive.])

# NO (makes sure script runs from where it can see the ./lib directory)
AC_CONFIG_SRCDIR([lib])

# NO (include all C macros in source files)
# (there's only two we actually need: GPIOD_VERSION_STR and _GNU_SOURCE)
AC_CONFIG_HEADERS([config.h])

# YES (Zig make sure the target platform is Linux, ideally you can do it without config.h)
AC_DEFINE([_GNU_SOURCE], [], [We want GNU extensions])

# NO (this just silences a warning from the archiver)
# Silence warning: ar: 'u' modifier ignored since 'D' is the default
AC_SUBST(AR_FLAGS, [cr])

# YES
AM_PROG_AR
AC_PROG_CC

# NO
LT_INIT

# NO (functions to throw errors if system functions and headers are missing)
AC_DEFUN([ERR_NOT_FOUND],
	[AC_MSG_ERROR([$1 not found (needed to build $2)], [1])])
AC_DEFUN([FUNC_NOT_FOUND_LIB],
	[ERR_NOT_FOUND([$1()], [the library])])
AC_DEFUN([HEADER_NOT_FOUND_LIB],
	[ERR_NOT_FOUND([$1 header], [the library])])

# YES (force the generation of default header checks)
# This is always checked (library needs this)
AC_CHECK_INCLUDES_DEFAULT

# YES (perhaps we could replicate this by simply guaranteeing glibc with GNU extensions?)
AC_FUNC_MALLOC
AC_HEADER_STDBOOL
AC_CHECK_FUNC([ioctl], [], [FUNC_NOT_FOUND_LIB([ioctl])])
AC_CHECK_FUNC([open], [], [FUNC_NOT_FOUND_LIB([open])])
AC_CHECK_FUNC([close], [], [FUNC_NOT_FOUND_LIB([close])])
AC_CHECK_FUNC([read], [], [FUNC_NOT_FOUND_LIB([read])])
AC_CHECK_FUNC([ppoll], [], [FUNC_NOT_FOUND_LIB([ppoll])])
AC_CHECK_FUNC([realpath], [], [FUNC_NOT_FOUND_LIB([realpath])])
AC_CHECK_HEADERS([fcntl.h], [], [HEADER_NOT_FOUND_LIB([fcntl.h])])
AC_CHECK_HEADERS([poll.h], [], [HEADER_NOT_FOUND_LIB([poll.h])])
AC_CHECK_HEADERS([sys/sysmacros.h], [], [HEADER_NOT_FOUND_LIB([sys/sysmacros.h])])
AC_CHECK_HEADERS([sys/ioctl.h], [], [HEADER_NOT_FOUND_LIB([sys/ioctl.h])])
AC_CHECK_HEADERS([sys/param.h], [], [HEADER_NOT_FOUND_LIB([sys/param.h])])
AC_CHECK_HEADERS([sys/stat.h], [], [HEADER_NOT_FOUND_LIB([sys/stat.h])])
AC_CHECK_HEADERS([sys/types.h], [], [HEADER_NOT_FOUND_LIB([sys/types.h])])
AC_CHECK_HEADERS([linux/const.h], [], [HEADER_NOT_FOUND_LIB([linux/const.h])])
AC_CHECK_HEADERS([linux/ioctl.h], [], [HEADER_NOT_FOUND_LIB([linux/ioctl.h])])
AC_CHECK_HEADERS([linux/types.h], [], [HEADER_NOT_FOUND_LIB([linux/types.h])])

AC_CONFIG_FILES([Makefile
		 include/Makefile
		 lib/Makefile])

AC_OUTPUT
