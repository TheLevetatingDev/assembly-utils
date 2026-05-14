# GNU assembler (as) Makefile for Linux x86_64

AS      = as
LD      = ld

SRC_DIR = src
BUILD   = build

SRC     = $(SRC_DIR)/main.s
OBJ     = $(BUILD)/dog.o
BIN     = $(BUILD)/dog

all: $(BIN)

$(BUILD):
	mkdir -p $(BUILD)

$(OBJ): $(SRC) | $(BUILD)
	$(AS) $(SRC) -o $(OBJ)

$(BIN): $(OBJ)
	$(LD) $(OBJ) -o $(BIN)

run: $(BIN)
	./$(BIN)

clean:
	rm -rf $(BUILD)

.PHONY: all run clean