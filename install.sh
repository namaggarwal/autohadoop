#!/bin/bash

#Assumptions
#The user is same as this user on all the nodes
#Else specify the user to log into the other systems
#Username can be specified using -u option


#Global Variables
USER=$(whoami)
#Username specified or not 0 - username not specified, 1- username given
USPEC=0

#Username option
while getopts ":u:" opt; do
  case $opt in
    u)
      USER=$OPTARG
      USPEC=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

#If username specified then shift the first two arguments
if [ $USPEC -eq 1 ];
then
   shift
   shift
fi


if [ $# -lt 2 ];
then
   echo "We require atleast one master and one slave. Cannot continue ... "
   exit
elif [ $# -eq 2 ] && [ $1 -eq $2 ];
then
   echo "You specified a single slave that is same as master. Cannot continue ... "
   exit
fi


echo "Yo"
