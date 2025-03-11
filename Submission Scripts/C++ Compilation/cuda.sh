#!/bin/bash
#SBATCH --cpus-per-task  1
#SBATCH --time           00:01:00
#SBATCH --mem-per-cpu    1G
#SBATCH --partition      agpuq
#SBATCH --gres           gpu:1
#SBATCH --job-name       cuda
#SBATCH --output         cuda-%J.out
#SBATCH --error          cuda-%J.err
#SBATCH --mail-user      %{USER}@memphis.edu
#SBATCH --mail-type      ALL

##############################################
#    This create a C++ language file, load   #
#  the gcc module, compile the C++ language  #
#    file, and run the C++ language file.    #
##############################################

module load cuda/12.3

# Example c++ CUDA source code for a test program
echo -e "#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>
#include <vector>

struct computePolynomial {
	const float value;
	computePolynomial(float v):value(v){}
	
	__device__
	float operator() (float &constant, float &exponent) const
	{
		return constant*pow(value,exponent);
	}
};

int main()
{
	thrust::host_vector<float> polynomial_h;
	for(float i=1;i<=6;i++) polynomial_h.push_back(i);
	thrust::device_vector<float> polynomial_d(polynomial_h);
	
	thrust::host_vector<float> exponent_h;
	for(float i=1;i<=6;i++) exponent_h.push_back(i);
	thrust::device_vector<float> exponent_d(exponent_h);
	
	thrust::device_vector<float> results_d(6,0);
	
	float value=2;
	
	thrust::transform(polynomial_d.begin(),polynomial_d.end(), exponent_d.begin(), results_d.begin(), computePolynomial(value));
	float sum=thrust::reduce(results_d.begin(),results_d.end());
	
	// should output \"642\" because:
	// 1*(2)+2*(2)^2+3*(2)^3+4*(2)^4+5*(2)^5+6*(2)^6=642
	std::cout << sum << std::endl;
	return 0;
}" > testCUDA.cu

# Compile the test program as a seperate task
nvcc testCUDA.cu -o testCUDA

# Run the test program as a seperate task
./testCUDA
