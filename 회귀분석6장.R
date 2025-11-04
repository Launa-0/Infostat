####################################################################
#  회귀분석

# 6장 모형비교와 변수선택법

getwd()
setwd("D:/동덕여자대학교/강의노트/2024년2학기/회귀분석/R")
save.image("6장.RData") # save(list=ls(), file="6장.RData")
rm(list=ls())
load("6장.RData")  

####################################################################


#예제 6.1 


data(longley)
str(longley)
help(longley)
cor(longley[,c(2:5,7)])
fit = lm(GNP ~ Unemployed + Armed.Forces + Population + Employed, data=longley)
summary(fit)    # show results

extractAIC(fit)
AIC(fit)

install.packages('rsq')
library(rsq)
rsq(fit)


fit0 = lm(GNP ~  Employed, data=longley)
summary(fit0)
rsq(fit0)
fit_glm = glm(GNP ~ Unemployed + Armed.Forces +  Population + Employed, data=longley)
AIC(fit_glm)
?AIC
AIC(fit)
-2*logLik(fit) + 2*6
length(coef(fit))
extractAIC(fit)
extractAIC(fit_glm)
?extractAIC
anova(fit)
attributes(fit)
fit$df.residual

library(rsq)
rsq(fit)

#  For mullticollinearity problem

install.packages("remotes")
library(remotes)
install_github("JohnHendrickx/Perturb", upgrade = "never", INSTALL_opts = c("--no-multiarch"))
library(perturb)


help(colldiag)
# colldiag(fit,scale=FALSE, center=TRUE, add.intercept=FALSE)
colldiag(fit, center=TRUE, add.intercept=FALSE)  # 다중공선성 확인

?vif
?anova
?step
library(car)
vif(fit)
?step

# Stepwise Regression
step(fit, direction="both")
step=step(fit, direction="both")

summary(step)
AIC(step)
extractAIC(step)
-2*logLik(step) + 2*5

step$anova

attributes(step)


colldiag(step,center=TRUE, add.intercept=FALSE) # 다중공선성 확인
vif(step)   # 다중공선성 확인

mm=model.matrix(step)
eigen(cor(mm[,-1]))


mm=model.matrix(fit)
mm
eigen(cor(mm[,-1]))

# 모형 비교
#  For a more comprehensive evaluation of model fit see regression diagnostics
fit1 = lm(GNP ~ Unemployed +  Population + Armed.Forces, data=longley)
summary(fit1)
logLik(fit1)
AIC(fit1)
library(car)
vif(fit1)
extractAIC(fit1)
AIC(fit1)
-2*logLik(fit1) + 2*5
step(fit1)

fit2 = lm(GNP ~ Unemployed +  Population, data=longley)
summary(fit2)
extractAIC(fit2)
AIC(fit2)

anova(fit1, fit2, test="F")


## GNP적합을 위한 대한 최종 회귀모형

colldiag(fit2,center=TRUE, add.intercept=FALSE) # 다중공선성 확인
vif(fit2)   # 다중공선성 확인
mm=model.matrix(fit2)
eigen(cor(mm[,-1]))



# All Subsets Regression

x = cbind(Unemployed, Armed.Forces, Population, Employed)
help(leaps)
lp = leaps(x, y=GNP, method="Cp")
lp


install.packages("leaps")
library(leaps)
?regsubsets
ls = regsubsets(GNP ~ Unemployed + Armed.Forces + Population + Employed, nbest=7, data=longley)
summary(ls)
library(car)
help(subsets)
x11()
subsets(ls, statistic="rsq")
subsets(ls, statistic="cp")
help(subsets)
plot(ls, scale="r2")
help(anova.lm)
help(vif)

?step
library(MASS)
?stepAIC

## 6.5 설명변수들에 대한 유의성 검정 

library(faraway)
data(savings)

?savings
str(savings)
cor(savings[,c(1:5)])

# (1) 모든 설명변수들이 유의하지 않은지에 대한 검정

fit = lm(sr ~ pop15 + pop75 + dpi + ddpi, data=savings)  # full model

summary(fit)
fit0 = lm(sr ~ 1, data=savings)
summary(fit0)
anova(fit0, fit, test="F")

# (2) dpi가 유의한지를 검정

fit0 = lm(sr ~ pop15 + pop75 + ddpi, data=savings)
summary(fit0)
anova(fit0, fit, test="F")

# (3) ddpi의 회귀계수가 0.3인지를 검정

tstat = (0.4097- 0.3)/0.197
tstat
p.val = 2*pt(tstat, df=fit$df.residual, lower.tail = F)
p.val 

fit1 = lm(sr ~ pop15 + pop75 + dpi + offset(0.3*ddpi), data=savings) # beta-ddpi=0.3
summary(fit1)

anova(fit1, fit, test="F")

# (4) pop15와 pop75의 회귀계수가 같은지를 검정

fit2 = lm(sr ~ I(pop15 + pop75) + dpi + ddpi, data=savings)  # beta_pop15=beta_pop75
summary(fit2)

anova(fit2, fit, test="F")

# (5) 설명변수 pop15과 dpi를 제외한 모형과의 차이가 있는지 검정 

fit3 = lm(sr ~  pop15 +  ddpi, data=savings)  # reduced model
summary(fit3)

anova(fit3, fit, test="F")
