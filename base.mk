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
	
# Clean all ...
# ------------------------------------------------------------------------------
cleanall: clean distclean cleanhtml
