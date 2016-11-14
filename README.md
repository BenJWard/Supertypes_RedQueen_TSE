# Supertype evolution model unifies the Red Queen hypothesis with trans-species evolution

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

Two parts of the project are included in this repository:

**1). Computation of Jost D on Super-Type data, and bootstrapping simulations.**

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

**2). Simulations of immune gene evolution in a host-parasite system.**

The code provided in the src folder is for a Minitab 12.1 macro to study
the evolution of immune genes in a host-parasite system, examining whether
trans-species polymorphisms of STs can evolve in a Red Queen's arms race.

In particular, it analyses the adaptive evolutionary change in epitope
recognition of immune alleles and STs (i.e. their paratope) during host
parasite co-evolution using an agent-based model.

The Minitab 12.1 macro is for the most basic model that (1) would result in
antagonistic host-parasite co-evolution, and (2) in which we could quantify the
resulting adaptive evolutionary change in phenotype over time.

Hence, rather than using a strict population genetic model, it models the
paratope of immune alleles and the epitope of parasites in a 2-D grid with
size 1000 x 1000.

The fitness effect of immune alleles was determined by the position of immune
alleles and parasites in the epitope/paratope space.
The adaptive evolutionary change in phenotype of alleles and STs was quantified
by tracking changes in their position within this space over time.
Analysing the phenotypic change enabled us to study trans species evolution.
Furthermore, by analysing fluctuations in immune allele frequencies, we were
able to study the population genetic characteristics of the model.  

Hosts were diploid with one immune locus. Parasites were haploid. Each host was
infected by one parasite every generation. The minimum Euclidean distance was
calculated between an individual’s immune alleles and one randomly drawn
parasite representing the infection. Depending on this distance, the parasite
was either recognized (in a resistant host) or not (in a susceptible host).
Fitness was relative so that 50% of all parasites died (on resistant hosts).
The other 50% of parasites (on susceptible hosts) reproduced clonally one
individual offspring. Parasite offspring mutated, causing them to change their
X or Y coordinates by one unit within the grid.
Parasite infection on the susceptible hosts reduced host fitness by 0.25, and
host with zero fitness died. Resistant host gained 0.25 fitness units, and
individuals with one fitness units reproduced offspring that all started with
0.25 fitness units.

Reproduction of hosts was sexual, and hosts produced gametes, each containing
one parental immune allele. This immune allele could mutate with probability µ,
which caused it to change its X or Y coordinates by one unit within the grid.
Note that by simulating a high mutation rate, we effectively accelerated
evolutionary time in the model.

For example, simulations with µ= 0.1 equate to 3.1 x 106 generations in real
time, assuming a base mutation rate of 10-9 per base per generation, and 16
PBR codons with a total of 32 replacement sites (i.e. the 1st and 2nd codon
positions of the PBR).  Gametes of reproducing hosts united randomly with one
another to produce the next generation of diploid offspring. This resulted in a
Poisson distribution of offspring per parent (mean=variance=unity).
Output is displayed in the Minitab 12.1 Data Window.

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
