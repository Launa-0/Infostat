####################################################################
#  회귀분석

# 5장. 회귀진단 및 보정

getwd()
setwd("F:/동덕여대/회귀")
save.image("5장_111A.RData") # save(list=ls(), file="5장.RData")
rm(list=ls())  #메모리 지우기
load("5장_1111.RData")  

####################################################################

#예제 5.1 R 데이터 mtcars에 대한 회귀분석과 회귀진단



install.packages("car")
library(car)
?mtcars
data(mtcars)
attach(mtcars)
str(mtcars)

mtcars[1:3,] #data
head(mtcars,3)

install.packages('psych')
library(psych)

?corr.test
corr.test(mtcars)

install.packages('Hmisc')
library(Hmisc)
?rcorr
rcorr(as.matrix(mtcars))

fit = lm(mpg ~ disp+hp+wt+drat, data=mtcars)

attributes(fit)
str(fit)
fit$coefficients
fit$residuals
fit$fitted.values

summary(fit)

?cooks.distance
cooks.distance(fit)


x11() # 그림을 다른 화면으로로
#residuals
#par(mfrow=c(1,2)) # 그래프 2개 같이 출력
par(mfrow=c(1,1))
plot(x=mtcars$mpg, y=residuals(fit), pch="*", lwd=3, col=4, main="residual")
abline(h=0, col=2, lwd=2)

plot(x=fitted(fit), y=rstandard(fit), ylim=c(-2,3), lwd=4, col=4, main="standardized residual")
abline(h=0, col=2, lwd=2)

plot(x=fitted(fit), y=rstudent(fit), ylim=c(-2,3), lwd=4, col=4, main="studentized residual")
abline(h=0, col=2, lwd=2)



dffits(fit)  #DFFITS

#influence measure
help(influence.measures)
inflm.fit = influence.measures(fit)
inflm.fit

attributes(inflm.fit)

which(apply(inflm.fit$is.inf, 1, any))
# which observations 'are' influential: 영향점만 출력
inflm.fit$is.inf
summary(inflm.fit)    # only these

mtcars[1:3,]  #data
head(mtcars,3)

#  Assessing Outliers
outlierTest(fit)    # Bonferonni p-value for most extreme obs
library(car)
help(outlierTest)
par(mfrow=c(1,1))

install.packages("EnvStats")
library(EnvStates)

?qqplot
EnvStats::qqPlot(fit$residuals,distribution = "norm", main="QQ Plot",points.col=4,line.lwd=2)    #qq plot for studentized resid
qqline(fit$residuals)

x11()
?qqnorm
qqnorm(y=fit$residuals,main="QQ plot2",col=4,lwd=2)
qqline(y=fit$residuals,col=2,lwd=2)

help(model.matrix)
help(hat)
h=hat(model.matrix(fit))
h
plot(h, type="h", xlab="case index", main="leverage plot", col=2, lwd=2)

# Partial regression plot  and Influential Observations
help(avPlots)
avPlots(fit, ask=FALSE)     # added plots

#  Cook's D plot :  identify D values > 4/(n-k-1)
cutoff = 4/(nrow(mtcars)-length(fit$coefficients))
plot(fit, which=4, cook.levels=cutoff, col=2, lwd=2)

# Influence Plot
influencePlot(fit, main="Influence Plot", sub="Circle size is proportial to Cook's Distance")
?influencePlot

#  Normality of Residuals
qqPlot(studres(fit), main="QQ Plot")  # t 분포 Q-Q plot for studentized resid
shapiro.test(fit$residuals)
?qqPlot

#  distribution of studentized residuals
help(rstandard)
help(studres)
library(MASS)

sresid = 
hist(studres(fit), freq=FALSE,  xlab="studentized residual", main="Distribution of Studentized Residuals")
xfit = seq(min(studres(fit)),max(studres(fit)), length=40)
yfit = dnorm(xfit)
lines(xfit, yfit, col=2, lwd=2)
shapiro.test(studres(fit))

#  Evaluate homoscedasticity
ncvTest(fit)      # non-constant error variance test
?ncvTest
summary(fit)
library(lmtest)
bptest(fit)

