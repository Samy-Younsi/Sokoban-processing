/////////////////////////////////////////////////////
//
// Sokoban
// DM "UED 131 - Programmation impérative" 2024-2025
// NOM         : Younsi
// Prénom      : Samy
//
/////////////////////////////////////////////////////

// constantes pour décoder les niveaux
// -----------------------------------
int Empty = 0;  
int Floor = 1;  
int Wall = 2;  
int Box = 3;  
int Target = 4;
int BoxOnTarget = 5;
int Avatar = 6;
//
// Les variables globales
// ======================
//variable dimensions
int dim_x;
int dim_y;
//variable step
int step;
//variable bandeau
int bandeau;
//variable shift
int shift_x;
int shift_y;
//variable personnage
int avatarX = 3;
int avatarY = 1;
//variable boite
int boxX = 1;
int boxY = 2;
//variable cible
int targetX = 1;
int targetY = 3;
//création des tableaux
int[][] map;
boolean[][] targets;
int currentLevel = 1;
int targetCount = 0;
//permet de charger le niveau selon la variable current level
PImage reload;
//importe le son
import processing.sound.*;
SoundFile sokoban;
//=================================================================
//
// Initialisation de la fenêtre graphique
//
//=================================================================
void settings() {
  size(500, 500);
  loadLevel(currentLevel);
}

//=================================================================
//
// Initialisation du programme
//
//=================================================================
void setup() {
  dim_x = 6;
  dim_y = 6;
  step = 50;
  bandeau = 50;
  shift_x = ((width - (dim_x * step))/ 2);
  shift_y = ((bandeau + (height - (dim_y * step) - bandeau))/2);
  //afficher l'image relaod.png
  reload = loadImage("reload.png");
  // son du niveau
  sokoban = new SoundFile(this, "sokoban.mp3");
  sokoban.loop();
}


//=================================================================
//
// Boucle de rendu
//
//=================================================================
void draw() {
  drawMap();
}


//=================================================================
// Teste si le niveau est résolu
// - niveau résolu si toutes les cibles ont une caisse sur elles
// - sortie = true si niveau résolu, false sinon
//=================================================================
boolean solved() {
   for (int y = 0; y < targets.length; y++) {
      for (int x = 0; x < targets[y].length; x++) {
        if (targets[y][x] && map[y + 2][x] != BoxOnTarget) {
          // Une cible sans boîte
          return false;
        }
      }
    }
    return true;
  }

//=================================================================
// Charge un niveau en mémoire
// - lev = le numéro du niveau à charger
//=================================================================
void loadLevel(int lev) {
  String[] levelData = loadStrings("level" + lev + ".skb");
  map = new int[levelData.length][levelData[2].length()];
    targets = new boolean[levelData.length][levelData[2].length()];
  
    for (int y = 2; y < levelData.length; y++) {
        for (int x = 0; x < levelData[y].length(); x++) {
            char c = levelData[y].charAt(x);
            //passer d'entier en caractère
            map[y][x] = c - '0'; 
            //si il y a une cible
            if (map[y][x] == Target || map[y][x] == BoxOnTarget) {
                targets[y-2][x] = true;
                targetCount++; 
            }
        }
    }
}

//=================================================================
// Dessine le niveau
//=================================================================
void drawMap() {
  pushMatrix();
  //bouton 
  background(73, 109, 161);
  fill(#94A6E8);
  noStroke();
  rect(0,0,width,bandeau);
  image(reload,width-50,0);
  // affichr le texte dans le bandeau
  fill(#504B6E);
  textSize(40);
  if (solved()) {
    if (currentLevel < 26) {
        textSize(24);
        text("BRAVO ! Touche ESPACE pour continuer.", width / 81, 40);
        if (keyPressed && key == ' ') {
           currentLevel++;
           loadLevel(currentLevel);
      }
    } 
    else {
      textSize(24);
      text("BRAVO !!! Tous les niveaux sont terminés !", width / 81, 40);
    }    
  }
  else {
      text("Level "+currentLevel, width / 3, 40);
  }
  //pour partir du point 0 et decaler
  translate(shift_x,shift_y);
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map[y].length; x++) {
      if (map[y][x] == Box) {
                // Colonne boîte
                boxX = x; 
                // Ligne boîte
                boxY = y-2;
                drawFloor(x,(y-2));
                drawBox(x,(y-2));
      }
      else if (map[y][x] == Floor) {
                drawFloor(x,(y-2));
      }
      else if (map[y][x] == Wall) {
                drawWall(x,(y-2)); 
      }
      else if (map[y][x] == Avatar) {
                // Colonne du personnage
                avatarX = x ; 
                // Ligne du personnage
                avatarY = y-2 ;
                drawFloor(x,(y-2));
                drawAvatar(x,(y-2));
      }
      else if (map[y][x] == Target) {
                // Colonne cible
                targetX = x;
                // Ligne cible
                targetY = y-2;
                drawFloor(x,(y-2));
                drawTarget(targetX,targetY);
      }
      else if (map[y][x] == BoxOnTarget) {
                // Colonne boîte
                boxX = x;
                // Ligne boîte
                boxY = y-2;
                drawFloor(x,(y-2));
                drawBox(boxX,boxY);
                drawTarget(x,y-2);
            }   
   }
  }
    popMatrix(); 
 }

