

/**********************************************************************************
 * Class:     Menu
 *
 * Authors:   Adam Austin
 *
 * Function:  Create and control the menu. Options selected in the menu are then stored in the Util 
              class for later use and reference by other classes and methods outside the menu
 *             
 * Imports:   None
 *
 * Methods:   display()           - Displays the current menu screen
 *            screenMain()        - This is the main menu screen
 *            screenServer()      - This is the screen to either start a server or start a local game
 *            screenServerReady() - This is the screen just before game play starts. Shows the server hostname 
 *            screenClient()      - This is the screen for the client to enter the hostname of the server and connect
 *            select()            - This is the keyboard interaction for the user to select options in the menu, and type a hostname when required
 *            getServerStatus()   - Returns wether or not the current program is acting as a server or client
 *            isLocal()           - Returns wether or not the current program is local multiplayer or over LAN 
 *
 **********************************************************************************/

class Menu {
  
  int selection;
  int screen;
  int maxSelection;
  color c1 = color(173, 149, 34);
  color c2 = color(143, 60, 30);
  boolean enter;
  String IP;
  boolean userInput = false;
  PFont font;
  PImage mainMenu;
  PImage creditScreen;
  PImage onShow;
  boolean isServer;
  boolean isLocal = false;


 /**********************************************************************************
 * Method:     Constructor
 *
 * Author(s):  Adam Austin
 *
 * Function:   Create the menu object
 *             
 * Parameters: None
 *
 **********************************************************************************/
  Menu() {
    selection = 0; 
    screen = 0;
    maxSelection = 2;
    enter = false;
    IP = "";
    font = loadFont("coolFont2.vlw");
    mainMenu = loadImage("mainMenu.png");
    creditScreen = loadImage("credits.png");
    onShow = mainMenu;
    textFont(font);
    isServer = true;
  }


 /**********************************************************************************
 * Method:        display()
 *
 * Author(s):     Adam Austin
 *
 * Function:      Display the current screen option
 *             
 * Parameters:    None
 *
 * Return values: None
 *
 **********************************************************************************/
  void display() {
    textSize(64);
    image(onShow, 0, 0); 
    selection = (selection % (maxSelection + 1));
    if ( selection < 0) {
      selection = maxSelection;
    }

    switch(screen) {
    case 0:
      screenMain();
      break;
    case 1:
      screenServer();
      break;
    case 11:
      screenServerReady();
      break;
    case 2:
      screenClient();
      break;
    case 3:
      screenCredits();
    }

    enter = false;
  }


 /**********************************************************************************
 * Method:       screenMain()
 *
 * Author(s):    Adam Austin
 *
 * Function:     The main screen
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void screenMain() {
    onShow = mainMenu;
    String[] textString = { "Start Multiplayer Game", "Join Multiplayer Game", "Credits", "Exit"};
    maxSelection = textString.length - 1;
    for (int i = 0; i < textString.length; i++) {
      if (i == selection) {
        fill(c1);
      } else {
        fill(c2);
      }
      text(textString[i], 150, (i + 1) * 70 + 200);
    }

    if (enter) {
      switch(selection) {
      case 0:
        screen = 1;
        break;

      case 1:
        screen = 2;
        if (IP.length() > 0) {
          Util.onMenu = false;
          isServer = false;
        }
        break;

      case 2:
        screen = 3;
        break;

      default:
        exit();
        break;
      }
    }
  }


 /**********************************************************************************
 * Method:       screenServer()
 *
 * Author(s):    Adam Austin
 *
 * Function:     The "Start Multiplayer" screen
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void screenServer() {
    String[] textString = { "Create Network Game", "Start Local Game", "Back"};
    maxSelection = textString.length - 1;
    for (int i = 0; i < textString.length; i++) {
      if (i == selection) {
        fill(c1);
      } else {
        fill(c2);
      }
      text(textString[i], 150, (i + 1) * 70 + 200);
    }

    if (enter) {
      switch(selection) {
      case 0:
        //Util.onMenu = false;
        //Util.isServer = true;
        screen = 11;
        break;
      case 1:
        isLocal = true;
        Util.onMenu = false;
        break;
      case 2:
        selection = 0;
        screen = 0;
        break;
      }
    }
  }


 /**********************************************************************************
 * Method:       screenServerReady()
 *
 * Author(s):    Adam Austin
 *
 * Function:     The final screen before the game, shows server host name on server machine
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void screenServerReady() {
    String textString = "Your Hostname is";
    String hostString = (String)Util.hostname;
    fill(c2);
    text(textString, 200, 300);
    fill(c1);
    text(hostString, 150, 400);
    fill(c2);

    text("Press enter to start game", 200, 500);
    if (enter) {
      isServer = true;
      Util.onMenu = false; 
      if (Util.setup) {
        Util.networkSetup = false;
      }
    }
  }


 /**********************************************************************************
 * Method:       screenClient()
 *
 * Author(s):    Adam Austin
 *
 * Function:     The join game screen
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void screenClient() {
    isServer = false;
    fill(c2);
    text("Please enter the server hostname", 75, 300);  
    userInput = true;
    fill(c1);
    text(IP, 100, 400);
  }

  void screenCredits() {
    onShow = creditScreen;
    fill(c1);
    text("Back", 100, height - 50);
    if (enter) {
      screen = 0;
    }
    
  }


 /**********************************************************************************
 * Method:       select()
 *
 * Author(s):    Adam Austin
 *
 * Function:     Used for keyboard interaction with the menu
 *             
 * Parameters:   None
 *
 **********************************************************************************/
  void select() {
    if ( keyCode == UP) {
      selection--;
    } else if (keyCode == DOWN ) {
      selection++;
    } else if (keyCode == 10) {
      enter = true;
    }

    if (userInput) {
      IP += key; 
      if (keyCode == 8 ) {
        if (IP.length() < 2) {
          IP = "";
        } else {
          IP = IP.substring(0, IP.length() - 2);
        }
      }
      if (IP.length() > 0 && keyCode == 10) {
        Util.onMenu = false;
        //Util.isServer = false;
        Util.IP = IP.substring(0, IP.length()-1);
        println(IP);
      }
    }
  }


 /**********************************************************************************
 * Method:       getServerStatus()
 *
 * Author(s):    Adam Austin
 *
 * Function:     returns wether the program is acting as a server or client
 *             
 * Parameters:   None
 *
 * Return values: isServer - True if acting as a server
 *                         - false if acting as a client
 **********************************************************************************/
  boolean getServerStatus() {
    return isServer;
  }
  
  
 /**********************************************************************************
 * Method:       isLocal()
 *
 * Author(s):    Adam Austin
 *
 * Function:     returns wether the program is running the game locally only
 *             
 * Parameters:   None
 *
 * Return values: isLocal -  True if playing locally
 *                         - false if playing over network
 **********************************************************************************/
  boolean isLocal(){
   return isLocal;
     
  }
}