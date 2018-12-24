all: $(OBJS) $(TESTBENCHES)

%_tb: %_tb.o %.o
	$(GHDLC) -e $(FLAGS) $@
	$(GHDLC) -r ${FLAGS} $@ --vcd=${WAVEDIR}/out_$@.vcd ${TB_OPTION}

%: %.o
	# do nothing

%.o: %.vhdl
	$(GHDLC) -a $(FLAGS) $<
