# test of deleteHybridEdge!, functions to extract displayed trees/subnetworks,
#      used to compare networks with the hardwired cluster distance.
# Cecile March 2016

using PhyloNetworks

#---- testing deleteHybridEdge! ---------------#
println("\n\nTesting deleteHybridEdge!")

# example of network with one hybrid edge connected to the root:
net = readTopology("((Adif:1.0,(Aech:0.122,#H6:10.0::0.047):10.0):1.614,Aten:1.0,((Asub:1.0,Agem:1.0):0.0)#H6:5.062::0.953);");
# plot(net, showEdgeNumber=true, showNodeNumber=true)
PhyloNetworks.deleteHybridEdge!(net, net.edge[10]);
writeTopology(net) == "(Adif:1.0,(Aech:0.122,(Asub:1.0,Agem:1.0):10.0):10.0,Aten:2.614);" ||
 error("deleteHybridEdge! didn't work on 10th edge")
net = readTopology("((Adif:1.0,(Aech:0.122,#H6:10.0::0.047):10.0):1.614,Aten:1.0,((Asub:1.0,Agem:1.0):0.0)#H6:5.062::0.953);");
PhyloNetworks.deleteHybridEdge!(net, net.edge[3]);
writeTopology(net) == "((Adif:1.0,Aech:10.122):1.614,Aten:1.0,(Asub:1.0,Agem:1.0):5.062);" ||
 error("deleteHybridEdge! didn't work on 3rd edge")
# plot(net, showEdgeNumber=true, showNodeNumber=true)

net=readTopology("(4,((1,(2)#H7:::0.864):2.069,(6,5):3.423):0.265,(3,#H7:::0.1361111):10.0);");
# plot(net, showEdgeNumber=true, showNodeNumber=true)
PhyloNetworks.deleteHybridEdge!(net, net.edge[11]);
writeTopology(net) == "(4,((1,2):2.069,(6,5):3.423):0.265,3);" ||
 error("deleteHybridEdge! didn't work on 11th edge")
net=readTopology("(4,((1,(2)#H7:::0.864):2.069,(6,5):3.423):0.265,(3,#H7:::0.1361111):10.0);");
PhyloNetworks.deleteHybridEdge!(net, net.edge[4]);
writeTopology(net) == "(4,((6,5):3.423,1):0.265,(3,2):10.0);" ||
 error("deleteHybridEdge! didn't work on 4th edge")

# example with wrong attributed inChild1
net=readTopology("(4,((1,(2)#H7:::0.864):2.069,(6,5):3.423):0.265,(3,#H7:::0.1361111):10.0);");
net.edge[5].isChild1 = false;
PhyloNetworks.deleteHybridEdge!(net, net.edge[4]);
writeTopology(net) == "(4,((6,5):3.423,1):0.265,(3,2):10.0);" ||
 error("deleteHybridEdge! didn't work on 4th edge when isChild1 was outdated")

net = readTopology("((Adif:1.0,(Aech:0.122,#H6:10.0::0.047):10.0):1.614,Aten:1.0,((Asub:1.0,Agem:1.0):0.0)#H6:5.062::0.953);");
net.edge[5].isChild1 = false # edge 5 from -1 to -2
PhyloNetworks.deleteHybridEdge!(net, net.edge[10]);
# WARNING: node -1 being the root is contradicted by isChild1 of its edges.
writeTopology(net) == "(Adif:1.0,(Aech:0.122,(Asub:1.0,Agem:1.0):10.0):10.0,Aten:2.614);" ||
 error("deleteHybridEdge! didn't work on 10th edge after isChild1 was changed")

# plot(net, showEdgeNumber=true, showNodeNumber=true)

#----------------------------------------------------------#
#   testing functions to display trees / subnetworks       #
#----------------------------------------------------------#

println("\n\nTesting deleteHybridThreshold!")

