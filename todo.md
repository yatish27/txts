```
Lib=$(PWD)/_raw
Out=$(PWD)#



Here=$(PWD)
There=$(subst $(Raw),$(Out),$(Here))

dirs:
	echo mkdir -p $(There)

files:=$(shell  ls $(Here) | grep -v _ )



tmp0=$(foreach f,$(files),echo $(There)/$f;)
tmp1=$(subst .mkd,.html,$(tmp0))#must be first
tmp2=$(subst .md,.html,$(tmp1))
tmp3=$(subst .dot,.png,$(tmp2))
goals=$(subst .plt,.png,$(tmp3))

go: 
	echo   $(goals)
#
#$(There)/%.html : %.html ; cp $< $@
#$(There)/%.doc  : %.doc ; cp $<  $@
#$(There)/%.pdf  : %.pfg ; cp $<  $@
#$(There)/%.gif  : %.gif ; cp $<  $@
#$(There)/%.jpg  : %.jpg ; cp $<  $@

$(There)/%.html : $(Here)/%.md
	echo 1 pandoc -o $@  $< 

$(There)/%.html : $(Here)/%.mkd
	echo 2 pandoc -o $@  $< 

$(There)/%.png : $(Here)/%.dot
	echo 3 dot -Tpng  -o $@  $< 

$(There)/%.png : $(Here)/%.plt
	echo 4 gnuplot $<  $@

$(There)/% : $(Here)/%; echo 5 cp $< $@
```


write a make file that is a recursive walker

```
.md ==> .html % via pandoc
.mkd ==> .html % via pandoc slides
.dot ==> png # graphs
.plt ==> png # plots
.x   ==> x
```

if gets fired off on a Raw directory and is written to an Out directory

so the whole site is

```
.cook
   lib # my code
   inc # a whole bunch of defaults used in compilation
         references.bib
         style.css
         before.html
         after.html
         template.html
.raw
   inc
     optional stuff 
  the rest of your stuff   
```

during compilation, we use files in cook/inc UNLESS they are found in raw/inc

```
ifeq ($(wildcard file1),) 
    CLEAN_SRC =
else 
    CLEAN_SRC = *.h file3
endif
```
