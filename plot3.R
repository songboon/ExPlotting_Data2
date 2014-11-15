makePlot3 <- function(){
  ## load the ggplot library
  library(ggplot2)
  
  ## construct the data folder path
  workingdir <- getwd()
  datadir <- "exdata-data-NEI_data"
  datadirpath <- paste(workingdir, datadir, sep="/")
  
  ## set the graphical output filename
  graphicaloutputfilename <- "plot3.png"
  
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
  
  ## select only the Baltimore City, Maryland (fips == "24510") data
  NEI <- NEI[NEI$fips == "24510", ]
  
  ## free up memory as best practise
  ##rm(NEI, SCC)
  
  ## set the margin of the graph output
  par("mar"=c(6, 5, 4, 2))
  
  ## output to png file format
  png(filename = graphicaloutputfilename, 
      width = 480, height = 480, 
      units = "px")
  
  ## construct plot 3
  g <- ggplot(NEI, aes(year, Emissions, color = type))
  g + geom_line(stat = "summary", fun.y = "sum") +
    ylab(expression('PM'[2.5]*" Emissions")) +
    ggtitle("Baltimore City emissions from 1999 to 2008")
  
  ## close the graphical device
  dev.off()
}