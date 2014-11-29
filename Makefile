# LTFLAGS=-jobname=$(DOCNAME) -interaction batchmode

DOCNAME=virus
PDF=$(DOCNAME).pdf
DVI=$(DOCNAME).dvi
PS=$(DOCNAME).ps
AUXFILES=missfont.log
AUXFILES+=$(DOCNAME).log
AUXFILES+=$(DOCNAME).aux
AUXFILES+=$(DOCNAME).lof
AUXFILES+=$(DOCNAME).lot
AUXFILES+=$(DOCNAME).out
AUXFILES+=$(DOCNAME).toc
AUXFILES+=$(DOCNAME).bbl
AUXFILES+=$(DOCNAME).blg
AUXFILES+=$(DOCNAME).nav
AUXFILES+=$(DOCNAME).snm
AUXFILES+=$(DOCNAME).vrb
AUXFILES+=$(DOCNAME).loap
SOURCES=
SOURCES+=src/main.tex
BINARIES=
BINARIES+=$(wildcard dump/*.exe)
DUMPS=$(patsubst %.exe,%.hex,$(BINARIES))

#SOURCES+=macros/macros.tex
#SOURCES+=$(wildcard gen/*.tex)
#SOURCES+=mdtuffs.cls
LATEX=latex
BIBTEX=bibtex
DVIPS=dvips
PS2PDF=ps2pdf
#ENSPELL=aspell -t -p ./dic/en -d british
#ENSPELL=aspell --lang=en_GB --personal=./dic/en -c
ENSPELL=hunspell -t -d en_GB -p $(realpath dic/en)
BRSPELL=hunspell -t -d pt_BR -p $(realpath dic/br)
#BRSPELL=hunspell -t -d pt_BR -p /home/alex/uffs/tcc/mono/dic/br
#BRSPELL=hunspell -t -p ./dic/br -d pt_BR
#BRSPELL=ispell -t -p ./dic/br -d brazilian
#BRSPELL=aspell --lang=pt_BR --personal=./dic/br -c
LTFLAGS=-jobname=$(DOCNAME) -interaction=batchmode
#LTFLAGS=-jobname=$(DOCNAME) -interaction=nonstopmode -file-line-error-style

.PHONY: all clean auxclean view verr

all: $(PDF)

dump/alex.hex: dump/alex.exe
	@hexdump -C $< > $@

verr:
	@cat $(DOCNAME).log

auxclean:
	@rm -f $(AUXFILES)

clean: auxclean
	@rm -f $(DVI) $(PS) $(PDF)

view: $(PDF)
	@evince $< &

spell:
	@$(BRSPELL) src/conclusao.tex

#$(BIBTEX) $(DOCNAME)
#$(LATEX) $(LTFLAGS) $<
#$(LATEX) $(LTFLAGS) $<

$(DVI): $(SOURCES) $(DUMPS)
	@$(LATEX) $(LTFLAGS) $<

$(PS): $(DVI)
	@$(DVIPS) -q $<

$(PDF): $(PS)
	@$(PS2PDF) $<
