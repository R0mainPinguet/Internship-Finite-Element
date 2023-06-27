test:
	echo "Use it to clean workspace"

.PHONY: test mclean eclean


mclean:
	rm -rf test
	rm -f test.prj

eclean:
	rm -f *~
	rm -f */*~
	rm -f */*/*~
