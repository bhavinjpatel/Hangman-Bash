import sys

word = sys.argv[1]
letters = sys.argv[2]
count = 0

for letter in word:
	if letter in letters:
		count = count + 1
if count == len(word):
	print("You won!")
