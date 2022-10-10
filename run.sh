#!/bin/sh

# use --flavor dev for running on android device

flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# developer needs to specify runtime variables in ~/.zshrc or similar file
# export DART_DEFINE_API_URL="IS_PROD"
# export DART_DEFINE_API_URL="URL_PLACEHOLDER"
# export DART_DEFINE_API_KEY="API_KEY_PLACEHOLDER"
flutter run --dart-define=IS_PROD=$IS_PROD --dart-define=API_URL=$DART_DEFINE_API_URL --dart-define=API_KEY=$DART_DEFINE_API_KEY $1 $2 $3