//=================================================================
// Dessine une caisse en bois
// x, y = les coordonnées de la caisse (dans le tableau de la map)
//=================================================================
void drawBox(int x, int y) {
  pushMatrix();
  translate(x * step, y * step);
  stroke(1);
  fill(#B9831E);
  //carré initial
  rect(x, y, 50, 50);
  fill(#9D6A0B);
  //carré au milieu
  rect(x+8, y+8, 34, 34);
  fill(#B9831E);
  //ligne dans le carré du milieu
  line(x+8, y+42, x+42, y+8);
  noStroke();
  fill(#676767);
  //Triangle gris en haut a gauche
  triangle(x, y, x+5, y, x, y+5);
  //en haut à droite
  triangle(x+50, y, x+45, y, x+50, y+5);
  //en bas à gauche
  triangle(x, y+50, x+5, y+50, x, y+45);
  //en bas à droite
  triangle(x+50, y+50, x+45, y+50, x+50, y+45);
  popMatrix();
}


//=================================================================
// Dessine un mur
// x, y = les coordonnées du mur (dans le tableau de la map)
//=================================================================
void drawWall(int x, int y) {
  pushMatrix();
  translate(x * step, y * step);
  noStroke();
  fill(#868686);
  //carré initial
  rect(x, y, 50, 50);
  fill(#767373);
  //carré milieu
  rect(x+8, y+8, 34, 34, 5);
  fill(#767373);
  //triangle haut
  triangle(x+7,y+3,x+42,y+3,x+25,y+20);
  //bas
  triangle(x+7,y+47,x+42,y+47,x+25,y+30);
  //gauche
  triangle(x+3,y+7,x+3,y+42,x+20,y+25);
  //droite
  triangle(x+47,y+7,x+47,y+42,x+30,y+25);
  fill(#5F5C5C);
  //gauche
  triangle(x+8,y+12,x+8,y+37,x+20,y+25);
  //droite
  triangle(x+42,y+12,x+42,y+37,x+30,y+25);
  //haut
  triangle(x+12,y+8,x+37,y+8,x+25,y+20);
  //bas
  triangle(x+12,y+42,x+37,y+42,x+25,y+30);
  popMatrix();
}

//=================================================================
// Dessine une dalle du sol
// x, y = les coordonnées du sol (dans le tableau de la map)
//=================================================================
void drawFloor(int x, int y) {
  pushMatrix();
  translate(x * step, y * step);
  stroke(0);
  fill(#B7B7B7);
  rect(x,y,50,50,5);
  rect(x,y,50,5,5);
  rect(x,y+5,50,5,5);
  rect(x,y+10,50,5,5);
  rect(x,y+15,50,5,5);
  rect(x,y+20,50,5,5);
  rect(x,y+25,50,5,5);
  rect(x,y+30,50,5,5);
  rect(x,y+35,50,5,5);
  rect(x,y+40,50,5,5);
  rect(x,y+45,50,5,5);
  popMatrix();
}


//=================================================================
// Dessine l'avatar
// x, y = les coordonnées de l'avatar (dans le tableau de la map)
//=================================================================
void drawAvatar(int x, int y) {
  pushMatrix();
  translate(x * step, y * step);
  noStroke();
  fill(0);
  //chaussures
  ellipse(x+11, y+47, 15, 8);
  ellipse(x+39, y+47, 15, 8);
  fill(#CE0202);
  //salopette rouge
  rect(x+3, y+29, 44,18);
  fill(#950000);
  arc(x+25, y+47, 20, 15, -PI, 0);
  fill(#2FA730);
  //tee shirt vert
  arc(x+25, y+29, 20, 15, 0, PI);
  //manches tee shirt
  ellipse(x+3, y+36, 6, 12);
  ellipse(x+47, y+36, 6, 12);
  fill(#F0CE8F);
  //séparé du point d'origine 0 0
  pushMatrix();
  //main gauche
  translate(x+6, y+40);
  rotate(degrees(45));
  ellipse(0, 0, 12, 8);
  popMatrix();
  pushMatrix();
  //main droite
  translate(x+46, y+40);
  rotate(degrees(165));
  ellipse(0, 0, 12, 8);
  popMatrix();
  //visage
  rect(x+3, y+10, 44, 20, 14);
  //cheveux
  fill(#764E04);
  triangle(x+3, y+10, x+10, y+10, x+3, y+20);
  triangle(x+47, y+10, x+40, y+10, x+47, y+20);
  //yeux
  ellipse(x+15, y+17, 4, 6);
  ellipse(x+35, y+17, 4, 6);
  //moustache
  triangle(x+17, y+27, x+33, y+27, x+25, y+21);
  //nez
  fill(#DBB164);
  ellipse(x+25, y+21, 8, 4);
  //oreilles
  arc(x+47, y+20, 10, 10, -PI/2, PI/2);
  arc(x+3, y+20, 10, 10, PI/2, 3*PI/2);
  //casquette
  fill(#288E21);
  rect(x+3, y, 44, 10, 10);
  fill(255);
  arc(x+25.5, y+8, 17, 7, -PI, 0);
  //devant casquette
  fill(#2FA730);
  rect(x+3, y+8, 44, 5, 8);
  popMatrix();
}

//=================================================================
// Dessine les cibles
// x, y = les coordonnées de la cible (dans le tableau de la map)
//=================================================================
void drawTarget(int x, int y) {
  pushMatrix();
  translate(x * step + step / 2, y * step + step / 2);
  if (x == boxX && y == boxY) { 
    // Si la caisse est sur la cible
    fill(52, 240, 44, 128);
    rectMode(CENTER);
    rect(boxX, boxY, step, step);
    rectMode(CORNER);
  }
  // Si il y a une cible sur la case
  if (targets[y][x]) { 
    fill(#34F02C);
    ellipse(x, y, 15, 15);
    fill(#15B70D);
    ellipse(x, y, 7, 7);
  }
  popMatrix();
}

//=================================================================
// Commande du personnage avec les flèches
// -> déplace le personnage dans la direction de la flèche
//    si les conditions le permettent
//=================================================================
void keyReleased() {
  int caseX = avatarX;
  int caseY = avatarY;

  // Déterminer la direction
  if (keyCode == UP) {
    // Décremente la valeur de avatarY
    caseY--; 
  } else if (keyCode == DOWN) {
    // Incrémente la valeur de avatarY
    caseY++; 
  } else if (keyCode == LEFT) {
    // Décremente la valeur de avatarX
    caseX--; 
  } else if (keyCode == RIGHT) {
    // Incrémente la valeur de avatarX
    caseX++;
  }

  // Déterminer la case suivante
  int caseSuivanteX = caseX + (caseX - avatarX);
  int caseSuivanteY = caseY + (caseY - avatarY);

  // Si la case est un sol ou une cible
  if (map[caseY + 2][caseX] == Floor || map[caseY + 2][caseX] == Target) {
    // Met à jour la carte
    if (targets[avatarY][avatarX]) {
      // Si l'avatar était sur une cible, la restaure
      map[avatarY + 2][avatarX] = Target;
    } else {
      // Sinon, la transforme en sol
      map[avatarY + 2][avatarX] = Floor;
    }
    // Déplace l'avatar
    avatarX = caseX;
    avatarY = caseY;
    map[avatarY + 2][avatarX] = Avatar;
  } 
  // Si la case contient une boîte et que la case suivante est vide ou une cible
  else if ((map[caseY + 2][caseX] == Box || map[caseY + 2][caseX] == BoxOnTarget) &&
           (map[caseSuivanteY + 2][caseSuivanteX] == Floor || map[caseSuivanteY + 2][caseSuivanteX] == Target)) {
    // Déplace la boîte
    if (targets[caseY][caseX]) {
      // Si la boîte était sur une cible, restaure la cible
      map[caseY + 2][caseX] = Target;
    } else {
      // Sinon, la transforme en sol
      map[caseY + 2][caseX] = Floor;
    }

    if (targets[caseSuivanteY][caseSuivanteX]) {
      // Si la case suivante est une cible, place une boîte sur cible
      map[caseSuivanteY + 2][caseSuivanteX] = BoxOnTarget;
    } else {
      // Sinon, place une boîte normale
      map[caseSuivanteY + 2][caseSuivanteX] = Box;
    }

    // Déplace l'avatar
    if (targets[avatarY][avatarX]) {
      // Si l'avatar était sur une cible, restaure la cible
      map[avatarY + 2][avatarX] = Target;
    } else {
      // Sinon, la transforme en sol
      map[avatarY + 2][avatarX] = Floor;
    }
    avatarX = caseX;
    avatarY = caseY;
    map[avatarY + 2][avatarX] = Avatar;
  }
}



//=================================================================
// Recharge du niveau
// -> recharge le niveau courant quand on clique sur le bouton
//=================================================================
void mouseClicked() {
  //Vérifie si le clic est sur le bouton de rechargement
  if (mouseX >= width - 50 && mouseX <= width && mouseY >= 0 && mouseY <= 50) {
    // Réinitialise les positions de l'avatar et de la caisse à celle de départ
    loadLevel(currentLevel);
  }
}
