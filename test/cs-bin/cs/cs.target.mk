# This file is generated by gyp; do not edit.

TOOLSET := target
TARGET := cs
DEFS_Debug :=

# Flags passed to all source files.
CFLAGS_Debug := \
	-O2 \
	-Wall

# Flags passed to only C files.
CFLAGS_C_Debug :=

# Flags passed to only C++ files.
CFLAGS_CC_Debug :=

INCS_Debug := \
	-Isrc \
	-Isrc/qzFeedsExt \
	-Isrc/unix

DEFS_Release :=

# Flags passed to all source files.
CFLAGS_Release :=

# Flags passed to only C files.
CFLAGS_C_Release :=

# Flags passed to only C++ files.
CFLAGS_CC_Release :=

INCS_Release := \
	-Isrc \
	-Isrc/qzFeedsExt \
	-Isrc/unix

OBJS := \
	$(obj).target/$(TARGET)/cs/cs.o

# Add to the list of files we specially track dependencies for.
all_deps += $(OBJS)

# Make sure our dependencies are built before any of us.
$(OBJS): | $(obj).target/src/libneo.a

# CFLAGS et al overrides must be target-local.
# See "Target-specific Variable Values" in the GNU Make manual.
$(OBJS): TOOLSET := $(TOOLSET)
$(OBJS): GYP_CFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_C_$(BUILDTYPE))
$(OBJS): GYP_CXXFLAGS := $(DEFS_$(BUILDTYPE)) $(INCS_$(BUILDTYPE))  $(CFLAGS_$(BUILDTYPE)) $(CFLAGS_CC_$(BUILDTYPE))

# Suffix rules, putting all outputs into $(obj).

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(srcdir)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# Try building from generated source, too.

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj).$(TOOLSET)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

$(obj).$(TOOLSET)/$(TARGET)/%.o: $(obj)/%.c FORCE_DO_CMD
	@$(call do_cmd,cc,1)

# End of this set of suffix rules
### Rules for final target.
LDFLAGS_Debug :=

LDFLAGS_Release :=

LIBS :=

$(builddir)/cs: GYP_LDFLAGS := $(LDFLAGS_$(BUILDTYPE))
$(builddir)/cs: LIBS := $(LIBS)
$(builddir)/cs: LD_INPUTS := $(OBJS) $(obj).target/src/libneo.a
$(builddir)/cs: TOOLSET := $(TOOLSET)
$(builddir)/cs: $(OBJS) $(obj).target/src/libneo.a FORCE_DO_CMD
	$(call do_cmd,link)

all_deps += $(builddir)/cs
# Add target alias
.PHONY: cs
cs: $(builddir)/cs

# Add executable to "all" target.
.PHONY: all
all: $(builddir)/cs

