all: pages challenge_slides.html

skeleton-%.R: %.Rmd
	Rscript -e "knitr::purl('$<', output='$@', documentation=0L)"

%.html: %.Rmd
	Rscript -e "rmarkdown::render('$<', output_format=rmarkdown::html_document(toc=TRUE, highlight='tango', self_contained=FALSE, lib_dir='libs'))"

motivation.html: motivation.md
	pandoc -o $@ $^

handout-script.R: skeleton-00-before-we-start.R skeleton-01-intro-to-R.R skeleton-02-starting-with-data.R skeleton-03-data-frames.R skeleton-04-dplyr.R
	for f in $^; do cat $$f; echo "\n"; done > $@
	make clean-skeleton

pages: motivation.html 00-before-we-start.html 01-intro-to-R.html 02-starting-with-data.html 03-data-frames.html 04-dplyr.html 05-visualization-ggplot2.html 06-rmarkdown.html capstone.html 00-notes.html 01-notes.html 02-notes.html 03-notes.html

challenge_slides.Rmd: ruby/make_challenge_slides.rb 01-intro-to-R.Rmd 02-starting-with-data.Rmd 03-data-frames.Rmd 04-dplyr.Rmd 05-visualization-ggplot2.Rmd capstone.Rmd
	$<

challenge_slides.html: challenge_slides.Rmd
	R -e "rmarkdown::render('$<')"

capstone.html: capstone.Rmd
	Rscript -e "rmarkdown::render('$<', output_format=rmarkdown::html_document(highlight='tango', self_contained=FALSE, lib_dir='libs'))"


clean-skeleton:
	-rm skeleton-*-*.R

clean-md:
	-rm *-*.md

clean-html:
	-rm *.html

clean: clean-skeleton clean-html clean-md

clean-data:
	-rm -rf data
