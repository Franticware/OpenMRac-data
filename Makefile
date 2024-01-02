prefix ?= /usr/local
TARGET = openmrac.dat
INSTALLDIR = $(prefix)/share/openmrac/

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): *.jpg *.png *.3dm *.3mt *.cmo *.def *.wav
	ls *.wav | sed 's/.wav$$//g' > wavlist.txt
	while read line; do rm -f $$line.raw; sox $$line.wav --bits 16 $$line.raw; done < wavlist.txt
	ls *.jpg *.png *.3dm *.3mt *.cmo *.def *.raw > filelist.txt
	rm -f $(TARGET)
	while read line; do tar --owner=root:0 --group=root:0 --mtime='UTC 1970-01-01 00:00:00' --mode=go=rX,u+rw,a-s -rvf $(TARGET) $$line; done < filelist.txt
	sha1sum $(TARGET) > $(TARGET).sha1sum

clean:
	rm -f *.raw
	rm -f $(TARGET)
	rm -f $(TARGET).sha1sum
	rm -f wavlist.txt
	rm -f filelist.txt

install: $(TARGET) uninstall
	sudo mkdir $(INSTALLDIR)
	sudo cp $(TARGET) $(INSTALLDIR)$(TARGET)

uninstall:
	sudo rm -rf $(INSTALLDIR)
