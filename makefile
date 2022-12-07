gen:
	flutter packages pub run build_runner build --delete-conflicting-outputs

loc:
	flutter gen-l10n

get:
	flutter pub get

clean:
	flutter clean

check:
	flutter analyze
