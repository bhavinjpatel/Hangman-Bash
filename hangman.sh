#!/bin/bash

cat ./hangman.txt

USERMENU="
Welcome, please select an option listed down below:

1) Play Hangman
2) See Contribution Details
3) See Help Menu
4) Quit
"
USEROPTIONS="
1) Play Hangman
2) See Contribution Details
3) See Help Menu
4) Quit
"
echo "$USERMENU"
read -p "Please enter an option: " USEROPTION

while [[ ( -z "$USEROPTION") || (! "$USEROPTION" =~ ^[1-4]{1}$) ]];
do
	echo "$USEROPTION is not a valid option."
	echo "$USEROPTIONS"
	read -p "Please enter an option: " USEROPTION
done
echo "$USEROPTION"
