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

int
main(int argc, char** argv)
  {
  
  mat A = 10 * randi<mat>(M,N);
  mat B = 10 * randi<mat>(M,N);
  auto start = std::chrono::high_resolution_clock::now();
  mat C = A*B;
  auto finish = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> elapsed = finish - start;

  std::cout << (int) (elapsed.count() * 1000000) << endl;

  
  
  
  return 0;
  }
