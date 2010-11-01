- Put the game files inside the "game" folder

- Open GameIDs.txt for a list of games supported by ScummVM
  - Locate the line with the name of the game you want to run. Take note of its Game Name and game_identifier
  - Open Info.plist and replace:
    - Game Name (one occurrence) with the Game Name taken from GameIDs.txt
    - game_identifier (two occurrences) with the game_identifier from GameIDs.txt
  - Save, close, replace the game.icns with a better one for the game you want to run, and enjoy it.

(c) 2010 syao / dotalux.com
