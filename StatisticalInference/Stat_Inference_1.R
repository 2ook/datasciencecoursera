exp.data <- data.frame()
i = 1
while(i <= 1000){
  exp.data <- rbind(exp.data,rexp(40,.2))
  i = i + 1
}

hist(rowMeans(exp.data),breaks=20)
abline(v=mean(rowMeans(exp.data)),col='red')
abline(v=5,col='blue')

mean(rowMeans(exp.data))
library(ggplot2)

ggplot(exp.data,aes(x=rowMeans(exp.data))) + 
  geom_histogram() + 
  geom_vline(xintercept = mean(rowMeans(exp.data)),color='red',size=2) +
  geom_vline(xintercept = 5,color='blue',size=2) +
  xlab('Mean of Exponential Simulation') +
  ylab('Count') +
  ggtitle('Simulation Mean vs. Theoretical Exponential Mean')

var(rowMeans(exp.data))
(1/.2)^2/40

coverage <- apply(exp.data,1,function(x) {
  ll <- mean(x) - 1.96*5/sqrt(40)
  ul <- mean(x) + 1.96*5/sqrt(40)
  mean(ll<5 & ul>5)
})

sum(coverage)/1000


library(lattice)
with(ToothGrowth,densityplot(~ len|supp, 
            main="Density Plot by Supplement Type",
            xlab="Tooth Length", 
            layout=c(1,2)))

with(ToothGrowth,xyplot(len ~ dose|supp, 
            main="Tooth Length by Dose and Supplement Type",
            xlab="Dose", 
            ylab="Tooth Length",
            layout=c(2,1)))

library(psych)
library(knitr)
kable(describe(ToothGrowth))

kable(describeBy(ToothGrowth,ToothGrowth$supp)[[1]])
kable(describeBy(ToothGrowth,ToothGrowth$supp)[[2]])

with(ToothGrowth, t.test(len ~ supp, paired = FALSE))

TG.sub.1 <- subset(ToothGrowth, dose %in% c(0.5, 1))
TG.sub.2 <- subset(ToothGrowth, dose %in% c(0.5, 2))
TG.sub.3 <- subset(ToothGrowth, dose %in% c(1, 2))

with(TG.sub.1, t.test(len ~ supp, paired = FALSE))
with(TG.sub.2, t.test(len ~ supp, paired = FALSE))
with(TG.sub.3, t.test(len ~ supp, paired = FALSE))

TG.sub.OJ.1 <- subset(ToothGrowth, supp == 'OJ' & dose %in% c(0.5, 1))
TG.sub.OJ.2 <- subset(ToothGrowth, supp == 'OJ' & dose %in% c(0.5, 2))
TG.sub.OJ.3 <- subset(ToothGrowth, supp == 'OJ' & dose %in% c(1, 2))

