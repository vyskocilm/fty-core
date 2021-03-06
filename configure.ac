# autoconf/automake basis
AC_PREREQ([2.5])
AC_INIT([bios], [0.1.0], [EatonIPCOpensource@Eaton.com])
PACKAGE_VENDOR="Eaton"

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
# Sub-makefiles: do not forget to update SUBDIRS list in root Makefile.am
AC_CONFIG_FILES([Makefile tools/Makefile docs/examples/Makefile database/mysql/Makefile])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([foreign 1.11 -Wall -Wno-portability silent-rules tar-pax no-dist-gzip dist-xz subdir-objects])

# libtool
LT_PREREQ([2.2])
LT_INIT([disable-static])

AS_IF([test "x$enable_static" = "xyes"], [AC_MSG_ERROR([--enable-static is not supported by 42ITy fty-core])])

AC_ARG_WITH([package-vendor],
	[AS_HELP_STRING([--with-package-vendor=ARG],
		[name of the entity which distributes this build
		 of the package (default is '$PACKAGE_VENDOR')])],
	[PACKAGE_VENDOR="${withval}"
	 AC_MSG_NOTICE([Using requested PACKAGE_VENDOR='$PACKAGE_VENDOR'])]
	# This may be left empty by explicit request
)

# the default value may be revised, so we have two layers of conditionals here
_ENABLE_DEBUG_BUILD=1
AC_ARG_ENABLE(debug-build,
	[AS_HELP_STRING([--enable-debug-build],
		[configure Makefile to enable various debugging flags])],
	[AS_CASE(["x$enableval"],
		["xyes"],[_ENABLE_DEBUG_BUILD=1],
		["xno"],[_ENABLE_DEBUG_BUILD=0])])
# value for both Makefile conditionals as well as the AM_COND_IF macro below
AM_CONDITIONAL([ENABLE_DEBUG_BUILD],
	[test "x$_ENABLE_DEBUG_BUILD" != x0])
AM_COND_IF([ENABLE_DEBUG_BUILD],
	[AC_MSG_NOTICE([Enabling various debugging flags])
         my_CFLAGS="$my_CFLAGS -DDEBUG -DDEVEL"
         my_CPPFLAGS="$my_CPPFLAGS -DDEBUG -DDEVEL"
         my_CXXFLAGS="$my_CXXFLAGS -DDEBUG -DDEVEL"],
	[AC_MSG_NOTICE([Not enabling various debugging flags])])
# a define-flag into config.h just in case some C code would need it later on?
AC_DEFINE_UNQUOTED([ENABLE_DEBUG_BUILD],   [$_ENABLE_DEBUG_BUILD],
        [Flag mostly for Makefile: enable various debugging flags (0=no)?])

ci_tests=false
AC_ARG_ENABLE(ci-tests,
	[AS_HELP_STRING([--enable-ci-tests],
		[turn on build of CI test programs along with "all"])],
	[AS_CASE(["x$enableval"],
		["xyes"],[ci_tests=true],
		["xno"],[ci_tests=false],
		[*],[AC_MSG_ERROR([bad value ${enableval} for --enable-ci-tests])])])
AM_CONDITIONAL([ENABLE_CI_TESTS], [test "x${ci_tests}" = xtrue])

# Google Thread Sanitizer; see
#   http://code.google.com/p/thread-sanitizer/wiki
# Note that TSAN incurs 5x-15x slowdown, so it is off by default
# As of GCC4.8, TSAN is only available for 64-bit Linux
# As of GCC4.9, either TSAN or ASAN may be used, not both
_CFLAGS_TSAN="-fsanitize=thread -fPIE -pie"
_LDFLAGS_TSAN="-pie -ltsan -shared"
_ENABLE_DEBUG_TSAN=0
#_ENABLE_DEBUG_TSAN=$ENABLE_DEBUG_BUILD
AC_ARG_ENABLE(thread-sanitizer,
	[AS_HELP_STRING([--enable-thread-sanitizer],
		[configure Makefile to enable Thread Sanitizer])],
	[AS_CASE(["x$enableval"],
		["xyes"],[_ENABLE_DEBUG_TSAN=1],
		["xno"],[_ENABLE_DEBUG_TSAN=0])])
