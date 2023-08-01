**********************************************

This folder contains scripts to run the study described in the paper 
"Acetylcholine and noradrenaline enhance foraging optimality in humans" by Sidorenko et al.

The scripts allows to create the datasets for both Foraging and Time Perception tasks and run those tasks.

Moreover, we aimed to automatize the experiment as much as possible in order to minimize the intervention of the experimenter.
Thus, the folder contains multiple scripts needed to ensure the fluidity of the experiment
(e.g., scripts to announce the start of the task, display a reminder, or play the instructions about how to chew the gum).

**********************************************

The script generalWrapper.m allows to create task-by-task datasets for each participant 

The main script used to run the ON-drug session of the experiment is BEH_wrapperTrainingAndTasks.m

Each task has a wrapper script that sets up the information about the folders and record the responses

Each task also has the main script that runs the task and record intermediate responses (to have at least partial answers, in case there is a technical
issue in the middle of the task).

Besides the main script, each task has also auxiliary scripts that contains the code for functions (e.g., to display the milk level raising in the bucket). 

**********************************************

For any questions, please reach out to Nick Sidorenko at nick.sidorenko@econ.uzh.ch












 