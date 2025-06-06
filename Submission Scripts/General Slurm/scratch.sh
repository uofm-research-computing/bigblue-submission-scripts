#!/bin/bash
#SBATCH --cpus-per-task=[NCPUS]
#SBATCH --mem-per-cpu=[MEMORY_NEEDED_PER_CPU]
#SBATCH --partition=[PARTITION/QUEUE]
#SBATCH --time=[DAYS]-[HOURS]:[MINUTES]:[SECONDS]
#SBATCH --job-name=[JOBNAME]
#SBATCH --mail-user=[USERNAME]@memphis.edu
#SBATCH --output=[STDOUT].out
#SBATCH --error=[STDERR].err


export OMP_NUM_THREADS=$SLURM_NTASKS

# Go to submission directory.
cd $SLURM_SUBMIT_DIR
 
# Load some modules.
#module load [MODULE]

# What is my job ID?
echo "$SLURM_JOB_ID"


#################################################
# Get your data into scratch if needed          #
#################################################
SUCCESS="0"
export SCRATCH_DIR="/scratch/${USER}/${SLURM_JOB_ID}"
export INPUT_DIR="/project/${USER}/job/inputData"

# Ensure that two operations succeed using && to pipe successful status.
# "rsync" is better than "cp" for remote directories, but has a speed penalty for local directories.
mkdir -p "$SCRATCH_DIR" && cp -r "$INPUT_DIR" "$SCRATCH_DIR" && SUCESS="1"

# Exit if copy failed, which might happen if you mistype in SCRATCH_DIR or INPUT_DIR
if [ "$SUCCESS" == "0" ]; then echo "copy from \"$INPUT_DIR\" to \"$SCRATCH_DIR\" failed" 1>&2; exit -1; fi

# Also, if you fail to include $SCRATCH_DIR or mistype the variable, it won't overwrite some files.
# Keep quotes around the variable to ensure you capture space characters



#################################################
# Run your executable here                      #
#################################################
#[EXECUTABLE] [OPTIONS] ||



#################################################
# Get your data into project and clean-up       #
#################################################
SUCCESS="0"
export SCRATCH_OUTPUT_DIR="/scratch/${USER}/${SLURM_JOB_ID}/outputData"
export OUTPUT_DIR="/project/${USER}/job/outputData"

# "mv" command is an alternative to "cp", but might leave files scattered or incomplete.
# "rsync" is better than "cp" for remote directories, but has a speed penalty for local directories.
cp -r "$SCRATCH_OUTPUT_DIR" "$OUTPUT_DIR" && rm -rf "$SCRATCH_DIR" && SUCCESS="1"

# Exit if move failed
if [ "$SUCCESS" == "0" ]; then echo "move from \"$SCRATCH_OUTPUT_DIR\" to \"$OUTPUT_DIR\" failed" 1>&2; exit -1; fi
