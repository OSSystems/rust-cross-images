#!/usr/bin/env bash

set -ex

hide_output() {
  set +x
  on_err="
echo ERROR: An error was encountered with the build.
cat /tmp/build.log
exit 1
"
  trap "$on_err" ERR
  bash -c "while true; do sleep 30; echo \$(date) - building ...; done" &
  PING_LOOP_PID=$!
  $@ &> /tmp/build.log
  trap - ERR
  kill $PING_LOOP_PID
  set -x
}

VERSION=7.66.0

# This needs to be downloaded directly from S3, it can't go through the CDN.
# That's because the CDN is backed by CloudFront, which requires SNI and TLSv1
# (without paying an absurd amount of money).
curl https://rust-lang-ci-mirrors.s3-us-west-1.amazonaws.com/rustc/curl-$VERSION.tar.xz \
  | xz --decompress \
  | tar xf -

# Remove packaged curl as we'll install from source a new one.
apt-get remove -y curl
apt-get autoremove -y

mkdir curl-build
cd curl-build
hide_output ../curl-$VERSION/configure \
      --prefix=/usr \
      --disable-sspi \
      --disable-gopher \
      --disable-smtp \
      --disable-smb \
      --disable-imap \
      --disable-pop3 \
      --disable-tftp \
      --disable-telnet \
      --disable-manual \
      --disable-dict \
      --disable-rtsp \
      --disable-ldaps \
      --disable-ldap
hide_output make -j10
hide_output make install

cd ..
rm -rf curl-build
rm -rf curl-$VERSION
