.PHONY: clean all run

PROJECT_BUILD_PATH = ./bin
PROJECT_SRC_PATH = ../src
PROJECT_TST_PATH = ../test

PROJECT_SRC = $(wildcard ../src/*.v)
PROJECT_SRC += $(PROJECT_TST_PATH)/tb_mips_pipeline.v

PROJECT_INC = -I $(PROJECT_SRC_PATH)

PROJECT_LIBS = -y../lib

REG_INIT_FILE = "../test/reg_init.txt"
IM_FILE = "../test/imem.txt"
DM_FILE = "../test/dmem.txt"
PROJECT_DEFS = -DINSTR_FILE=\"$(IM_FILE)\"
PROJECT_DEFS += -DDATA_FILE=\"$(DM_FILE)\"
PROJECT_DEFS += -DREG_INITF=\"$(REG_INIT_FILE)\"

IVERILOG_FLAGS = -Wall

all: $(PROJECT_SRC)
	@echo build started...
	@iverilog $(IVERILOG_FLAGS) -o $(PROJECT_BUILD_PATH)/out $(PROJECT_DEFS) $(PROJECT_INC) $(PROJECT_LIBS) $(PROJECT_SRC)
	@echo done

clean:
	@echo clean started...
	@rm -vrf $(wildcard $(PROJECT_BUILD_PATH)/*)
	@echo done

run:
	@vvp $(PROJECT_BUILD_PATH)/out