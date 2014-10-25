VPATH = nss:include:ncs:bioware
OUTDIR=ncs
SOURCES=$(shell find nss -type f -iname '*.nss')
OBJECTS=$(foreach x, $(basename $(notdir $(SOURCES))), $(x).ncs)

MAKEFLAGS += -r

.SUFFIXES:
.SUFFIXES: .d .nss .ncs

TARGET = NWScripts

$(TARGET) : $(OBJECTS) ;

%.ncs: %.nss
	@find_dep.py $< > $(patsubst %.ncs,$(OUTDIR)/%.d, $@)
	@NWNScriptCompiler -q -b $(OUTDIR) -i "nss;include;bioware" -cego1 $<
	@echo "NSS $<"

-include $(OBJECTS:%.ncs=$(OUTDIR)/%.d)

.PHONY: clean
clean:
	rm $(OUTDIR)/*
