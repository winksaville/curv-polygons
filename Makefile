# The default filename to use for various target if name
# option is not provided
default_name=polygon
_name=$(if $(name),$(name),$(default_name))
filename=$(_name)

# Use a BROWSER for png_viewer if it exists otherwise use google-chrome-stable
export png_viewer=$(if $(BROWSER),$(BROWSER),google-chrome-stable)

# v
_vsize=$(if $(vsize),$(vsize),1)
option_vsize=-O vsize=$(_vsize)

export screenshot_filename=$(filename).png

AT=@

.PHONY: help
help:
	$(AT)echo "make target"
	$(AT)echo " targets:"
	$(AT)echo "   l          curv -l $(filename).curv"
	$(AT)echo "   live       curv -l $(filename).curv"
	$(AT)echo "   lz         curv -l -O lazy $(filename).curv"
	$(AT)echo "   obj        output $(filename).obj"
	$(AT)echo "   slice      prusa-silcer $(filename).obj"
	$(AT)echo "   ss         take a screenshot"
	$(AT)echo "   view       view screenshot"
	$(AT)echo "   tmps       clean tmp files ',*'"
	$(AT)echo "   clean      clean obj and tmp files"
	$(AT)echo "   distclean  clean png, 3mp obj and tmp files"
	$(AT)echo ""
	$(AT)echo " options:"
	$(AT)echo "   name       basename to use, default: ${name}"
	$(AT)echo "              valid for all targets"
	$(AT)echo "                example: make lz name=polygon"
	$(AT)echo "   vsize      value for `-O vsize=xxx where xxx is vsize,"
	$(AT)echo "              valid for the obj target"
	$(AT)echo "                example: make obj vsize=0.1"


.PHONY: l
l:
	curv -l $(filename).curv

.PHONY: lz
lz:
	curv -l -O lazy $(filename).curv

.PHONY: live
live: l
	
	
obj: $(filename).obj

$(filename).obj: $(filename).curv
	curv -o $(filename).obj $(option_vsize) -O jit $(filename).curv

.PHONY: slice
slice: $(filename).obj
	prusa-slicer $(filename).obj

.PHONY: ss
ss:
	$(AT)echo "select desired window, you have 2 seconds:"
	$(AT)gnome-screenshot -w -d 2 -f "$${screenshot_filename}"
	$(AT)echo "done, screenshot written to $${screenshot_filename}"

.PHONY: view
view:
	$(AT)$${png_viewer} $${screenshot_filename}

.PHONY: tmps
tmps:
	$(AT)rm -f ,*

.PHONY: clean tmps
clean:
	$(AT)rm -f $(filename).obj

.PHONY: distclean clean
distclean:
	$(AT)rm -f $(filename).png ,*
