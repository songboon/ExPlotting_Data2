  ## load the ggplot library
  library(ggplot2)
  
  ## construct the data folder path
  workingdir <- getwd()
  datadir <- "exdata-data-NEI_data"
  datadirpath <- paste(workingdir, datadir, sep="/")
  
  ## set the graphical output filename
  graphicaloutputfilename <- "plot4.png"
  
  ## if the graphical output file exist, then delete it
  if(file.exists(graphicaloutputfilename)) {
    file.remove(graphicaloutputfilename)
  }
  
  ## set the full path to the PM25 and SCC files
  sccfilename <- "Source_Classification_Code.rds"
  pm25filename <- "summarySCC_PM25.rds"
  
  sccdestfile <- paste(datadirpath, sccfilename, sep="/")
  pm25destfile <- paste(datadirpath, pm25filename, sep="/")
  
  ## reading the dataset into the R
  NEI <- readRDS(pm25destfile)
  SCC <- readRDS(sccdestfile)
  
  # select emissions from coal combustion-related sources
  coalSCC <- SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]
  
  ## merge two data sets
  NEI <- merge(x=NEI, y=coalSCC, by='SCC')
  emissions <- aggregate(NEI[, 'Emissions'], list(NEI$year), sum)
  colnames(emissions) <- c('Year', 'Level')
  
  ## free up memory as best practise
  rm(NEI, SCC)
  
  ## set the margin of the graph output
  par("mar"=c(6, 5, 4, 2))
  
  ## output to png file format
  png(filename = graphicaloutputfilename)
  
  ## construct plot 4  
  ggplot(data=emissions, aes(x=Year, y=Level/1000)) + 
    geom_line(aes(group=1, col=Level)) + geom_point(aes(size=2, col=Level)) + 
    ggtitle(expression('Coal related emissions of PM'[2.5])) + 
    ylab(expression(paste('PM', ''[2.5], ' (1000)'))) + 
    geom_text(aes(label=round(Level/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
    theme(legend.position='none') + scale_colour_gradient(low='black', high='red')
  
  ## close the graphical device
  dev.off()
