# GNU assembler (as) Makefile for Linux x86_64

AS      = as
LD      = ld

SRC_DIR = src
BUILD   = build

SRCS    = $(wildcard $(SRC_DIR)/*.s)
BINS    = $(patsubst $(SRC_DIR)/%.s,$(BUILD)/%,$(SRCS))

all: $(BUILD) $(BINS)

$(BUILD):
	mkdir -p $(BUILD)

# compile each .s into its own binary
$(BUILD)/%: $(SRC_DIR)/%.s | $(BUILD)
	$(AS) $< -o $(BUILD)/$*.o
	$(LD) $(BUILD)/$*.o -o $@

run: all
	@echo "Run with: ./build/<program_name>"

clean:
	rm -rf $(BUILD)

.PHONY: all run clean