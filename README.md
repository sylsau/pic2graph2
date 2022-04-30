***pic2img***, modernized version of groff's pic2graph utility to turn PIC diagram into images easily.  
Usage:  pic2img [-f FORMAT -q QUALITY -s SIZE -b -k -K PRECONV-ENCODING --eqn EQN-DELIM -U] < IN > OUT

# Example

Turns this:
```
boxwid=1; 	boxht=.75;
linewid=1; 	lineht=.75;
box "\fBBIG BOX" "number 1\fR"
arrow "goes to" ""
box "\fBANOTHER\fR" "HUGE BOX"
down
move 1.4
left
move 2
box "\fB\s-3Slightly\s-1 less\s-1 important" "\s-1box\s-1 here...\s+7\fR" dashed
right
box invis
line 1.5 dashed "and up" "" "we go"
up
arrow 1 dashed

```
into this:

<img src=https://raw.githubusercontent.com/sylsau/pic2img/master/static/tests/diag.png width=700>
