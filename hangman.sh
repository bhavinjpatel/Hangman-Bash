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
Login_Menu_items=" 
WELCOME TO HANGMAN!

1) Login as existing user
2) Create Account
"
LoginMenu (){
echo "$Login_Menu_items"
read -p "Please enter an option: " LoginOPTION

while [[ ( -z "$LoginOPTION") || (! "$LoginOPTION" =~ ^[1-2]{1}$) ]];
do
        echo "$LoginOPTION is not a valid option."
        echo "$LoginOPTIONS"
        read -p "Please enter an option: " LoginOPTION
done

if [[ "$LoginOPTION" -eq 1 ]];
then
	validate_user
elif [[ "$LoginOPTION" -eq 2 ]];
then
	Register_User
fi
}
validate_user (){
	read -p "Please enter your name: " name
	while [[ (-z "$name") || (! "$name" =~ [:alpha:]) ]];
	do
		echo "$name is not valid. Name can only contain alphabets"
		read -p "Please enter your name: " name
	done

	read -p "Please enter your pin: " pin
	while [[ (-z "$pin") || (! $pin =~ ^[0-9]+$ ) ]];
        do
                echo "$pin is not valid. Pin can only contain digits"
                read -p "Please enter your secret pin: " pin
        done
	if [[ -f ./assets/.user_data.out ]]; then
		entry=$(grep $name ./assets/.user_data.out | grep $pin)
		if ! test -z "$entry"
		then
			clear
			display_menus
		else
			echo "Either user not registered or incorrect pin!"
			LoginMenu
		fi
	else
		echo "No user present in database!"
		LoginMenu
	fi
}
Register_User ()
{
        read -p "Please enter your name: " name
        while [[ (-z "$name") || (! "$name" =~ [:alpha:]) ]];
        do
                echo "$name is not valid. Name can only contain alphabets"
                read -p "Please enter your name: " name
        done

        read -p "Please enter a secret pin: " pin
        while [[ (-z "$pin") ]] || [[ (! $pin =~ ^[0-9]+$ ) ]];
        do
                echo "$pin is not valid. Pin can only contain digit"
                read -p "Please enter a secret pin: " pin
        done
	echo -e "\nHi $name, you have been registered successfully. Your secret pin is $pin. Please login to play the game!"
	echo $name $pin >> ./assets/.user_data.out
	echo ""
	LoginMenu
}
USERMENU="
Welcome, please select an option listed down below:

