#!/bin/bash

cat ./assets/hangman.txt

USERMENU="
Welcome, please select an option listed down below:

1) Play Hangman
2) Help
3) Contribution Details
4) Quit
"
USEROPTIONS="
1) Play Hangman
2) Help
3) Contribution Details
4) Quit
"
menu () {

	echo "$USERMENU"
	read -p "Please enter an option: " USEROPTION

	while [[ ( -z "$USEROPTION") || (! "$USEROPTION" =~ ^[1-4]{1}$) ]];
	do
		echo "$USEROPTION is not a valid option."
		echo "$USEROPTIONS"
		read -p "Please enter an option: " USEROPTION
	done
return
}
display_menus () {

if [[ "$USEROPTION" -eq 1 ]]; then
	WORD=$(shuf ./assets/words.txt | head -n 1)
	echo $WORD
elif [[ "$USEROPTION" -eq 2 ]]; then
	echo "Help Menu:"
elif [[ "$USEROPTION" -eq 3 ]]; then
	echo "Project by: Bhavin Patel, Christian Santana, and Dylan Klintworth"
else
	echo "Quitting hangman"
	exit 1
fi
return
}
menu
