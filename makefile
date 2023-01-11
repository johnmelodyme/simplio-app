clean:
	flutter clean

install:
	flutter pub get

generate:
	flutter packages pub run build_runner build --delete-conflicting-outputs

localize:
	flutter gen-l10n

analyze:
	flutter analyze

test:
	flutter test tests/unit_tests
