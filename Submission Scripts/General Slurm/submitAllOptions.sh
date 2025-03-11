#!/bin/bash
# Required Flags
#SBATCH --job-name=[JOB_NAME]
#SBATCH --output=[OUTPUT_FILENAME]
#SBATCH --error=[ERROR_FILENAME]
#SBATCH --partition=[PARTITION_NAME]
#SBATCH --time=[MAX_RUN_TIME]
#SBATCH --mem=[MEMORY_NEEDED_FOR_JOB]
#SBATCH --nodes=[NUMBER_OF_NODES]

# Optional Flags
#SBATCH --ntasks=[NUMBER_OF_TASKS]
#SBATCH --ntasks-per-node=[TASKS_PER_NODE]
#SBATCH --cpus-per-task=[CPUS_PER_TASK]
#SBATCH --gres=[SPECIFIC_RESOURCES]
#SBATCH --mem-per-cpu=[MEMORY_PER_CPU]
#SBATCH --mail-type=[MAIL_NOTIFICATION_TYPE]
#SBATCH --mail-user=[USER_EMAIL]
#SBATCH --nodelist=[NODELIST]
#SBATCH --dependency=[JOB_DEPENDENCY]
#SBATCH --array=[JOB_ARRAY_RANGE]

# ---------------- Explanation of SBATCH Flags ----------------

# --job-name=[JOB_NAME]
# Example: "my_simulation_job"
# Sets the name of the job, which is useful for identifying it in the job queue.

# --output=[OUTPUT_FILENAME]
# Example: "output_%j.log" (where %j is replaced by the job ID)
# Specifies the file where the standard output of the job will be written.

# --error=[ERROR_FILENAME]
# Example: "error_%j.log" (where %j is replaced by the job ID)
# Specifies the file where the standard error of the job will be written.

# --partition=[PARTITION_NAME]
# Example: "acomputeq"
# Run sinfo -o "%P %D %m %c %G %l" to see all partitions
# Specifies the partition or queue where the job will be run.

# --time=[MAX_RUN_TIME]
# Example: "1-12:00:00" (for one day and 12 hours)
# Sets the maximum wall time the job is allowed to run, in the format `DD-HH:MM:SS`.

# --mem=[MEMORY_NEEDED_FOR_JOB]
# Example: "16G" (for 16 GB)
# Requests the total amount of memory per node.

# --nodes=[NUMBER_OF_NODES]
# Example: "2" (for 2 nodes)
# Specifies the number of nodes to be allocated for the job.

# --ntasks=[NUMBER_OF_TASKS]
# Example: "16" (for 16 tasks)
# Sets the total number of tasks for the job, usually corresponding to the number of cores.
# For normal multithreaded jobs, 'ulimit -T' will limit the number of threads you can run at once. 
ulimit -T $SLURM_NTASKS
# For openMP jobs, OMP_NUM_THREADS will limit the number of threads your openMP job will need.
export OMP_NUM_THREADS=$SLURM_NTASKS

# --ntasks-per-node=[TASKS_PER_NODE]
# Example: "8" (for 8 tasks per node)
# Specifies the number of tasks to be allocated per node. This can be useful for distributing tasks across multiple nodes.

# --cpus-per-task=[CPUS_PER_TASK]
# Example: "4" (for 4 CPU cores per task)
# Specifies the number of CPU cores allocated per task.

# --gres=[SPECIFIC_RESOURCES]
# Example: "gpu:2" (for 2 GPUs)
# Requests specific resources, such as GPUs.

# --mem-per-cpu=[MEMORY_PER_CPU]
# Example: "4G" (for 4 GB per CPU)
# Specifies the amount of memory required per CPU. Useful when allocating memory based on the number of CPUs.

# --mail-type=[MAIL_NOTIFICATION_TYPE]
# Example: "END,FAIL" (to get notifications when the job ends or fails)
# Specifies when to send email notifications (e.g., `BEGIN`, `END`, `FAIL`, `ALL`).

# --mail-user=[USER_EMAIL]
# Example: "user@example.com"
# Specifies the email address to which notifications will be sent.

# --nodelist=[NODELIST]
# Example: "node01,node02"
# Allows you to request specific nodes by name.

# --dependency=[JOB_DEPENDENCY]
# Example: "afterok:12345" (to start after job 12345 completes successfully)
# Sets a job dependency, so the job will only start after a specified job ID has completed.

# --array=[JOB_ARRAY_RANGE]
# Example: "0-9" (for an array of 10 jobs with indices 0 through 9)
# Example: "0-20%2" (for an array starting at 0 and starting a task every 2nd number)
# Submits an array of jobs, specifying the range of indices.

# ---------------- End of SBATCH Flag Explanations ----------------

# Set the temporary directory
tmpdir="/scratch/${USER}/${SLURM_JOB_ID}"

# Make the temporary directory
mkdir -p $tmpdir

# Copy job directory to temporary directory
rsync -a ./

# Change to temporary directory
cd $tmpdir

# Load necessary modules
module load [MODULES_NEEDED_FOR_JOB]  # Example: "python/3.9.18/gcc.8.5.0" or "cuda/12.3" for GPU usage

# Run your application or script
[COMMAND_TO_RUN_JOB]  # Example: "python my_script.py"