net21 = readTopology("(A,((B,#H1),(C,(D)#H1)));");
# manual bug fix to get good gamma's (0.5 not 1.0) and major/minor
net21.edge[3].gamma = 0.5;
net21.edge[7].gamma = 0.5;
deleteHybridThreshold!(net21,0.2);
writeTopology(net21) == "(A,((B,#H1:::0.5),(C,(D)#H1:::0.5)));" ||
 error("deleteHybridThreshold! didn't work on net21, gamma=0.2")
deleteHybridThreshold!(net21,0.5);
writeTopology(net21) == "(A,((C,D),B));" ||
 error("deleteHybridThreshold! didn't work on net21, gamma=0.5")

net22 = readTopology("(A,((B,#H1:::0.2),(C,(D)#H1:::0.8)));");
deleteHybridThreshold!(net22,0.3);
writeTopology(net22) == "(A,((C,D),B));" ||
 error("deleteHybridThreshold! didn't work on net22, gamma=0.3")

net31 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(C:0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
net32 = deepcopy(net31); for (e in net32.edge) e.length=-1.0; end
# plot(net31)
deleteHybridThreshold!(net31,0.3);
writeTopology(net31) == "(A:1.0,((C:0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("deleteHybridThreshold! didn't work on net31, gamma=0.3")
deleteHybridThreshold!(net32,0.3)
writeTopology(net32) == "(A,((C,D),B));" ||
 error("deleteHybridThreshold! didn't work on net32, gamma=0.3")

net42 = readTopology("(A:1.0,((B:1.1,#H1:0.2):1.2,(C:0.9,(D:0.8)#H1:0.3):1.3):0.7):0.1;");
deleteHybridThreshold!(net42,0.5);
writeTopology(net42) == "(A:1.0,((C:0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("deleteHybridThreshold! didn't work on net42, gamma=0.5")

net5 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
# plot(net5)
deleteHybridThreshold!(net5,0.5);  # both H1 and H2 eliminated
writeTopology(net5) == "(A:1.0,((((C:0.52,E:0.52):0.6,F:1.5):0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("deleteHybridThreshold! didn't work on net5, gamma=0.5")
net5 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
deleteHybridThreshold!(net5,0.3);  # H2 remains
writeTopology(net5) == "(A:1.0,((((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("deleteHybridThreshold! didn't work on net5, gamma=0.3")

println("\n\nTesting displayedNetworks! and displayedTrees")

net3 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(C:0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
net31 = PhyloNetworks.displayedNetworks!(net3, net3.node[6]); #H1 = 6th node
writeTopology(net31) == "(A:1.0,((B:1.1,D:1.0):1.2,C:2.2):0.7);" ||
 error("displayedNetworks! didn't work on net3, minor at 6th node")
writeTopology(net3)  == "(A:1.0,((C:0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("displayedNetworks! didn't work on net3, major at 6th node")

net3 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(C:0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
a = displayedTrees(net3, 0.2);
length(a) == 2 ||
 error("displayedTrees didn't work on net3, gamma=0.2: output not of length 2")
writeTopology(a[1]) == "(A:1.0,((C:0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("displayedTrees didn't work on net3, gamma=0.2: 1st tree wrong")
writeTopology(a[2]) == "(A:1.0,((B:1.1,D:1.0):1.2,C:2.2):0.7);" ||
 error("displayedTrees didn't work on net3, gamma=0.2: 2nd tree wrong")

net5 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
a = displayedTrees(net5, 0.5);
length(a) == 1 ||
 error("displayedTrees didn't work on net5, gamma=0.5: output not of length 1")
writeTopology(a[1]) == "(A:1.0,((((C:0.52,E:0.52):0.6,F:1.5):0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("displayedTrees didn't work on net5, gamma=0.5: wrong tree")
a = displayedTrees(net5, 0.1);
length(a) == 4 ||
 error("displayedTrees didn't work on net5, gamma=0.1: output not of length 4")
(writeTopology(a[1]) == "(A:1.0,((((C:0.52,E:0.52):0.6,F:1.5):0.9,D:1.1):1.3,B:2.3):0.7);" &&
 writeTopology(a[2]) == "(A:1.0,((B:1.1,D:1.0):1.2,((C:0.52,E:0.52):0.6,F:1.5):2.2):0.7);" &&
 writeTopology(a[3]) == "(A:1.0,((((F:0.7,E:0.51):0.8,C:1.12):0.9,D:1.1):1.3,B:2.3):0.7);" &&
 writeTopology(a[4]) == "(A:1.0,((B:1.1,D:1.0):1.2,((F:0.7,E:0.51):0.8,C:1.12):2.2):0.7);") ||
 error("displayedTrees didn't work on net5, gamma=0.1: one or more tree(s) is/are wrong")

println("\n\nTesting majorTree and displayedNetworkAt!")

writeTopology(majorTree(net5)) == "(A:1.0,((((C:0.52,E:0.52):0.6,F:1.5):0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("majorTree didn't work on net5")

net5 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
displayedNetworkAt!(net5, net5.hybrid[1]);
writeTopology(net5) == "(A:1.0,((((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,D:1.1):1.3,B:2.3):0.7);" ||
 error("displayedNetworkAt! didn't work on net5, 1st hybrid")

#----------------------------------------------------------#
#   testing functions to compare trees                     #
#----------------------------------------------------------#

println("\n\nTesting tree2Matrix")

net5 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
tree = displayedTrees(net5, 0.0);
taxa = tipLabels(net5);
M1 = PhyloNetworks.tree2Matrix(tree[1], taxa, rooted=false);
M2 = PhyloNetworks.tree2Matrix(tree[2], taxa, rooted=false);
M1 ==
[15 0 0 1 1 1 1;
 12 0 0 1 1 1 0;
  8 0 0 1 1 0 0] || error("bad M1, from net5")
M2 ==
[ 4 0 1 0 0 0 1;
 12 0 0 1 1 1 0;
  8 0 0 1 1 0 0] || error("bad M2, from net5")
hardwiredClusterDistance(tree[1], tree[2], true) == 2 || error("wrong dist between rooted trees 1 and 2");
hardwiredClusterDistance(tree[1], tree[2], false)== 2 || error("wrong dist between unrooted trees 1 and 2");
hardwiredClusters(net5, taxa) ==
[16 0 1 1 1 1 1 10;
  4 0 1 0 0 0 1 10;
  3 0 0 0 0 0 1 11;
 15 0 0 1 1 1 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10;
  7 0 0 0 1 0 0 11;
 11 0 0 0 1 1 0 10] || error("wrong matrix of hardwired clusters for net5");
hardwiredClusterDistance(net5, tree[2], true) == 4 || error("wrong dist between net5 and tree 2");

## check things with R
# library(ape); set.seed(15); phy <- rmtree(10,8); write.tree(phy,"tenRtrees.tre")
# library(phangorn); RF.dist(phy,rooted=F)
#     1  2  3  4  5  6  7  8  9
# 2   8
# 3  10 10
# 4  10 10 10
# 5  10  8  8 10
# 6  10 10  8 10  8
# 7  10 10 10 10 10 10
# 8  10  8  8 10 10  8 10
# 9  10 10  8  8 10 10 10 10
# 10  8  6 10  8  8 10 10 10  8
# i=10; j=1; RF.dist(phy[[i]],phy[[j]],rooted=T) # 10
# i=10; j=2; RF.dist(phy[[i]],phy[[j]],rooted=T) #  8
## now checking if we get the same results in julia
# phy = readInputTrees("tenRtrees.tre")
# or
phy1 = readTopology("((t8:0.8623136566,(((t6:0.141187073,t2:0.7767125128):0.9646669542,t4:0.8037273993):0.447443719,t5:0.7933459524):0.8417851452):0.7066285675,(t1:0.0580010619,(t7:0.6590069213,t3:0.1069735419):0.5657461432):0.3575631182);");
phy2 = readTopology("((t3:0.9152618761,t4:0.4574306419):0.7603277895,(((t1:0.4291725352,t8:0.3302786439):0.3437780738,(t5:0.8438980761,(t6:0.6667000714,t2:0.7141199473):0.01087239943):0.752832541):0.2591188031,t7:0.7685037958):0.9210739341);");
phy3 = readTopology("(((t7:0.3309174306,t6:0.8330178803):0.7741786113,(((t2:0.4048132468,t8:0.6809111023):0.6810255498,(t4:0.6540613638,t5:0.2610215396):0.8490990005):0.6802781771,t3:0.2325445588):0.911911567):0.94644987,t1:0.09404937108);");
phy10= readTopology("((t4:0.1083955287,((t1:0.8376079942,t8:0.1745392387):0.6178579947,((t6:0.3196466176,t2:0.9228881211):0.3112748025,t7:0.05162345758):0.7137957355):0.5162231021):0.06693460606,(t5:0.005652675638,t3:0.2584615161):0.7333540542);");

(hardwiredClusterDistance(phy1, phy10, false)== 8 &&
 hardwiredClusterDistance(phy2, phy10, false)== 6 &&
 hardwiredClusterDistance(phy3, phy10, false)==10 &&
 hardwiredClusterDistance(phy1, phy2,  false)== 8 &&
 hardwiredClusterDistance(phy1, phy3,  false)==10 &&
 hardwiredClusterDistance(phy2, phy3,  false)==10 &&
 hardwiredClusterDistance(phy1, phy10, true) ==10 &&
 hardwiredClusterDistance(phy2, phy10, true) == 8 ) ||
  error("wrong RF distance between some of the trees");

#----------------------------------------------------------#
#   testing function to compare networks                   #
#   with hardwired clusters                                #
#   used for detection of given hybridization event        #
#----------------------------------------------------------#

println("\n\nTesting displayedTrees, hardwiredClusters, hardwiredClusterDistance, displayedNetworkAt!")

estnet = readTopology("(6,((5,#H7:0.0::0.402):8.735,((1,2):6.107,((3,4):1.069)#H7:9.509::0.598):6.029):0.752);")
# originally from "../msSNaQ/simulations/estimatedNetworks/baseline/nloci10/1_julia.out"
trunet = readTopology("((((1,2),((3,4))#H1),(#H1,5)),6);");
hardwiredClusterDistance(majorTree(trunet), majorTree(estnet),false) == 0 ||
 error("estnet and trunet should be found to have the same unrooted major tree");
truminor = minorTreeAt(trunet, 1); # (1:1.0,2:1.0,((5:1.0,(3:1.0,4:1.0):2.0):1.0,6:1.0):2.0);
estminor = minorTreeAt(estnet, 1); # (5:1.0,(3:1.0,4:1.0):1.069,(6:1.0,(1:1.0,2:1.0):10.0):8.735);
writeTopology(truminor) == "((((1,2),(3,4)),5),6);" || error("wrong truminor");
writeTopology(estminor) == "(6,(((1,2):6.107,(3,4):10.578):6.029,5):0.752);" || error("wrong estminor");
hardwiredClusterDistance(truminor, estminor, false) == 0 ||
 error("truminor and estminor should be found to be at distance 0 when unrooted.");
# so the hybrid edge was estimated correctly!!


net5 = readTopology("(A,((B,#H1:::0.2),(((C,(E)#H2:::0.7),(#H2:::0.3,F)),(D)#H1:::0.8)));");
tree = displayedTrees(net5, 0.0);
taxa = tipLabels(net5);
hardwiredClusters(tree[1], taxa) ==
[16 0 1 1 1 1 1 10;
 15 0 0 1 1 1 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10] || error("wrong hardwired cluster matrix for tree 1");
hardwiredClusters(tree[2], taxa) ==
[16 0 1 1 1 1 1 10;
  4 0 1 0 0 0 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10] || error("wrong hardwired cluster matrix for tree 2");
hardwiredClusters(net5, taxa) ==
[16 0 1 1 1 1 1 10;
  4 0 1 0 0 0 1 10;
  3 0 0 0 0 0 1 11;
 15 0 0 1 1 1 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10;
  7 0 0 0 1 0 0 11;
 11 0 0 0 1 1 0 10] || error("wrong hardwired cluster matrix for net5");

trunet = readTopology("(((1,2),((3,4))#H1),(#H1,5),6);"); # unrooted
taxa = tipLabels(trunet);
hardwiredClusters(trunet, taxa) ==
[8 1 1 1 1 0 0 10
 3 1 1 0 0 0 0 10
 7 0 0 1 1 0 0 11
 6 0 0 1 1 0 0 10
11 0 0 1 1 1 0 10] || error("wrong hardwired cluster matrix for unrooted trunet");
trunet = readTopology("((((1,2),((3,4))#H1),(#H1,5)),6);"); # rooted: good!
hardwiredClusters(trunet, taxa) ==
[12 1 1 1 1 1 0 10;
  8 1 1 1 1 0 0 10;
  3 1 1 0 0 0 0 10;
  7 0 0 1 1 0 0 11;
  6 0 0 1 1 0 0 10;
 11 0 0 1 1 1 0 10] || error("wrong hardwired cluster matrix for trunet");
hardwiredClusters(estnet, taxa) ==
[13 1 1 1 1 1 0 10
  4 0 0 1 1 1 0 10
  3 0 0 1 1 0 0 11
 10 0 0 1 1 0 0 10
 12 1 1 1 1 0 0 10
  7 1 1 0 0 0 0 10] || error("wrong hardwired cluster matrix for estnet")
hardwiredClusterDistance(trunet,estnet,true) == 0 ||
 error("trunet and estnet should be found to be at HWDist 0");

net51 = readTopologyLevel1("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;")
PhyloNetworks.directEdges!(net51); # doing this avoids a warning on the next line:
displayedNetworkAt!(net51, net51.hybrid[1]) # H2
# "WARNING: node -3 being the root is contradicted by isChild1 of its edges."
root!(net51, "A");
writeTopology(net51) == "(A:0.5,((((C:0.52,(E:0.5)#H2:0.02):0.6,(#H2:0.01,F:0.7):0.8):0.9,D:1.1):1.3,B:2.3):0.5);" ||
  error("wrong net51 after displayedNetworkAt!");
net52 = readTopology("(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,(E:0.5)#H2:0.02::0.7):0.6,(#H2:0.01::0.3,F:0.7):0.8):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7):0.1;");
displayedNetworkAt!(net52, net52.hybrid[2])
writeTopology(net52) == "(A:1.0,((B:1.1,#H1:0.2::0.2):1.2,(((C:0.52,E:0.52):0.6,F:1.5):0.9,(D:0.8)#H1:0.3::0.8):1.3):0.7);" ||
  error("wrong net52 after displayedNetworkAt!");
taxa = tipLabels(net52); # order: A B C E F D
hardwiredClusters(net51, taxa) ==
[16 0 1 1 1 1 1 10;
 15 0 0 1 1 1 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10;
  7 0 0 0 1 0 0 11;
 11 0 0 0 1 1 0 10] || error("wrong hardwired clusters for net51");
hardwiredClusters(net52, taxa) ==
[16 0 1 1 1 1 1 10;
  4 0 1 0 0 0 1 10;
  3 0 0 0 0 0 1 11;
 15 0 0 1 1 1 1 10;
 12 0 0 1 1 1 0 10;
  8 0 0 1 1 0 0 10] || error("wrong hardwired clusters for net52");
hardwiredClusterDistance(net51,net52,true) == 4 ||
 error("wrong HWDist between net51 and net52");
