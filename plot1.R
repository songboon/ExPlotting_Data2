makePlot1 <- function(){
  
  ## construct the data folder path
  workingdir <- getwd()
  datadir <- "exdata-data-NEI_data"
  datadirpath <- paste(workingdir, datadir, sep="/")
  
  ## set the graphical output filename
  graphicaloutputfilename <- "plot1.png"
  
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
  
  # construct the data for plotting by aggregate for each year
  emissions <- aggregate(NEI$Emissions, list(NEI$year), FUN = sum)
  colnames(emissions) <- c("Year","Level")
  emissions$Level <- round(emissions$Level/1000,2)
  
  ## free up memory as best practise
  rm(NEI, SCC)
  
  ## set the margin of the graph output
  par("mar"=c(6, 5, 4, 2))
  
  ## output to png file format
  png(filename = graphicaloutputfilename, 
      width = 480, height = 480, 
      units = "px")
  
  ## construct plot 1
  plot(emissions, type = "l",
       main = "US emissions from PM2.5 from 1999 to 2008",
       xlab = "Year",
       ylab = expression('PM'[2.5]*" Emission (1000)"))
  
  ## close the graphical device
  dev.off()
}