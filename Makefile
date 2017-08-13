# -*- make -*-
# FILE: "/home/evmik/src/my_src/robocode_bots/robocode_bots.EvBotNG/Makefile"
# LAST MODIFICATION: "Sat, 07 Nov 2015 16:46:23 -0500 (evmik)"
# (C) 2012 by Eugeniy Mikhailov, <evgmik@gmail.com>
# $Id:$

SUPERPACKADE = eem
BOTNAME = EvBotNG

ROBOCODE_VERSION_TO_COMPILE = ~/misc/robocode-1.9.2.5
ROBOCODE_VERSION_TO_RUN = ~/misc/robocode-1.9.2.5
ROBOTS_DIR   = $(ROBOCODE_VERSION_TO_RUN)/robots
ROBOCODEJAR  = $(ROBOCODE_VERSION_TO_COMPILE)/libs/robocode.jar

TESTVERSION := vtest
VERSION     := $(shell git describe --tags --abbrev=0)
UUID        := $(shell uuid)

TESTJAR    = $(SUPERPACKADE).$(BOTNAME)_$(TESTVERSION).jar 
RELEASEJAR = $(SUPERPACKADE).$(BOTNAME)_$(VERSION).jar

OUTDIR = out
#JAVAC = /usr/lib/jvm/java-7-openjdk-i386/bin/javac
JAVAC = /usr/bin/javac
JFLAGS = -d $(OUTDIR) -classpath $(ROBOCODEJAR): -Xlint:unchecked

SRC = $(shell find $(SUPERPACKADE) -type f -name *.java)

CLASSES=$(SRC:%.java=$(OUTDIR)/%.class)
SRCFORJAR=$(SRC:%.java=$(OUTDIR)/%.java)

.SUFFIXES: .java .class 

all: $(CLASSES) $(TESTJAR) copy-jar-test

release: $(RELEASEJAR)
	cp $(RELEASEJAR) $(ROBOTS_DIR)/$(RELEASEJAR)

upload: $(RELEASEJAR)
	 rsync -rvze ssh $(RELEASEJAR) evmik.org:public_html/robocode/	

copy-jar-test: $(ROBOTS_DIR)/$(TESTJAR)

$(ROBOTS_DIR)/$(TESTJAR): $(TESTJAR)
	cp $(TESTJAR) $(ROBOTS_DIR)/$(TESTJAR)

$(TESTJAR): $(CLASSES) $(SRCFORJAR)
	echo $(TESTVERSION)
	cat $(BOTNAME).properties.template \
		| sed s'/^uuid=.*$$'/uuid=$(UUID)/ \
		| sed s'/^robot.version=.*$$'/robot.version=$(TESTVERSION)/ \
		> $(OUTDIR)/$(SUPERPACKADE)/$(BOTNAME).properties
	cd $(OUTDIR); jar cvfM  ../$@  `find $(SUPERPACKADE) -type f`

$(RELEASEJAR): $(CLASSES) $(SRCFORJAR)
	cat $(BOTNAME).properties.template \
		| sed s'/^uuid=.*$$'/uuid=$(UUID)/ \
		| sed s'/^robot.version=.*$$'/robot.version=$(VERSION)/ \
		> $(OUTDIR)/$(SUPERPACKADE)/$(BOTNAME).properties
	cd $(OUTDIR); jar cvfM  ../$@  `find $(SUPERPACKADE) -type f`


out:
	mkdir -p $(OUTDIR)

$(SRCFORJAR):$(OUTDIR)/%.java : %.java $(OUTDIR)
	cp $< $@

$(CLASSES):$(OUTDIR)/%.class : %.java $(OUTDIR)
	$(JAVAC) $(JFLAGS) $<

clean:
	rm -f $(CLASSES)
	rm -f *jar

realclean: clean
	rm -rf $(OUTDIR)
