## cmake/SMLNJ-Bootfiles.cmake
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## FetchContent declarations for SML/NJ bootfiles
## When configuring the build, CMake will download the boot file
## for your current system.
## If you do not want the configure step to perform a network request,
## download the bootfile and set the CMake variable
## `boot.<suffix>.<version>_SOURCE_DIR`
## to point to the downloaded location.
## Ex.
##    cmake -S . -B _build -Dboot.amd64-unix.110.99.8_SOURCE_DIR=/tmp/bootfile-dir
##
## TODO: This setup doesn't work great since the directory needs to be writable
##   

include(FetchContent)

# The URL to fetch bootfiles from
set(SMLNJ_SRCARCHIVEURL "https://smlnj.cs.uchicago.edu/dist/working/")

macro(declare_bootfile version suffix hash)
    FetchContent_Declare(
        "boot.${suffix}.${version}"
        URL "${SMLNJ_SRCARCHIVEURL}/${version}/boot.${suffix}.tgz"
        URL_HASH "${hash}"
        TLS_VERIFY True
    )
endmacro()

# These hashes can be calculated with `curl -s <url> | sha256sum`

## 110.99.8
declare_bootfile(110.99.8 amd64-unix
    SHA256=b9d2dec5a4a77be7caf3badc1166ae4cbd912fb7b22c041c9459477f5df8f064)
declare_bootfile(110.99.8 ppc-unix
    SHA256=4e165002979fbd9d93e034b9a23f81186744dadf35648d8ff82a4b966e6eacfa)
declare_bootfile(110.99.8 sparc-unix
    SHA256=d4d71fdade73b234d6f79623d3cca4f5cf2dad966216b70dbe07024b1e49312d)
declare_bootfile(110.99.8 x86-unix
    SHA256=a4d3d6d7699cd7b41c2eafaf83c97c9d8985384cba55b7420254531703972ffa)
declare_bootfile(110.99.8 x86-win32
    SHA256=e783ff41f19b219aa00b24eb3f02c43b3ae75d56a562a69699143a5bedb9f021)

## 110.99.7.1
declare_bootfile(110.99.7.1 amd64-unix
    SHA256=aa0703f0cad35e0f716b412c23127229760ee05a4455ae3f6021b4cee847d754)
declare_bootfile(110.99.7.1 ppc-unix
    SHA256=f8243995e20d1aeef8efcaf46d62e272b6433eb6262f2b61fedf218e481756b0)
declare_bootfile(110.99.7.1 sparc-unix
    SHA256=bc54508dfdd0dd0c4e3854932d606f32894c6bef3c9c11e94d3815f5bdab216b)
declare_bootfile(110.99.7.1 x86-unix
    SHA256=55424c39af2905e0c538b8af19a3c2d016ed02c8095e3723a73260c2980e875a)
declare_bootfile(110.99.7.1 x86-win32
    SHA256=fddaa0a1a8591781c05f2e788c6e4ddc2cbef5b45b3aad902fc6eefb0fb466fa)

## 110.99.7
declare_bootfile(110.99.7 amd64-unix
    SHA256=c39a23d7aa64986ba2383296e0be0f23ad7b6940e6ad3f357af814ec06fa7874)
declare_bootfile(110.99.7 ppc-unix
    SHA256=12acf646d92bf14a6d8911d1f5493b87e1a819b3eb1026944e8cb6c8846f57bb)
declare_bootfile(110.99.7 sparc-unix
    SHA256=180a5beeb810490e4aa4e3e2ea1a040184778c2e80c2dda9de1749d2f7c0adee)
declare_bootfile(110.99.7 x86-unix
    SHA256=712bbd6bc65818d001088033e9d775f0ad6aadc6a864f33b8362ec344a226df3)
declare_bootfile(110.99.7 x86-win32
    SHA256=5f0d2e639bbb1ac12ca84dc7db53703b96b12835db699f3f07209fd61cc95bab)

## 110.99.6.1
declare_bootfile(110.99.6.1 amd64-unix
    SHA256=91469b2b4dcc7526154568562a5de44b7d92131518a4cdccb4b534982c6189a4)
declare_bootfile(110.99.6.1 ppc-unix
    SHA256=8defd5b4bade063b3a64812d351094ece13fe00291d494dcc6feec2aaf768d57)
declare_bootfile(110.99.6.1 sparc-unix
    SHA256=08df5322ce771a8bce9b3f699139c2c914055ec4fda86fa940a59cc638836414)
declare_bootfile(110.99.6.1 x86-unix
    SHA256=db2058d30199f01d63602e68b3d49f1fa78a2685a5438ac0725042dcf9da7287)
declare_bootfile(110.99.6.1 x86-win32
    SHA256=76d8402710982624421f98c564e776f850f1d24e2543292e4655932c44eb6907)

## 110.99.6
declare_bootfile(110.99.6 amd64-unix
    SHA256=487518b7f8c92d48ae208802ab717f5f6d2bdf48b7f854b654936c32964cbd49)
declare_bootfile(110.99.6 ppc-unix
    SHA256=a1dae55d3785d429563847c5a28b5bc32cd05bf03cdbb958c97d68c94394e88c)
declare_bootfile(110.99.6 sparc-unix
    SHA256=44fa53c6b8fa0808a563959c760db3204482f26cf7d5bfb8e0102335c2286220)
declare_bootfile(110.99.6 x86-unix
    SHA256=edf934c7d963f649584e58f278cb8a692c99a1c740c058d7b0d2bba8fe8c11a5)
declare_bootfile(110.99.6 x86-win32
    SHA256=0f36a7a2ae8ca268f09fe615e866aea193e94f7a956919a5df3b33c747914c1a)

