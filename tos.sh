#!/bin/sh

export _JAVA_OPTIONS="-Dsun.java2d.ddscale=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel ${_JAVA_OPTIONS}"
export PATH=/usr/lib/jvm/zulu-8-amd64/jre/bin/:$PATH
exec  /home/jona/thinkorswim/thinkorswim "$@"
