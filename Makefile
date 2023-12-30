# Configuration for GNU make
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKE := make -s
DATETIME_FORMAT := %(%Y-%m-%d %H:%M:%S)T
.ONESHELL:
.SUFFIXES:
.DELETE_ON_ERROR:
.DEFAULT_GOAL := all

# Check for required commands to run this Makefile
YQ := $(shell command -v yq 2> /dev/null)
ifeq ($(YQ),)
$(error "yq is not available")
endif

MO := ./template/mo # mo is a mustache template engine
ifeq ($(MO),)
$(error "mo is not available")
endif

# Set variables
DEFFILE_GO_URL := https://raw.githubusercontent.com/apptainer/apptainer/main/pkg/build/types/parser/deffile.go

SHELLSCRIPT_SECTIONS_RE := setup|files|environment|pre|post|runscript|test|startscript|appinstall|appfiles|appenv|apptest|apprun|appstart
LABELS_SECTIONS_RE := labels|applabels
HELP_SECTIONS_RE := help|apphelp
ARGUMENTS_SECTIONS_RE := arguments

build/deffile.go: # Get deffile.go from apptainer repo
	@mkdir -p $(@D) && curl -L $(DEFFILE_GO_URL) -o $@

.PHONY: extract-valid-headers
extract-valid-sections: build/deffile.go # Extract valid sections from deffile.go
	@cat $< | sed -nE '/var\s+validSections.*\{/,/\}/p' | grep -oE '"[^"].*"' | tr -d '"' | paste -sd '|'

.PHONY: extract-valid-headers
extract-valid-headers: build/deffile.go # Extract valid headers from deffile.go
	@cat $< | sed -nE '/var\s+validHeaders.*\{/,/\}/p' | grep -oE '"[^"].*"' | tr -d '"' | paste -sd '|'

.PHONY: extract-valid-sections
extract-app-sections: build/deffile.go # Extract app sections from deffile.go
	@cat $< | sed -nE '/var\s+appSections.*\{/,/\}/p' | grep -oE '"[^"].*"' | tr -d '"' | paste -sd '|'

.PHONY: extract-shellscript-sections
extract-shellscript-sections: build/deffile.go # Extract shellscript sections from deffile.go
	@$(MAKE) extract-app-sections extract-valid-sections | tr '|' '\n' | sort | uniq | grep -E "$(SHELLSCRIPT_SECTIONS_RE)" | paste -sd '|'

.PHONY: extract-labels-sections
extract-labels-sections: build/deffile.go # Extract shellscript sections from deffile.go
	@$(MAKE) extract-app-sections extract-valid-sections | tr '|' '\n' | sort | uniq | grep -E "$(LABELS_SECTIONS_RE)" | paste -sd '|'

.PHONY: extract-arguments-sections
extract-arguments-sections: build/deffile.go # Extract shellscript sections from deffile.go
	@$(MAKE) extract-app-sections extract-valid-sections | tr '|' '\n' | sort | uniq | grep -E "$(ARGUMENTS_SECTIONS_RE)" | paste -sd '|'

.PHONY: extract-other-sections
extract-other-sections: build/deffile.go # Extract other sections from deffile.go
	@$(MAKE) extract-app-sections extract-valid-sections | tr '|' '\n' | sort | uniq | grep -vE '$(SHELLSCRIPT_SECTIONS_RE)|$(LABELS_SECTIONS_RE)|$(ARGUMENTS_SECTIONS_RE)' | paste -sd '|'

build/apptainer.tmLanguage.json: template/apptainer.tmLanguage.yml.mo build/deffile.go # Generate apptainer.tmLanguage.json from template
	OTHER_SECTIONS='$(shell $(MAKE) extract-other-sections)' \
	VALID_HEADERS='$(shell $(MAKE) extract-valid-headers)' \
	SHELLSCRIPT_SECTIONS='$(shell $(MAKE) extract-shellscript-sections)' \
	LABELS_SECTIONS='$(shell $(MAKE) extract-labels-sections)' \
	ARGUMENTS_SECTIONS='$(shell $(MAKE) extract-arguments-sections)' \
	$(MO) $< | yq --input-format yml --output-format json > $@

syntaxes/apptainer.tmLanguage.json: build/apptainer.tmLanguage.json # Copy apptainer.tmLanguage.json to syntaxes
	@mkdir -p $(@D) && cp $< $@

.PHONY: clean
clean: # Clean build files
	rm -f build/*.json build/*.mo build/*.yml build/*.yaml syntaxes/*.json

.PHONY: clean-all
clean-all: clean
	rm -rf build/

all: syntaxes/apptainer.tmLanguage.json # Default target
