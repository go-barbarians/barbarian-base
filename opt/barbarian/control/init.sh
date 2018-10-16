#!/bin/mksh

cd /tmp

if [[ -z "${GLIBC_REPO}" ]]
then
	GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
fi

# Glibc as a whole is LGPL licensed. Some of its code is BSD/MIT/CMU/other licensed.
if [[ -z "${GLIBC_VERSION}" ]]
then
	GLIBC_VERSION=2.28-r0
fi

# Java is GPL licensed with classpath exception
if [[ -z "${JAVA8_DOWNLOAD}" ]]
then
	JAVA8_DOWNLOAD=https://github.com/ojdkbuild/contrib_jdk8u-ci/releases/download/jdk8u181-b13/jdk-8u181-ojdkbuild-linux-x64.zip
fi

if [[ -z "${JAVA_INSTALL_VERSION}" ]]
then
	JAVA_INSTALL_VERSION=jdk-8u181-ojdkbuild-linux-x64
fi

if [[ -z "${BASH_REPO}" ]]
then
	BASH_REPO=http://dl-cdn.alpinelinux.org/alpine/v3.3/main/x86_64
fi

# Bash is GPL licensed. 
# You should be able to build programs that interoperate via
# the stdin/stdout interface without being affected by the GPL, but
# linking, reflecting/dynamically loading or otherwise invoking 
# the GPL licensed code in an intimate way, for example within 
# the same process, may trigger the copyleft aspect of the license 
# conditions and require your program to also be GPL licensed,
# or not distributed.
# The prinicpal is that the program should always be able to
# run without dependency on the GPL code. For example, if a future
# version of the GPL code is released that is 10% faster than the
# original version of the GPL code, then the user must be able to 
# use *your* program with the new version of the GPL code without
# modification.
# https://www.gnu.org/licenses/gpl-faq.html
#
if [[ -z "${BASH_APK}" ]]
then
	BASH_APK=bash-4.3.42-r6.apk
fi

# Readline is a GPL licensed library.
# Not LGPL.
if [[ -z "${BASH_READLINE_APK}" ]]
then
	BASH_READLINE_APK=readline-6.3.008-r4.apk
fi

# Bash requires readline, which depends on ncursesw
# we are currently shipping ncurses but not ncursesw
if [[ -z "${BASH_NCURSES_APK}" ]]
then
	BASH_NCURSES_APK=ncurses-libs-6.0_p20170701-r0.apk
fi

PYTHON=/opt/python27/bin/python
DOWNLOADER=/opt/barbarian/control/download.py
UNTAR=/opt/barbarian/control/untar.py
UNZIP=/opt/barbarian/control/unzip.py
PIP_INSTALLER=/opt/python27/get-pip.py
PIP=/opt/python27/bin/pip
JAVA_INSTALL_DIR=/opt/java8

$PYTHON $PIP_INSTALLER
$PIP install urllib3

for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}
do
	echo "downloading ${pkg}.apk"
	$PYTHON $DOWNLOADER -u ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -t /tmp/${pkg}.apk
done

#todo: MUST be a zip file currently, but the script *could* detect the filetype
echo "downloading ${JAVA_INSTALL_VERSION}.zip"
$PYTHON $DOWNLOADER -u $JAVA8_DOWNLOAD -t /tmp/${JAVA_INSTALL_VERSION}.zip

mkdir -p $JAVA_INSTALL_DIR

echo "unpacking ${JAVA_INSTALL_VERSION}.zip"
$PYTHON $UNZIP -t /tmp/${JAVA_INSTALL_VERSION}.zip -o $JAVA_INSTALL_DIR

mkdir -p /opt/glibc

cd /opt/glibc
for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}
do 
	echo "unpacking ${pkg}.apk"
	$PYTHON $UNTAR /tmp/${pkg}.apk
done
cd /tmp

#todo: fails currently
#/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 

echo "/opt/glibc/usr/glibc-compat/lib" >> /opt/glibc/usr/glibc-compat/etc/ld.so.conf
echo "/opt/glibc/lib" >> /opt/glibc/usr/glibc-compat/etc/ld.so.conf
echo "/opt/glibc/usr/lib" >> /opt/glibc/usr/glibc-compat/etc/ld.so.conf

/opt/glibc/usr/glibc-compat/sbin/ldconfig -C /opt/glibc/usr/glibc-compat/etc/ld.so.cache -f /opt/glibc/usr/glibc-compat/etc/ld.so.conf /opt/glibc/lib /opt/glibc/usr/glibc-compat/lib

chmod +x $JAVA_INSTALL_DIR/$JAVA_INSTALL_VERSION/bin/java
chmod +x $JAVA_INSTALL_DIR/$JAVA_INSTALL_VERSION/jre/bin/java

echo "downloading ${BASH_APK}"
python /opt/barbarian/control/download.py -u $BASH_REPO/$BASH_APK -t /tmp/bash.apk

echo "downloading ${BASH_NCURSES_APK}"
python /opt/barbarian/control/download.py -u $BASH_REPO/$BASH_NCURSES_APK -t /tmp/ncurses.apk

echo "downloading ${BASH_READLINE_APK}"
python /opt/barbarian/control/download.py -u $BASH_REPO/$BASH_READLINE_APK -t /tmp/readline.apk

# this path is prebaked, along with a symlink to /bin/bash and LD_LIBRARY_PATH env var.
cd /opt/bash
echo "unpacking $BASH_APK"
python /opt/barbarian/control/untar.py /tmp/bash.apk

echo "unpacking $BASH_NCURSES_APK"
python /opt/barbarian/control/untar.py /tmp/ncurses.apk

echo "unpacking $BASH_READLINE_APK"
python /opt/barbarian/control/untar.py /tmp/readline.apk

cd /tmp

