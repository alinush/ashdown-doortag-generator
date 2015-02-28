Ashdown Door Tag generator
==========================

How to use?

    Usage: ./doortag-gen.py sample-list.txt sample-back.pdf

Requires `xelatex`. Install on Ubuntu machines with:

    apt-get install texlive-xetex texlive-latex-recommended texlive-latex-extra

How do you create a `sample-back.pdf` background?
-------------------------------------------------

Dheera's answer:

> The door tags are U.S. business card size, i.e. 3.5 by 2 inches.
However, since the printer has an error of +/-1 mm or so in alignment,
2 things need to be done:

> 0. You need to include a bleed -- the script is hardcoded for 3.75 by
2.25 inches. This means that your sample-back.pdf should be exactly
3.75 by 2.25 inches, and only the middle 3.5 by 2 inch portion will be
cut out. This allows some error margin for the printer so it doesn't
have to nail the alignment exactly.

> 1. Make sure that the left and right edges are the same colour, and
the top and bottom edges are the same colour, since the business card
perforated sheets do not have any margin between adjacent cards. A
solid border going around the entire card of any colour is one easy
way to accomplish this but you can also be creative with your design.

> I design the cards in Inkscape and export to PDF. I expect other tools
would work fine as well. Whatever you do make sure it is a 100% vector
image file. Otherwise the printing will be painfully, painfully slow
(like, you'll be waiting literally an hour vs. a few seconds).
