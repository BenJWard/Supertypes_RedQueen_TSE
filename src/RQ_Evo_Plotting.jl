#!/usr/bin/env julia

using DataFrames, Plots, StatPlots

dat = readtable("data/ST_RQ_Dynamics.csv")

dat[:,1] = map((x) -> parse(Int, match(r"(\d+)$", x).match), dat[:,1])
rename!(dat, :x, :Generation)

dat = stack(dat, 2:16)
rename!(dat, :value, :Count)
rename!(dat, :variable, :Allele)

dat = by(dat, :Generation) do df
    div = 1 / sum(df[:Count])
    DataFrame(Allele = df[:Allele],
              Count = df[:Count],
              Percentage = ((df[:Count] .* div) .* 100))
end

writetable("results/plotting/StackedDataFrame.csv", dat)

groupedbar(dat, x = :Generation, y = :Percentage, bar_position = :stack)
