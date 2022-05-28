# CTL Model Checking of Markov Decision Processes over the Distribution Space

This repo also published at [github](https://github.com/anducnguyen/mdp_CTL_BR/tree/main) contains artifacts for the paper CTL Model Checking of Markov Decision Processes] over the Distribution Space
There are three folders:

1. Toolbox
1. 3statesMDP-Example1
2. UAV-Case Study

## Systems Information

Macbook Pro 13" 2021 Apple M1 chip,

8-core CPU with 4 performance cores and 4 efficiency cores,

8-core GPU,

16-core Neural Engine,

16 GB RAM

## Installation

Before running each 'main.m' in each folder, the follwing [toolbox](https://github.com/anducnguyen/mdp_CTL_BR/tree/main/toolbox) is required:

1. [yalmip](https://yalmip.github.io/tutorial/installation/)
2. [sedumi](https://sedumi.ie.lehigh.edu/?page_id=58)
3. [Matlab Reinforement Learning Toolbox](https://www.mathworks.com/products/reinforcement-learning.html)

Note that *yalmip* and *sedumi* is contained in [toolbox/tbxmanager](https://github.com/anducnguyen/mdp_CTL_BR/tree/main/toolbox/tbxmanager/toolboxes) so you can just dowload and addpath in Matlab. 

<!-- For *mosek* you will need license file 'mosek.lic', a free version can be obtained with studentship. -->

## Usage

After installing the toolboxes, you can directly run 
1. 'main.m' in [3stateMDP-Example1](https://github.com/anducnguyen/mdp_CTL_BR/tree/main/3statesMDP-Example%201) for the first example presented in the paper
2. 'uav_determin.m' and 'uav_noisy.m' in [UAV-CaseStudy](https://github.com/anducnguyen/mdp_CTL_BR/tree/main/UAV-Case%20Study) for the UAV Case Study deterministic scenario and noisy scenario.

The result is reported in the following [OneDrive](https://unioxfordnexus-my.sharepoint.com/:f:/r/personal/lina3904_ox_ac_uk/Documents/UAV%20Case%20Study%20Results?csf=1&web=1&e=H16KpD)


## License
This allows the QEST 2022 Artifact Evaluation Committee to evaluate the artifact w.r.t. the required [criteria](https://www.qest.org/qest2022/artifacts.html#artifact-guidelines).
