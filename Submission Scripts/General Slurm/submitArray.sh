#!/bin/bash
#SBATCH --ntasks=[NTASKS]
#SBATCH --partition=[PARTITION/QUEUE]
#SBATCH --time=[DAYS]-[HOURS]:[MINUTES]:[SECONDS]
#SBATCH --account=[DEPTCODE]
#SBATCH --job-name=[JOBNAME]
#SBATCH --mail-user=%{USER}@memphis.edu
#SBATCH --mail-type=[MAILTYPE]
#SBATCH --output=[OUTPUTFILE]
#SBATCH --error=[ERRORFILE]
#SBATCH --array=[SLURM_ARRAY_TASK_ID values]

# --partition=[PARTITION_NAME]
# Example: "acomputeq"
# Run sinfo -o "%P %D %m %c %G %l" to see all partitions
# Specifies the partition or queue where the job will be run.

################################################
# SLURM_ARRAY_TASK_ID and --array              #
#----------------------------------------------#
# An environment variable that labels the      #
# array's task. Formats for --array:           #
#  Range (from a, a+1, a+2, ..., b):           #
#     a-b                                      #
#  Range, every Nth task:                      #
#     a-b%N                                    #
#  Single value:                               #
#     a                                        #
#  3 above, all together in one submission:    #
#     a,c-d,e-f%N                              #
################################################
echo "$SLURM_ARRAY_TASK_ID"

#These job id's should be the same:
echo "$SLURM_JOB_ID"
echo "$SLURM_ARRAY_JOB_ID"

# This outputs the list of nodes associated with 
# this array id:
cat $SLURM_JOB_NODELIST

# First SLURM_ARRAY_TASK_ID
echo "$SLURM_ARRAY_TASK_MIN" 

# Last SLURM_ARRAY_TASK_ID
echo "$SLURM_ARRAY_TASK_MAX" 

#################################################
# Examples:                                     #
#################################################

##########################################################################
# This for;do statement is for testing our array indexing                #
# outside of a job submission. Here we are renaming some                 #
# files:                                                                 #
#  i.e. I have a set of $N+1 files, labeled FILE_$I:                     #
#       FILE_0, FILE_1, FILE_2, ..., FILE_$N                             #
#                                                                        #
#  I want a new set of files, labeled FILE_$I_$SLURM_ARRAY_TASK_ID:      #
#       FILE_0_0, FILE_0_1, FILE_0_2,..., FILE_$N_$SLURM_ARRAY_TASK_ID   #
#       FILE_1_0, FILE_1_1, FILE_1_2,..., FILE_$N_$SLURM_ARRAY_TASK_ID   #
#       FILE_2_0, FILE_2_1, FILE_2_2,..., FILE_$N_$SLURM_ARRAY_TASK_ID   #
#       ................................                                 #
#       FILE_$N_0, FILE_$N_1, FILE_$N_2,... FILE_$N_$SLURM_ARRAY_TASK_ID #
#                                                                        #
# After testing, you could just comment out the for, do, and done lines  #
# and submit it                                                          #
##########################################################################
N=5
for SLURM_ARRAY_TASK_ID in {0..70}
do 
    echo "$SLURM_ARRAY_TASK_ID"
    I=`echo "${SLURM_ARRAY_TASK_ID}%$N" | bc`
    name="FILE_${I}"
    newName="${name}_${SLURM_ARRAY_TASK_ID}"
    echo "$name => $newName"
done
cp ${name} ${newName}

# Using R, taking two files with
# SLURM_ARRAY_TASK_ID as part of the name. e.g. file_0.data, file_1.data, ...
module load R/4.3.2/gcc.8.5.0
Rscript --vanilla myScript.R file_${SLURM_ARRAY_TASK_ID}.data file_${SLURM_ARRAY_TASK_ID}.out

# Using Python (assuming 'module load python/3.7.0'), taking two files with
# SLURM_ARRAY_TASK_ID as part of the name. e.g. file_0.data, file_1.data, ...
python3 myScript.py file_${SLURM_ARRAY_TASK_ID}.data file_${SLURM_ARRAY_TASK_ID}.out

# Using MATLAB, taking two files with (no module, just export PATH)
# SLURM_ARRAY_TASK_ID as part of the name. e.g. file_0.data, file_1.data, ...
export PATH=$PATH:/public/apps/matlab/R2018a/bin
matlab -nodisplay -nojvm -nosplash -r "myFunction(\"file_${SLURM_ARRAY_TASK_ID}.data\", \"file_${SLURM_ARRAY_TASK_ID}.out\");quit";

# You could also just pass SLURM_ARRAY_TASK_ID as a value for some argument alone
python3 myScript.py ${SLURM_ARRAY_TASK_ID}
Rscript --vanilla myScript.R ${SLURM_ARRAY_TASK_ID}
matlab -nodisplay -nojvm -nosplash -r "myFunction(${SLURM_ARRAY_TASK_ID});quit";