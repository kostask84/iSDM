#' R function to plot the realized versus the potential distribution using a RGB colour space  
#'@description R to plot the realized versus the potential distribution using a RGB colour space  
#'@usage RGBplot(x=x,y=y,cex=0.6,xlab=xlab,ylab=ylab)
#'@param x May be a SpatilPixelsDataFrame, or a SpatialGridDataFrame as defined in package sp or a RasterLayer as defined in package raster
#'@param y An object belonging to the same class as x
#'@param cex A numerical value giving the amount by which plotting symbols should be magnified relative to the default
#'@param xlab A title for the x axis
#'@param ylab A title for the y axis
#'@export
#'@examples
#'library(raster)
#'library(sp)
#'library(virtualspecies)
#'library(colorRamps)
#'
#'envData<-getData('worldclim', var='bio', res=10)
#'envData<-crop(envData,extent(-8,15,38,55))
#'
#' # Generate virtual species responses with formatfunctions
#'my.parameters <- formatFunctions(bio1 = c(fun = "dnorm", mean = 140, sd = 40), bio5 = c(fun = "dnorm",
#'mean = 230, sd = 70),bio6 = c(fun = "dnorm",mean = 10, sd = 40))

#' # Generate a virtual species potential distributions with responses to environmental variables
#'potential.dist <- generateSpFromFun(envData[[c(1,5,6)]], my.parameters)$suitab.raster
#'
#' #Limit the distribution 
#'realized.dist<-potential.dist
#'cell.id<-which(coordinates(realized.dist)[,2]>48)
#'dis.lim<-sample(seq(0,1,by=0.01),length(cell.id),replace=T)
#'values(realized.dist)[cell.id]<-ifelse(values(realized.dist)[cell.id]>dis.lim,values(realized.dist)[cell.id]-dis.lim,0)

#'RGBplot(x=potential.dist,y=realized.dist,cex=0.6,xlab="Potential distribution",ylab="Realized distribution")

RGBplot<-function(x=x,y=y,cex=0.5,xlab=xlab,ylab=ylab) {
  if(class(x)!=class(y)) {stop("x and Y  must belong to the same class")}
  if(!any(dim(x)==dim(y))) {stop("x and y must have the same dimensions")}
  if(class(x) %in% c("SpatialPixelsDataFrame","SpatialGridDataFrame")){x<-raster(x)
                                                                       y<-raster(y)}
  if(class(x)!="RasterLayer"){stop("the class of the object x does not correspond to the classes handled by this function")}
  XY<-coordinates(x)                         
  x<-values(x)
  y<-values(y)
  names(x)<-seq(1:length(x))
  names(y)<-seq(1:length(y))
  rownames(XY)<-names(x)
  x<-na.omit(x)
  y<-y[names(x)]
  XY<-XY[names(x),]
  RGB<-matrix(NA,ncol=3,nrow=length(x))
  RGB[,1]<-(x-min(x)/(max(x)-min(x)))*255
  RGB[,2]<-(y-min(y)/(max(y)-min(y)))*255
  RGB[,3]<-c(255-RGB[,1])
  col<-rgb(RGB[,1],RGB[,2],RGB[,3],maxColorValue =255)
  layout(mat=matrix(c(2,1),ncol=2,nrow=1),widths=c(0.8,0.8))
  par(mar=c(2,2,1,1))
  plot(XY,col=col,cex=cex,pch=15,xlab="Longitude",ylab="Latitude")
  par(mar=c(4,4,4,4))
  plot(x,y,xlab=xlab,ylab=ylab,cex=cex,col=col,pch=15)
} # end of function RGBplot
