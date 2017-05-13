/**********************************************************************************
 * Class:     Menu
 *
 * Authors:   Adam Austin
 *
 * Function:  TODO
 *             
 * Imports:   TODO
 *
 * Methods:   TODO
 *
 **********************************************************************************/

class Menu {
  //fill(173,149, 34);
  //rect(0,0, height,width);
  //fill(143,60,30);
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
 * Function:   TODO
 *             
 * Parameters: TODO
 *
 * Notes:      TODO
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


  void screenServer() {
    fill(0, 255, 0);


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

  boolean getServerStatus() {
    return isServer;
  }
  
  boolean isLocal(){
   return isLocal;
     
  }
}