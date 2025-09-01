# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: 2017-2022 Bartosz Golaszewski <brgl@bgdev.pl>

AC_PREREQ([2.71])

AC_INIT([libgpiod], [2.3], [], [],
	[https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/])
AC_SUBST(EXTRA_VERSION, [-devel])

AC_DEFINE_UNQUOTED([GPIOD_VERSION_STR],
			["$PACKAGE_VERSION$EXTRA_VERSION"],
			[Full library version string.])
AC_SUBST(VERSION_STR, [$PACKAGE_VERSION$EXTRA_VERSION])

# Define the libtool version as (C.R.A)
# NOTE: this version only applies to the core C library.
AC_SUBST(ABI_VERSION, [4.1.1])

AC_CONFIG_AUX_DIR([autostuff])
AC_CONFIG_MACRO_DIRS([m4])
AM_INIT_AUTOMAKE([foreign subdir-objects])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
m4_pattern_forbid([^AX_],
	[Unexpanded AX_ macro found. Please install GNU autoconf-archive.])

AC_CONFIG_SRCDIR([lib])
AC_CONFIG_HEADERS([config.h])

AC_DEFINE([_GNU_SOURCE], [], [We want GNU extensions])

# Silence warning: ar: 'u' modifier ignored since 'D' is the default
AC_SUBST(AR_FLAGS, [cr])

AM_PROG_AR
AC_PROG_CC
# AC_PROG_CXX
# AC_PROG_INSTALL
# AC_PROG_EGREP

LT_INIT

AC_DEFUN([ERR_NOT_FOUND],
	[AC_MSG_ERROR([$1 not found (needed to build $2)], [1])])

AC_DEFUN([FUNC_NOT_FOUND_LIB],
	[ERR_NOT_FOUND([$1()], [the library])])

AC_DEFUN([HEADER_NOT_FOUND_LIB],
	[ERR_NOT_FOUND([$1 header], [the library])])

AC_DEFUN([HEADER_NOT_FOUND_TESTS],
	[ERR_NOT_FOUND([$1 header], [the test suite])])

AC_DEFUN([HEADER_NOT_FOUND_CXX],
	[ERR_NOT_FOUND([$1 header], [C++ bindings])])

# This is always checked (library needs this)
AC_CHECK_INCLUDES_DEFAULT

AC_FUNC_MALLOC
AC_HEADER_STDBOOL
AC_CHECK_FUNC([ioctl], [], [FUNC_NOT_FOUND_LIB([ioctl])])
AC_CHECK_FUNC([open], [], [FUNC_NOT_FOUND_LIB([open])])
AC_CHECK_FUNC([close], [], [FUNC_NOT_FOUND_LIB([close])])
AC_CHECK_FUNC([read], [], [FUNC_NOT_FOUND_LIB([read])])
AC_CHECK_FUNC([ppoll], [], [FUNC_NOT_FOUND_LIB([ppoll])])
AC_CHECK_FUNC([realpath], [], [FUNC_NOT_FOUND_LIB([realpath])])
# AC_CHECK_FUNC([readlink], [], [FUNC_NOT_FOUND_LIB([readlink])])
AC_CHECK_HEADERS([fcntl.h], [], [HEADER_NOT_FOUND_LIB([fcntl.h])])
# AC_CHECK_HEADERS([getopt.h], [], [HEADER_NOT_FOUND_LIB([getopt.h])])
# AC_CHECK_HEADERS([dirent.h], [], [HEADER_NOT_FOUND_LIB([dirent.h])])
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
		 lib/Makefile
		 lib/libgpiod.pc])

AC_OUTPUT
