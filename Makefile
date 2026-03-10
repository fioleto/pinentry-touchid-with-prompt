# Copyright (c) 2026 Futo Sasaki. All rights reserved.
# Licensed under the Apache License, Version 2.0

BINARY          := pinentry-touchid-with-prompt
SIGNING_IDENTITY ?= -
APPLE_ID        ?=
APPLE_PASSWORD  ?=
APPLE_TEAM_ID   ?= KM7UDALG6L

.PHONY: build sign notarize verify clean

build:
	CGO_ENABLED=1 go build -o $(BINARY) .

sign: build
	codesign --sign "$(SIGNING_IDENTITY)" --options runtime --timestamp $(BINARY)

verify:
	codesign --verify --verbose $(BINARY)

notarize: sign
	zip $(BINARY).zip $(BINARY)
	xcrun notarytool submit $(BINARY).zip \
		--apple-id "$(APPLE_ID)" \
		--password "$(APPLE_PASSWORD)" \
		--team-id "$(APPLE_TEAM_ID)" \
		--wait
	xcrun stapler staple $(BINARY).zip

clean:
	rm -f $(BINARY) $(BINARY).zip
