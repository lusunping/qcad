include( ../../shared_app.pri )

macx {
    ICON = $$PWD/qcad.icns
}

win32 {
    !isEmpty(r_iconrc) {
        RC_FILE = $$r_iconrc
    }
    else {
        RC_FILE = $$PWD/qcad.rc
    }
}

win32 {
    QMAKE_LFLAGS_WINDOWS += /FORCE:MULTIPLE
}

#linux-g++ {
#    QMAKE_CXXFLAGS += -static-libgcc -static-libstdc++
#    QMAKE_LFLAGS += -L.
#    QMAKE_LFLAGS += -static-libgcc -static-libstdc++
#}

SOURCES += $$PWD/main.cpp
TEMPLATE = app
OTHER_FILES += $$PWD/run.dox

win32 {
    TARGET = $${RLIBNAME}
}

macx {
    TARGET = QCAD
} 
else {
    unix {
        TARGET = $${RLIBNAME}-bin
    }
}

# copy Qt plugins to QCAD plugin folder:
!build_pass {
    macx {
        FILES = \
            imageformats/libqgif.dylib \
            imageformats/libqico.dylib \
            imageformats/libqjpeg.dylib \
            imageformats/libqsvg.dylib \
            imageformats/libqtiff.dylib \
            sqldrivers/libqsqlite.dylib \
            sqldrivers/libqsqlodbc.dylib

        greaterThan(QT_MAJOR_VERSION, 4) {
            FILES += imageformats/libqtga.dylib
            FILES += printsupport/libcocoaprintersupport.dylib
        }
        else {
            FILES += \
                codecs/libqcncodecs.dylib \
                codecs/libqjpcodecs.dylib \
                codecs/libqkrcodecs.dylib \
                codecs/libqtwcodecs.dylib
        }

        contains(QT_VERSION, ^4\\.8\\..*) {
            FILES += imageformats/libqtga.dylib
        }

        for(FILE,FILES) {
            !exists("$${DESTDIR}/../plugins/$${FILE}") {
                message("copying file $$[QT_INSTALL_PLUGINS]/$${FILE}")
                system(cp "$$[QT_INSTALL_PLUGINS]/$${FILE}" "$${DESTDIR}/../plugins/$${FILE}")
            }
        }
    }

    else:unix {
        FILES = \
            imageformats/libqgif.so \
            imageformats/libqico.so \
            imageformats/libqjpeg.so \
            imageformats/libqsvg.so \
            imageformats/libqtiff.so \
            sqldrivers/libqsqlite.so

        greaterThan(QT_MAJOR_VERSION, 4) {
            FILES += imageformats/libqtga.so
        }
        else {
            FILES += \
                codecs/libqcncodecs.so \
                codecs/libqjpcodecs.so \
                codecs/libqkrcodecs.so \
                codecs/libqtwcodecs.so
        }

        contains(QT_VERSION, ^4\\.8\\..*) {
            FILES += imageformats/libqtga.so
        }

        for(FILE,FILES) {
            !exists("$${DESTDIR}/../plugins/$${FILE}") {
                system(cp "$$[QT_INSTALL_PLUGINS]/$${FILE}" "$${DESTDIR}/../plugins/$${FILE}")
            }
        }
    }

    else:win32 {
        greaterThan(QT_MAJOR_VERSION, 4) {
            FILES += \
                imageformats\\qgif.dll \
                imageformats\\qico.dll \
                imageformats\\qjpeg.dll \
                imageformats\\qsvg.dll \
                imageformats\\qtga.dll \
                imageformats\\qtiff.dll \
                imageformats\\qwbmp.dll \
                sqldrivers\\qsqlite.dll \
                printsupport\\windowsprintersupport.dll
        }

        contains(QT_VERSION, ^4\\..*\\..*) {
            FILES += \
                imageformats\\qgif4.dll \
                imageformats\\qico4.dll \
                imageformats\\qjpeg4.dll \
                imageformats\\qsvg4.dll \
                imageformats\\qtiff4.dll \
                sqldrivers\\qsqlite4.dll \
                codecs\\qcncodecs4.dll \
                codecs\\qjpcodecs4.dll \
                codecs\\qkrcodecs4.dll \
                codecs\\qtwcodecs4.dll
        }

        contains(QT_VERSION, ^4\\.8\\..*) {
            FILES += imageformats\\qtga4.dll
        }

        DESTDIR_WIN = $${DESTDIR}
        DESTDIR_WIN ~= s,/,\\,g

        for(FILE,FILES) {
            !exists("$$[QT_INSTALL_PLUGINS]\\$${FILE}") {
                error("File $$[QT_INSTALL_PLUGINS]\\$${FILE} not found. This Qt plugin is required by QCAD.")
            }
            !exists("$${DESTDIR_WIN}\\..\\plugins\\$${FILE}") {
                message(Copying $${FILE})
                system(cp "$$[QT_INSTALL_PLUGINS]\\$${FILE}" "$${DESTDIR_WIN}\\..\\plugins\\$${FILE}")
            }
        }

        # copy Qt libraries into same dir as exe to avoid Qt version mixup:
        greaterThan(QT_MAJOR_VERSION, 4) {
            system(cp "$$[QT_INSTALL_BINS]/*.dll" "$${DESTDIR_WIN}")
            system(cp "$$[QT_INSTALL_PLUGINS]/platforms/*.dll" "$${DESTDIR_WIN}\\..\\platforms")
        }
        else {
            system(cp "$$[QT_INSTALL_LIBS]/*.dll" "$${DESTDIR_WIN}")
        }
    }
}

