# Compiler: GNU gfortran/gcc

FC = gfortran
CC = gcc
F90FLAGS += -ffree-line-length-none -fno-backslash
CPPFLAGS += -DFCOMPILER=_GFORTRAN_

cmd=$(shell basename $(shell which $(FC)))
ver:=$(shell $(FC) --version | sed -n 's/GNU Fortran.*\([1-9][0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
GFORTRANMAJORVERSION=$(shell echo $(ver) | awk -F. '{print $$1}')
GFORTRANMINORVERSION=$(shell echo $(ver) | awk -F. '{print $$2}')
GFORTRANMINORSUBVERSION=$(shell echo $(ver) | awk -F. '{print $$3}')

# sizeof is implemented from ver 4.3
NOSIZEOF=$(shell [ $(GFORTRANMAJORVERSION) -le 4 -o \( $(GFORTRANMAJORVERSION) -eq 4 -a $(GFORTRANMINORVERSION) -lt 3 \) ] && echo on)
ifeq ($(NOSIZEOF),on) # this cannot be replaced by ifdef
	CPPFLAGS += -DNO_SIZEOF
endif

ifdef DBLE
	F90FLAGS += -fdefault-real-8
endif

ifdef STATIC
	LDFLAGS += -static
endif

ifdef DEBUG
	F90FLAGS += -g -Wall -fimplicit-none -fbounds-check
	F90OPTFLAGS =
	CFLAGS += -g -Wall -fbounds-check
	COPTFLAGS =
else
	ifdef OPT
		F90OPTFLAGS += -O3
		COPTFLAGS += -O3
	endif

	ifeq ($(findstring gprof,$(PROF)),gprof)
		F90FLAGS += -pg
		CFLAGS += -pg
	endif
endif

ifdef USE_OPENMP
	F90FLAGS += -fopenmp
	CFLAGS += -fopenmp
endif