AS_IF([test "x$_ENABLE_DEBUG_TSAN" != x0],
        [my_save_cflags="$CFLAGS"
         my_save_ldflags="$LDFLAGS"
         AC_MSG_CHECKING([whether CC supports Thread Sanitizer: CFLAGS='$_CFLAGS_TSAN' LDFLAGS='$_LDFLAGS_TSAN'])
         CFLAGS="$_CFLAGS_TSAN -Werror"
         LDFLAGS="$_LDFLAGS_TSAN -Werror"
         AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
            [AC_MSG_RESULT([yes])],
            [AC_MSG_RESULT([no])
             AC_MSG_NOTICE([NOTE: Thread Sanitizer was requested but support was not detected, DISABLING])
             _ENABLE_DEBUG_TSAN=0])
         LDFLAGS="$my_save_ldflags"
         CFLAGS="$my_save_cflags"]
)
# value for both Makefile conditionals as well as the AM_COND_IF macro below
AM_CONDITIONAL([ENABLE_DEBUG_TSAN],
	[test "x$_ENABLE_DEBUG_TSAN" != x0])
AM_COND_IF([ENABLE_DEBUG_TSAN],
	[AC_MSG_NOTICE([Enabling Thread Sanitizer])
         my_LDFLAGS="$my_LDFLAGS $_LDFLAGS_TSAN"
         my_CFLAGS="$my_CFLAGS $_CFLAGS_TSAN"
         my_CPPFLAGS="$my_CPPFLAGS $_CFLAGS_TSAN"
         my_CXXFLAGS="$my_CXXFLAGS $_CFLAGS_TSAN"],
	[AC_MSG_NOTICE([Not enabling Thread Sanitizer])])
# a define-flag into config.h just in case some C code would need it later on?
AC_DEFINE_UNQUOTED([ENABLE_DEBUG_TSAN],   [$_ENABLE_DEBUG_TSAN],
        [Flag mostly for Makefile: enable Thread Sanitizer (0=no)?])

# Google Address Sanitizer and Leak Sanitizer; see
#   http://code.google.com/p/address-sanitizer/wiki
# As of GCC4.9, either TSAN or ASAN+LSAN may be used, not both at once.
# If TSan is off, then by default ASan is (or not) enabled if Debug is (or not)
# It can be manually enabled for "production" builds as well, just 2x slowdown
_CFLAGS_ASAN="-fsanitize=address -fno-omit-frame-pointer"
_LDFLAGS_ASAN="-lasan -llsan -shared"
AS_IF([test "x$_ENABLE_DEBUG_TSAN" = x0],
        [_ENABLE_DEBUG_ASAN=$ENABLE_DEBUG_BUILD],
        [_ENABLE_DEBUG_ASAN=0])

# TODO: Currently CI tests fail with ASan in place because our code is buggy
# Until this is fixed, default builds are without ASAN, it can be enabled on
# the `configure` command-line explicitly.
_ENABLE_DEBUG_ASAN=0

AC_ARG_ENABLE(address-sanitizer,
	[AS_HELP_STRING([--enable-address-sanitizer],
		[configure Makefile to enable Address Sanitizer])],
	[AS_CASE(["x$enableval"],
		["xyes"],[_ENABLE_DEBUG_ASAN=1],
		["xno"],[_ENABLE_DEBUG_ASAN=0])])
AS_IF([test "x$_ENABLE_DEBUG_ASAN" != x0],
        [my_save_cflags="$CFLAGS"
         my_save_ldflags="$LDFLAGS"
         AC_MSG_CHECKING([whether CC supports Address Sanitizer: CFLAGS='$_CFLAGS_ASAN' LDFLAGS='$_LDFLAGS_ASAN'])
         CFLAGS="$_CFLAGS_ASAN -Werror"
         LDFLAGS="$_LDFLAGS_ASAN -Werror"
         AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
            [AC_MSG_RESULT([yes])],
            [AC_MSG_RESULT([no])
             AC_MSG_NOTICE([NOTE: Address Sanitizer was requested but support was not detected, DISABLING])
             _ENABLE_DEBUG_ASAN=0])
         LDFLAGS="$my_save_ldflags"
         CFLAGS="$my_save_cflags"]
)
# value for both Makefile conditionals as well as the AM_COND_IF macro below
# note that in the Makefile we (should?) conditionally link against libasan;
# at least this holds for our built SO libraries like bios_web.so
AM_CONDITIONAL([ENABLE_DEBUG_ASAN],
	[test "x$_ENABLE_DEBUG_ASAN" != x0])
