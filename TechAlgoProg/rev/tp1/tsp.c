//
//  TSP
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <stdbool.h>
#include <math.h>
#include <unistd.h>
#include <time.h>

#include <GL/glu.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>

#include "variables.h"
#include "utils.h"
#include "misc.c"


static void drawTour(point *V, int n, int *P){

  // saute le dessin si le précédent a été fait il y a moins de 20ms
  static unsigned int last_tick = 0;
  if(n<0) { last_tick = 0; n=-n; }  // force le dessin si n<0
  if(last_tick + 20 > SDL_GetTicks()) return;
  last_tick = SDL_GetTicks();

  // gestion de la file d'event
  handleEvent(false);

  // efface la fenêtre
  glClearColor(0,0,0,1);
  glClear(GL_COLOR_BUFFER_BIT);

  // dessine le cycle
  if(P && V){
    selectColor(1,1,1); // couleur blanche
    for (int i = 0 ; i < n ; i++)
      drawLine(V[P[i]], V[P[(i+1) % n]]);
  }
  // dessine les points
  if(V){
    selectColor(1,0,0); // couleur rouge
    for (int i = 0 ; i < n ; i++)
      drawPoint(V[i]);
  }

  // affiche le dessin
  SDL_GL_SwapWindow(window);
}


static void drawPath(point *V, int n, int *path, int len){

  // saute le dessin si le précédent a été fait il y a moins de 20ms
  static unsigned int last_tick = 0;
  if(n<0) { last_tick = 0; n=-n; }  // force le dessin si n<0
  if(last_tick + 20 > SDL_GetTicks()) return;
  last_tick = SDL_GetTicks();

  // gestion de la file d'event
  handleEvent(false);

  // efface la fenêtre
  glClearColor(0,0,0,1);
  glClear(GL_COLOR_BUFFER_BIT);

  // dessine le chemin
  selectColor(0,1,0); // vert
  for (int i = 0 ; i < len-1 ; i++)
    drawLine(V[path[i]], V[path[i+1]]);

  // dessine les points
  selectColor(1,0,0); // rouge
  for (int i = 0 ; i < n ; i++)
    drawPoint(V[i]);

  // affiche le dessin
  SDL_GL_SwapWindow(window);
}


// Génère n points aléatoires du rectangle entier [0,X] × [0,Y] et
// renvoie le tableau des n points ainsi générés et met à jour la
// variable globale vertices[].
static point* generatePoints(int n, int X, int Y) {
  vertices = malloc(n * sizeof(point));
  const double rx = (double) X / RAND_MAX;
  const double ry = (double) Y / RAND_MAX;
  for (int i = 0 ; i < n ; i++){
    vertices[i].x = random() * rx;
    vertices[i].y = random() * ry;
  }
  return vertices;
}

static double dist(point A, point B){
	// ...
	return 0;
}

static double value(point *V, int n, int *P){
	// ...
	return 0;
}

static double tsp_brute_force(point *V, int n, int *Q){
	// ...
	return 0;
}

static void MaxPermutation(int *P, int k){
	// ...
	return;
}

static double value_opt(point *V, int n, int *P,double w){
	// ...
	return 0;
}

static double tsp_brute_force_opt(point *V, int n, int *Q){
	// ...
	return 0;
}

// taille initiale de la fenêtre
int width = 640;
int height = 480;

// pour la fenêtre graphique
bool running = true;
bool mouse_down = false;
double scale = 1;


int main(int argc, char *argv[]) {

	initSDLOpenGL();
	srandom(time(NULL));
	TopChrono(0); // initialise tous les chronos

	bool need_redraw = true;
	bool wait_event = true;

	int n = 10;
	point *V = generatePoints(n, width, height);
	int *P = malloc(n * sizeof(int));
	for(int i = 0; i < n; i++) P[i] = i; // première permutation
	drawTour(V, n, NULL); // dessine les points

	{
	  TopChrono(1); // départ du chrono 1
	  double w = tsp_brute_force(V,n,P);
	  char *s = TopChrono(1); // s=durée
	  printf("value: %g\n",w);
	  printf("runing time: %s\n",s);
	  drawTour(V, -n, P); // dessine la tournée
	}

	{
	  /*
	    TopChrono(1); // départ du chrono 1
	    double w = tsp_brute_force_opt(V,n,P);
	    char *s = TopChrono(1); // s=durée
	    printf("value: %g\n",w);
	    printf("runing time: %s\n",s);
	    drawTour(V, -n, P); // dessine la tournée
	  */
	}

	{
	  /*
	    TopChrono(1); // départ du chrono 1
	    double w = tsp_prog_dyn(V,n,P);
	    char *s = TopChrono(1); // s=durée
	    printf("value: %g\n",w);
	    printf("runing time: %s\n",s);
	    drawTour(V, -n, P); // dessine la tournée
	  */
	}

	// Affiche le résultat et attend (q pour sortir)
	while(running){
	  if (need_redraw) drawTour(V, n, P);
	  need_redraw = handleEvent(wait_event);
	}

	// Libération de la mémoire
	TopChrono(-1);
	free(V);
	free(P);

	cleaning();
	return 0;
}
