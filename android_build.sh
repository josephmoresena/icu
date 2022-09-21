!#/bin/bash
export ICU_DIR=$PDW
export ICU_SOURCES=$ICU_DIR/icu4c
export BASE=$ICU_DIR/build

mkdir build

cd $BASE
mkdir build_icu_linux
cd build_icu_linux 

export CPPFLAGS="-O3 -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
-DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
-DUCONFIG_NO_LEGACY_CONVERSION=1 -DUCONFIG_NO_BREAK_ITERATION=1 \
-DUCONFIG_NO_COLLATION=1 -DUCONFIG_NO_FORMATTING=1 -DUCONFIG_NO_TRANSLITERATION=0 \
-DUCONFIG_NO_REGULAR_EXPRESSIONS=1"
sh $ICU_SOURCES/source/runConfigureICU Linux --prefix=$PWD/icu_build --enable-extras=no \
--enable-strict=no -enable-static --enable-shared=no --enable-tests=no \
--enable-samples=no --enable-dyload=no
make -j4
#make install

cd $BASE
mkdir build_icu_android
cd build_icu_android 

export ANDROIDVER=8
export AR=/usr/bin/ar
export HOST_ICU=$BASE/build_icu_android
export ICU_CROSS_BUILD=$BASE/build_icu_linux
export NDK_STANDARD_ROOT=$ANDROID_NDK_HOME
export CPPFLAGS="-I$NDK_STANDARD_ROOT/sysroot/usr/include/ \
-O3 -fno-short-wchar -DU_USING_ICU_NAMESPACE=1 -fno-short-enums \
-DU_HAVE_NL_LANGINFO_CODESET=0 -D__STDC_INT64__ -DU_TIMEZONE=0 \
-DUCONFIG_NO_LEGACY_CONVERSION=1 -DUCONFIG_NO_BREAK_ITERATION=1 \
-DUCONFIG_NO_COLLATION=1 -DUCONFIG_NO_FORMATTING=1 -DUCONFIG_NO_TRANSLITERATION=0 \
-DUCONFIG_NO_REGULAR_EXPRESSIONS=1"
export LDFLAGS="-lc -lstdc++ -Wl,-rpath-link=$NDK_STANDARD_ROOT/sysroot/usr/lib/"
export PATH=$NDK_STANDARD_ROOT/bin:${PATH}
$ICU_SOURCES/source/runConfigureICU Linux --with-cross-build=$ICU_CROSS_BUILD \
--enable-extras=no --enable-strict=no -enable-static --enable-shared=no \
--enable-tests=no --enable-samples=no --enable-dyload=no \
--host=aarch64-linux-android21 --prefix=$PWD/icu_build
make -j4
#make install