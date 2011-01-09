include LaTeX.mk

# Required variables.
# ------------------------------------------------------------------------------
#MASTER=

# Overridable variables.
# ------------------------------------------------------------------------------
PDF_VIEWER=evince
HTML_VIEWER=epiphany-browser
HTML_DIR=html
FLAVORS=PDF
HTML_EXTRA_OPTS=
HTML_DEFAULT_OPTS=-local_icons -html_version 3.2,math,unicode -split 0

# New useful targets.
# ------------------------------------------------------------------------------
viewpdf: $(MASTER).pdf
	$(PDF_VIEWER) $(MASTER).pdf &

view: viewpdf
	
# New targets for generating HTML.
# ------------------------------------------------------------------------------
html: $(HTML_DIR)/index.html

# Depend on pdf because if anything changes we want to rebuild, including the
# .bib file.
$(HTML_DIR)/index.html: $(MASTER).pdf
	mkdir -p $(HTML_DIR)	
	latex2html_wrap.py \
	    -dir $(HTML_DIR) \
	     $(HTML_DEFAULT_OPTS) $(HTML_EXTRA_OPTS) \
	     $(MASTER).tex

viewhtml: html
	$(HTML_VIEWER) $(HTML_DIR)/index.html
	
cleanhtml:
	rm -rf $(HTML_DIR)
	
# Other way to generate HTML.
# ------------------------------------------------------------------------------
html2: $(HTML_DIR)2/$(MASTER).html

# Depend on pdf because if anything changes we want to rebuild, including the
# .bib file.
$(HTML_DIR)2/$(MASTER).html: $(MASTER).pdf
	mkdir -p $(HTML_DIR)2
	mk4ht htlatex $(MASTER).tex
	mv $(MASTER).html $(HTML_DIR)2
	mv $(MASTER).css $(HTML_DIR)2

viewhtml2: html2
	$(HTML_VIEWER) $(HTML_DIR)2/$(MASTER).html
	
cleanhtml2:
	rm -rf $(HTML_DIR)2

# New targets for generating ODT.
# ------------------------------------------------------------------------------
$(MASTER).odt: $(HTML_DIR)/index.html
	cd $(HTML_DIR) &&\
	unoconv -f odt index.html &&\
	mv index.odt ../$(MASTER).odt
	
odt: $(MASTER).odt
	
viewodt: $(MASTER).odt
	oowriter $(MASTER).odt

cleanodt:
	rm -rf $(MASTER).odt
	
# Other way to generate ODT.
# ------------------------------------------------------------------------------
$(MASTER)2.odt: $(MASTER).pdf
	mk4ht oolatex $(MASTER).tex
	
odt2: $(MASTER)2.odt
	
viewodt2: $(MASTER)2.odt
	oowriter $(MASTER)2.odt

cleanodt2:
	rm -rf $(MASTER)2.odt

# Clean all ...
# ------------------------------------------------------------------------------
cleanall: clean distclean cleanhtml cleanodt cleanhtml2 cleanodt
