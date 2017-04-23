all:
	python3 setup.py build_ext -i

.PHONY: clean test

clean:
	rm storm/*.so storm/*.c

test:
	PYTHONPATH=. python demo/main.py
