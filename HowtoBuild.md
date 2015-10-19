# Introduction #

Beware mortal soul, building a kernel can be difficult enough. Snowflake likes to throw in a bunch more curlies into the process, so dun be too sad if it doesn't quite work.

# Supported Host Systems #

These have been confirmed working as at [revision 208](https://code.google.com/p/snowflake-os/source/detail?r=208):
  * linux 64-bit (32-bit _should_ work)
  * mac os x 10.5/10.6 with cross-compiler (requires XCode 3.2.2)
  * freebsd 32-bit

# Details #

Some pre-requisite software:
  * gcc/binutils with support for i386-elf (need multilib support on 64-bit)
  * mkisofs
  * make/patch/sed/grep/useful tools like that
Once all that is installed, it should be as simple as typing `make` from the root of the project source.

# Mac OS X #

Building snowflake itself is almost as easy as building for everything else. It's just building the prerequisites first!

  1. build a cross compiler
  1. build mkisofs

## Building a Cross Compiler ##

These steps are a modified version of http://m3os.wordpress.com/2009/03/29/tutorial-building-an-i386-elf-cross-compiler-and-binutils-on-os-x/. It is also assumed you have the latest XCode suite installed.

Prerequisites:
  1. gmp: http://ftp.gnu.org/pub/gnu/gmp/gmp-4.3.2.tar.bz2
  1. mpfr: http://ftp.gnu.org/pub/gnu/mpfr/mpfr-2.4.2.tar.bz2
  1. mpc: http://www.multiprecision.org/mpc/download/mpc-0.8.1.tar.gz
These can be built with typical `tar xjf xxx.tar.bz2; cd xxx; ./configure; make; sudo make install` (or `tar zxf xxx.tar.gz`).

Then building your cross compiler:
  1. `mkdir crosstools && cd crosstools`
  1. `curl http://ftp.gnu.org/pub/gnu/binutils/binutils-2.20.1.tar.bz2 > binutils.tar.bz2`
  1. `tar xjf binutils.tar.bz2`
  1. `curl http://ftp.gnu.org/pub/gnu/gcc/gcc-4.5.0/gcc-4.5.0.tar.bz2 > gcc.tar.bz2`
  1. `tar xjf gcc.tar.bz2`
  1. `sudo mkdir /usr/local/cross`
  1. `sudo chmod 777 /usr/local/cross`
  1. `mkdir build-binutils && cd build-binutils`
  1. `../binutils-2.20.1/configure --target=i386-elf --prefix=/usr/local/cross`
  1. `make -j 3 all`
  1. `find . -name 'Makefile.in' | xargs sed -i -e 's/-Werror//g'`
  1. `find . -name 'Makefile' | xargs sed -i -e 's/-Werror//g'`
  1. `make all install`
  1. `cd ..`
  1. `mkdir build-gcc && cd build-gcc`
  1. `../gcc-4.5.0/configure --target=i386-elf --prefix=/usr/local/cross  --with-gnu-as --with-gnu-ld --disable-libssp --enable-languages=c`
  1. `make all install`
The `find/sed` magic is to address an issue where it complains about format strings warning.

## Building mkisofs ##

Cdrtools can be obtained from http://cdrecord.berlios.de/old/private/cdrecord.html. The package [ftp://ftp.berlios.de/pub/cdrecord/alpha/cdrtools-beta.tar.gz](ftp://ftp.berlios.de/pub/cdrecord/alpha/cdrtools-beta.tar.gz) seems to work fine. Simply skip the configure step, and run `make; sudo make install`. It installs the tools in a weird location, so fix that too:

  * `sudo mv /opt/schilly/bin/* /usr/bin/`

## Building Snowflake ##

Once you have your cross compiler and mkisofs, the steps are (if you used a different path to the instructions above, use that here instead):
  1. `export TOOLSPREFIX=/usr/local/cross/bin`
  1. `make`

If all goes well, you should have a snowflake.native which is the kernel. If everything goes really well, you should also have a snowflake.iso to boot!

![http://www.wilcox-tech.com/opensource/snowflake-vbox-osx.png](http://www.wilcox-tech.com/opensource/snowflake-vbox-osx.png)