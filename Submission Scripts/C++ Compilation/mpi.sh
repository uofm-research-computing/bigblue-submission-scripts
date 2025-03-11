#!/bin/bash
#SBATCH --ntasks        6
#SBATCH --time          00:01:00
#SBATCH --mem-per-cpu   400M
#SBATCH --partition     acomputeq
#SBATCH --job-name      mpi
#SBATCH --output        mpi-%J.out
#SBATCH --error         mpi-%J.err
#SBATCH --mail-user      %{USER}@memphis.edu
#SBATCH --mail-type     ALL

##############################################
#    This create a C++ language file, load   #
#  the gcc module, compile the C++ language  #
#    file, and run the C++ language file.    #
##############################################

module load openmpi/4.1.5rc2/hpcx

# Example c++ source code for a test program
echo -e "#include <iostream>
#include <vector>
#include <cmath>
#include <mpi.h>

int computePolynomial(int value, int constant, int exponent)
{
	return constant*pow(value,exponent);
}

int main(int argc, char **argv)
{
	MPI_Init(&argc, &argv);
	int rank;
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	
	int value;
	std::vector<int> polynomial(6,0);
	if(rank==0)
	{
		value=2;
		polynomial={1,2,3,4,5,6};
	}
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Bcast(&polynomial[0],6,MPI_INT,0,MPI_COMM_WORLD);
	
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Bcast(&value,1,MPI_INT,0,MPI_COMM_WORLD);
	
	MPI_Barrier(MPI_COMM_WORLD);
	
	int result=0;
	result=computePolynomial(value,polynomial[rank],rank+1);
	
	int sum=0;
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Reduce(&result,&sum,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	MPI_Barrier(MPI_COMM_WORLD);
	
	// should output \"642\" if ntasks=6 because:
	// 1*(2)+2*(2)^2+3*(2)^3+4*(2)^4+5*(2)^5+6*(2)^6=642
	if(rank==0)
		std::cout << sum << std::endl;
	
	MPI_Finalize();
	return 0;
}" > testMPI.cpp

# Compile the test program
mpiCC testMPI.cpp -o testMPI

# Run the test program as 6 seperate tasks
mpirun ./testMPI
