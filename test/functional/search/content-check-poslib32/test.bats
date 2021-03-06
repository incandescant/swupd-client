#!/usr/bin/env bats

load "../../swupdlib"

setup() {
  clean_test_dir
  tar -C "$DIR/web-dir/10" -cf "$DIR/web-dir/10/Manifest.MoM.tar" Manifest.MoM Manifest.MoM.signed
  tar -C "$DIR/web-dir/10" -cf "$DIR/web-dir/10/Manifest.test-bundle.tar" Manifest.test-bundle Manifest.test-bundle.signed
  tar -C "$DIR/web-dir/10" -cf "$DIR/web-dir/10/Manifest.os-core.tar" Manifest.os-core Manifest.os-core.signed
}

teardown() {
  pushd "$DIR/web-dir/10"
  rm *.tar
  popd
}

@test "search for a library in lib32" {
  run sudo sh -c "$SWUPD search $SWUPD_OPTS -l test-lib32"

  echo "$output"
  [ "${lines[0]}" = "Attempting to download version string to memory" ]
  [ "${lines[1]}" = "Searching for 'test-lib32'" ]
  echo "$output" | grep -q "'test-bundle'  :  '/usr/lib/test-lib32'"
  [ $? -eq 0 ]
}

# vi: ft=sh ts=8 sw=2 sts=2 et tw=80
