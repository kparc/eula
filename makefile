all:
	rm -rf *.crc
	@npm version patch --silent
	@npm publish

pack:
	./pack.sh