1) Play Hangman
2) Help
3) Contribution Details
4) See Winners Board
5) Quit
"
USEROPTIONS="
1) Play Hangman
2) Help
3) Contribution Details
4) See Winners Board
5) Quit
"
go_back () {
	read -p "Enter 'gb' to go back: " GB
	while [[ ( -z "$GB" ) || (! "$GB" =~ ^gb$) ]];
	do
		echo "$GB is not a valid entry."
		read -p "Enter 'gb' to go back: " GB
	done
	clear
	display_menus
}
winners_board (){
clear
cat ./assets/hangman.txt
echo ""
echo -e "NAME	Time to guess (sec) "
cat ./assets/.winners_board.out | sort -nk 2 | head -5 | column -t
read -p "Please press any key to go to main menu" input
clear
display_menus
}
display_menus () {
cat ./assets/hangman.txt
echo "$USERMENU"
read -p "Please enter an option: " USEROPTION

while [[ ( -z "$USEROPTION") || (! "$USEROPTION" =~ ^[1-5]{1}$) ]];
do
	echo "$USEROPTION is not a valid option."
	echo "$USEROPTIONS"
	read -p "Please enter an option: " USEROPTION
done
if [[ "$USEROPTION" -eq 1 ]]; then
	play
elif [[ "$USEROPTION" -eq 2 ]]; then
	echo "
Help Menu:

To play Hangman, press 1 on the main menu.
You will be asked to select a difficulty.
Easy difficulty will select a word from 1-5 letters.
Medium difficulty will select a word from 6-10 letters.
Hard difficulty will select a word greater than 11 letters.

Synopsis:
Hangman is a classic game.
A word is selected and you will guess the letters within the word until you either win or lose.
You have 6 chances to pick the correct letters or else you will perish!
"
	go_back
elif [[ "$USEROPTION" -eq 3 ]]; then
	echo "Project by: Bhavin Patel, Christian Santana, and Dylan Klintworth"
	go_back
elif [[ "$USEROPTION" -eq 4 ]]; then
	winners_board
else
	echo "Quitting Hangman"
	exit 1
fi
}
choose_difficulty () {
	clear
	cat ./assets/hangman.txt
	echo -e "Please choose a difficulty:\n1) Easy (1-5 letters)\n2) Medium (6 - 10 letters)\n3) Hard (11+ letters)"
	read DIFFICULTY
	while [[ ! "$DIFFICULTY" =~ ^[1-3]{1}$ ]];
	do
		echo "$DIFFICULTY is not a valid option."
		read -p "Please enter an option: " DIFFICULTY
	done
}
play () {
	cat ./assets/hangman.txt
	LIFECOUNT=6
	LETTERS=""
	Guess=""
	choose_difficulty
	WORD=$(shuf ./assets/words.txt | head -n 1)
	WORD=${WORD::-1}
	WORDLENGTH="${#WORD}"
	if [[ "$DIFFICULTY" -eq 1 ]]; then
		while [[ ! ("$WORDLENGTH" -ge 1 && "$WORDLENGTH" -le 5) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	elif [[ "$DIFFICULTY" -eq 2 ]]; then
		while [[ ! ("$WORDLENGTH" -ge 6 && "$WORDLENGTH" -le 10) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	elif [[ "$DIFFICULTY" -eq 3 ]]; then
		while [[ ! ("$WORDLENGTH" -ge 11) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	fi
	date1=`date +%s`; 
	while timer=true 
	do
	   	echo "$((`date +%s` - $date1))" > ./.timer.out
       	done &
	bgPID=$!;
	while [[ "$LIFECOUNT" -gt 0 ]];
	do
		scene
	done
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
	read -p "Enter Letter: " LETTER
	while [[ ! "$LETTER" =~ ^[A-Za-z]{1}$ ]]; 
	do
		echo "$LETTER is not a letter."
		read -p "Enter letter: " LETTER
	done
	Guess="${Guess}${LETTER}"
	Guess=$(echo "$Guess" | grep -o . | sort | tr -d "\n")
}
letter_contained () {
	if [[ "$WORD" == *"$LETTER"* ]]; then
		echo "$LETTER is in the word."
		LETTERS="$LETTERS$LETTER"
		HAS_WON=$(python ./won.py $WORD $LETTERS)
		if [[ "$HAS_WON" == "You won!" ]]; then
			timer=false
			echo -e "\n\n"
			cat assets/youwon.txt
			echo -e "\n\nThe word was $WORD"
			echo -e "\n\nYou guessed it in $(cat ./.timer.out) seconds\n\nYou are being returned to the menu"
			echo $name $(cat ./.timer.out) >> ./assets/.winners_board.out
			kill "$bgPID"
			display_menus
		fi
	else
		let LIFECOUNT-=1
		echo "$LETTER is not in the word"
	fi
}
letter_function () {
	clear
	cat ./assets/hangman.txt
	echo $WORD
	echo $time
	if [[ "$LIFECOUNT" -eq 6 ]]; then
		echo "$Intro"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 5 ]]; then
		echo "$wrong1"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 4 ]]; then
		echo "$wrong2"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 3 ]]; then
		echo "$wrong3"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 2 ]]; then
		echo "$wrong4"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 1 ]]; then
		echo "$wrong5"
		echo -e "The word is $WORDLENGTH letters long...\nYou have"  $LIFECOUNT "chances"
	elif [[ "$LIFECOUNT" -eq 0 ]]; then
		echo "$wrong6"
        	echo "$LIFECOUNT lives. You lost! Word was: $WORD"
		kill "$bgPID"
		break
	fi	
	let LETTERSLENGTH=${#LETTERS}
	if [[ $LETTERSLENGTH -ne  0 ]]; then
		python ./print_letters.py $WORD $LETTERS
	else
		python ./print_underscores.py $WORD
	fi
	echo "Characters guessed: $Guess"
	letter_validation
	letter_contained
	echo
}
scene () {
	letter_function
}
LoginMenu
#display_menus
