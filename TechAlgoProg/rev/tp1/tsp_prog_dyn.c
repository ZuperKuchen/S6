/* ==== Programmation dynamique ==== */

// à insérer avant main() dans tsp.c
// compléter tsp_prog_dyn()

static int NextSet(int S, int n){
/*
  Cette fonction permet de lister les sous-ensembles de {0,...,n-1}
  par taille croissante, les sous-ensembles étant vu comme des mots
  binaires codés par des entiers (int). Ainsi NextSet(S,n) donne le
  prochain sous-ensemble immédiatement supérieur à S.

  Renvoie le plus petit entier immédiatement supérieur à S>0 et qui a
  soit le même poids que S, c'est-à-dire le même nombre de 1 dans son
  écriture binaire que S, soit le poids de S plus 1 s'il n'y en a pas
  de même poids. La fonction renvoie 0 si S est le plus grand entier
  sur n bits, soit S=2^n-1.

  L'algorithme est le suivant: dans S on décale complètement à droite
  le premier bloc de 1 (celui contenant le bit de poids faible) sauf
  le bit le plus à gauche de ce bloc qui lui est décalé d'une position
  à gauche. Si on ne peut pas décaler ce bit plus à gauche c'est que
  ou bien on est arrivé à 2^n-1 (et on renvoie 0) ou bien on doit
  passer à un poids plus élevé. Dans ce cas on renvoie 2^p-1 où p est
  le nouveau nombre de 1 de S plus 1.

  Résultats obtenus en itérant S -> NextSet(S,4) à partir de S=1:
   (taille 1) S = 0001 -> 0010 -> 0100 -> 1000 ->
   (taille 2)     0011 -> 0101 -> 0110 -> 1001 -> 1010 -> 1100 ->
   (taille 3)     0111 -> 1011 -> 1101 -> 1110
   (taille 4)     1111 ->
   (taille 0)     0000

  Ainsi, les 16 entiers sur n=4 bits sont parcourus dans l'ordre: 1 ->
  2 -> 4 -> 8 -> 3 -> 5 -> 6 -> 9 -> 10 -> 12 -> 7 -> 11 -> 13 -> 14
  -> 15 -> 0

  L'algorithme prend un temps O(1) car les opérations de shifts (<<)
  et la fonction ffs() sur des int correspondent à des instructions
  machines sur des registres.
*/
  int p1 = ffs(S); // position du bit le plus à droit (commence à 1)
  int p2 = ffs(~(S >> p1)) + p1 - 1; // position du bit le plus gauche du 1er bloc de 1
  if (p2 - p1 + 1 == n) return 0; // cas S=2^n-1
  if (p2 == n) return (1 << (p2 - p1 + 2)) - 1; // cas: poids(S)+1
  return (S & ((-1) << p2)) | (1 << p2) | ((1 << (p2 - p1)) - 1); // cas: poids(S)
}


/* renvoie l'ensemble S\{i} */
static inline int DeleteSet(int S, int i){
  return (S & ~(1 << (i)));
}


/* une cellule de la table */
typedef struct{
  double length; // longueur du chemin minimum D[t][S]
  int pred;      // point précédant t dans la solution D[t][S]
} cell;


int ExtractPath(cell **D, int t, int S, int n, int *Q){
  // Construit dans Q le chemin extrait de la table D depuis la case
  // D[t][S] jusqu'au sommet V[n-1]. Il faut que Q[] soit assez grand
  // Renvoie la taille du chemin

  Q[0]=t;  // écrit le dernier point
  int k=1; // k=taille de Q=nombre de points écrits dans Q
  while(Q[k-1]!=n-1){ // on s'arrête si le dernier point est V[n-1]
    Q[k] = D[Q[k-1]][S].pred;
    S=DeleteSet(S,Q[k-1]);
    k++;
  }
  return k;
}


static double tsp_prog_dyn(point *V, int n, int *Q){
/*
  Version programmation dynamique du TSP. Le résultat doit être écrit
  dans la permutation Q, tableau qui doit être alloué avant
  l'appel. On renvoie la valeur de la tournée minimum ou -1 s'il y a
  eut une erreur (pression de 'q' pour sortir de l'affichage).  Une
  fois que votre programme arrivera à calculer une tournée optimale (à
  comparer avec tsp_brute_force() ou tsp_brute_force_opt()), il sera
  intéressant de dessiner à chaque fois que possible le chemin courant
  avec drawPath(). La variable "running" indique si l'affichage est
  actif, la pression de 'q' faisant passer running à faux.

  Attention ! Par rapport au cours, il est plus malin de commencer la
  tournée à partir du point d'indice n-1 (au lieu de 0). Pourquoi ?

  Pour résumer:

  - D[t][S].length = longueur minimum d'un chemin allant de V[n-1] à
    V[t] qui visite tous les points d'indice dans S

  - D[t][S].pred = l'indice du point précédant V[t] dans le chemin
    ci-dessus de longueur D[t][S].length
*/

  int t,S;

  // déclaration de la table D[t][S] qui comportent (n-1)*2^(n-1) cellules
  cell **D = malloc((n-1)*sizeof(cell*)); // n-1 lignes
  for(t=0; t<n-1; t++) D[t] = malloc((1<<(n-1))*sizeof(cell)); // 2^{n-1} colonnes

  // cas de base, lorsque S={t}, pour t=0..n-2: D[t][S]=d(V[n-1],V[t])
  S=1; // S=...001 et pour l'incrémenter utiliser NextSet(S,n-1)
  ;;;
  ;;;

  // cas |S|>1 (cardinalité de S > 1): D[t][S] = min_x { D[x][S\{t}] +
  // d(V[x],V[t]) } avec t dans S et x dans S\{t}. NB: pour faire T =
  // S\{t}, utilisez T=DeleteSet(S,t); et pour savoir si x appartient
  // à l'ensemble S testez tout simplement si (S != DeleteSet(S,x)).
  do{

    ;;;
    ;;;

    // ici D[t][S].length et D[t][S].pred viennent d'être calculés.
    // Il reste a extraire le chemin de V[t] à V[n-1] et le mettre
    // dans Q, c'est le rôle de la fonction ExtractPath().

       int k = ExtractPath(D,t,S,n,Q);
       drawPath(V,n,Q,k);
    // }

    S=NextSet(S,n-1);
  }while (S && running);

  double w=-1; // valeur de la tournée optimale, -1 par défaut

  if(running){
    // on a terminé correctement le calcul complet de la table D. Il
    // faut alors calculer la longueur w de la tournée optimale et
    // éventuellement construire la tournée pour la mettre dans Q. NB:
    // si le calcul a été interrompu (pression de 'q' pendant
    // l'affichage) alors ne rien faire et renvoyer -1
    ;;;
    ;;;
  }

  ;;; // pensez à libérer la table D
  return w;
}
