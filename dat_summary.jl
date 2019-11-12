module DataSummary
export data_summary

using DataFrames, Statistics

"""
    data_summary(data, depvars, groupvars)

A simple data summary module. It returns the mean, standard deviation,
and standard error of the mean for any number of dependent and
independent variables.

# Arguments
- `data` = `DataFrame`
- `depvars` = `Array{::Symbol}`
- `groupvars` = `Array{::Symbol}`

# Example
Example: Get average miles per gallon in city and highway by Manufacturer,
Year, and Class.

```data_summary test
julia> using RDatasets
julia> include("./dat_summary.jl")
julia> mpg = dataset("ggplot2","mpg")
julia> summary = DataSummary.data_summary(mpg, [:Cty,:Hwy],
                        [:Manufacturer,:Year,:Class])
```
"""
function data_summary(data, depvars::Array, groupvars::Array)
    outputdf = []
    tempdf = []
    for i = 1:length(depvars)
        if i == 1
            outputdf = by(data, groupvars, df -> length(df[:,depvars[1]]))
            rename!(outputdf, :x1 => :N)
            outputdf[!,:Mean] = by(data, groupvars, df -> mean(df[:,depvars[1]]))[!,:x1]
            outputdf[!,:SD] = by(data, groupvars, df -> std(df[:,depvars[1]]))[!,:x1]
            outputdf[!,:SEM] = outputdf.SD ./ sqrt.(outputdf.N)
            outputdf[!,:Variable] = repeat([String(depvars[1])],length(outputdf.N))
        else
            tempdf = by(data, groupvars, df -> length(df[:,depvars[i]]))
            rename!(tempdf, :x1 => :N)
            tempdf[!,:Mean] = by(data, groupvars, df -> mean(df[:,depvars[i]]))[!,:x1]
            tempdf[!,:SD] = by(data, groupvars, df -> std(df[:,depvars[i]]))[!,:x1]
            tempdf[!,:SEM] = tempdf.SD ./ sqrt.(tempdf.N)
            tempdf[!,:Variable] = repeat([String(depvars[i])],length(tempdf.N))
            outputdf = join(outputdf, tempdf, kind = :outer,
                        on = intersect(names(outputdf), names(tempdf)))
        end
    end
    return outputdf
end
end
