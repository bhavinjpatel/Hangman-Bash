import sys

word = sys.argv[1]
letters = sys.argv[2]
for letter in word:
	if letter in letters:
		print(letter, end=' ')
	else:
		print('_', end=' ')
print()   
