include constants.mk
SUBDIRS=general display cpu
MODULES=riscv

.PHONY: all clean riscv

all: riscv
	$(GHDLC) -a top.vhdl

riscv:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	$(MAKE) all -C $$subdir || exit 1;\
	echo "exec make all in the $$subdir directory.";\
	done

clean:
	rm -rf wave/*.vcd *.o *-obj93.cf
