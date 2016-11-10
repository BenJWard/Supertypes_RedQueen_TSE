# Computation of Jost D on Super-Type data, and bootstrapping simulations.

This repository houses work done as part of the project and publication:

**"Supertype evolution model unifies the Red Queen Hypothesis with trans-species
evolution"**

by

- Jackie Lighten
- Alexander S.T. Papadopulos
- Ben J. Ward
- Ian Paterson
- Lyndsey Baillie
- Ian R. Bradbury
- Andrew P. Hendry
- Paul Bentzen
- Cock van Oosterhout

This repository houses scripts used for the computation of a measure of
differentiation called JostD, on the sample data.
In addition, random bootstrap simulations were performed, with the aim of
randomizing supertype category allocations to sequenced alleles. To see if JostD
estimated from the actual data differed significantly from the distribution of
estimates of JostD computed for randomized simulations.

Much of the computation of JostD and the randomized simulations is handled by a
package used in these scripts called SuperTypeR, so as other users wanting to
use similar calculations in the future can include
[SuperTypeR](https://github.com/Ward9250/SuperTypeR) in their own scripts.

[SuperTypeR](https://github.com/Ward9250/SuperTypeR),
and the scripts in this Repo were written by co-author
Ben J. Ward (Github: Ward9250).


## Repository Details:

### Folders
* data - Raw data given to me at start of project or computational experiments.
* results - The result files of computational experiments.
* src - Source code of binary executable files used in this project and / or scripts.

### Execution environment(s)
1. R with the [SuperTypeR](https://github.com/Ward9250/SuperTypeR) package installed.

### Computational Experiments/Tasks.

1. _analysis_: Calculate JostD of the data, and do bootstrap simulations of JostD.


## More details:

### Data Files:

**File:** *SuperType_Designations.csv*

This contains the original supertype designation for each allele.
The first column is the supertype, the second is genotype, and the third is the
sequence of the genotype.


**File:** *Samples.csv*

This contains the genotypes per individual per population and the corresponding
STs. Each row is one sample.

Columns are (left to right):

1. Sample ID
2. Population
3. Drainage
4-12. Alleles in sample  
14-22. Supertypes corresponding to alleles in columns 4-12.
24. Number of alleles in sample.
25. Number of supertypes in sample.


### Analysis

The script in `src/DataAnalysis.R` scripts the the analysis for this project.
It pre-processes the input data file `data/Samples.csv`, before using the
[SuperTypeR](https://github.com/Ward9250/SuperTypeR) package to compute JostD
on the data in Samples.csv, before doing bootstrap simulations to estimate the
mean and standard error of the JostD estimates.

### Supertype counting and computation of JostD

Supertype counting, computation of of JostD and Pairwise JostD is done by the
[SuperTypeR](https://github.com/Ward9250/SuperTypeR) package.

#### Random Bootstrap Simulations

##### Aim
The aim is to randomly assign the alleles to the supertypes in file
*SuperType_Designations.csv*, generating a set of artificial supertypes composed
of a random set of alleles. The analysis can then be re-run on these null
datasets to assess whether the results from the actual data are significantly
different.

##### Simulation Steps

**FOR EACH IN N ITERATIONS:**

1. Wipe ST designations across all samples in data from *Samples.csv*.

2. For the data in *SuperType_Designations.csv*, randomly reallocate the alleles
in the total gene pool (~539) to the supertypes (the supertypes still get the
same number of alleles allocated to them). Allocation is done without
replacement.

3. For each population in *Samples.csv*, count the number of each supertype
present in the population. This results in a matrix of supertype counts per
population, where each row is a supertype, and each column is a population.

4. Calculate the pairwise Jost D for the matrix output from step 3.
Also calculate the average of each column i.e. the mean Jost D for each
population relative to all others.
