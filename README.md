# BigBlue Submission Scripts 

This repository holds files/scripts commonly used on the HPC at the University of Memphis.

## Copying GitHub Files to BigBlue

We recommend that beginning users copy this full repository to their home directory for ease of access
```
git clone https://github.com/uofm-research-computing/bigblue-submission-scripts.git
```

If you want a specific file from this repo, you can right-click the "Raw" button, copy that link, and then do 
```
wget https://github.com/uofm-research-computing/bigblue-research-computing/raw/refs/heads/main/Submission%20Scripts/C++%20Compilation/mpi.sh
```
using the link you got when your right-clicked.


## Partitions/Queues
When submitting a job, you'll need to specify which partition your job should run in. Here are the possible queues available.
| Queue         | Number of Nodes | Memory per Node | CPU Cores per Node | Additional Notes               |
|---------------|-----------------|-----------------|--------------------|--------------------------------|
| *acomputeq*   | 16              | 768 GB          | 192                |                                |
| *awholeq*     | 8               | 768 GB          | 192                | Allocate cores in units of 192 |
| *abigmemq*    | 4               | 1.5 TB          | 192                |                                |
| *agpuq*       | 4               | 768 GB          | 192                | 2 A100 GPUs                    |
| *icomputeq*   | 40              | 192 GB          | 40                 |                                |
| *iwholeq*     | 38              | 192 GB          | 40                 | Allocate cores in units of 40  |
| *ibigmemq*    | 4               | 1.5 TB          | 40                 |                                |
| *igpuq*       | 6               | 192 GB          | 40                 | 2 V100 GPUs                    |

You can also run `sinfo -o "%P %D %m %c %G %l"` on the cluster to see similar information, though the memory is presented in MB there.

## Submission Script Guide

When you log in, you are placed on either of the login nodes (`log01`/`log02`), but running a script there takes up memory for every other user online. You must submit a script as a job to utilize the power of the cluster. 

