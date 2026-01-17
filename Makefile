.PHONY: build
build:
	fvm flutter build apk --flavor production -t lib/main_production.dart --dart-define-from-file .env.production --release

.PHONY: build-bundle
build-bundle:
	fvm flutter build appbundle --flavor production -t lib/main_production.dart --dart-define-from-file .env.production --release
