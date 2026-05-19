.PHONY: build run package install uninstall clean

APP_NAME := MarkdownReader
INSTALL_DIR := $(HOME)/Applications
APP_BUNDLE := .build/release/$(APP_NAME).app

build:
	swift build

run:
	swift run MarkdownReader

package:
	bash Scripts/package-app.sh release

install: package
	mkdir -p "$(INSTALL_DIR)"
	rm -rf "$(INSTALL_DIR)/$(APP_NAME).app"
	cp -R "$(APP_BUNDLE)" "$(INSTALL_DIR)/"
	@echo "Installed $(APP_NAME) to $(INSTALL_DIR)/$(APP_NAME).app"

uninstall:
	rm -rf "$(INSTALL_DIR)/$(APP_NAME).app"
	@echo "Removed $(INSTALL_DIR)/$(APP_NAME).app"

clean:
	swift package clean
