
Build:
	perl Build.PL

help install clean distclean check distcheck: Build
	./Build $@
