#Question 1
data(mtcars)
fit.1 <- lm(mpg ~ factor(cyl) + wt, data = mtcars)
summary(fit.1)

#Question 2
fit.2 <- lm(mpg ~ factor(cyl), data = mtcars)
summary(fit.1)
summary(fit.2)

#Question 3
fit.3 <- lm(mpg ~ factor(cyl)*wt, data = mtcars)
summary(fit.3)
anova(fit.1,fit.3)

#Question 4
fit.4 <- lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)
summary(fit.4)

#Question 5
x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)

fit.5 <- lm(y ~ x)
hatvalues(fit.5)

#Question 6
dfbetas(fit.5)