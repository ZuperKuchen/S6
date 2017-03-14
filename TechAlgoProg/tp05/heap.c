#include <stdlib.h>
#include "heap.h"

void echange(void** array,int ind1,int ind2){
  void* tmp = array[ind1];
  array[ind1] = array[ind2];
  array[ind2] = tmp;
}

heap heap_create(int n, int (*f)(const void *, const void *)){
  heap tas = malloc(sizeof(heap));
  tas->nmax = n;
  tas->size = 0;
  tas->array = malloc(n*sizeof(void*));
  tas->f = f;
  return tas;
}

void heap_destroy(heap h){
  free(h->array);
  free(h);
}

int heap_empty(heap h){
  return (h->size == 0);
}

int heap_add(heap h, void *object){
  if(h->size == h->nmax) return 1;
  h->array[++h->size] = object;
  int ind = h->size;
  while( ind!=1 && h->f(h->array[ind], h->array[ind/2]) < 0 ) { ///// while array[ind] < array[ind/2]
    echange(h->array, ind, ind/2);
    ind /= 2;
  }
  return 0;
}


void *heap_top(heap h){
  if ( h->size == 0) return NULL;
  return h->array[1];
}


void *heap_pop(heap h){
  void* res = h->array[1];
  echange(h->array, 1, (h->size)--);
  int ind = 1;
  int min;
  while(1){
    min = ind;
    if (2*ind <= h->size && h->f(h->array[ind], h->array[2*ind]) > 0){
      min = 2*ind;
    }
    if (2*ind +1 <= h->size && h->f(h->array[min], h->array[2*ind +1]) > 0){
      min = 2*ind +1;
    }
    if(ind == min){
      break;
    }
    echange(h->array, ind, min);
    ind = min;
  }
  return res;
}
