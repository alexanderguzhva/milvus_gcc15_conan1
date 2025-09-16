# building Milvus with GCC-15 / Clang-21 using conan 1

**TLDR**: compile milvus with GCC-15 on Ubuntu 22.04 on x86, upgrade some packages (including `OpenSSL`), don't care about old compilers

See the bottom of the document for minor clang-related changes (see `Step 15` section down there) before starting.

Milvus commit: `9228ed7b8f2bc4a39c10f9a73cd605f5cd9414a6` (the most recent commit `b38013352dada7bb1c156ae66669f3e7f8274123` won't compile because of some missing references)

## Start a container

```bash
docker pull ubuntu:22.04
docker run -it --name milvus_2204_gcc15 ubuntu:22.04
```

I'm demonstrating the sequence of commands if they were executed inside a container.

## Step 1. Install GCC-15

Check `01_install_gcc15.sh`

```
Libraries have been installed in:
   /opt/gcc-15/lib/../lib64

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'
```

## Step 2. Install the most recent cmake

Check `02_install_cmake.sh`

## Step 3. Install golang 1.24

Check `03_install_golang_124.sh`

## Step 4. Download conan1

Check `04_install_conan1.sh`

## Step 5. Setup conan.

Check `05_setup_conan.sh`

This step does the following:

* Allows conan1 to accept `GCC-15`
* Modifies a default conan profile for `GCC-15` and certain packages

This conan profile also introduces some additional C++ compilation flags for certain packages. Basically, starting from `GCC-13`, the `GCC` compiler started being stricter about `#include <cstdint>`, so this is a cheap way to patch a package.

## Step 6. Setup M4 package

Check `06_setup_package_m4.sh`

`M4` package's most recent version is `1.4.20`, but I cannot easily replace it in conan builds, because it is introduced as `tool_required`, even in Conan 2. The most practical way is to use `M4` version `1.4.20` and put it as `1.4.19`. 

This script compiles `M4` version `1.4.20` and puts it into a local conan cache as `1.4.19`. You DO need to compile it.

## Step 7. Download some extra packages

Check `07_download_some.sh`

Some third-party components from prereqs

## Step 7a. Setup OpenSSL 3.5.2 (the most recent)

Check `07a_setup_package_openssl.sh`

This scripts introduces a recipe for OpenSSL 3.5.2 and puts into a local conan cache. It is **expected** that this script fails for conan. I'm not sure why but I cannot compile OpenSSL 3.5.2 (using uncommenting commented lines in the script). This hacky way will make conan to compile openssl during the milvus build. If you don't want such a hack, switch to OpenSSL 3.3.2 in `milvus/internal/core/conanfile.py`, which is the most recent available version in Conan 1 `conancenter` repo.

## Step 8. Setup Cyrus-Sasl package

Check `08_setup_package_cyrus_sasl.sh`

Some old package used by `mongoc-driver`. I've used one of the recent commits from its github, which fixes the errors and the compilation. The commit diff is hardcoded in `conanfile.py`.

This script puts the package into a local conan cache. It is **expected** that conan fails for this script. Uncomment the commented lines to compile the package (which is unneeded, it will be compiled during the milvus build).

Also, its `conanfile.py` refers to an external file https://gist.github.com/alexanderguzhva/fbe0fc0f940e7d29d70f11c05f4f05e8/raw/3c13b80de6621ca2ce61251c83aca3e562f813fa/cyrus_sasl_ac0c278817a082c625c496ec812318c019e0b96f_with_configure.tar.gz . Basically, a github-provided source does not provide `./configure` file, but provides `./autogen.sh`. The archive mentioned above contains a generated `configure`, that's it.

Also, `conanfile.py` is expected to call the compilation the code twice (yes, twice), bcz of some incorrect compilation order.

## Step 9. Setup the newest zstd 1.5.7 package

Check `09_setup_package_zstd.sh`

Installs the most recent `zstd` version `1.5.7` with perf improvements.

This script puts the package into a local conan cache. It is **expected** that conan fails for this script. Uncomment the commented lines to compile the package (which is unneeded, it will be compiled during the milvus build).

## Step 10. Setup thrift package

Check `10_setup_package_thrift.sh`

Installs thrift 0.22.0. Mostly, an experiment from myself whether it is trivial to upgrade packages.

This script puts the package into a local conan cache. It is **expected** that conan fails for this script. Uncomment the commented lines to compile the package (which is unneeded, it will be compiled during the milvus build).

## Step 11. Setup yaml-cpp package

Check `11_setup_package_yaml_cpp.sh`

Same

This script puts the package into a local conan cache. It is **expected** that conan fails for this script. Uncomment the commented lines to compile the package (which is unneeded, it will be compiled during the milvus build).

## Step 12. Install milvus and replace some files

Check `12_download_milvus.sh`

Downloads milvus and sets up a right commit as a current one

Also, please overwrite

* `milvus/scripts/3rdparty_build.sh` with `step12/3rdparty_build.sh`  
* `milvus/internal/core/conanfile.py` with `step12/conanfile.py`

Use `step12/builder.sh` for compiling milvus (step 14)

## Step 13. Apply patch to milvus

Check `step13/1.patch`

Basically, it injects missing `#include <cstdint>` headers to certain milvus files.

## Step 14. Compile milvus

Use `step12/builder.sh` for compiling milvus

## Step 15. Clang

You may use the given process, but do the following extra steps:

First, install `clang` version `21` instead of `GCC` on `step 1`. Follow the instruction on https://apt.llvm.org/

```bash
cd /tmp
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 21
```

Then, add the following line to the end of `step5/default` conan profile` in step 5: 

`grpc:CXXFLAGS=-Wno-missing-template-arg-list-after-template-kw`

Basically, it is needed to silence a particular warning.

Then, add the following symbolic links (or play with `update-alternatives` if you want a hard way)

```bash
sudo ln -s /usr/bin/clang++-21 /usr/bin/clang++
sudo ln -s /usr/bin/clang-21 /usr/bin/clang
```

## The result

I was able to successfully compile milvus, including cardinal.

ARM will likely require libunwind change to 1.8.0 or 1.8.1

# More comments

* Upgrading to conan 2 is straightforward. 
* Conan 2 allows upgrading more packages than Conan 1.
* Upgrading google 3rd-party components ultimately requires a rework of a deprecated interface `google::cloud::oauth2_internal::Credentials`, which is available in `google-cloud-cpp` version `2.5.0`, but unavailable in `2.11.0`. It unwinds a chain of possible dependencies upgrades.
* Certain packages can be upgraded, say, `rocksdb` to `10.5.1`, but it requires an upgrade on `Milvus` side as well
