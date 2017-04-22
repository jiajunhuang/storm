all:
	python3 setup.py build_ext -i

.PHONY: clean

clean:
	rm storm/*.so storm/*.c
