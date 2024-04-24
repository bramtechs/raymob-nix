{ pkgs ? import <nixpkgs> {config.android_sdk.accept_license = true; config.allowUnfreePredicate = _: true; }, doom ? import <doomhowl> {} }:

with pkgs;

let
  android-nixpkgs = callPackage (import (builtins.fetchGit {
    url = "https://github.com/tadfisher/android-nixpkgs.git";
  })) {
    # Default; can also choose "beta", "preview", or "canary".
    channel = "stable";
  };

  buildToolsVersion = "34.0.0";
  
  android-sdk = android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    build-tools-34-0-0
    platform-tools
    platforms-android-33
    ndk-25-1-8937393
    cmake-3-22-1
    emulator
  ]);

in
mkShell
  {
    buildInputs = [
      openjdk17-bootstrap
      android-sdk 
    ];

      shellHook = ''
        export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_SDK_ROOT/build-tools/${buildToolsVersion}/aapt2"
      ''; 
  }
  
