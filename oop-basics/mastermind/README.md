# Ruby Mastermind

## Overview

Project for The Odin Project (https://www.theodinproject.com/) to recreate the game Mastermind with Ruby, played from the command line.

The goal of Mastermind is to guess your opponents secret code within a certain number of turns (like hangman but with colored pegs). Each turn you get some feedback on how good your guess was - whether you got any pegs right or if you got the correct colors but in the wrong place. For more information, see https://en.wikipedia.org/wiki/Mastermind_(board_game).

The current version of the program allows the player to play as either the code maker or the code breaker: 
- As the code breaker, the computer will generate a random 4-color code which you have 12 turns to crack
- As the code maker, you provide the computer with a 4-color code that the computer must crack

## How to use

The game can be run from the command line by simply running:

```
$ ruby mastermind.rb
```

Further instructions provided within the command line.

Live preview of the game available here: https://replit.com/@ayrtonomics/Mastermind?v=1

## Key Topics

This project was part of the Object Oriented Programming basics section of the course. 

Focus was given to trying to start to write more fundamentally solid programs (e.g., Don't repeat yourself, Modular, Single-responsibility principle).

While part of the OOP section, a number of other basic Ruby building blocks used (e.g., working with arrays, custom methods, iteration, etc.) 

Had to write several custom array methods to be used for the computer to be able to crack the code. The basic strategy for the computer was to compare it's most recent guess to an array of all possible combinations and to use the feedback to remove all possible combinations which would not have been possible (given the feedback).

## Potential Next Steps

A number of ways the game could be improved. The option to play multiple rounds could be added, as well as the option to play versus the computer or versus another opponent.
