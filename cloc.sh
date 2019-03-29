#!/bin/sh -l
cloc . --xml -report-file cloc.xml --exclude-dir=build,libs,assets,res --include-lang=Java,Kotlin