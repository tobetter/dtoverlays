HOSTCC := gcc
DTC := $(shell which dtc)

src=$(CURDIR)

export DTC

.DEFAULT_GOAL := all
MAKEFLAGS += --no-print-directory

ifeq ("$(origin V)", "command line")
	KBUILD_VERBOSE = $(V)
endif

ifndef KBUILD_VERBOSE
	KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
	quiet =
	Q =
else
	quiet = quiet_
	Q = @
endif

export KBUILD_VERBOSE quiet Q

ifndef KERNELRELEASE
	KERNELRELEASE=$(shell uname -r)
endif

export KERNELRELEASE

ifndef DESTDIR
	DESTDIR=/boot/dtbs/$(KERNELRELEASE)
endif

export DESTDIR

version_tag := $(shell echo $(KERNELRELEASE) | sed "s/-arm64//g")
srctree := /usr/src/linux-headers-$(version_tag)-common
fixdep := /lib/modules/$(KERNELRELEASE)/build/scripts/basic/fixdep

export version_tag srctree fixdep

.PHONY: prepare
prepare:
ifeq ($(wildcard /usr/src/linux-headers-$(KERNELRELEASE)),)
	@echo >&2 '*** "/usr/src/linux-headers-$(KERNELRELEASE)" is missing.'
	@echo >&2 '***'
	@echo >&2 '*** Probably you need to install Linux kernel header package'
	@echo >&2 '*** and try again.'
	@echo >&2 '***'
	@echo >&2 '***   $$ sudo apt update'
	@echo >&2 '***   $$ sudo apt install -y linux-headers-$(KERNELRELEASE)'
	@echo >&2 '***'
	@exit 1
endif

all: dtbs

.PHONY: build dtbs install
dtbs: prepare
	$(Q)$(MAKE) -f $(src)/Makefile.build \
		src=$(src)/overlays obj=$(src)/overlays

install: dtbs
	$(Q)$(MAKE) -f $(src)/Makefile.install \
		src=$(src)/overlays obj=$(src)/overlays dst=$(DESTDIR)

uninstall: prepare
	$(Q)$(MAKE) -f $(src)/Makefile.uninstall \
		src=$(src)/overlays obj=$(src)/overlays dst=$(DESTDIR)

clean: prepare
	$(Q)$(MAKE) -f $(src)/Makefile.clean \
		src=$(src)/overlays obj=$(src)/overlays

# vim: filetype=make
