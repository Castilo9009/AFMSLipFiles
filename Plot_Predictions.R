library(psych)
library(ggplot2)
library(gridExtra)

PlotAll <- function (opp, success){
  n <- length(colnames(success))
  x <- rep(opp, n)
  label <- melt(success)$variable
  succ <- melt(success)$value
  plotData = data.frame(opp, succ, label)
  ggplot() + coord_cartesian(ylim=c(0, 1)) + labs(title="Learning Curve (All KCs)") + 
    ylab("Average Error") + xlab("Opportunities") + 
    geom_smooth(data=plotData, aes(x=opp, y=succ, group=label, color=label, fill=label)) 
}

PlotKC <- function (kc, opp, success, kcid, kcs){
  opp <- opp[kcid == kc]
  success <- success[kcid==kc,]
  
  n <- length(colnames(success))
  x <- rep(opp, n)
  label <- melt(success)$variable
  succ <- melt(success)$value
  plotData = data.frame(opp, succ, label)
  ggplot() + coord_cartesian(ylim=c(0, 1)) + labs(title=paste("Learning Curve (", kcs[kc], ")")) + 
    ylab("Average Error") + xlab("Opportunities") + 
    geom_smooth(data=plotData, aes(x=opp, y=succ, group=label, color=label, fill=label)) 
}

############# GEOMETRY ################
# Load the original Datashop file
datashop = read.csv("~/Projects/AFM-Octave/geometry-ken-analysis/ds76_student_step_All_Data_74_2015_0203_121851.txt", sep='\t')
datashop$knowledge_component <- as.factor(datashop$KC..DecompArithDiam.)
datashop$opportunity <- datashop$Opportunity..DecompArithDiam.

# Load AFM and AFMS results
afm_predictions = read.csv("~/Projects/AFM-Octave/geometry-ken-analysis/row_afm_afms2.csv", header=FALSE)

# Load the BKT results
bkt_predictions = read.csv("~/Projects/AFM-Octave/geometry/bkt.tdt", sep='\t')

############# GEOMETRY ################
# Load the original Datashop file
#datashop = read.csv("~/Projects/AFM-Octave/geometry/ds76_student_step_All_Data_74_2014_0615_045213.txt", sep='\t')
#datashop$knowledge_component <- as.factor(datashop$KC..LFASearchAICWholeModel3.)
#datashop$opportunity <- datashop$Opportunity..LFASearchAICWholeModel3.

# Load AFM and AFMS results
#afm_predictions = read.csv("~/Projects/AFM-Octave/geometry/row_afm_afms.csv", header=FALSE)

# Load the BKT results
#bkt_predictions = read.csv("~/Projects/AFM-Octave/geometry/bkt.tdt", sep='\t')

############# SELF EXPLANATION ########
# Load the original Datashop file
#datashop = read.csv("~/Projects/AFM-Octave/selfexplanation/ds293_student_step_All_Data_876_2014_0828_184125.txt", sep='\t')
#datashop$knowledge_component <- as.factor(datashop$KC..LFASearchAICModel0.r2.)
#datashop$opportunity <- datashop$Opportunity..LFASearchAICModel0.r2.

# Load AFM and AFMS results
#afm_predictions = read.csv("~/Projects/AFM-Octave/selfexplanation/row_afm_afms.csv", header=FALSE)

# Load the BKT results
#bkt_predictions = read.csv("~/Projects/AFM-Octave/selfexplanation/bkt.tdt", sep='\t')

############# SELF EXPLANATION 2 ########
# Load the original Datashop file
#datashop = read.csv("~/Projects/AFM-Octave/selfexplanation2/ds372_student_step_All_Data_1182_2014_0328_135316.txt", sep='\t')
#datashop$knowledge_component <- as.factor(datashop$KC..LFASearchAICWholeModel1.)
#datashop$opportunity <- datashop$Opportunity..LFASearchAICWholeModel1.
# Load AFM and AFMS results
#afm_predictions = read.csv("~/Projects/AFM-Octave/selfexplanation2/row_afm_afms.csv", header=FALSE)
# Load the BKT results
#bkt_predictions = read.csv("~/Projects/AFM-Octave/selfexplanation2/bkt.tdt", sep='\t')

