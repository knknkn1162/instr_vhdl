include constants.mk
SUBDIRS=general pkg controller component

.PHONY: all clean

all:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	$(MAKE) all -C $$subdir || exit 1;\
	echo "exec make all in the $$subdir directory.";\
	done

clean:
	rm -rf *.vcd *.o work-obj93.cf
