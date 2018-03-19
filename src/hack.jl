# Import Julia packages
using DataFrames
using Combinatorics.combinations

# Import local Julia files
# with functions that we
# want to use
include("types.jl")
include("readData.jl")
include("readwrite.jl")
include("auxiliary.jl")
include("optimization.jl")
include("compareNetworks.jl")

# Turn off debugging globally
DEBUG  = false
DEBUGC = false

treeCF = readTrees2CF("/Users/paulblischak/Dropbox/QCF/sims/compare/all-trees.tre")
