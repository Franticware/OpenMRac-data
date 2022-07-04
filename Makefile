TARGET = openmrac.dat
INSTALLDIR = /usr/share/openmrac/

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): *.jpg *.png *.3dm *.3mt *.cmo *.def *.wav
	ls *.wav | sed 's/.wav$$//g' > wavlist.txt
	while read line; do rm -f $$line.raw; sox $$line.wav --bits 16 $$line.raw; done < wavlist.txt
	ls *.jpg *.png *.3dm *.3mt *.cmo *.def *.raw > filelist.txt
	rm -f $(TARGET)
	while read line; do tar -rvf $(TARGET) $$line; done < filelist.txt

clean:
	rm -f *.raw
	rm -f $(TARGET)
	rm -f wavlist.txt
	rm -f filelist.txt

install: $(TARGET)
	sudo rm -rf $(INSTALLDIR)
	sudo mkdir $(INSTALLDIR)
	sudo cp $(TARGET) $(INSTALLDIR)$(TARGET)

uninstall:
	sudo rm -rf $(INSTALLDIR)
