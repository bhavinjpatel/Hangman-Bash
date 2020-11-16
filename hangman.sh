#!/bin/bash
if ! type python &> /dev/null; then
	echo "You do not have python installed. Please install python and create a symbolic link for it with the command 'sudo ln -s /usr/bin/python[version] /usr/bin/python'"
	exit 1
fi
cat ./assets/hangman.txt

Intro="
  +---+

  |   |

      |

      |

      |

      |

=========
"

wrong1="
  +---+

  |   |

  O   |

      |

      |

      |

=========
"

wrong2="
  +---+

  |   |

  O   |

  |   |

      |

      |

=========
"

wrong3="
  +---+

  |   |

  O   |

 /|   |

      |

      |

=========
"
wrong4="
  +---+

  |   |

  O   |

 /|\  |

      |

      |

=========
"

wrong5="
  +---+

  |   |

  O   |

 /|\  |

 /    |

      |

=========
"

wrong6="
  +---+

  |   |

  O   |

 /|\  |

 / \  |

      |

=========
"
Guesses=""
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
elif [[ "$USEROPTION" -eq 2 ]]; then
	echo "Help Menu:
	Guess the word."
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
	LETTERS=""
	Guess=""
	WORD=$(shuf ./assets/words.txt | head -n 1)
	WORD=${WORD::-1}
	echo "$Intro"
	WORDLENGTH="${#WORD}"
	echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	while [[ "$LIFECOUNT" -gt 0 ]];
	do
		scene
	done
	echo "$wrong6"
	echo "$LIFECOUNT lives. You lost! Word was: $WORD"
	read -p "Play again? Enter y/n: " RESET
	while [[ ( -z "$RESET" ) || (!( "$RESET" == "y" ||  "$RESET" == "n")) ]];
	do
		echo "Not a valid entry. Please enter y/n."
		read RESET
	done
	if [[ "$RESET" == "y" ]]; then
		play
	else
		display_menus
	fi

}
letter_validation () {
	echo $WORD
	read -p "Enter Letter: " LETTER
	while [[ ! "$LETTER" =~ ^[A-Za-z]{1}$ ]]; 
	do
		echo "$LETTER is not a letter."
		read -p "Enter letter: " LETTER
	done
	Guess="${Guess} ${LETTER}"
	Guess=$(echo "$Guess" | grep -o . | sort | tr -d "\n")
}
letter_contained () {
	if [[ "$WORD" == *"$LETTER"* ]]; then
		echo "$LETTER is in the word."
		LETTERS="$LETTERS$LETTER"
		python ./print_letters.py $WORD $LETTERS	
	else
		let LIFECOUNT-=1
		echo "$LETTER is not in the word"
		let LETTERSLENGTH=${#LETTERS}
		if [[ $LETTERSLENGTH -ne  0 ]]; then
			python ./print_letters.py $WORD $LETTERS
		else
			python ./print_underscores.py $WORD
		fi
	fi
	echo $Guess
}
scene () {
	if [[ $LIFECOUNT -eq 6 ]]; then
		letter_validation
		letter_contained
	elif [[ "$LIFECOUNT" -eq 5 ]]; then
		echo "$wrong1"
		letter_validation
		letter_contained
	elif [[ "$LIFECOUNT" -eq 4 ]]; then
		echo "$wrong2"
		letter_validation
		letter_contained
	elif [[ "$LIFECOUNT" -eq 3 ]]; then
		echo "$wrong3"
		letter_validation
		letter_contained
	elif [[ "$LIFECOUNT" -eq 2 ]]; then
		echo "$wrong4"
		letter_validation
		letter_contained
	elif [[ "$LIFECOUNT" -eq 1 ]]; then
		echo "$wrong5"
		letter_validation
		letter_contained
	fi
}

display_menus
