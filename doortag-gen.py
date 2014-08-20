#!/usr/bin/env python

import sys
import subprocess

if len(sys.argv)<3:
  print("Usage: %s listofnames.txt background.pdf" % sys.argv[0])
  exit(0)

filename_list = sys.argv[1]

with open(filename_list) as f:
  names = f.readlines()

filename_background = sys.argv[2]

margin_top = 0.5*254
margin_left = 0.75*254
margin_bottom = 0.5*254
margin_right = 0.75*254

page_width=int(8.5*254+0.5)
page_height=int(11*254+0.5)

num_cols=2
num_rows=5

label_width = 3.75*254
label_height = 2.25*254
label_bleed = .125*254

text_top = int(0.25 * label_height)

latex = ""
latex += "\\documentclass[12pt]{article}"
latex += "\\pagestyle{empty}"
latex += "\\usepackage{fontspec}"
latex += "\\usepackage{xunicode}"
latex += "\\usepackage{setspace}"
latex += "\\usepackage{graphics}"
latex += "\\usepackage{graphicx}"
latex += "\\usepackage{color}"
latex += "\\usepackage[left=0cm,top=0cm,right=0cm,bottom=0cm,nohead,nofoot]{geometry}"
latex += "\\usepackage[absolute]{textpos}"
latex += "\\setstretch{2.0}"
latex += "\\setmainfont[Ligatures=TeX,Scale=2]{custom.ttf}"
latex += "\\setlength\\parindent{0cm}"
latex += "\\setlength\\parskip{0cm}"
latex += "\\TPGrid[0.1mm,0.1mm]{%d}{%d}" % (page_width, page_height)
latex += "\\begin{document}"

for i in range(0, len(names)):
  print(names[i])

  i_mod = i % (num_rows*num_cols)

  if i_mod == 0:
    latex += "\\newpage\\tiny ."

  label_left = int(0.5 + margin_left +
               (page_width-margin_left-margin_right)/num_cols*(i_mod%2) - label_bleed)
  label_top  = int(0.5 + margin_top +
               ((page_height-margin_top-margin_bottom)/num_rows)*int(i_mod/2) - label_bleed)

  latex += "\\begin{textblock}{%d}(%d,%d)" % (label_width, label_left, label_top)
  latex += "\\includegraphics[width=3.75in]{%s}" % filename_background
  latex += "\\end{textblock}"

  latex += "\\begin{textblock}{%d}(%d,%d)" % (label_width, label_left, label_top + text_top)
  latex += "\\begin{center}\\textcolor[rgb]{0,0,0}{"
  latex += "{ %s }\\\\" % names[i]
  latex += "}"
  latex += "\\end{center}"
  latex += "\\end{textblock}"

latex += "\\end{document}"

file_latex = open("doortag.tex", "w")
file_latex.write(latex)
file_latex.close()

subprocess.call(["xelatex", "doortag.tex"])

