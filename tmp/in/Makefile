# rpm= recursive pandoc make

# define BODY
# Version of  has been released.
# 
# It $$ can be downloaded from $(PWD)
# 
# etc, etc.
# endef
# 
# export BODY
# 
# all:
# 	echo  "$$BODY"  > a.txt
# 
#todo needs a zap to kiil everything
#     needs biblio and other files
#     need a dirs that ignores "_"

#Full pathnames: 
Lib=$(PWD)# top
Out=$(Lib)#                        output dir
In=$(Lib)/_in#                     source
Share=$(Lib)/_share#               files used at compile time
Local=$(Lib)/_local#               local variants of compile-time files

define slide
	pandoc -s             \
	  --webtex -i -t slidy \
      -r markdown+simple_tables+table_captions \
      -o $(2) $(1)
endef

define page
	 pandoc -s \
       --toc    \
       -r markdown+simple_tables+table_captions+pipe_tables \
       -o $(2) $(1)
endef

##############################

define files
	$(shell find . -maxdepth 1  -type f  \
	 | grep -v Makefile \
	 | grep -v _  | awk '{print "$(There)/" $$1}')
endef

define worker
     cd $(realpath $(1)); \
	 $(MAKE) -s -f $(Lib)/Makefile Here=$(realpath $(1)) sub;
endef

Here=$(PWD)#
There=$(subst $(In),$(Out),$(Here))#
Goals=$(subst .md,.html,\
      $(subst .mkd,.html,\
        $(subst .dot,.png,\
          $(subst .plt,.png,\
             $(call files)))))

all:
	@mkdir -p $(Out) $(In) $(Share) $(Local)
	@$(call worker,$(In))
	
sub : dirs $(Goals) 
	@(echo $(PWD))
	@$(foreach d,$(wildcard */.), $(call worker,$d))

dirs :
	$(shell mkdir -p $(There))

$(There)/%.html : %.mkd  ; $(call slide,$<,$@)
$(There)/%.html : %.md   ; $(call page,$<,$@)
$(There)/%.png  : %.dot  ; dot -Tpng -o $@ $<
$(There)/%.png  : %.plt  ; gnuplot $< >$@
$(There)/%      : %      ; cp $< $@
