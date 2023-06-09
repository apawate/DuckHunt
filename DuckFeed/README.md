# Duck Hunt 
### A duck and pelican FEEDING game for APCS with a possible Arduino Wii component. 

DUCK FEED FOR LIFE!

## How to run the Java code

### Set up core.java
First, [download Processing](https://processing.org/download) if you haven't already; it's essential for the beta versions and quite possibly the main version of this code.Under the **Java Projects** dropdown menu in the VSCode sidebar, add `core.java` as a new library. This will allow Processing to be used as a graphics program for your code. Click the **+** sign under **Referenced Libraries** and navigate to that file.

To find `core.java` (if the version we have provided doesn't work), look inside the Processing folder in your Documents or Downloads, and then click into the `core` folder and click some more until you find it.

### Set up the other stuff
Repeat the above process for the graphics libraries, which should be in the same folder as core.java, which is located in a subfolder of the **Processing** folder of your computer. Add all the jogl and gluegen jars. If you run into problems, feel free to leave an issue on the GitHub or contact us at [this link](mailto:apawate739@student.fuhsd.org)!

### Downgrade Java :(
If you have JDK-11, delete that and make sure you have JDK-8 instead. For some unknown reason, Processing will not compile when used with the JDK-11. Don't worry, it shouldn't be _too_ hard to get it back... This might be a bit hard, so if you need help feel free to search online or contact us at the link above.

### That's it!

## Arduino and DuckFeed: Beta Version

### Arduino
Wire up the HM-10 Bluetooth Module (circuit diagrams are available online) and run the `bluetoothducks.ino` file under `DuckFeed`. Then, download the [Duino](https://github.com/davebaraka/duino) app from the Google Play store and connect to the HM-10. Run `sprites.pde` (NOT DuckFeed.java, that doesn't support serial functionality) and edit the port value to fit the port your Arduino is connected at. Then watch the magic happen! It's still in a beta version, but that doesn't mean it is _completely_ nonfunctional.

### Beta
The `sprites.pde` file contains beta features such as sound and Arduino app control. Run it with [Processing](https://processing.org) and watch the buggy magic occur!


_Questions? Contact us [here](mailto:apawate739@student.fuhsd.org)!_
