#!/bin/bash
#SBATCH --cpus-per-task  1
#SBATCH --time           7-00:00:00
#SBATCH --mem-per-cpu    1G
#SBATCH --partition      acomputeq
#SBATCH --job-name       advanced
#SBATCH --output         advanced-%J.out
#SBATCH --error          advanced-%J.err
#SBATCH --mail-user      %{USER}@memphis.edu
#SBATCH --mail-type      ALL

##############################################
#    This create a C++ language file, load   #
#  the gcc module, compile the C++ language  #
#    file, and run the C++ language file.    #
##############################################

# Example c++ source code for a test program
echo -e "#include <iostream>

int main()
{
	//This will output to stdout
	std::cout << \"Output!\" << std::endl;
	//This will output to stderr
	std::cerr << \"Error!\" << std::endl;
	return 0;
}" > testAdvanced.cpp

# Compile the test program as a seperate task
srun g++ testAdvanced.cpp -o testAdvanced

# Run the test program as a seperate task
srun ./testAdvanced
