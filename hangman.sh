#!/bin/bash
#check to see user has python installed and symbolically linked
if ! type python &> /dev/null; then
	echo "You do not have python installed. Please install python and create a symbolic link for it with the command 'sudo ln -s /usr/bin/python[version] /usr/bin/python'"
	exit 1
fi
cat ./assets/hangman.txt
#Displays for game
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
Guesses="" #SET Guesses to blank values
Login_Menu_items=" 
WELCOME TO HANGMAN!

1) Login as existing user
2) Create Account
"
#allow users to log in
LoginMenu (){
	echo "$Login_Menu_items"
	read -p "Please enter an option: " LoginOPTION
#verifies login information
	while [[ ( -z "$LoginOPTION") || (! "$LoginOPTION" =~ ^[1-2]{1}$) ]];
	do
		echo "$LoginOPTION is not a valid option."
		echo "$LoginOPTIONS"
		read -p "Please enter an option: " LoginOPTION
	done

	if [[ "$LoginOPTION" -eq 1 ]]; #if option 1, login user
	then
		validate_user
	elif [[ "$LoginOPTION" -eq 2 ]]; #if option 2, register user
	then
		Register_User
	fi
}
validate_user (){
	read -p "Please enter your name: " name #get name
	#validate name is valid
	while [[ (-z "$name") || (! "$name" =~ ^[[:alpha:]]+$ ) ]];
	do
		echo "$name is not valid. Name can only contain letters."
		read -p "Please enter your name: " name
	done
	
	read -p "Please enter your pin: " pin #get pin
	#validate pin is valid
	while [[ (-z "$pin") || ( ! $pin =~ ^[0-9]+$ ) ]];
        do
                echo "$pin is not valid. Pin can only contain digits."
                read -p "Please enter your secret pin: " pin
        done
	if [[ -f ./assets/.user_data.out ]]; then #checks for user details in user_data
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
        read -p "Please enter your name: " name #gets name
	#validates name
        while [[ (-z "$name") || ( ! "$name" =~ ^[[:alpha:]]+$ ) ]];
        do
                echo "$name is not valid. Name can only contain letters."
                read -p "Please enter your name: " name
        done
        read -p "Please enter a secret pin: " pin #get pin
	#validate pin
        while [[ (-z "$pin") ]] || [[ (! $pin =~ ^[0-9]+$ ) ]];
        do
                echo "$pin is not valid. Pin can only contain digits."
                read -p "Please enter a secret pin: " pin
        done
	echo -e "\nHi $name, you have been registered successfully. Your secret pin is $pin. Please login to play the game!"
	echo "$name $pin" >> ./assets/.user_data.out #registers name and pin to user_data file
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
	cat ./assets/hangman.txt #get hangman banner
	echo "$USERMENU"
	 #show menu and validate user options
	read -p "Please enter an option: " USEROPTION

	while [[ ( -z "$USEROPTION") || (! "$USEROPTION" =~ ^[1-5]{1}$) ]];
	do
		echo "$USEROPTION is not a valid option."
		echo "$USEROPTIONS"
		read -p "Please enter an option: " USEROPTION
	done
	if [[ "$USEROPTION" -eq 1 ]]; then #enact play if option 1
		play
	elif [[ "$USEROPTION" -eq 2 ]]; then #show menu if option 2
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
	elif [[ "$USEROPTION" -eq 3 ]]; then #show project contributors if option 3
		echo "Project by: Bhavin Patel, Christian Santana, and Dylan Klintworth"
		go_back
	elif [[ "$USEROPTION" -eq 4 ]]; then #show winner board if option 4
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
	read DIFFICULTY #get difficulty
	#validate difficulty
	while [[ ! "$DIFFICULTY" =~ ^[1-3]{1}$ ]];
	do
		echo "$DIFFICULTY is not a valid option."
		read -p "Please enter an option: " DIFFICULTY
	done
}
play () {
	#show banner
	cat ./assets/hangman.txt
	LIFECOUNT=6 #set life count to 6
	LETTERS="" #letters blank
	Guess="" #guess blank
	choose_difficulty #choose game difficulty
	WORD=$(shuf ./assets/words.txt | head -n 1) #get word
	WORD=${WORD::-1} #remove irrenous last byte
	WORDLENGTH="${#WORD}" #get word length
	if [[ "$DIFFICULTY" -eq 1 ]]; then #set word difficulty to easy if 1
		while [[ ! ("$WORDLENGTH" -ge 1 && "$WORDLENGTH" -le 5) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	elif [[ "$DIFFICULTY" -eq 2 ]]; then #set word difficulty to medium if 2
		while [[ ! ("$WORDLENGTH" -ge 6 && "$WORDLENGTH" -le 10) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	elif [[ "$DIFFICULTY" -eq 3 ]]; then #set word difficulty to hard if 3
		while [[ ! ("$WORDLENGTH" -ge 11) ]];		
		do
			WORD=$(shuf ./assets/words.txt | head -n 1)
			WORD=${WORD::-1}
			WORDLENGTH="${#WORD}"
		done
		echo "$WORDLENGTH"
	fi
	date1=$SECONDS; #get seconds since 1-1-1970
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
			echo -e "\n\n"
			cat assets/youwon.txt
			echo -e "\n\nThe word was $WORD"
			DURATION=$(( SECONDS - date1 )) 
			echo -e "\n\nYou guessed it in $DURATION seconds\n\nYou are being returned to the menu"
			echo "$name $DURATION" >> ./assets/.winners_board.out
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
	echo "$WORD"
	echo "Second Count: $(( SECONDS - date1 ))"
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
