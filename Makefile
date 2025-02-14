
# Settings

SRC_DIR=src
BIN_DIR=bin
DOC_DIR=doc
JAVAC=$(JDK_HOME)/bin/javac
JAVAC_FLAGS=
JAVA=$(JDK_HOME)/bin/java
JAR=$(JDK_HOME)/bin/jar
PYTHON=python

# Targets

.PHONY: all generate-src sj3d doc demo clean

all: sj3d.jar

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

generate-src: src/sj3d/Util.java src/sj3d/Renderer.java

src/sj3d/Util.java: scripts/gen-util.py src/sj3d/Util.java.in
	$(PYTHON) scripts/gen-util.py <$@.in >$@

src/sj3d/Renderer.java: scripts/gen-renderer.py src/sj3d/Renderer.java.in
	$(PYTHON) scripts/gen-renderer.py <$@.in >$@

sj3d: $(BIN_DIR) generate-src
	find $(SRC_DIR) -iname '*.java' | xargs $(JAVAC) -d $(BIN_DIR) $(JAVAC_FLAGS)

demo/SJ3DDemo.class: sj3d.jar demo/SJ3DDemo.java
	$(JAVAC) -cp sj3d.jar demo/SJ3DDemo.java

demo: sj3d.jar demo/SJ3DDemo.class
	$(JAVA) -cp .:sj3d.jar demo.SJ3DDemo

sj3d.jar: $(BIN_DIR) sj3d
	$(JAR) cf sj3d.jar -C $(BIN_DIR)/ sj3d

doc: $(SRC) generate-src
	javadoc -sourcepath $(SRC_DIR) -protected -verbose -d $(DOC_DIR) -version -author sj3d

clean:
	$(RM) -rf $(BIN_DIR)
	$(RM) -rf $(DOC_DIR)
	$(RM) -f sj3d.jar
	$(RM) -f demo/*.class
	$(RM) -f src/sj3d/Util.java src/sj3d/Renderer.java
