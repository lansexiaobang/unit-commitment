all: project.pdf

project.pdf: project.tex
	latex project.tex
	bibtex project.tex
	latex project.tex
	latex project.tex
	dvipdf project.dvi project.pdf

clean:
	rm -f project.out *.log *.aux *.dvi *.bak *.o

pristine:
	rm -f project.pdf

