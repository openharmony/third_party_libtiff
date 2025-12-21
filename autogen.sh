#!/bin/sh

retval=0

set -x

case `uname` in
  Darwin*)
    glibtoolize --force --copy || retval=$?
    ;;
  *)
    libtoolize --force --copy || retval=$?
    ;;
esac
aclocal -I ./m4 || retval=$?
autoheader || retval=$?
automake --foreign --add-missing --copy || retval=$?
autoconf || retval=$?
# Get latest config.guess and config.sub from upstream master since
# these are often out of date.


# 在 for file in config.guess config.sub 之前加一个判断
if [ -f config/config.guess ] && [ -f config/config.sub ]; then
    echo "$0: using existing config.guess and config.sub"
else
    for file in config.guess config.sub
    do
        echo "$0: getting $file..."
        wget ... || retval=$?
        ...
    done
fi

exit $retval