AM_COND_IF([ENABLE_DEBUG_ASAN],
	[AC_MSG_NOTICE([Enabling Address Sanitizer])
         my_LDFLAGS="$my_LDFLAGS $_LDFLAGS_ASAN"
         my_CFLAGS="$my_CFLAGS $_CFLAGS_ASAN"
         my_CPPFLAGS="$my_CPPFLAGS $_CFLAGS_ASAN"
         my_CXXFLAGS="$my_CXXFLAGS $_CFLAGS_ASAN"],
	[AC_MSG_NOTICE([Not enabling Address Sanitizer])])
# a define-flag into config.h just in case some C code would need it later on?
AC_DEFINE_UNQUOTED([ENABLE_DEBUG_ASAN],   [$_ENABLE_DEBUG_ASAN],
        [Flag mostly for Makefile: enable Address Sanitizer (0=no)?])

### At least for some GCC versions, only one of these sanitizers may be used
AS_IF([test "x$_ENABLE_DEBUG_TSAN" != x0 -a "x$_ENABLE_DEBUG_ASAN" != x0],
        [AC_MSG_CHECKING([whether -fsanitize=address is incompatible with -fsanitize=thread for this compiler])
         my_save_cflags="$CFLAGS"
         my_save_ldflags="$LDFLAGS"
         CFLAGS="$_CFLAGS_ASAN $_CFLAGS_TSAN -Werror"
         LDFLAGS="$_LDFLAGS_ASAN $_LDFLAGS_TSAN -Werror"
         AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
            [AC_MSG_RESULT([no])],
            [AC_MSG_RESULT([yes])
             AC_MSG_ERROR([You can only enable either Address Sanitizer or Thread Sanitizer, sorry])])
         LDFLAGS="$my_save_ldflags"
         CFLAGS="$my_save_cflags"]
)

