# SuperType Analysis: Ben J. Ward, 2016.

# Required libraries
library(dplyr)
library(SuperTypeR)
library(ggplot2)
library(gdata)
library(tidyr)

# Begin Function definitions

transformSamplesData <- function(table){

  genoIdx <- paste("G", 1:9, sep = "")
  stIdx <- paste("S", 1:9, sep = "")

  do.call(rbind, apply(table, 1, function(x){

    # Get genotype information
    geno <- x[genoIdx]
    geno <- geno[which((geno != "") & (!is.na(geno)))]

    genCount <- length(geno)

    # Get supertype information
    st <- x[stIdx]
    st <- st[which((st != "") & (!is.na(st)))]

    if(genCount == length(st)){
      return(
        data.frame(Sample = rep(x["Sample"], genCount),
                   Site = rep(x["Site"], genCount),
                   Drainage = rep(x["Drainage"], genCount),
                   Genotype = geno,
                   Supertype = st,
                   AlleleNum = as.numeric(rep.int(x["Ai"], genCount)),
                   SuperTypeNum = as.numeric(rep.int(x["STi"], genCount))
        )
      )
    } else {
      errmsg <- paste0("The number of genotypes is ",
                       genCount,
                       ". \nHowever the number of supertypes assigned is ",
                       length(st), "!")
      stop(errmsg)
    }

  }))}

# End Function Definitons

# Begin Script

## Load in initial raw data
samples <- read.csv("data/Samples.csv", header = TRUE, stringsAsFactors = FALSE)
stDesignations <- read.csv("data/SuperType_Designations.csv")

## Transform sample data for SuperTypeR functions.
transformedSamples <- transformSamplesData(samples)
write.csv(transformedSamples,
    file = "results/simulate/TransformedSamples.csv",
    row.names = FALSE)
rm(samples)


### ST Counting and Jost calculations for entire populations.

# Count Supertypes in each community and calculate JOST D. Output results to two files.
# countSuperTypesPerPop is provided by my little SuperTypeR package.
countTable <- countSuperTypesPerPop(transformedSamples)
write.csv(countTable,
    file = "results/simulate/SuperType_Counts_Per_Population.csv")


# pairwiseD22 uses the counts generated by countSuperTypesPerPop. This is also
# provided by SuperTypeR.
pairwise_jost <- pairwiseD22(countTable, boot = 1000)
write.csv(pairwise_jost[[1]], file = "results/simulate/Population_Pairwise_JostD_Means.csv")
write.csv(pairwise_jost[[2]], file = "results/simulate/Population_Pairwise_JostD_SD.csv")


obsSummary <- data.frame(colMeans(pairwise_jost[[1]]))
obsSummary$location <- rownames(obsSummary)
colnames(obsSummary) <- c("jostd", "location")
write.csv(obsSummary, file = "results/simulate/Population_Pairwise_JostD_colMeans.csv")



# Simulations to compute null jost.

simulationOutput <-
  as.data.frame(
    do.call(rbind,
            nullSimulations(transformedSamples,
                            stDesignations,
                            iter = 1000)))
simulationOutput$iter <- 1:nrow(simulationOutput)
longSimulationOutput <- gather_(as.data.frame(simulationOutput),
                                "location",
                                "jostd",
                                colnames(simulationOutput)[1:(ncol(simulationOutput) - 1)])

write.csv(longSimulationOutput,
    file = "results/simulate/Full_Simulation_Output.csv")

simSummary <- longSimulationOutput %>%
  group_by(location) %>%
  summarise(mean = mean(jostd),
            median = median(jostd),
            sd = sd(jostd))
write.csv(simSummary, file = "results/simulate/Summary_Simulation_Output.csv")

combinedSummary <- inner_join(simSummary, obsSummary, by = "location")

namesFileOrder <- colnames(pairwise_jost[[1]])

combinedSummary$location <- as.factor(combinedSummary$location)
combinedSummary$location <- reorder.factor(combinedSummary$location, new.order = namesFileOrder)

colnames(combinedSummary) <- c("Location", "Simulation_Mean", "Simulation_Median", "Simulation_SD", "observed")

limits <- aes(ymax = combinedSummary$Simulation_Mean + combinedSummary$Simulation_SD,
              ymin = combinedSummary$Simulation_Mean - combinedSummary$Simulation_SD)

write.csv(combinedSummary, file = "results/simulate/Plotting_Table.csv")

summaryPlot <- ggplot(combinedSummary,
                      aes(x = Location, y = Simulation_Mean)) +
  geom_point(color="blue") +
  geom_errorbar(limits) +
  geom_point(mapping = aes(y = observed), color="red") +
  labs(x = "Population", y = expression(paste("Mean supertype population differentiation", (D[est])))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave("results/simulate/SummaryPlot.png", plot = summaryPlot, width = 30, height = 20, units="cm")