names(afm_predictions) <- c("Row", "AFM", "AFMS")
afm_predictions$AFM <- 1 - afm_predictions$AFM
afm_predictions$AFMS <- 1 - afm_predictions$AFMS
datashop <- merge(datashop, afm_predictions, by="Row")

bkt_predictions <- bkt_predictions[c("row", "BKT_predict")]
names(bkt_predictions) <- c("Row", "BKT")
bkt_predictions$BKT <- 1 - bkt_predictions$BKT
datashop <- merge(datashop, bkt_predictions, by="Row")

######################################

kcs <- unique(unlist(Map(function(x) strsplit(toString(x), "~~"), datashop$knowledge_component)))
users <- unique(datashop$Anon.Student.Id)

datashop$actual <- 1
datashop$actual[datashop$First.Attempt == "correct"] <- 0
datashop$sid <- match(datashop$Anon.Student.Id, users)
datashop$kcid <- match(datashop$knowledge_component, kcs)

# Compute the residuals
datashop$AFMResiduals <- datashop$actual - datashop$AFM
datashop$AFMSResiduals <- datashop$actual - datashop$AFMS
datashop$BKTResiduals <- datashop$actual - datashop$BKT


PlotAll(datashop$opportunity, datashop[, c("actual", "AFM","AFMS")])
PlotKC(12, datashop$opportunity, datashop[, c("actual", "AFM","AFMS")], datashop$kcid, kcs)

################# DO THE PLOTTING ##############

########## GEOMETRY DECOMPARITH ################
#pdf(file="~/Projects/AFM-Octave/geometry-ken-analysis/decomparithdiam-error-plots.pdf")
#PlotAllAFMs()
#for (i in seq(length(kcs))){
#  print(KCPlotAFMs(i))
#} 
#dev.off() 

#pdf(file="~/Projects/AFM-Octave/geometry-ken-analysis/decomparithdiam-residual-plots.pdf")
#PlotAllAFMsResiduals()
#for (i in seq(length(kcs))){
#  print(PlotKCAFMsResiduals(i))
#} 
#dev.off() 

########## GEOMETRY DECOMPARITH2 ################
pdf(file="~/Projects/AFM-Octave/geometry-ken-analysis/decomparithdiam2-error-plots.pdf")
PlotAllAFMs()
for (i in seq(length(kcs))){
  print(KCPlotAFMs(i))
} 
dev.off() 

pdf(file="~/Projects/AFM-Octave/geometry-ken-analysis/decomparithdiam2-residual-plots.pdf")
PlotAllAFMsResiduals()
for (i in seq(length(kcs))){
  print(PlotKCAFMsResiduals(i))
} 
dev.off() 

########## SELF EXPLANATION2 ################
#pdf(file="~/Projects/AFM-Octave/selfexplanation2/error-plots2.pdf")
#PlotAll2()
#for (i in seq(length(kcs))){
#  print(KCPlot2(i))
#} 
#dev.off() 

#pdf(file="~/Projects/AFM-Octave/selfexplanation2/residual-plots.pdf")
#PlotAllResiduals()
#for (i in seq(length(kcs))){
#  print(PlotKCResiduals(i))
#} 
#dev.off() 

########## SELF EXPLANATION ################
#pdf(file="~/Projects/AFM-Octave/selfexplanation/error-plots2.pdf")
#PlotAll2()
#for (i in seq(length(kcs))){
#  print(KCPlot2(i))
#} 
#dev.off() 

#pdf(file="~/Projects/AFM-Octave/selfexplanation/residual-plots.pdf")
#PlotAllResiduals()
#for (i in seq(length(kcs))){
#  print(PlotKCResiduals(i))
#} 
#dev.off() 

########## GEOMETRY ################
#pdf(file="~/Projects/AFM-Octave/geometry/error-plots2.pdf")
#PlotAll2()
#for (i in seq(length(kcs))){
#  print(KCPlot2(i))
#} 
#dev.off() 

#pdf(file="~/Projects/AFM-Octave/geometry/residual-plots.pdf")
#PlotAllResiduals()
#for (i in seq(length(kcs))){
#  print(PlotKCResiduals(i))
#} 
#dev.off() 