# display source/build paths of interest to us
AC_MSG_NOTICE([Determining source code paths:])
AC_MSG_NOTICE(AS_HELP_STRING([Value of srcdir:], ['$srcdir']))
_curdir_abs="`pwd`"
AC_MSG_NOTICE(AS_HELP_STRING([Value of _curdir_abs:], ['$_curdir_abs']))
AS_CASE(["x$srcdir"],
    [x/*], [_srcdir_abs="$srcdir"],
    [*],   [_srcdir_abs="$_curdir_abs/$srcdir"
	    AS_IF([test -d "$_srcdir_abs"],
		  [_srcdir_abs="`cd "$_srcdir_abs" && pwd || echo "$_srcdir_abs"`"])
])
AC_MSG_NOTICE(AS_HELP_STRING([Value of _srcdir_abs:], ['$_srcdir_abs']))

AS_IF([test -d "$_srcdir_abs/.git"],
	[AC_MSG_NOTICE([Getting current Git workspace attributes...])
	 # The script would need a git... can detect one or use the set envvar
	 # So let's help it if we can
	 AC_PATH_PROGS([GIT], [git])
	 AS_IF([test -n "$GIT" -a -x "$GIT"], [export GIT])
	 AC_PATH_PROGS([DATE], [gdate date])
	 AS_IF([test -n "$DATE" -a -x "$DATE"], [export DATE])
	 AS_IF([(cd "$_srcdir_abs" && $GDETAILSH ) > "$_curdir_abs/.git_details.tmp"],
		[AS_IF([test -s "$_curdir_abs/.git_details.tmp"],
		 [AS_IF([test -s "$_curdir_abs/.git_details"],
			[AS_IF([diff -bu "$_curdir_abs/.git_details" \
				             "$_curdir_abs/.git_details.tmp" | \
				    egrep -v '^(\-\-\-|\+\+\+|[ @]|[\+\-]PACKAGE_BUILD_TSTAMP)' \
				    >/dev/null 2>&1],
				[AC_MSG_NOTICE([Got new workspace metadata to replace the old copy])
				 mv -f "$_curdir_abs/.git_details.tmp" "$_curdir_abs/.git_details"],
				[AC_MSG_NOTICE([Got new workspace metadata but no significant changes against the old copy])]
			 )],
			[AC_MSG_NOTICE([Got new workspace metadata and had no old stashed away, using freely])
			 mv -f "$_curdir_abs/.git_details.tmp" "$_curdir_abs/.git_details"])
		 ], [AC_MSG_NOTICE([No Git metadata was detected (empty output)])
			 rm -f "$_curdir_abs/.git_details.tmp"])
			], [AC_MSG_NOTICE([No Git metadata was detected (script errored out)])
				rm -f "$_curdir_abs/.git_details.tmp"])
	], [AC_MSG_NOTICE([No Git workspace was detected ($_srcdir_abs/.git directory missing)])
])

# From old copy or a new generation, we may have the file with metadata...
# We no longer cook (most of) this data into config.h because it does get
# obsolete quickly during development. Rather, the build products that
# need (test, display) this information should use or convert the file.
# The Makefile takes care to keep it current as long as possible.
# Also, for display in the end of execution, try to "source" the values.
AS_IF([test -s "$_curdir_abs/.git_details"],
	[AC_MSG_NOTICE([Getting Git details into PACKAGE_* macros...])
	 source "$_curdir_abs/.git_details" && for V in \
		PACKAGE_GIT_ORIGIN PACKAGE_GIT_BRANCH PACKAGE_GIT_TAGGED \
		PACKAGE_GIT_TSTAMP PACKAGE_GIT_HASH_S PACKAGE_GIT_HASH_L \
		PACKAGE_GIT_STATUS PACKAGE_BUILD_TSTAMP \
		PACKAGE_GIT_TSTAMP_ISO8601 PACKAGE_BUILD_TSTAMP_ISO8601 \
		PACKAGE_BUILD_HOST_UNAME PACKAGE_BUILD_HOST_NAME \
		PACKAGE_BUILD_HOST_OS ; do
			eval $V='$'${V}_ESCAPED || eval $V=""
		done
	 AS_IF([test -z "$PACKAGE_GIT_HASH_S"], [source "$_curdir_abs/.git_details"])
	 AS_IF([test -n "$PACKAGE_GIT_HASH_S" -a x"$PACKAGE_GIT_HASH_S" != x'""' \
	          -a -n "$PACKAGE_GIT_TSTAMP" -a x"$PACKAGE_GIT_TSTAMP" != x'""'],
		[AC_MSG_NOTICE([Setting PACKAGE_STRING and PACKAGE_VERSION to include Git hash '$PACKAGE_GIT_HASH_S' and commit timestamp '$PACKAGE_GIT_TSTAMP'...])
		 PACKAGE_STRING="$PACKAGE_STRING.$PACKAGE_GIT_TSTAMP~$PACKAGE_GIT_HASH_S"
		 PACKAGE_VERSION="$PACKAGE_VERSION.$PACKAGE_GIT_TSTAMP~$PACKAGE_GIT_HASH_S"
		 _FIX_PACKAGE_STRING=y
		 _FIX_PACKAGE_VERSION=y
		 ### Rather don't fix the VERSION as it influences the
		 ### tarball name in "make distcheck", install paths, etc.
		 #VERSION="$VERSION.$PACKAGE_GIT_TSTAMP~$PACKAGE_GIT_HASH_S"
		 #_FIX_VERSION=y
	 ])
	], [AC_MSG_NOTICE([No Git details detected ($_curdir_abs/.git_details file missing), they will be missing from REST API and other reports])
])

### Allow to revise the packaging strings in config.h
m4_define([__AC_UNDEFINE],[_AC_DEFINE([#ifdef $1
 #undef $1
#endif])])

# General substitutions for all these packaging variables
AS_IF([test x"$_FIX_PACKAGE_NAME" = xy],
	[AC_MSG_NOTICE([Overriding PACKAGE_NAME='$PACKAGE_NAME'])
	 __AC_UNDEFINE([PACKAGE_NAME])
	 AC_DEFINE_UNQUOTED([PACKAGE_NAME],
	    ["$PACKAGE_NAME"],
	    [Packaging metadata: distro source code name])
])
AS_IF([test x"$_FIX_PACKAGE_VERSION" = xy],
	[AC_MSG_NOTICE([Overriding PACKAGE_VERSION='$PACKAGE_VERSION'])
	 __AC_UNDEFINE([PACKAGE_VERSION])
	 AC_DEFINE_UNQUOTED([PACKAGE_VERSION],
	    ["$PACKAGE_VERSION"],
	    [Packaging metadata: distro source code/packaged release version])
])
AS_IF([test x"$_FIX_VERSION" = xy],
	[AC_MSG_NOTICE([Overriding VERSION='$VERSION'])
	 __AC_UNDEFINE([VERSION])
	 AC_DEFINE_UNQUOTED([VERSION],
	    ["$VERSION"],
	    [Version number of package])
])
AS_IF([test x"$_FIX_PACKAGE_STRING" = xy],
	[AC_MSG_NOTICE([Overriding PACKAGE_STRING='$PACKAGE_STRING'])
	 __AC_UNDEFINE([PACKAGE_STRING])
	 AC_DEFINE_UNQUOTED([PACKAGE_STRING],
	    ["$PACKAGE_STRING"],
	    [Packaging metadata: distro source code name+version])
])
AS_IF([test x"$_FIX_PACKAGE_URL" = xy],
	[AC_MSG_NOTICE([Overriding PACKAGE_URL='$PACKAGE_URL'])
	 __AC_UNDEFINE([PACKAGE_URL])
	 AC_DEFINE_UNQUOTED([PACKAGE_URL],
	    ["$PACKAGE_URL"],
	    [Packaging metadata: distro contact (website)])
])
AS_IF([test x"$_FIX_PACKAGE_BUGREPORT" = xy],
	[AC_MSG_NOTICE([Overriding PACKAGE_BUGREPORT='$PACKAGE_BUGREPORT'])
	 __AC_UNDEFINE([PACKAGE_BUGREPORT])
	 AC_DEFINE_UNQUOTED([PACKAGE_BUGREPORT],
	    ["$PACKAGE_BUGREPORT"],
	    [Packaging metadata: distro contact (email/tracker)])
])
AC_MSG_NOTICE([Overriding PACKAGE_VENDOR='$PACKAGE_VENDOR'])
AC_DEFINE_UNQUOTED([PACKAGE_VENDOR],
	    ["$PACKAGE_VENDOR"],
	    [Packaging metadata: name of the entity which distributes this build of the package])


AC_PROG_INSTALL
AC_PROG_LN_S
PKG_PROG_PKG_CONFIG

# Checks for optional programs. 

dnl script is in m4
#doxygen
AC_PROG_TRY_DOXYGEN

AS_IF([test -z "$DOXYGEN"],
  [AC_MSG_NOTICE([
  -----------------------------------------
  No Doxygen program found - continuing
  without Doxygen documentation support.
  -----------------------------------------
  ])
  HAVE_DOXYGEN=0],
  [HAVE_DOXYGEN=1])
myDOXDIR="docs/doxygen"
mydoxylog="doxylog.txt"
mysrcDIR="src" 
dnl the directory to search source file that must be included in documentation
AM_CONDITIONAL([HAVE_DOXYGEN],[test -n "$DOXYGEN"])
AC_SUBST([HAVE_DOXYGEN])
AC_SUBST([myDOXDIR])
AC_SUBST([mydoxylog])
AC_SUBST([mysrcDIR])

# astyle
dnl ASTYLE would have the absolute path, use AC_CHECK_PROGS for relative
AC_PATH_PROGS([ASTYLE], [astyle])
AM_CONDITIONAL([HAVE_ASTYLE], [test -n "${ASTYLE}"])

dnl Documentation generation
# asciidoc
AC_PATH_PROGS([ASCIIDOC], [asciidoc])
# a2x
dnl TODO  MVY a2x - is it ok?
AC_PATH_PROGS([A2X], [a2x])

AS_IF([test -z "$ASCIIDOC" -a -z "$A2X"],
  [AC_MSG_NOTICE([
  -----------------------------------------
  No asciidoc or a2x program found - continuing
  without ASCIIDOC documentation support.
  -----------------------------------------
  ])
])
AM_CONDITIONAL([HAVE_ASCIIDOC],[test -n "$ASCIIDOC"])
AM_CONDITIONAL([HAVE_A2X],[test -n "$A2X"])


# sed is great!
AC_CHECK_PROGS([SED], [sed])

# sourced from an m4/*.m4 include file during configure script compilation
gl_VISIBILITY

# see daemon(7)
AC_ARG_WITH([systemdsystemunitdir],
     [AS_HELP_STRING([--with-systemdsystemunitdir=DIR], [Directory for systemd service files])],,
     [with_systemdsystemunitdir=auto])
AS_IF([test "x$with_systemdsystemunitdir" = "xyes" -o "x$with_systemdsystemunitdir" = "xauto"], [
     def_systemdsystemunitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)

     AS_IF([test "x$def_systemdsystemunitdir" = "x"],
         [AS_IF([test "x$with_systemdsystemunitdir" = "xyes"],
                [AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])])
          with_systemdsystemunitdir=no],
         [with_systemdsystemunitdir="$def_systemdsystemunitdir"])])
AS_IF([test "x$with_systemdsystemunitdir" != "xno"],
        [AC_SUBST([systemdsystemunitdir], [$with_systemdsystemunitdir])])
AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$with_systemdsystemunitdir" != "xno"])

# same logic as above, for presets (list of svcs enabled/disabled by default)
AC_ARG_WITH([systemdsystempresetdir],
     [AS_HELP_STRING([--with-systemdsystempresetdir=DIR], [Directory for systemd preset files])],,
     [with_systemdsystempresetdir=auto])
AS_IF([test "x$with_systemdsystempresetdir" = "xyes" -o "x$with_systemdsystempresetdir" = "xauto"], [
     def_systemdsystempresetdir=$($PKG_CONFIG --variable=systemdsystempresetdir systemd)

     AS_IF([test "x$def_systemdsystempresetdir" = "x"],
         [AS_IF([test "x$with_systemdsystempresetdir" = "xyes"],
                [AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])])
          with_systemdsystempresetdir=no],
         [with_systemdsystempresetdir="$def_systemdsystempresetdir"])])
AS_IF([test "x$with_systemdsystempresetdir" != "xno"],
        [AC_SUBST([systemdsystempresetdir], [$with_systemdsystempresetdir])])
AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$with_systemdsystempresetdir" != "xno"])

# Note: default path for "systemd-tmpfiles" packaged configs is currently
# hardcoded per http://www.freedesktop.org/software/systemd/man/tmpfiles.d.html
#systemdtmpfilesdir =    /usr/lib/tmpfiles.d/
AC_ARG_WITH([systemdtmpfilesdir],
     [AS_HELP_STRING([--with-systemdtmpfilesdir=DIR], [Directory for systemd preset files])],,
     [with_systemdtmpfilesdir=auto])
AS_IF([test "x$with_systemdtmpfilesdir" = "xyes" -o "x$with_systemdtmpfilesdir" = "xauto"], [
     def_systemdtmpfilesdir=$($PKG_CONFIG --variable=systemdtmpfilesdir systemd)
     # NOTE: The variable queried above might not exist at all
     AS_IF([test "x$def_systemdtmpfilesdir" = "x"],
         [with_systemdtmpfilesdir="/usr/lib/tmpfiles.d"],
         [with_systemdtmpfilesdir="$def_systemdtmpfilesdir"])])
AS_IF([test "x$with_systemdtmpfilesdir" != "xno"],
        [AC_SUBST([systemdtmpfilesdir], [$with_systemdtmpfilesdir])])
AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$with_systemdtmpfilesdir" != "xno"])

AC_SUBST([my_CFLAGS])
AC_SUBST([my_CPPFLAGS])
AC_SUBST([my_CXXFLAGS])
AC_SUBST([my_LDFLAGS])

# Snatched and adapted from libpng:
# http://www.opensource.apple.com/source/X11libs/X11libs-40/libpng/libpng-1.2.35/configure.ac
AC_MSG_CHECKING([if libraries can be versioned])
GLD="`$LD --help < /dev/null 2>/dev/null | grep version-script`"
AS_IF([test -n "$GLD"],
        [have_ld_version_script=yes
         AC_MSG_RESULT(yes)],
        [have_ld_version_script=no
         AC_MSG_RESULT(no)
         AC_MSG_WARN(*** You have not enabled versioned symbols.)
])
AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$have_ld_version_script" = "yes")
AS_IF([test "$have_ld_version_script" = "yes"],
        [AC_MSG_CHECKING([for symbol prefix])
         SYMBOL_PREFIX=`echo "PREFIX=__USER_LABEL_PREFIX__" \
                   | ${CPP-${CC-gcc} -E} - 2>&1 \
                   | ${EGREP-grep} "^PREFIX=" \
                   | ${SED-sed} "s:^PREFIX=::"`
         AC_SUBST(SYMBOL_PREFIX)
         AC_MSG_RESULT($SYMBOL_PREFIX)
         CXXFLAG_VISIBILITY=""
         gl_VISIBILITY
         AS_CASE(["$CFLAG_VISIBILITY"],
            [*-fvisibility-inlines-hidden*],[
                CXXFLAG_VISIBILITY="$CFLAG_VISIBILITY"],
            [*-fvisibility=hidden*],[
                CXXFLAG_VISIBILITY="$CFLAG_VISIBILITY -fvisibility-inlines-hidden"])
        AC_SUBST(CXXFLAG_VISIBILITY)
])


AC_MSG_NOTICE([
Summary:

        Version:                 ${PACKAGE_NAME} ${VERSION}

        Git origin URL:          ${PACKAGE_GIT_ORIGIN}
        Git branch:              ${PACKAGE_GIT_BRANCH}
        Git tag:                 ${PACKAGE_GIT_TAGGED}
        Git last-commit tstamp:  ${PACKAGE_GIT_TSTAMP} ${PACKAGE_GIT_TSTAMP_ISO8601}
        Git last-commit hash(S): ${PACKAGE_GIT_HASH_S}
        Git last-commit hash(L): ${PACKAGE_GIT_HASH_L}
        Git status (uncommitted files):	'${PACKAGE_GIT_STATUS}'

        Build-host 'uname -a':   ${PACKAGE_BUILD_HOST_UNAME}
        Build-host system name:  ${PACKAGE_BUILD_HOST_NAME}
        Build-host OS/kernel:    ${PACKAGE_BUILD_HOST_OS}
        Build-host timestamp:    ${PACKAGE_BUILD_TSTAMP} ${PACKAGE_BUILD_TSTAMP_ISO8601}

        prefix:                  ${prefix}
        sysconf dir:             ${sysconfdir}
        datarootdir:             ${datarootdir}
        includedir:              ${includedir}
        lib dir:                 ${libdir}

        a2x:                     ${A2X:-none}
        astyle:                  ${ASTYLE:-none}
        asciidoc:                ${ASCIIDOC:-none}
        doxygen:                 ${DOXYGEN:-none}

        ENABLE_CI_TESTS:         ${ci_tests}

        CFLAGS:                  ${my_CFLAGS} ${CFLAGS}
        CXXFLAGS:                ${my_CXXFLAGS} ${CXXFLAGS}
        CPPFLAGS:                ${OUR_CPPFLAGS} ${CPPFLAGS}
        LDFLAGS:                 ${OUR_LDFLAGS} ${LDFLAGS}
        PKG_CONFIG:              ${PKG_CONFIG}
        SYSTEMDSYSTEMUNITDIR:    ${systemdsystemunitdir}
        SYSTEMDSYSTEMPRESETDIR:  ${systemdsystempresetdir}
        SYSTEMDTMPFILESDIR:      ${systemdtmpfilesdir}

        absolute SRC DIR:        ${_srcdir_abs}
        absolute CUR DIR:        ${_curdir_abs}
])

unset _srcdir_abs

AC_OUTPUT
