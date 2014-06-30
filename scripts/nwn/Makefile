VPATH = nss:include:ncs:bioware


SOURCES=$(shell find nss -type f -iname '*.nss')
OBJECTS=$(foreach x, $(basename $(notdir $(SOURCES))), $(x).ncs)

MAKEFLAGS += -r

.SUFFIXES:
.SUFFIXES: .d .nss .ncs

TARGET = TAScripts

$(TARGET) : $(OBJECTS)
	touch $(TARGET)

%.ncs: %.nss
	NWNScriptCompiler.exe -q -b ncs -i "nss;include;bioware" -1cego $<

ncs/%.d: %.nss
	find_dep.py $<

-include $(OBJECTS:%.ncs=ncs/%.d)
