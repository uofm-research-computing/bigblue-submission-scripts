#!/bin/bash
#SBATCH --ntasks-per-node=[NTASKS]
#SBATCH --nodes=[NNODES]
#SBATCH --partition=[PARTITION/QUEUE]
#SBATCH --time=[DAYS]-[HOURS]:[MINUTES]:[SECONDS]
#SBATCH --account=[DEPTCODE]
#SBATCH --job-name=[JOBNAME]
#SBATCH --mail-user=%{USER}@memphis.edu
#SBATCH --output=[STDOUT]-%j.out
#SBATCH --error=[STDERR]-%j.err
#SBATCH --mem-per-cpu=[MEMORY_NEEDED_PER_CPU]

# --partition=[PARTITION_NAME]
# Example: "acomputeq"
# Run sinfo -o "%P %D %m %c %G %l" to see all partitions
# Specifies the partition or queue where the job will be run.

# Go to submission directory
cd $SLURM_SUBMIT_DIR

#################################################
# modules                                       #
#-----------------------------------------------#
# Any modules you need can be found with        #
# 'module avail'. If you compile something with #
# a particular compiler using a module, you     #
# probably want to call that module here.       #
# You probably want to load the openmpi module. #
#################################################
module load openmpi/4.1.5rc2/hpcx

# What is my job ID? 
echo "$SLURM_JOB_ID"

#################################################
# Run your executable here                      #
#-----------------------------------------------#
# Note that in some documentation of mpirun, it #
# may tell you to use '-n' for number of        #
# processors. Default is [NTASKS]*[NNODES].     #
# Furthermore, some documentation might tell you#
# to use mpiexec. In most cases, this isn't     #
# needed, but if you need to manually set up the#
# mpi launcher, you might try that before       #
# execution.                                    #
# You might be interested in these environment  #
# variables:                                    #
#  SLURM_JOB_NODELIST                           #
#   The list of nodes used for an MPI job. This #
#   is a file name.                             #
#  SLURM_NNODES                                 #
#   Number of nodes used in an MPI job.         #
#  SLURM_NTASKS_PER_NODE                        #
#   Number of threads per node.                 #
#  SLURM_NTASKS                                 #
#   Number of tasks on all nodes in job.        #
#################################################
mpirun [EXECUTABLE] [OPTIONS]