#  Plot studentized residuals vs. fitted values
library(car)
spreadLevelPlot(fit,)
?spreadLevelPlot


ls.diag(fit)   # diagnostic statistics

help(ls.diag)

#  외부 데이터로 송출
data(mtcars)
write.csv(mtcars,"D:/동덕여자대학교/강의노트/2019년2학기/회귀분석/DATA/mtcars.csv", na=" ", row.names=TRUE)

# 예제 5.2 R Galapagos 섬 데이터

install.packages("faraway")
library(faraway)

write.csv(gala,"D:/동덕여자대학교/강의노트/2019년2학기/회귀분석/DATA/gala.csv", na=" ", row.names=TRUE)
help(gala)

data(gala)
?gala
str(gala)
corr.test(gala)
ga = lm(Species ~ Area + Elevation + Nearest + Scruz + Adjacent, data=gala)
summary(ga)

shapiro.test(gala$Species)
plot(fitted(ga), resid(ga), main="fitted value vs residual", lwd=2, col=4)
abline(h=0, col=2, lwd=2)
plot(fitted(ga), rstandard(ga), main="fitted value vs standardized residual", lwd=2, col=4)
abline(h=0, col=2, lwd=2)

shapiro.test(rstandard(ga))
AIC(ga)

library(MASS)
op=par(mfrow=c(1,1))
boxcox(ga)
boxcox(ga, plotit=T)
boxcox(ga, lambda=seq(0.0, 1.0, by=0.05), plotit=T)
help(boxcox)

## 변수변환 제곱근 변환 모형 적합

ga2 = lm(sqrt(Species) ~ Area + Elevation + Nearest + Scruz + Adjacent, data=gala)
summary(ga2)
AIC(ga2)

shapiro.test(resid(ga2))
plot(fitted(ga2), rstandard(ga2), main="fitted value vs studentized residual", lwd=3, col=4)
abline(h=0, col=2, lwd=2)

library(faraway)
data(gala)
gala
write.csv(gala,"E:/수업실습/회귀분석/data/gala.csv", na=" ", row.names=TRUE)
colnames(gala[,1])="islands"
help(rstudent)
help(studres)

# 예제 5.3 R longley 데이터 에 대한 다중선형회귀모형 적합
help(longley)
data(longley)
attach(longley)
str(longley)

install.packages("Hmisc")
library(Hmisc)
?rcorr
?cor
cor(as.matrix(longley),as.matrix(longley))
library(psych)
corr.test(longley)


with(data=longley, cor.test(GNP,Unemployed, Population, Armed.Forces))

fit = lm(GNP ~ Unemployed + Population + Armed.Forces)
summary(fit)       # show results

coefficients(fit)           # model coefficents
confint(fit, level=0.95)    # CIs for model parameters
fitted(fit)                 # predicted values
residuals(fit)              # residuals
library(car)
anova(fit)                  # ANOVA table
?Anova
Anova(fit, type=3)
vcov(fit)                   # covariance matrix for model parameters
influence(fit)              # regression diagnostics
ls.diag(fit)
?influence
influence.measures(fit)
?influence.measures
?model.matrix

##  How to get MSE
h = influence(fit)$hat
mse=sum(resid(fit)**2)/fit$df.residual
s=sqrt(mse)
resid=resid(fit)
attributes(im)
attributes(fit)

r=resid/(s*sqrt(1-h))  # standardized residual 
r
rstandard(fit)

rstudent(fit)

ls.diag(fit)$stud.res
ls.diag(fit)$std.res


#  Residual Diagnostic plots
plot(fitted(fit), rstandard(fit), main="fitted value vs standardized residual", lwd=3, col=4)
abline(h=0, lwd=2, col=2)
plot(fitted(fit), rstudent(fit), main="fitted value vs studentized residual", lwd=3, col=4)
abline(h=0, lwd=2, col=2)
layout(matrix(c(1,2,3,4), 2,2))      # optional 4 graph/page
plot(fit)
studres(fit)



h=hatvalues(fit)
?hat
data(longley)
write.csv(longley,"D:/동덕여자대학교/강의노트/2019년2학기/회귀분석/DATA/longley.csv", na=" ", row.names=TRUE)
