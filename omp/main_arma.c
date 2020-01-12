#include <iostream>
#include <stdlib.h>
#include <chrono>
#include <time.h>
#include <omp.h>
#include <armadillo>

#define MXY
#define NXY

using namespace std;
using namespace arma;

int main(int argc, char ** argv) {
  mat A = randi < mat > (M, N);
  mat B = randi < mat > (M, N);
  auto start = chrono::high_resolution_clock::now();
  mat C = A * B;
  auto finish = chrono::high_resolution_clock::now();
  chrono::duration < double > elapsed = finish - start;

  cout << (int)(elapsed.count() * 1000000) << endl;

  return 0;
}
