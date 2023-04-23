## Magnetizer

**Magnetizer** is a not-that-simple logic puzzle game where the objective is escape the labirynth. Magnetizer can stop its movement only by hitting a wall or another obstacle.

The game has been originally written by [Wackyjackie](http://magnetizer.xn.pl/). This is a port for NES console, fully fully reflects the original logic of the game, along with originally composed levels and level sets.

Magnetizer contains 7 different level sets of varying difficulty and a main theme. In comparison with the original the game extends some level sets (_Sandstorm_, _Ghostly Rooms_). The medal thresholds have been reduced, so it is much harder to beat the score. But hey, we didn't say it is going to be easy! Also, there is **a brand new level set**, _One-way Roads_, with 6 thematic levels!

### Controls

Menu controls:

* _up_/_down_ arrows: level change
* _left_/_right_ arrows: level set change
* _START_: choose a level
* _A_: toggle music _ON_/_OFF_
* _B_: toggle sound _ON_/_OFF_

Game controls:

* _arrows_: movement
* _A_: next level
* _B_: restart level
* _SELECT_: return to menu

### Authors
* **idea**: Wackyjackie
* **code**: Jakim, Wackyjackie (original code)
* **graphics**: Wackyjackie
* **music/sound effects**: Jakim
* **level design**: Jakim, Wackyjackie, klapekboy
* **sound engine**: [FamiTone2 by Shiru](http://shiru.untergrund.net/code.shtml)

Original game site: http://magnetizer.xn.pl/.

### Compiling the source

The game is written in _NESasm 6502 Assembler_. To install the assembler, please download the source code from the GitHub repository and follow the instructions:
[https://github.com/camsaul/nesasm](https://github.com/camsaul/nesasm)

After a successful _NESasm_ installation, in order to compile the game, run:

```bash
nesasm magnetizer.asm
```

Moreover, if you want to debug the game for any reason, you may also want to produce a `magnetizer.nes.0.nl` file for _FCEUX_, containing helpful procedure labels. In order to create such file, please run the following:

```bash
python converter/fns2nl.py
```

after compiling the game.

### Running the game

Game is compiled to a .NES file. It can be opened by any NES emulator out there. I recommend _FCEUX_. It also can be played on some mobile phones with possible emulators out there (like _Nestopia_ for Android devices).

**Please download the latest version of _FCEUX_**. The game is reported to not working correctly on older versions.