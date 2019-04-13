
ASSEMBLER = java -jar C:/Mars4_5/Mars4_5.jar
ASM_FLAGS = a dump
OUT_FILE_FORMAT = HexText

ASM_SOURCE = dot_product.asm

TEXT_FILE_NAME = ../test/imem.txt
DATA_FILE_NAME = ../test/dmem.txt

all: imem_file dmem_file

imem_file:
	$(ASSEMBLER) $(ASM_FLAGS) .text $(OUT_FILE_FORMAT) $(TEXT_FILE_NAME) $(ASM_SOURCE)

dmem_file:
	$(ASSEMBLER) $(ASM_FLAGS) .data $(OUT_FILE_FORMAT) $(DATA_FILE_NAME) $(ASM_SOURCE)