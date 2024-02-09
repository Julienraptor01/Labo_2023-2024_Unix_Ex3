# OS specific setup
ID=$(shell . /etc/os-release ; echo $$ID)
ifeq "$(ID)" "debian"
OS=debian
else ifeq "$(ID)" "fedora"
OS=fedora
else
ID_LIKE=$(shell . /etc/os-release ; echo $$ID_LIKE)
ifeq "$(ID_LIKE)" "debian"
OS=debian
else ifeq "$(ID_LIKE)" "fedora"
OS=fedora
endif
endif
ifeq "$(OS)" "debian"
QT5_HEADERS=/usr/include/x86_64-linux-gnu/qt5
else ifeq "$(OS)" "fedora"
QT5_HEADERS=/usr/include/qt5
else ifndef OS
$(error OS not supported)
endif
### paths
# sources sub directories
MAIN=/main
LIB=/lib
# sources
SRC=./src
MAIN_SRC=$(SRC)$(MAIN)
LIB_SRC=$(SRC)$(LIB)
# build
BUILD=./build
# build -> objs
OBJ=$(BUILD)/obj
MAIN_OBJ=$(OBJ)$(MAIN)
LIB_OBJ=$(OBJ)$(LIB)
# build -> bins
BIN=$(BUILD)/bin
MAIN_BIN=$(BIN)$(MAIN)
LIB_BIN=$(BIN)$(LIB)
# lists
# use a generic rule to list all the headers
HEADERS=$(wildcard $(MAIN_SRC)/*.h) $(wildcard $(LIB_SRC)/*.h)
# use a generic rule to list all the OBJECTS
OBJECTS=$(patsubst $(LIB_SRC)/%.cpp,$(LIB_OBJ)/%.o,$(wildcard $(LIB_SRC)/*.cpp))
# use a generic rule to list all the executables
EXECUTABLE=$(patsubst $(MAIN_SRC)/%.cpp,$(MAIN_BIN)/%,$(wildcard $(MAIN_SRC)/*.cpp))
### commands
# compile arguments
SRC_DEBUG_LINKER=-Xlinker --verbose
SRC_COMPILE_ARGS=-I $(MAIN_SRC) -Wall -Wextra -O3
SRC_COMPILE_ADD_ARGS=-I/usr/include/mysql -L/usr/lib64/mysql -lmysqlclient -lpthread -lz -lm -lrt -lssl -lcrypto -ldl
LIB_COMPILE_ARGS=-pipe -std=gnu++11 -Wall -W -D_REENTRANT -fPIC -DQT_DEPRECATED_WARNINGS -DQT_NO_DEBUG -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I$(QT5_HEADERS)/mkspecs/linux-g++ -isystem $(QT5_HEADERS) -isystem $(QT5_HEADERS)/QtWidgets -isystem $(QT5_HEADERS)/QtGui -isystem $(QT5_HEADERS)/QtCore -I $(LIB_SRC)
LIB_COMPILE_LINKER_ARGS=-lQt5Widgets -lQt5Gui -lQt5Core -lGL -lpthread

# compilation
COMPILE=g++
SRC_COMPILE=$(COMPILE) $(SRC_COMPILE_ARGS) $(SRC_COMPILE_ADD_ARGS)
LIB_COMPILE=$(COMPILE) $(LIB_COMPILE_ARGS) $(SRC_COMPILE_ARGS)

# deletion
DELETE=rm -rf
# silent log using printf
LOG=@printf

.PHONY:	all setup clean full-clean
.SECONDARY:	$(MAIN_OBJECTS) $(OBJECTS)

all:	setup $(MAIN_BIN)/main $(EXECUTABLE)
	$(LOG) '\n\033[44mmake all finished\033[49m\n\n'

#generic rule for the creation of the main object files
$(MAIN_OBJ)/%.o:	$(MAIN_SRC)/%.cpp $(HEADERS)
	$(LOG) '\n\033[42mcreation of the $* object file\033[49m\n'
	$(SRC_COMPILE) \
	$(MAIN_SRC)/$*.cpp \
	-c \
	-o $(MAIN_OBJ)/$*.o

#generic rule for the creation of the library object files
$(LIB_OBJ)/%.o:	$(LIB_SRC)/%.cpp $(HEADERS)
	$(LOG) '\n\033[42mcreation of the $* object file\033[49m\n'
	$(LIB_COMPILE) \
	$(LIB_SRC)/$*.cpp \
	-c \
	-o $(LIB_OBJ)/$*.o

$(MAIN_BIN)/%:	$(MAIN_OBJ)/%.o
	$(LOG) '\n\033[42mcreation of the $* executable\033[49m\n'
	$(SRC_COMPILE) \
	$(MAIN_OBJ)/$*.o \
	-o $(MAIN_BIN)/$* \
	$(SRC_COMPILE_ADD_ARGS)

$(MAIN_BIN)/main:	$(OBJECTS)
	$(LOG) '\n\033[42mcreation of the main executable\033[49m\n'
	$(LIB_COMPILE) \
	$(OBJECTS) \
	-o $(MAIN_BIN)/main \
	$(LIB_COMPILE_LINKER_ARGS)

setup:
	$(LOG) '\n\033[42msetup of the directories\033[49m\n'
	mkdir \
	-p \
	$(MAIN_OBJ) \
	$(LIB_OBJ) \
	$(MAIN_BIN) \
	$(LIB_BIN)
	$(LOG) '\n\033[44mmake setup finished\033[49m\n\n'

clean:
	$(LOG) '\n\033[41mdeletion of the object directory\033[49m\n'
	$(DELETE) $(OBJ)/*
	make setup
	$(LOG) '\n\033[44mmake clean finished\033[49m\n\n'

full-clean:
	$(LOG) '\n\033[41mdeletion of ALL the build directories\033[49m\n'
	$(DELETE) $(BUILD)/*
	make setup
	$(LOG) '\n\033[44mmake full-clean finished\033[49m\n\n'
