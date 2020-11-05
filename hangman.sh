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
go_back () {
	read -p "Enter 'gb' to go back: " GB
	while [[ ( -z "$GB" ) || (! "$GB" =~ ^gb$) ]];
	do
		echo "$GB is not a valid entry."
		read -p "Enter 'gb' to go back: " GB
	done
	display_menus
}
display_menus () {

echo "$USERMENU"
read -p "Please enter an option: " USEROPTION

while [[ ( -z "$USEROPTION") || (! "$USEROPTION" =~ ^[1-4]{1}$) ]];
do
	echo "$USEROPTION is not a valid option."
	echo "$USEROPTIONS"
	read -p "Please enter an option: " USEROPTION
done
if [[ "$USEROPTION" -eq 1 ]]; then
	play
	go_back
elif [[ "$USEROPTION" -eq 2 ]]; then
	echo "Help Menu:"
	go_back
elif [[ "$USEROPTION" -eq 3 ]]; then
	echo "Project by: Bhavin Patel, Christian Santana, and Dylan Klintworth"
	go_back
else
	echo "Quitting Hangman"
	exit 1
fi
}
play () {
	LIFECOUNT=6
	WORD=$(shuf ./assets/words.txt | head -n 1)
	echo "$WORD"
	WORDLENGTH="$(( $(echo "$WORD" | wc -m) - 2 ))"
	echo "$WORDLENGTH"
	echo -e "The word is $WORDLENGTH letters long...\nYou have 6 chances"
	read -p "Enter Letter: " LETTER
	echo "$WORD" | grep $LETTER
}

display_menus
