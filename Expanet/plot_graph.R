library(igraph)
g<-read_graph("data/output/control/graphs/pbe03020_RNA_polymerase.gml", format = c("gml"))
g<-read_graph("data/output/control/graphs/pbe04146_Peroxisome.gml", format = c("gml"))

cls=rep("grey80",1,length(V(g)))
soi=which(vertex_attr(g,"issoi")==1)
cls[soi]="skyblue1"

lbs_cols=rep("grey80",1,length(V(g)))
lbs_cols[soi]="black"

par(mar=c(0,0,0,0))
igraph::plot.igraph(g, layout=layout_with_fr,vertex.color = as.vector(cls),
                    label.color="red", vertex.size=5, vertex.label.dist=1.5,
                    vertex.label.family="Calibri",vertex.label.cex=0.8,
                    vertex.label.color=lbs_cols,vertex.label.font=2)

#layout_as_tree
#layout_nicely
#layout_with_fr
#layout_with_kk