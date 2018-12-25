GHDLC=ghdl
PROJECT_NAME=instr
WORKDIR=..
WAVEDIR=${WORKDIR}/wave
FLAGS=--work=${PROJECT_NAME} --workdir=${WORKDIR}/
#TB_OPTION=--assert-level=error
MODULES=
TESTS=
OBJS=$(addsuffix .o, ${MODULES})
TESTBENCHES=$(addsuffix _tb, ${TESTS})
