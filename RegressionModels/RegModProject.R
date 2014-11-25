dim(mtcars)
mtcars

library(lattice)
trans.label <- ifelse(mtcars$am == 1,'manual','automatic')
densityplot(~ mtcars$mpg|trans.label, layout=c(1,2),
            main="Density of Miles Per Gallon by Transmission Type",
            xlab="Miles Per Gallo")

library(ggplot2)
ggplot(mtcars,aes(trans.label,mpg)) + 
  geom_boxplot(aes(fill=factor(trans.label))) +
  xlab('Transmission Type') + 
  ylab('Miles Per Gallon') + 
  ggtitle('Miles Per Gallon by Transmission Type')


cor(mtcars[,1],mtcars[,2:11])

mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am)

fit.1 <- lm(mpg ~ factor(am), data = mtcars)
summary(fit.1)

library(MASS)
step <- stepAIC(fit.1, direction="forward")
step$anova

library(leaps)
leaps <- regsubsets(mpg ~ ., data = mtcars)
summary(leaps)
plot(leaps,scale="r2")

par(mar = rep(2.5, 4))
par(mfrow = c(2,2))
plot(step)

summary(step)

library(MASS)
step <- stepAIC(lm(mpg ~ ., data = mtcars), scope = ~ .^2, direction="both")
summary(step)


fit.2 <- lm(mpg ~ factor(am)*qsec + wt, data = mtcars)
summary(fit.2)
plot(fit.2)