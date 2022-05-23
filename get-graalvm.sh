#!/bin/sh

showHelp()
{
   echo ""
   echo -e "Usage: $0 [-e edition -c component -j java-version -y versionYear]"
   echo -e "-c\tcomponent\t\tGraalVM Component to install, i.e jdk, native-image (default: jdk)."
   echo -e "-j\tjavaVersion\t\tGraalVM base java version (default: 17)."
   echo -e "-y\tyearRelease\t\t GraalVM main release train, for example release train for 22.3.1 is 22 (default: this year otherwise last year)."
   exit 1 # Exit script after printing help
}

while getopts "c:j:y:" opt
do
   case "$opt" in
      c ) GRAALVM_COMPONENT="${OPTARG}" ;;
      j ) GRAALVM_JAVA="${OPTARG}" ;;
      y ) FLAG_YEAR="${OPTARG}" ;;
      ? ) showHelp ;; # Print showHelp in case parameter is non-existent.
   esac
done


if [ -z "$GRAALVM_EDITION" ]
then
    GRAALVM_EDITION="ee"
fi
if [ -z "$GRAALVM_COMPONENT" ]
then
    GRAALVM_COMPONENT="jdk"
fi
if [ -z "$GRAALVM_JAVA" ]
then
    GRAALVM_JAVA="17"
fi
if [ -z "$FLAG_YEAR" ]
then
   GRAALVM_YEAR="$(date '+%y')"
   FLAG_YEAR="latest"
else 
   GRAALVM_YEAR=$FLAG_YEAR
fi

PACKAGE_MANAGER=yum
if ! command -v $PACKAGE_MANAGER &> /dev/null
then
    PACKAGE_MANAGER=dnf
    if ! command -v $PACKAGE_MANAGER &> /dev/null
    then
        echo "Neither yum nor dnf could be found on this system."
        exit 1
    fi
fi

echo -e "Now executing list command"
echo -e $PACKAGE_MANAGER list graalvm${GRAALVM_YEAR}-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT* || ((test "$FLAG_YEAR"  == "latest") && $PACKAGE_MANAGER list graalvm$(expr $GRAALVM_YEAR - 1)-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT*)

echo -e "Now executing install command"
echo -e $PACKAGE_MANAGER install -y graalvm${GRAALVM_YEAR}-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT* || ((test "$FLAG_YEAR"  == "latest") && $PACKAGE_MANAGER install -y graalvm$(expr $GRAALVM_YEAR - 1)-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT*)

$PACKAGE_MANAGER list graalvm${GRAALVM_YEAR}-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT* || ((test "$FLAG_YEAR"  == "latest") && $PACKAGE_MANAGER list graalvm$(expr $GRAALVM_YEAR - 1)-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT*)
$PACKAGE_MANAGER install -y graalvm${GRAALVM_YEAR}-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT* || ((test "$FLAG_YEAR"  == "latest") && $PACKAGE_MANAGER install -y graalvm$(expr $GRAALVM_YEAR - 1)-$GRAALVM_EDITION-$GRAALVM_JAVA-$GRAALVM_COMPONENT*)
