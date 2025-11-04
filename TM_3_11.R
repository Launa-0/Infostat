getwd()
setwd('F:/동덕여대/텍마')
save.image("R수업결과.RData")
load("R수업결과.RData")

rm(list=ls())
rm(x)

x<-5
y=4
x+y
x=c(1,2,3)
y=c(4,5,6)
z=x+y

talent = read.csv('F:/동덕여대/텍마/DATA/연예인.csv',fileEncoding='euc-kr')
#한글 깨짐 방지용

talent2 = read.csv('F:/동덕여대/텍마/DATA/연예인.csv',fileEncoding='cp949')
str(talent)
talent

install.packages('readr')
library(readr)
talent3 = read_csv('F:/동덕여대/텍마/DATA/연예인.csv')

install.packages('readxl')
library(readxl)
talent4 =  read_excel('F:/동덕여대/텍마/DATA/연예인.xlsx')

ls()

install.packages('tidyverse')
library(tidyverse)

plot(diff(log(sample(rnorm(n=10000, mean = 10, sd= 1), size = 100, replace = FALSE))), 
     col = "red", type =  "l")

rnorm(n=10000, mean=10, sd=1) %>%
  sample(size=100, replace=FALSE) %>%
  log %>%
  diff %>%
  plot(col= 'red', type= 'l')
