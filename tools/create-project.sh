#!/bin/bash
usage()
{
cat<<EOF
	usage: $0 options

	build Otsuka Android project
	OPTIONS:
	 -n --name    : Project name.
	 -t --target  : Target ID of the new project. [required]
	 -p --path    : The new project's directory. [required]
	 -k --package : Android package name for the application. [required]
	 -a --activity: Name of the default Activity that is created. [required]

EOF
}

NAME=
TARGET=
PACKAGE=
ACTIVITY=
while getopts “hn:t:k:a:” OPTION
do 
	case $OPTION in
		h)
			usage
			exit 1
			;;
		n)
			NAME=$OPTARG
			;;
		t)	
			TARGET=$OPTARG
			;;
		k)
			PACKAGE=$OPTARG
			;;
		a)	
			ACTIVITY=$OPTARG
			;;	
		?)
			usage
			exit
			;;
	esac
done

if [[ -z $PACKAGE ]] || [[ -z $NAME ]] || [[ -z $TARGET ]] || [[ -z $ACTIVITY ]]
then
	usage
	exit 1
fi

pushd android

	android create project -k $PACKAGE -n $NAME -t $TARGET -a $ACTIVITY -p .
	rm project.properties
	rm build.xml
	mv src src.bak
	mkdir -p src/main/java
	mkdir -p src/test/java
	mv src.bak/* src/main/java
	rm -rf src.bak


popd

