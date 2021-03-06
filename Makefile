TARGET = Basic2Asm.jar
CLASSES = \
	Basic2Asm.class \
	CommandLineData.class \
# blank line (allow \ after the last class)

$(TARGET): $(CLASSES) jar-manifest.txt
	jar cfm $(TARGET) jar-manifest.txt $(CLASSES)

%.class: %.java
	javac -encoding UTF-8 $<

.PHONY: clean
clean:
	rm -f $(TARGET) $(CLASSES)

.PHONY: test
test: $(TARGET)
	make -C tests
