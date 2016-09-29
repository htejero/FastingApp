load("~/GSE24504_mouse_All_data.Rdata")
library(dplyr)

basic.TT <- function(x) {
  
  cols = c("SYMBOL", "GENENAME", "logFC", "adj.P.Val")
  
  return (x[, cols])
  
}


basic.DE.results <- lapply(DE.results, function(x)  lapply(x, basic.TT))




basic.DE.results$`12`$brain %>% head




getGene <- function(x, gene) {
  
  return(x[x$SYMBOL==gene,])
  
  
}

gene = "SGK"
gene.list <- lapply(basic.DE.results, function(x)  lapply(x, function(x) getGene(x, gene)))



tissue = "brain"

timepoint ="12"


tissue.df = do.call(rbind, gene.list[[timepoint]])
timepoint.df = do.call(rbind, sapply(gene.list, function(x) x[tissue]))


tissue.df$tissue = as.factor(names(gene.list[[timepoint]]))

timepoint.df$timepoint = as.factor(names(gene.list))


library(ggplot2)

ggplot(aes(x=tissue, y = logFC, fill = tissue), data = tissue.df) + geom_bar(stat = "identity")

ggplot(aes(x=timepoint, y = logFC, fill = timepoint), data = timepoint.df) + geom_bar(stat = "identity")

## Multiple tissues 

cc = do.call(rbind, sapply(gene.list, function(x) x))
cc$tissue = as.factor(rep(names(gene.list[[1]]), 4))
cc$timepoint = as.factor(rep(names(gene.list), each = 5))


ggplot(aes(x=tissue, y = logFC, fill = timepoint), 
       data = cc) + geom_bar(stat = "identity", position=position_dodge())

ggplot(aes(x=timepoint, y = logFC, fill = tissue), 
       data = cc) + geom_bar(stat = "identity", position=position_dodge())

which.Tissues = c("liver", "muscle")

ggplot(aes(x=timepoint, y = logFC, fill = tissue), 
       data = subset(cc, tissue %in% which.Tissues)) + geom_bar(stat = "identity", position=position_dodge())


subset(cc, tissue %in% which.Tissues)

