# Matrix multiplication benchmark written in C++

This is my homework project in `parallel algorithms` course. The main purpose of project is comparing speedup of parallel processing vs serial executing in `OpenMP`  library. I added some  more features to my project such as:
 - Comparing serial/parallel executing vs **optimized** serial/parallel executing 
 - Comparing speed of armadillo library vs mine.
 - A bash script to average running time and different matrix sizes.
 - plotting the result times

## Requirements

- bash
- g++
- armadillo library
- python 3.x
	- matplotlib
	- seaborn


## Usage
Use this command to run benchmark:

    ./run.sh -n10 -a"128 256 512"
 
 Where `10` is number of tests for averaging time and `"128 256 512"` is different matrix sizes for benchmarking. 

## Result

This benchmark tested on `Manjaro linux 18.0.1` running on `asus x450ld` with `Intel core i5 4200U`

Command:

    ./run.sh -n2 -a"16 32 64 128 256 512 1024 2048"

![benchmark](http://uupload.ir/files/gzkc_figure_1.png)

 
