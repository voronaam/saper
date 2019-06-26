# saper


A game written on an i386 laptop, ages ago
.

I have found it in a backup. The file is dated December 12, 2000.

This was the first game we wrote for ourself in a dorm witih no internet, no computer and no games. This was a log of fun.

The project has been converted to Lazarus, even though it would've been enough to open the PAS file in FreePascal.

To run the game:
1. Clone the repo
2. Download Lazarus (https://www.lazarus-ide.org/index.php?page=downloads)
3. Open the saper.lpr file
4. Run

This game is harder than the one shipped with the Windows OS, as it does not make an effort to guarantee to the player that the first opened field will not be a bomb. Some of the games will be very short.

Changes made to convert from TurboPascal i386 times:
- removed highscore functionality ("file of string" is not supported it seems)
- changed the bomb icon from "ю" to "b" (character encodings are a thing)
