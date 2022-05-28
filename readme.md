# CTL Model Checking of Markov Decision Processes over the Distribution Space

This repo also published at [github](https://github.com/anducnguyen/mdp_CTL_BR/tree/main) contains artifacts for the paper CTL Model Checking of Markov Decision Processes] over the Distribution Space
There are four folders:

1. tbxmanager
2. 3statesMDP-Csestudy1
3. UAV-Casestudy2
4. Data_Casestudy2
## Systems Information

Macbook Pro 13" 2021 Apple M1 chip,

8-core CPU with 4 performance cores and 4 efficiency cores,

8-core GPU,

16-core Neural Engine,

16 GB RAM

## Installation

Before running each 'main.m' in each folder, the follwing toolboxes are required:

1. [yalmip](https://yalmip.github.io/tutorial/installation/)
2. [sedumi](https://sedumi.ie.lehigh.edu/?page_id=58)
3. [Matlab Reinforement Learning Toolbox](https://www.mathworks.com/products/reinforcement-learning.html)

Note that *yalmip* and *sedumi* is contained in [tbxmanager]so you can just addpath in Matlab. 

<!-- For *mosek* you will need license file 'mosek.lic', a free version can be obtained with studentship. -->

## Usage

After installing the toolboxes, you can directly run 
1. run main.m in the 3statesMDP-Casestudy1 folder to reproduce the results of Example 2 in the paper, which are shown in Figs. 4–5;
2. run uav determin synthesis plot.m in the UAV-Casestudy2 folder to re- produce Fig. 6; run uav noisy synthesis plot.m in the UAV-Casestudy2 folder to reproduce Fig. 7.
The result is reported in the [Data_Casestudy2] File
## License
This allows the QEST 2022 Artifact Evaluation Committee to evaluate the artifact w.r.t. the required [criteria](https://www.qest.org/qest2022/artifacts.html#artifact-guidelines).
