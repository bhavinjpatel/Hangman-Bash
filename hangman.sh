#!/bin/bash

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
	declare -a LETTERS
	WORD=$(shuf ./assets/words.txt | head -n 1 | tr -d "$")
	echo "$Intro"
	echo "$WORD"
	WORDLENGTH="${#WORD}"
	echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	while [[ "$LIFECOUNT" -gt 0 ]];
	do
		scene
	done
	echo "$wrong6"
	echo "$LIFECOUNT lives. You lost! Word was: $WORD"
	
}
letter_validation () {
	read -p "Enter Letter: " LETTER
	while [[ ! "$LETTER" =~ ^[A-Za-z]{1}$ ]]; 
	do
		echo "$LETTER is not a letter."
		read -p "Enter letter: " LETTER
	done
	echo "$LETTER"
}
letter_contained () {
	if [[ "$WORD" == *"$LETTER"* ]]; then
		echo "$LETTER is in $WORD"
		for letter in $WORD; do
			echo -n "$letter"
		done
		for letter in $LETTERS; do
			echo -n "$letter"
		done
	else
		let LIFECOUNT-=1
	fi
}
scene () {
	letter_validation
	letter_contained
	if [[ "$LIFECOUNT" -eq 5 ]]; then
		echo "$wrong1"
		letter_validation
	elif [[ "$LIFECOUNT" -eq 4 ]]; then
		echo "$wrong2"
		letter_validation
	elif [[ "$LIFECOUNT" -eq 3 ]]; then
		echo "$wrong3"
		letter_validation
	elif [[ "$LIFECOUNT" -eq 2 ]]; then
		echo "$wrong4"
		letter_validation
	elif [[ "$LIFECOUNT" -eq 1 ]]; then
		echo "$wrong5"
		letter_validation
	fi
	
	
	echo $
	let LIFECOUNT-=1 
	
}

display_menus