There are two commands of submitting a job to the cluster: `sbatch` and `srun`. Below is a simple run-down of both commands. However, if we do not adequately describe what you are looking for, please visit the slurm documentaion on [sbatch](https://slurm.schedmd.com/sbatch.html).

You can watch the progress of your job using the `squeue -u $USER` command and replacing the $USER with your name. Alternatively, I like to use `squeue | grep $USER` command so my username returns bolded.

### sbatch

You can submit jobs using the sbatch command: `sbatch jobscript.sh`. However, it’s important to ensure that your submission script (`jobscript.sh`) follows the required format. Many issues arise when users overlook this critical step. Please visit this [sample script](https://github.com/uofm-research-computing/hpc/blob/60538f2cba2066fb2f2d1dc4fe04a39a5e9a9ed5/Submission%20Scripts/General%20Slurm/submitManual.sh) that walks through the format and the many flags.

### srun

You can run commands interactively through the `srun` command (which takes many of the same options as the `sbatch` command):

```
srun --cpus-per-task=1 --mem-per-cpu=500M --partition=acomputeq --job-name=test --time=00:02:00 --pty bash
```

will launch an interactive session on one of the acomputeq nodes once one is available where commands can be written. The `--pty` option indicates that the command is interactive. Run the `exit` (`Ctrl+D`) command to quit an interactive job.

## Directory Usage 

Our system provides three main directories for your storage needs:
- **/home/$USER**: Use this directory to store reusable scripts and small files. It has a storage limit of 50 GB. Please keep in mind that this space is intended for essential files that do not take up significant storage.
- **/project/$USER**: This is where you should keep all major files generated from your jobs that you need to retain. You have up to 1 TB of space available here. Store any important data and outputs that need to be preserved for future reference.
- **/scratch/$USER**: Set this directory as the location for temporary files during job execution. It provides 10 TB of space. Be sure to clean up and delete these temporary files after your job is completed. Move any crucial files to the **/project/$USER** directory. Note that files older than 60 days in this directory will be automatically deleted.

Ensure that you manage these directories appropriately to optimize your storage usage and maintain a clean working environment.

## Modules

Spack is a newer, faster, and more consistent software-install system used to install almost 8000 packages in an HPC environment. To see what spack packages are installed on bigblue:
1. Run `module load spack/0.21.0`
2. Run `module avail`

Many of the programs on the old cluster have been carried over as one of the spack modules. If you don't see a package you need, feel free to contact us about installing the package centrally. If you would prefer to install a package for yourself, use the instructions [here](https://spack.readthedocs.io/en/latest/getting_started.html). Installing yourself might be preferable—especially to begin with—as there might be a queue in front of your request to get something installed.

## Python

For python, we won't be installing packages centrally like the previous cluster. To install a python package:
1. Select a version of python, like one of the modules `python/3.10.3` or `python/3.12.1`
2. Run `pip3 install packageName --user` and for each package, you only have to run this one time.
3. Use the package like you would normally in your script. You will need to load the python module you used to install the package in your submission scripts or the terminal when you login.


## Hardware

During the Fall of 2023, we upgraded the cluster with more and newer compute resources. This upgrade is part of a new 4-year cycle, and it came online in late January 2024. The older Intel partition configuration consists of 88 compute nodes with 3520 total CPU cores (40 cores per node), 20736 GB total RAM, and 12 NVIDIA V100 GPUs. The new AMD partition configuration consists of 32 nodes with 6144 total CPU cores (192 cores per node), 27648 GB total RAM, and 8 A100 GPUs. Overall, the cluster has 120 compute nodes with 9152 cores, 48384 GB total RAM, and 20 GPUs.

### Intel Processors

- Intel Thin: 78 PowerEdge C6420 dual socket Intel Skylake Gold 6148 compute nodes with 192 GB DDR4 RAM and EDR Infiniband.
- NVIDIA GPU with Intel processors: 6 PowerEdge R740 dual socket Intel Skylake Gold 6148 GPU nodes with 192 GB DDR4 RAM, 2 x NVIDIA V100 GPU and EDR Infiniband - 5120 GPU cores/V100, 10240 GPU cores/GPU node
- Intel Fat: 2 PowerEdge R740 dual socket Intel Skylake Gold 6148 Fat Memory Nodes with 768 GB DDR4 RAM and EDR Infiniband
- Intel Large Fat: 2 PowerEdge R740 dual socket Intel Skylake Gold 6148 Nodes with 1.5 TB DDR4 RAM and EDR Infiniband

### AMD Processors (new)

- AMD Thin: 24 PowerEdge R7625 dual socket AMD Epyc Genoa 9654 compute nodes with 768 GB DDR5 RAM and HDR100 Infiniband.
- NVIDIA GPU with AMD processors: 4 PowerEdge R7625 dual socket AMD Epyc Genoa 9354 compute nodes with 768 GB DDR5 RAM, 2 x NVIDIA A100 GPU and HDR100 Infiniband.
- AMD Fat: 4 PowerEdge R7625 dual socket AMD Epyc Genoa 9654 compute nodes with 1.5 TB DDR5 RAM and HDR100 Infiniband.

### Storage

- Parallel File System: Arcastream PixStor (GPFS) with 60 x 7.68 TB HDD (460.8 TB total raw storage) providing up to 7.5 GB/sec read and 5.5 GB/sec write performance, and 8 x 15.3 TB SSD (122.9 TB total raw storage) providing up to 80 GB/s read and write speeds. Total storage is 583.7 TB.

| Fileset     | Description            |
|-------------|------------------------|
| *nvme1-scratch* | 250 TB scratch file system for active jobs requiring high-speed storage. Users initially have a 10 TB "soft" quota, and a 20 TB "hard" quota. |
| *sas1-home*   | 50 TB home file system for user software, modules, scripts, etc. Backed up once a week. Users initially have a 50 GB "soft" quota and a 60 GB "hard" quota. |
| *sas1-project* | 400 TB project file system for user data. Backed up once a week. Users initially have a 1 TB "soft" quota and a 2 TB "hard" quota. |

All compute nodes are connected via HDR100/EDR Infiniband (2:1 Blocking) and 1GbE for host/OOB management. Head and Login nodes are connected via HDR100 Infiniband and 10GbE for host/OOB management.
