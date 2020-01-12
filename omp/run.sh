#!/bin/bash

while getopts ":n:a:" opt; do
  case $opt in
    n) n="$OPTARG"
    ;;
    a) arr="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "$n" ]; then
	n=2
fi

IFS=', ' read -r -a sizes <<< $arr
if [ -z "$sizes" ]; then
	sizes=(16 32 64 128 256 512)
fi

rm results 2> /dev/null 

generate_omp(){
    source="main_omp.cpp"
    tmp=`cp main_omp.c $source`
    
    n_matrix=$1

    sed -i "s/MXY/M $n_matrix/gi" $source
    sed -i "s/NXY/N $n_matrix/gi" $source


    # echo "Start compiling serial and openmp"
    tmp=`g++ $source -fopenmp -o main_omp $2`
    tmp=`g++ $source -o main_ser $2`
    # echo "compiled successfully"
    rm $source
}

generate_arma(){
    source="main_arma.cpp"
    tmp=`cp main_arma.c $source`

    n_matrix=$1

    sed -i "s/MXY/M $n_matrix/gi" $source
    sed -i "s/NXY/N $n_matrix/gi" $source


    # echo "Start compiling armadillo"
    tmp=`g++ main_arma.cpp -fopenmp -larmadillo -o main_arma $2`
    # echo "compiled successfully"
    rm $source
}

print_average(){
    sum=0
    for i in $( seq 1 $2 ); do
        let sum+=`./$1`;
    done
    mean=`echo $sum / 1000000 / $2 | bc -l` ;
    echo "$mean"
}



echo "size serial parallel ser_opt par_opt armadillo arma_opt" >> results
args="-O3"
for i in ${!sizes[@]}; do
    size="${sizes[i]}"
    echo "set matrix size to $size"
    generate_omp $size     
    ser=$(print_average main_ser $n)
    echo "    average time of serial is $ser"

    par=$(print_average main_omp $n)
    echo "    average time of parallel is $par"

    generate_omp $size $args
    ser_opt=$(print_average main_ser $n)
    echo "    average time of ser_opt is $ser_opt"
    
    par_opt=$(print_average main_omp $n)
    echo "    average time of par_opt is $par_opt"

    generate_arma $size
    arma=$(print_average main_arma $n)
    echo "    average time of armadillo is $arma"

    generate_arma $size $args
    arma_opt=$(print_average main_arma $n)
    echo "    average time of arma_opt is $arma_opt"

    echo "$size $ser $par $ser_opt $par_opt $arma $arma_opt" >> results
done

tmp=`python3 plot.py results`

rm main_omp main_ser main_arma 2> /dev/null 
