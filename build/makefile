.PHONY: clean all run

PROJECT_BUILD_PATH = ./bin
PROJECT_SRC_PATH = ../src
PROJECT_TST_PATH = ../test

PROJECT_SRC_FILES = $(wildcard ../src/*.v)
PROJECT_SRC_FILES += $(wildcard ../src/*.vh)

PROJECT_TESTBENCH = $(PROJECT_TST_PATH)/mips_pipeline_tb.v

IVERILOG_FLAGS = -Wall

all: $(PROJECT_SRC_FILES) $(PROJECT_TESTBENCH)
	@iverilog $(IVERILOG_FLAGS) -o $(PROJECT_BUILD_PATH)/out $(PROJECT_TESTBENCH) $(PROJECT_SRC_FILES)

run:
	@vvp $(PROJECT_BUILD_PATH)/out

clean:
	@rm -vrf $(wildcard $(PROJECT_BUILD_PATH)/*)