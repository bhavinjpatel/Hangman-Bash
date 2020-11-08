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
	LETTERS=""
	WORD=$(shuf ./assets/words.txt | head -n 1)
	echo "$Intro"
	WORDLENGTH="$(( $(echo "$WORD" | wc -m) - 2 ))"
	while [[ "$LIFECOUNT" -gt 0 ]];
	do
		scene
	done
	echo "$wrong6"
	echo "$LIFECOUNT lives. You lost! Word was: $WORD"
	echo "$WORD" | grep $LETTER
}

scene () {
	if [[ "$LIFECOUNT" -eq 5 ]]; then
		echo "$wrong1"
	elif [[ "$LIFECOUNT" -eq 4 ]]; then
		echo "$wrong2"
	elif [[ "$LIFECOUNT" -eq 3 ]]; then
		echo "$wrong3"
	elif [[ "$LIFECOUNT" -eq 2 ]]; then
		echo "$wrong4"
	elif [[ "$LIFECOUNT" -eq 1 ]]; then
		echo "$wrong5"
	fi
	echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	read -p "Enter Letter: " LETTER
	let LIFECOUNT-=1 
	LETTERS="${LETTERS}${LETTER}"
	echo $LETTERS
}

display_menus
