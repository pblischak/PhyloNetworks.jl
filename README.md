# PhyloNetworks: analysis for phylogenetic networks

[![Build Status](https://travis-ci.org/crsl4/PhyloNetworks.jl.svg)](https://travis-ci.org/crsl4/PhyloNetworks.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://crsl4.github.io/PhyloNetworks.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://crsl4.github.io/PhyloNetworks.jl/latest)
[![codecov](https://codecov.io/gh/crsl4/PhyloNetworks.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/crsl4/PhyloNetworks.jl)
<!--
[![Coverage Status](https://coveralls.io/repos/crsl4/PhyloNetworks/badge.svg?branch=master&service=github)](https://coveralls.io/github/crsl4/PhyloNetworks?branch=master)
-->

  > **This is a fork of the original PhyloNetworks.jl package. It is a hacky
  > version that is trying to remove the plotting dependencies Rcall and Gadfly
  > so that I can use the package on a cluster.**

The solution to the install issue was to individually `include()` each of
the local modules and the necessary Julia Packages (`DataFrames` and
`Combinatorics.combinations`). I then made another Julia script in the
`src/` folder called `hack.jl` that has all of the functionality I
want/need. All I'm doing is comparing estimates of quartet concordance
factors, so the only function I really need is `readTree2CF()`. The
`hack.jl` has all of the necessary imports and includes to do this without
actually installing or loading the rest of the PhyloNetworks package.

I've also realized that the `functions.jl` script does not rely on the plotting
functions and can be included to use all the other methods. It appears Issue #16
is also associated with the problems I've been having.

## Overview

PhyloNetworks is a [Julia](http://julialang.org) package with utilities to:
- read / write phylogenetic trees and networks,
  in (extended) Newick format.
  Networks are considered explicit: nodes represent ancestral species.
  They can be rooted or unrooted.
- plot networks (and trees)
- manipulate networks: re-root, prune taxa, remove hybrid edges,
  extract the major tree from a network, extract displayed networks / trees
- compare networks / trees with dissimilarity measures
  (Robinson-Foulds distance on trees)
- summarize samples of bootstrap networks (or trees)
  with edge and node support
- estimate species networks from multilocus data (see below)
- phylogenetic comparative methods for continuous trait evolution
  on species networks / trees

To get help, check

- the [latest documentation](https://crsl4.github.io/PhyloNetworks.jl/latest)
- the [wiki](https://github.com/crsl4/PhyloNetworks.jl/wiki) for a step-by-step tutorial
  (June 2016) with background on networks
- the [google group](https://groups.google.com/forum/#!forum/phylonetworks-users)
  for common questions. Join the group to post/email your questions,
  or to receive information on new versions, bugs fixed, etc.

If you use the package, please cite

- Claudia Sol&iacute;s-Lemus, Paul Bastide and C&eacute;cile An&eacute; (2017). PhyloNetworks: a package for phylogenetic networks. [Molecular Biology and Evolution](https://academic.oup.com/mbe/article/doi/10.1093/molbev/msx235/4103410/PhyloNetworks-a-package-for-phylogenetic-networks?guestAccessKey=230afceb-df28-4160-832d-aa7c73f86369) doi: 10.1093/molbev/msx235

## Maximum pseudolikelihood estimation of species network: SNaQ <img src="http://pages.stat.wisc.edu/~claudia/Images/snaq.png" align=right title="SNaQ logo" width=262.5 height=111>
<!-- ![SNaQ logo](http://pages.stat.wisc.edu/~claudia/Images/snaq.png)
original size: 525px × 222px-->

SNaQ implements the statistical inference method in Sol&iacute;s-Lemus and An&eacute;
[(2016)](http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1005896).
The procedure involves a
numerical optimization of branch lengths and inheritance probabilities
and a heuristic search in the space of phylogenetic
networks.

If you use SNaQ, please cite

- Claudia Sol&iacute;s-Lemus and C&eacute;cile An&eacute; (2016).
  Inferring Phylogenetic Networks with Maximum Pseudolikelihood under Incomplete Lineage Sorting.
  [PLoS Genet](http://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1005896)
  12(3):e1005896. doi: 10.1371/journal.pgen.1005896
