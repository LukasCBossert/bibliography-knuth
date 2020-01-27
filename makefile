MAKE  = make
NAME  =bibliography-knuth
SHELL = bash
PWD   = $(shell pwd)
TEMP := $(shell mktemp -d -t tmp.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell /bin/date "+%Y-%m-%d---%H-%M-%S")
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
# Colors
RED   = \033[0;31m
CYAN  = \033[0;36m
NC    = \033[0m
echoNAME = @echo -e "$(CYAN) <$(NAME)>$(RED)"

.PHONY:  all

all: 
	latexmk  -lualatex $(NAME).tex


# clean all temporary files
clean:
	rm -f *.{sectionbibs.aux,thm,bibexample,biographies.aux,xdv,aux,mw,bbl,bcf,blg,doc,fdb_latexmk,fls,glo,gls,hd,idx,ilg,ind,listing,log,nav,out,run.xml,snm,synctex.gz,toc,vrb}
	rm -f *.{log,aux}
	$(echoNAME) "* cleaned temp files * $(NC)"



# zip files up for sending etc.
zip:
	rm -f $(NAME)*.zip
	mkdir $(TDIR)
	cp $(NAME).{pdf,bib,tex} README.md makefile $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)
	$(echoNAME) "* files zipped * $(NC)"

# install in your local TEX folder
install: all
	sudo mkdir -p $(LOCAL)/doc/latex/$(NAME)
	sudo mkdir -p $(LOCAL)/bibtex/bib/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
	sudo cp $(NAME).bib $(LOCAL)/bibtex/bib/$(NAME)
	sudo mktexlsr
	$(echoNAME) "* all files installed * $(NC)"


uninstall:
	sudo rm -r $(LOCAL)/source/latex/$(NAME)
	sudo -E mktexlsr
	$(echoNAME) "* all files uninstalled * $(NC)"
