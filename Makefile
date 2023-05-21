#
# Make system for sfor
#

APP = stdapp
APP_TARGET = x86_64-unknown-arceos.json

LIBOS = libos
LIBOS_FEATURES =
LIBOS_TARGET = x86_64-unknown-none

LD_SCRIPT := $(CURDIR)/linker_x86_64.lds

RELEASE ?= n	# y/n

ifeq ($(RELEASE), y)
	MODE_DIR = release
else
	MODE_DIR = debug
endif

APP_TARGET_DIR = $(APP)/target/$(basename $(APP_TARGET))/$(MODE_DIR)
LIBOS_TARGET_DIR = $(LIBOS)/target/$(LIBOS_TARGET)/$(MODE_DIR)

OUT_DIR = output

all: build
	@printf "make $@\n"

build: $(OUT_DIR) $(OUT_DIR)/$(APP)
	@printf "make $@\n"

$(OUT_DIR):
	@printf "make $@\n"
	mkdir -p $@

$(OUT_DIR)/$(APP): $(APP_TARGET_DIR)/$(APP)
	cp $^ $@

$(APP_TARGET_DIR)/$(APP): $(OUT_DIR)/$(LIBOS).a
	@printf "make $@\n"
	cargo rustc --manifest-path $(APP)/Cargo.toml \
		-Zbuild-std=core,alloc,panic_abort \
		-Zbuild-std-features=compiler-builtins-mem \
		--target $(APP_TARGET) \
		-- -L native=$(CURDIR)/$(OUT_DIR) -l static=os \
		-Clink-args="-T$(LD_SCRIPT)"

$(OUT_DIR)/$(LIBOS).a: $(LIBOS_TARGET_DIR)/$(LIBOS).a
	@printf "make $@\n"
	cp $^ $@
	cp ./$(LIBOS)/libarceos.redefine-syms.template $(OUT_DIR)/libarceos.redefine-syms
	nm --defined-only --print-file-name $(DIST_ARCHIVE) 2>/dev/null | \
		grep "^$(DIST_ARCHIVE):arceos-" | cut -d ' ' -f 3 | \
		grep "^arceos_" | xargs -Isymbol echo 'libarceos_symbol' \
		>> $(OUT_DIR)/libarceos.redefine-syms
	objcopy --prefix-symbols=libarceos_ $@
	objcopy --redefine-syms=$(OUT_DIR)/libarceos.redefine-syms $@

$(LIBOS_TARGET_DIR)/$(LIBOS).a: FORCE
	@printf "make $@\n"
	cargo rustc --manifest-path $(LIBOS)/Cargo.toml \
		--target $(LIBOS_TARGET) \
		--no-default-features --features "$(LIBOS_FEATURES)"

run: build justrun
	@printf "make $@\n"

justrun:
	@printf "make $@\n"
	qemu-system-x86_64 -smp 1 \
		-display none -m 1G -serial stdio \
		-cpu qemu64,apic,fsgsbase,rdtscp,xsave,xsaveopt,fxsr \
		-device isa-debug-exit,iobase=0xf4,iosize=0x04 \
		-kernel $(OUT_DIR)/$(APP) \
		-D qemu.log -d in_asm,int,mmu,pcall,cpu_reset,guest_errors

clean:
	@printf "make $@\n"
	@rm -rf $(OUT_DIR)/ $(LIBOS)/target/ $(APP)/target/

FORCE:

.PHONY: all build clean run justrun FORCE
