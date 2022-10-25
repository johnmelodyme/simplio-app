#!/bin/sh
# use --flavor dev for running on android device

while getopts ":c" flag; do
    # shellcheck disable=SC2220
    case "${flag}" in
        c) flutter clean
           flutter pub get
           flutter packages pub run build_runner build --delete-conflicting-outputs
           flutter run \
           --dart-define=IS_PROD="$IS_PROD" \
           --dart-define=API_URL="$DART_DEFINE_API_URL" \
           --dart-define=MNEMONIC="$MNEMONIC" $2 $3
           ;;
    esac
done



# developer needs to specify runtime variables in ~/.zshrc or similar file
# export DART_DEFINE_API_URL="IS_PROD"
# export DART_DEFINE_API_URL="URL_PLACEHOLDER"
# export MNEMONIC="region grain trick nose stamp example attract torch timber awake just solar" // YOUR MNEMONIC SEED
# export DART_DEFINE_API_KEY="API_KEY_PLACEHOLDER" (not needed anymore)
flutter run \
--dart-define=IS_PROD="$IS_PROD" \
--dart-define=API_URL="$DART_DEFINE_API_URL" \
--dart-define=MNEMONIC="$MNEMONIC" $1 $2
