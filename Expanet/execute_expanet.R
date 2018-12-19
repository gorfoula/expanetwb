library(expanet)


#Expanet is executed in two discrete steps. At first the expansion of #each pathway of each treatment is happening
#using the runExpanet() function and then to analyse the results #based on the expanded pathways a second function is 
#used called analyzeExpanet().

# @param treatment.label : Treatment's identification label [ string ]
# @param treatment.tm    : Treatment's transition matrix loaded object[ matrix ]
# @param resutls.dir     : Directory to store results [ string ]
# @param gsc             : List with Gene Set Collections  [ list ]
# @param l.of.walk       : The length of walk [ numeric ]
# @param verbose         : Either print or not results from lkwalk program [ logical ]
# @param n.cores         : Number of cores to be used [ numeric ]
# @param exeC            : C program execution path [ string ]

load("data/geneSets.RData")
load("data/pbe_path.Rdata")

load('data/control.tm.5.RData')
runExpanet( treatment.label = 'control',
            treatment.tm    = control.tm,
            results.dir     = 'data/output/control',
            gsc             = gse,# gse$kg.sets,
            l.of.walk       = 50,
            verbose         = FALSE,
            n.cores         = 2,
            exeC            = "./expanet/Cexec/lkwalk"
)

load('data/N.tm.5.RData')
runExpanet( treatment.label = 'N',
            treatment.tm    = N.tm,
            results.dir     = 'data/output/N',
            gsc             = gse,# gse$kg.sets,
            l.of.walk       = 50,
            verbose         = FALSE,
            n.cores         = 2,
            exeC            = "./expanet/Cexec/lkwalk"
)

# @param data.dir : The directory where the expanet saved the results from the first function
# @param control.label: Control's label (Should be the same as the folder name in data.dir)
# @param treatment.label : Treatment's label (Should be the same as the folder name in data.dir)
# @param control.adj  : Control's Adjacency matrix
# @param treatment.adj : Treatment's Adjacency matrix
# @param gene.set : Gene set collection
# @param threshold  : Edges weight threshold (if not provided algorithm calculates one by default)
# @param build.graphs : If TRUE it creates Cytoscape files for the expanted pathways if FALSE it doesn't
# @param save.results : If TRUE it stores the results (scores) in a csv format if FALSE it doesn't
load("data/N.adj.4.RData")
load("data/control.adj.4.RData")
indx=sample(1:nrow(control.adj),50)
analyzeExpanet( data.dir = 'data/output/',
                control.label = 'control',
                treatment.label = 'N', 
                control.adj = control.adj, 
                treatment.adj = N.adj,
                gene.set = gse,# gse$kg.sets,
                threshold = 0.0001,
                build.graphs = TRUE,
                save.results = TRUE
)