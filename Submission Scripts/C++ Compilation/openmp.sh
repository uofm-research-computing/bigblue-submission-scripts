#!/bin/bash
#SBATCH --cpus-per-task  4
#SBATCH --time           00:01:00
#SBATCH --mem-per-cpu    100M
#SBATCH --partition      acomputeq
#SBATCH --job-name       openmp
#SBATCH --output         openmp-%J.out
#SBATCH --error          openmp-%J.err
#SBATCH --mail-user      %{USER}@memphis.edu
#SBATCH --mail-type      ALL

##############################################
#    This create a C++ language file, load   #
#  the gcc module, compile the C++ language  #
#    file, and run the C++ language file.    #
##############################################

# Example c++ source code for a test program
echo -e "#include <iostream>
#include <vector>
#include <cmath>

int computePolynomial(int value, int constant, int exponent)
{
	return constant*pow(value,exponent);
}

int main()
{
	std::vector<int> polynomial({1,2,3,4,5,6});
	std::vector<int> results(6,0);
	int value=2;
	
	#pragma omp parallel for
	for(int i=0;i<6;i++)
		results[i]=computePolynomial(value,polynomial[i],i+1);
	
	int sum=0;
	#pragma omp parallel for reduction(+:sum)
	for(int i=0;i<6;i++)
		sum+=results[i];
	
	// should output \"642\" because:
	// 1*(2)+2*(2)^2+3*(2)^3+4*(2)^4+5*(2)^5+6*(2)^6=642
	std::cout << sum << std::endl;
	return 0;
}" > testOpenMP.cpp

# Compile the test program as a seperate task
srun g++ -fopenmp testOpenMP.cpp -o testOpenMP

# Set the number of threads for our OpenMP program
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Run the test program as a seperate task
srun ./testOpenMP
