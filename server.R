load(file = "/home/htejero/lincs/Projects/Fasting/FastingApp/basic.Res.Rdata")

library(ggplot2)

getGene <- function(x, gene) {
  return(x[x$SYMBOL==gene,])
}

shinyServer(function(input, output) {

  output$text1 <- renderText({ 
    if (input$gene %in% genes) {
      paste(input$gene ," expression")
    } else {
      paste("Error.", input$gene, "not found")
    }
   
  })
  
  output$plot <- renderPlot({
    
    
    gene.list <- lapply(basic.DE.results, function(x)  lapply(x, function(x) getGene(x, input$gene)))
    
    cc = do.call(rbind, sapply(gene.list, function(x) x))
    cc$tissue = as.factor(rep(names(gene.list[[1]]), 4))
    cc$timepoint = as.factor(rep(names(gene.list), each = 5))
    cc$Sig=  ""
    cc$Sig[cc$adj.P.Val<0.05]="*"
    cc$Sig[cc$adj.P.Val<0.001]="**"
    
    
    if (input$x_var=="tissue"){
      ggplot(aes(x=tissue, y = logFC, fill = timepoint), 
               data = subset(cc, timepoint %in% input$whichTimepoints & tissue %in% input$whichTissues)) + 
        geom_bar(stat = "identity", position=position_dodge(), colour = "black") + 
        xlab("Tissue") + ylab("logFC") + ggtitle(paste(input$gene, "Expression")) + 
        geom_text(aes(label=Sig), position=position_dodge(width=0.9) , vjust =-0.25, cex = 3)
      
      
      
    } else if (input$x_var=="timepoint") {
  
      
      ggplot(aes(x=timepoint, y = logFC, fill = tissue), 
             data = subset(cc, timepoint %in% input$whichTimepoints & tissue %in% input$whichTissues)) +
        geom_bar(stat = "identity", position=position_dodge(), colour = "black") +
        xlab("Timepoint") + ylab("logFC") + ggtitle(paste(input$gene, "Expression")) + 
        geom_text(aes(label=Sig), position=position_dodge(width=0.9) , vjust =-0.25, cex = 3) 
   
    }
    
    
  }
    
  )
  
})