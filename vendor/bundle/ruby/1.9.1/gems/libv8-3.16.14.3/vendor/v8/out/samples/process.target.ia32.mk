# This file is generated by gyp; do not edit.

TOOLSET := target
TARGET := process
DEFS_Debug := \
	'-DENABLE_DEBUGGER_SUPPORT' \
	'-DV8_TARGET_ARCH_IA32' \
	'-DDEBUG' \
	'-DENABLE_DISASSEMBLER' \
	'-DV8_ENABLE_CHECKS' \
	'-DOBJECT_PRINT' \
	'-DVERIFY_HEAP' \
	'-DENABLE_EXTRA_CHECKS'

# Flags passed to all source files.
CFLAGS_Debug := \
	-Wall \
	-Werror \
	-W \
	-Wno-unused-parameter \
	-Wnon-virtual-dtor \
	-pthread \
	-fno-rtti \
	-fno-exceptions \
	-pedantic \
	-Wno-unused-local-typedefs \
	-ansi \
	-m32 \
	-g \
	-O0 \
	-Wall \
	-Werror \
	-W \
	-Wno-unused-parameter \
	-Wnon-virtual-dtor \
	-Woverloaded-virtual \
	-Wno-unused-local-typedefs

# Flags passed to only C files.
CFLAGS_C_Debug :=

# Flags passed to only C++ files.
CFLAGS_CC_Debug :=

INCS_Debug := \
	-I$(srcdir)/include

DEFS_Release := \
	'-DENABLE_DEBUGGER_SUPPORT' \
	'-DV8_TARGET_ARCH_IA32'

# Flags passed to all source files.
CFLAGS_Release := \
	-Wall \
	-Werror \
	-W \
	-Wno-unused-parameter \
	-Wnon-virtual-dtor \
	-pthread \
	-fno-rtti \
	-fno-exceptions \
	-pedantic \
	-Wno-unused-local-typedefs \
	-ansi \
	-m32 \
	-fdata-sections \
	-ffunction-sections \
	-O3

# Flags passed to only C files.
CFLAGS_C_Release :=

# Flags passed to only C++ files.
CFLAGS_CC_Release :=

INCS_Release := \
	-I$(srcdir)/include

OBJS := \
	$(obj).target/$(TARGET)/samples/process.o

# Add to the list of files we specially track dependencies for.
all_deps += $(OBJS)

# Make sure our dependencies are built before any of us.
$(OBJS): | $(obj).target/tools/gyp/v8.stamp $(obj).target/tools/gyp/libv8_base.a $(obj).target/tools/gyp/libv8_snapshot.a $(obj).target/tools/gyp/js2c.stamp

# CFLAGS et al overrides must be target-local.
# See "Target-specific Variable Values" in the GNU Make manual.
$(OBJS): TOOLSET := $(TOOLSET)
$(OBJS): GYP_CFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_C_$(BUILDTYPE))
$(OBJS): GYP_CXXFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_CC_$(BUILDTYPE))

# Suffix rules, putting all outputs into $(obj).

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(srcdir)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

# Try building from generated source, too.

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj).$(TOOLSET)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj)/%.cc FORCE_DO_CMD
	@$(call do_cmd,cxx,1)

# End of this set of suffix rules
### Rules for final target.
LDFLAGS_Debug := \
	-pthread \
	-m32 \
	-rdynamic

LDFLAGS_Release := \
	-pthread \
	-m32

LIBS :=

$(builddir)/process: GYP_LDFLAGS := $(LDFLAGS_$(BUILDTYPE))
$(builddir)/process: LIBS := $(LIBS)
$(builddir)/process: LD_INPUTS := $(OBJS) $(obj).target/tools/gyp/libv8_base.a $(obj).target/tools/gyp/libv8_snapshot.a
$(builddir)/process: TOOLSET := $(TOOLSET)
$(builddir)/process: $(OBJS) $(obj).target/tools/gyp/libv8_base.a $(obj).target/tools/gyp/libv8_snapshot.a FORCE_DO_CMD
	$(call do_cmd,link)

all_deps += $(builddir)/process
# Add target alias
.PHONY: process
process: $(builddir)/process

# Add executable to "all" target.
.PHONY: all
all: $(builddir)/process

