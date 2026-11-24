#!/usr/bin/env bash
set -euo pipefail

# Use a Linux checkout for Autotools and preserve edits from the Windows checkout.
source_git() { git -c safe.directory=/source -C /source "$@"; }
git -c safe.directory=/source clone --quiet --shared /source /tmp/vlc
cd /tmp/vlc
source_git diff --no-ext-diff --no-textconv --binary HEAD -- > /tmp/working.patch
if [[ -s /tmp/working.patch ]]; then
    git apply --whitespace=nowarn /tmp/working.patch
fi
source_git ls-files --others --exclude-standard -z |
    tar -C /source --null -T - -cf - | tar -xf -

# Use the same dependency bundle as CI when its inputs match this checkout.
git add -N .
flags=(-a x86_64 -l)
if git diff --quiet HEAD -- extras/tools contrib extras/ci extras/package/win32; then
    revision=$(extras/ci/get-contrib-sha.sh win64)
    archive="https://artifacts.videolan.org/vlc-3.0/win64/vlc-contrib-x86_64-w64-mingw32-${revision}.tar.zst"
    if extras/ci/check-url.sh "$archive"; then
        export VLC_PREBUILT_CONTRIBS_URL="$archive"
        flags+=(-p)
    fi
fi

extras/package/win32/build.sh "${flags[@]}"
make -C win64 package-win32-debug-zip
cp win64/vlc-*-win64-debug.zip /output/
