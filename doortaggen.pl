#!/usr/bin/perl
# UNFINISHED script, still lots to be tweaked
# usage: perl doortaggen.pl nametaglist.txt doortagback.pdf

# nametaglist.txt should have all the names, 1 per line, no wierd characters

# doortagback.pdf should be 3.75 in x 2.25 in (including .125 in bleed on all 4 sides so final size is 3.5 x 2)
# printer's alignment is only accurate to within 1-2mm so left/right edges, top/bottom edges must have same colours
# so that misalignments look OK (nametags are tiled on the paper)
# should preferably use CMYK colours for better control over printer. black text on R100 red for example should use K100 R100
# to avoid registration issues; black text on white should use K100 or K100 R40 C40 for rich black.
# avoid using RGB colour.
# avoid using raster graphics in this PDF or it will take forever to print (and may not look great if it is not high-res enough)

# output is spit into /tmp/doortags.pdf

# TODO: clean up this script

use POSIX;

$file_namelist=$ARGV[0];
$file_background=$ARGV[1];

$margintop=0.5*254; # 0.5 in
$marginleft=0.75*254; # 0.75 in
$marginbottom=0.5*254; # 0.5 in
$marginright=0.75*254; # 0.75 in
$pagewidth=int(8.5*254+0.5);
$pageheight=int(11*254+0.5);
$colspacing=0;
$rowspacing=0;
$numcols=2;
$numrows=5;
$bleedleft=.125*254;
$bleedtop=.125*254;

$latex.=<<EOF;
\\documentclass[12pt]{article}
\\DeclareTextFontCommand{\\textgothamlight}{\\fontencoding{T1}\\fontfamily{allerrg}\\selectfont}
\\pagestyle{empty}
\\usepackage{setspace}
\\usepackage{graphics}
\\usepackage{graphicx}
\\usepackage{color}
\\usepackage[left=0cm,top=0cm,right=0cm,bottom=0cm,nohead,nofoot]{geometry}
\\usepackage[absolute]{textpos}
\\setstretch{2.0}
\\setlength\\parindent{0cm}
\\setlength\\parskip{0cm}
\\TPGrid[0.1mm,0.1mm]{ $pagewidth}{ $pageheight}
\\begin{document}
\\newpage\\tiny .
EOF

open(infile,"<$file_namelist");
@names=<infile>;
close(infile);

foreach $name (@names) {
  chomp($name);
  print $name."\n";
  if($name) {
    $textsize="\\large";$textheight=140;
    if(length($name)>24) { $textsize="\\normalsize";$textheight="120"; }
 #   if(length($name)<18) { $textsize="LARGE";$textheight="160"; }
    $labelleft=int(0.5+$marginleft+($pagewidth-$marginleft-$marginright-($numcols-1)*$colspacing)/$numcols*($j%2)+($j%2)*$colspacing);
    $labelwidth=int(0.5+$pagewidth-$marginleft-$marginright-($numcols-1)*$colspacing)/$numcols;
    $labelheight=int(0.5+($pageheight-$margintop-$marginbottom-($numrows-1)*$rowspacing)/$numrows);
    $labeltop=int(0.5+$margintop+(($pageheight-$margintop-$marginbottom)/$numrows)*floor($j/2))+$labelheight/3-$textheight/2;
    $bgleft=int(0.5+$marginleft+($pagewidth-$marginleft-$marginright-($numcols-1)*$colspacing)/$numcols*($j%2)+($j%2)*$colspacing - $bleedleft);
    $bgtop=int(0.5+$margintop+((10+$pageheight-$margintop-$marginbottom)/$numrows)*floor($j/2) - $bleedtop);
    $latex.=<<EOF;
\\begin{textblock}\x7B$labelwidth\x7D($bgleft,$bgtop)
\\includegraphics[width=3.75in]{doortagback.pdf}
\\end{textblock}

\\begin{textblock}{ $labelwidth}($labelleft,$labeltop)
\\begin{center}\\textcolor[rgb]{0,0,0}{
{ $textsize \\textgothamlight\x7B$name\x7D}\\\\
}
\\end{center}
\\end{textblock}


EOF
    $j++;
    if($j>$numrows*$numcols-1) {
	    $latex.="\\newpage\\tiny .\n";
	    $j=0;
    }
  }
}

$latex.=<<EOF;
\\end{document}
EOF

$filename="doortags";
system("cp $file_background /tmp/doortagback.pdf");
chdir("/tmp/");
open(outfile,">$filename.tex");
print outfile $latex;
close($outfile);
system("pdflatex $filename.tex");

