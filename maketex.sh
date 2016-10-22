#!/bin/sh

file="$1"

echo -e "\r\nPass 1:\r\n" &&
pdflatex -interaction=nonstopmode "$file.tex" &&
echo -e "\r\nPass 2:\r\n" &&
pdflatex -interaction=nonstopmode "$file.tex" &&
echo -e "\r\nSuccess! Opening File...\r\n"
cygstart "$file.pdf"
