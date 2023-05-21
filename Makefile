#
# Make system for sfor
#

APP = stdapp
APP_TARGET = x86_64-unknown-arceos.json

LIBOS = libos
LIBOS_FEATURES =
LIBOS_TARGET = x86_64-unknown-none

RELEASE ?= n	# y/n

ifeq ($(RELEASE), y)
	MODE_DIR = release
else
	MODE_DIR = debug
endif

LIBOS_TARGET_DIR = $(LIBOS)/target/$(LIBOS_TARGET)/$(MODE_DIR)

OUT_DIR = output

all: build
	@printf "make $@\n"

build: $(OUT_DIR) $(OUT_DIR)/$(APP)
	@printf "make $@\n"

$(OUT_DIR):
	@printf "make $@\n"
	mkdir -p $@

$(OUT_DIR)/$(APP): $(OUT_DIR)/$(LIBOS).a
	@printf "make $@\n"
	cargo rustc --manifest-path $(APP)/Cargo.toml \
		-Zbuild-std=core,alloc,panic_abort \
		-Zbuild-std-features=compiler-builtins-mem \
		--target $(APP_TARGET) \
		-- -L native=$(OUT_DIR) -l static=os

$(OUT_DIR)/$(LIBOS).a: $(LIBOS_TARGET_DIR)/$(LIBOS).a
	@printf "make $@\n"
	cp $^ $@

$(LIBOS_TARGET_DIR)/$(LIBOS).a: FORCE
	@printf "make $@\n"
	cargo rustc --manifest-path $(LIBOS)/Cargo.toml \
		--target $(LIBOS_TARGET) \
		--no-default-features --features "$(LIBOS_FEATURES)"

run: build justrun
	@printf "make $@\n"

justrun:
	@printf "make $@\n"

clean:
	@printf "make $@\n"
	@rm -rf $(OUT_DIR)/ $(LIBOS)/target/ $(APP)/target/

FORCE:

.PHONY: all build clean run justrun FORCE
