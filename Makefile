# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)


# Resolve Flutter project dependencies.
#
# Usage:
#   make deps

deps:
	flutter pub get


# Format Flutter Dart sources with dartfmt.
#
# Usage:
#   make fmt [check=(no|yes)]

fmt:
	flutter format $(if $(call eq,$(check),yes),-n --set-exit-if-changed,) .


# Lint Flutter Dart sources with dartanalyzer.
#
# Usage:
#   make lint

lint:
	flutter analyze .


# Runs Flutter tests.
#
# Usage:
#   make test

test:
	flutter test


# Build Flutter project.
#
# Usage:
#   make build [platform=(apk|ios)]

build:
	flutter build $(if $(call eq,$(platform),ios),ios,apk)


# Release project on GitHub.
#
# Usage:
#   make release

release:
	-git tag -d latest
	git tag latest
	git push origin latest --force


.PHONY: deps build fmt lint release test
