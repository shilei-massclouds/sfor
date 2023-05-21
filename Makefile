#
# Make system for sfor
#

APP = stdapp
LIB_OS = libos

OUT_DIR = output
APP_ELF = $(OUT_DIR)/$(APP)

all: build
	@printf "make $@\n"

build: $(OUT_DIR) $(APP_ELF)
	@printf "make $@\n"

$(OUT_DIR):
	@printf "make $@\n"
	mkdir -p $@

$(APP_ELF): $(LIB_OS)
	@printf "make $@\n"

$(LIB_OS):
	@printf "make $@\n"

run: build justrun
	@printf "make $@\n"

justrun:
	@printf "make $@\n"

clean:
	@printf "make $@\n"
	@rm -rf $(OUT_DIR)

FORCE:

.PHONY: all build clean run justrun FORCE
