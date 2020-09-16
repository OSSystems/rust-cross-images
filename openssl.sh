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

VERSION=1.0.2k

# This needs to be downloaded directly from S3, it can't go through the CDN.
# That's because the CDN is backed by CloudFront, which requires SNI and TLSv1
# (without paying an absurd amount of money).
URL=https://rust-lang-ci-mirrors.s3-us-west-1.amazonaws.com/rustc/openssl-$VERSION.tar.gz

curl $URL | tar xzf -

cd openssl-$VERSION
hide_output ./config --prefix=/usr shared -fPIC
hide_output make -j10
hide_output make install
cd ..
rm -rf openssl-$VERSION
