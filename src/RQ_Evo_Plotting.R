library(ggplot2)
library(dplyr)

# Read in data. Data was prepared by the RQ_Evo_Plotting.jl julia script.
dat <- read.csv("results/plotting/StackedDataFrame.csv", header = TRUE)

# Here I do some reording of the levels of the Allele factor in the dataframe.
# Because by default they are ordered lexicographically, and not by number.
# I then also convert it to numbers and then back to a factor to remove the
# "Allele_" part so it's just numbers that appear in the plot.
flevels <- c("Allele_1", "Allele_2", "Allele_3", "Allele_4", "Allele_5",
"Allele_6", "Allele_7", "Allele_8", "Allele_9", "Allele_10", "Allele_11",
"Allele_12", "Allele_13", "Allele_14", "Allele_15")
dat$Allele <- as.factor(as.numeric(factor(dat$Allele, levels = flevels)))

# Hexes I came up with.
newColours <- c("#0033FF", "#FF3300", "#00FF33", "#CC33CC", "#0099CC",
                "#CC6633", "#FF0000", "#66FF00", "#3300CC", "#FFFF66",
                "#CCCC33", "#000066", "#CCCCCC", "#FF0099", "#000000")

# Hexes provided by jackie.
jackieColours <- c("#B0171F", "#FFA54F", "#CDC5BF", "#9932CC", "#00F5FF",
                   "#00FF00", "#FF34B3", "#FF4500", "#919191", "#1E90FF",
                   "#228B22", "#FF0000", "#FFFF00", "#FF82AB", "#030303")

# Make plot's of full data
myplot <- ggplot(dat, aes(x = Generation, fill = Allele))
countPlot <- myplot + geom_bar(aes(y = Count), stat="identity")
path <- "results/plotting/Full_Range/Counts/"
ggsave(paste0(path, "Plot1.png"), plot = countPlot, width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")

path <- "results/plotting/Full_Range/Percent/"
perPlot <- myplot + geom_bar(aes(y = Percentage), stat="identity")
ggsave(paste0(path, "Plot1.png"), plot = perPlot, width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
perPlot + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
perPlot + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")

# Make plot's of first 100 generations
path <- "results/plotting/100_Generations/Counts/"
subdat <- dat %>% filter(Generation <= 100)
myplot2 <- ggplot(subdat, aes(x = Generation, fill = Allele))
countPlot2 <- myplot2 + geom_bar(aes(y = Count), stat="identity")
ggsave(paste0(path, "Plot1.png"), plot = countPlot2, width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot2 + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot2 + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")

path <- "results/plotting/100_Generations/Percent/"
perPlot2 <- myplot2 + geom_bar(aes(y = Percentage), stat="identity")
ggsave(paste0(path, "Plot1.png"), plot = perPlot2, width = 14, height = 7, units = "in")
perPlot2 + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
perPlot2 + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")

# Make plot's of first 150 generations
path <- "results/plotting/150_Generations/Counts/"
subdat <- dat %>% filter(Generation <= 150)
myplot2 <- ggplot(subdat, aes(x = Generation, fill = Allele))
countPlot2 <- myplot2 + geom_bar(aes(y = Count), stat="identity")
ggsave(paste0(path, "Plot1.png"), plot = countPlot2, width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot2 + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
countPlot2 + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")

path <- "results/plotting/150_Generations/Percent/"
perPlot2 <- myplot2 + geom_bar(aes(y = Percentage), stat="identity")
ggsave(paste0(path, "Plot1.png"), plot = perPlot2, width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
perPlot2 + scale_fill_manual(values = newColours)
ggsave(paste0(path, "Plot2.png"), width = 14, height = 7, units = "in")
# Here the scale_fill_manual commands are where we apply the colour scheme
# defined by the hexes.
perPlot2 + scale_fill_manual(values = jackieColours)
ggsave(paste0(path, "Plot3.png"), width = 14, height = 7, units = "in")
