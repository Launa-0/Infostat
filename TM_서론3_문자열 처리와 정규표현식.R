#####################################################################################
# 1장_문자 텍스트 다루기

setwd("C:/동덕여자대학교/강의노트/2025년 1학기/텍스트마이닝/R")
setwd("C:/동덕여자대학교/2025년 1학기/텍스트마이닝/R")
save.image("서론3_문자열 처리와 정규표현식.RData") # save(list=ls(), file="서론2_문자열 처리와 정규표현식.RData")
rm(list=ls())
load("서론3_문자열 처리와 정규표현식.RData")  
getwd()

#####################################################################################

install.packages("tidyverse")

library(tidyverse)

# 1. 문자열 처리와 정규표현식 

# 문자열을 다루는 기본 함수
?strsplit

letters
grep(pattern="[a-z]", x=letters)

## Double all 'a' or 'b's;  "\" must be escaped, i.e., 'doubled'
gsub(x="([ab])", pattern="[a,b]", replacement="abc and ABC")
gsub(x="([$ab+])", pattern="[\\$,\\+]", replacement="ttt and uuu")

txt <- c("The", "licenses", "for", "most", "software", "are",
         "designed", "to", "take", "away", "your", "freedom",
         "to", "share", "and", "change", "it.",
         "", "By", "contrast,", "the", "GNU", "General", "Public", "License",
         "is", "intended", "to", "guarantee", "your", "freedom", "to",
         "share", "and", "change", "free", "software", "--",
         "to", "make", "sure", "the", "software", "is",
         "free", "for", "all", "its", "users")

a <- grep(pattern="[b-e]", x=txt, value = TRUE)
a
b <- grep(pattern="[b-e]", x=txt, ignore.case = TRUE, value = TRUE)
b
setdiff(b, a)

x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
# split x on the letter e
strsplit(x=x, split="e")

?regexec

# 문자열 기초

double_quote <- "\""   # 문자열에 더블 따옴표(single of double quote, ") 입력

double_quote 
double_quote <- '\"'   # 문자열에 더블 따옴표(single of double quote, ") 입력
double_quote 

single_quote <- '\''  # 문자열에 싱글 따옴표(single of single quote, ’) 입력 

single_quote

x <- c("\"", "\\", '\'')
x
writeLines(x)

?writeLines
x <- "abc\n\tabc"   # 백슬레쉬가 포함된 문자열

# \n: Enter
# \t: tab 문자를 표현

writeLines(x)

# 백슬레쉬가 포함된 문자열
x <- "abc\n\tabc"

# \n: Enter
# \t: tab 문자를 표현

# 특수문자 표현
x <- "\u00b5" # 그리스 문자 mu 표현 (유니코드)
x

writeLines(x)

# 유용한 문자열 관련 함수

?nchar
x <- "Carlos Gardel's song: Por Una Cabeza"
nchar(x)
y <- "abcde\nfghij"
nchar(y)
z <- "김동덕: 가나다라마바사"
nchar(z)
# 문자열 벡터
s <- c("abc", "가나다", "1234[]", "R programming\n", "\"R\"")

nchar(s, type = "char")
nchar(s, type = "byte")
nchar(s, type = "width")

text = sentences
str <- sentences[1:10]
str
nchar(str)

?paste

i <- 1:length(letters)

paste(letters, i)             # sep = " "

paste(letters, i, sep = "_") # sep = "-"
paste0(letters, i)           # paste(letters, i, sep = "") 동일


paste(letters, collapse = "") # collapse 인수 활용
paste0(letters)
writeLines(paste(str, collapse = "\n"))

# 3개 이상 객체 묶기
paste("Col", 1:2, c(TRUE, FALSE, TRUE), sep =" ", collapse = "<->")

# paste 함수 응용
# 스트링 명령어 실행 
exprs <- paste("lm(mpg ~", names(mtcars)[3:5], ", data = mtcars)")
exprs

?parse
?eval
sapply(1:length(exprs), function(i) coef(eval(parse(text = exprs[i]))))

eval(parse(text = exprs[1]))
?sprintf

options()$digits #
pi                        # 파이 값
sprintf("%f", pi) 
sprintf("%.3f", pi)       # 소숫점 자리수 3자리 까지 출력
sprintf("%1.0f", pi)      # 소숫점 출력 하지 않음
sprintf("%5.1f", pi)      # 출력 문자열의 길이를 5로 고정 후 소숫점 한 자리까지 출력
nchar(sprintf("%5.1f", pi))
sprintf("%05.1f", pi)     # 빈 공백에 0값 대입
sprintf("%+f", pi)        # 양수/음수 표현
sprintf("%+f", -pi)

sprintf("% f", pi)        # 출력 문자열의 첫 번째 값을 공백으로
sprintf("%-10.3f", pi)    # 왼쪽 정렬
sprintf("%d", pi)         # 수치형에 정수 포맷을 입력하면?

sprintf("%d", 100);
sprintf("%d", 20L)
sprintf("%e", pi)         # 지수형
sprintf("%E", pi)
sprintf("%.2E", pi)

sprintf("%s = %.2f", "Mean", pi)  # 문자열 

# 응용 
?apply
mn <- apply(X=cars, MARGIN=2, FUN=mean)
std <- apply(cars, 2, sd)
mn; std

# Mean ± SD 형태로 결과 출력 (소숫점 2자리 고정)
sprintf("\U00B1")
res <- sprintf("%.2f \U00B1 %.2f", mn, std)
res
resp <- paste(paste0(names(cars), ": ", res), collapse = "\n")
writeLines(resp)
names(cars)
?substr

address <- "서울특별시 성북구 월곡동 동덕여자대학교"
university= substr(address, start = 15, stop = nchar(address))
university
nchar(address)
# 문자열 벡터에서 각 원소 별 적용
str
substr(str, 5, 15)

?tolower

x <- "MiXeD cAsE 123"
chartr("iXs", "why", x)
chartr("a-cX", "D-Fw", x)
tolower(x)
toupper(x)
casefold(x, upper =TRUE)

LETTERS; tolower(LETTERS)
letters; toupper(letters)

install.packages('glue')

library(glue)
?glue

name <- "Kim Dongduk"
glue("My name is {name}.")

# 긴 문자열과 R 객체를 결합 시 함수 내 “,”로 로 구분 후 결합 가능함 

name <- "Kim Dongduk"
age <- 42
anniversary <- as.Date("2022-03-05")
anniversary

glue("My name is {name}, ", 
     "My age next year is {age + 1}, ", 
     "My wedding aniversary is {anniversary}.")

# 함수 내 임시변수를 활용한 문자열 결함

glue("My name is {name_temp}, ", 
     "My age next year is {age_temp + 1}, ", 
     "My wedding aniversary is {anniversary_temp}.", 
     name_temp = "Kim Dongduk", 
     age_temp = 42, 
     anniversary_temp = as.Date("2022-03-05"))

# 데이터 프레임 변수에 일괄 적용 가능

dat <- head(iris)
dat
glue("The {dat$Species} has a sepal length {dat$Sepal.Length}")

# 단순히 새로 줄바꿈(Enter)으로 두 줄 이상 문자열을 생성 가능

glue("The first line
     The second line
     The third line")

# 문장 끝에 \\를 붙이면 줄바꿈이 실행되지 않음

glue("The first line, \\
     The second line, \\
     The third line")

# 이중 중괄호({{}}): {R 객체명}을 그대로 출럭

name <- "Kim Dongduk"
glue("My name is {name}, not {{name}}.")

# .open 및 .close를 사용해 대체 구분기호 지정 가능

one <- 1
glue("The value of $\\int (\\sqrt{2\\pi}\\sigma)^{-1}", 
     "\\exp[-(x - \\mu)^2/2\\sigma^2] dx$", 
     " is $<<one>>$", .open = "<<", .close = ">>")

glue("The value of $\\int (\\sqrt{2\\pi}\\sigma)^{-1}", 
     "\\exp[-(x - \\mu)^2/2\\sigma^2] dx$", 
     " is $#one#$", .open = "#", .close = "#")

glue("The value of $\\int (\\sqrt{2\\pi}\\sigma)^{-1}", 
     "\\exp[-(x - \\mu)^2/2\\sigma^2] dx$", 
     " is $ 1 $")

# 위 문자열을 Rmarkdown 문서에 수식으로 표현하고 싶다면 inline R code chunk 사용

`r glue("The value of $\\int (\\sqrt{2\\pi}\\sigma)^{-1}",
        "\\exp[-(x - \\mu)^2/2\\sigma^2] dx$", " is $<<one>>$", .open = "<<", .close = ">>") `

# grep(), grepl()  

?grep

letters                   # 26개 알파벳을 갖는 벡터임
grep(pattern="[a-z]", x=letters)

x <- c("Equator", "North Pole", "South Pole")

grep("Pole", x, value = T) # x에서 Pole 이 있는 원소의 문자열 반환

grep("Pole", x, value = F) # x에서 Pole 이 있는 원소의 색인 반환

grep("Eq", x)              # x에서 Eq를 포함한 원소 색인 반환

txt <- c( "The", "licenses", "for", "most", "software", "are", "designed", "to", "take", "away", 
          "your", "freedom","to", "share", "and", "change", "it.", "", "By", "contrast", "the", 
          "GNU", "General", "Public", "License", "is", "intended", "to", "guarantee", "your", 
          "freedom", "to", "share", "and", "change", "free", "software", "to", "make", 
            "sure", "the", "software", "is", "free", "for", "all", "its", "", "--", "users")

a <- grep(pattern= "[b-e]", x=txt, value = TRUE); a                         # 대소문자 구분함

b <- grep(pattern= "[b-e]", x=txt, ignore.case = TRUE, value = TRUE); b     # 대소문자 구분하지 않음

?sub
library(tidyverse)
# Titanic data 불러오기
url1 <- "https://raw.githubusercontent.com/"
url2 <- "agconti/kaggle-titanic/master/data/train.csv"
titanic <- read_csv(paste0(url1, url2))

write.csv(titanic, file='titanic.csv')

pname <- titanic$Name       # 승객이름 추출 
str(pname)
g <- grepl("James", pname)  # 승객 이름이 James 인 사람만 추출
pname[g]

jude <- c("Hey Jude, don't make it bad", 
          "Take a sad song and make it better", 
          "Remember to let her into your heart", 
          "Then you can start to make it better")

sub(pattern="a", replacement="X", x=jude)
gsub(pattern="a", replacement="X", x=jude)
sub(pattern=" ", replacement="_", jude)
gsub(pattern=" ", replacement="_", jude)

x <- c("Darth Vader: If you only knew the power of the Dark Side. 
       Obi-Wan never told you what happend to your father", 
       "Luke: He told me enough! It was you who killed him!", 
       "Darth Vader: No. I'm your father")

grep(pattern="you", x=x); grepl(pattern="you", x=x)    # grep 계열 함수
regexpr(pattern="you", text=x)       # 각 x의 문자열에서 you가 처음 나타난 위치 및 길이 반환
regexpr(pattern="father", text=x)    # 패턴을 포함하지 않은 경우 -1 반환

# substr() 함수와 regexpr() 함수를 이용하여 텍스 내 원하는 문자 추출을 할 수 있음  

idx <- regexpr(pattern="father", text=x)
idx
attr(idx, "match.length")
substr(x, idx, idx + attr(idx, "match.length") - 1)

gregexpr(pattern="you", text=x) # 각 x의 문자열에서 you가 나타난 모든 위치 및 길이 반환

gregexpr(pattern="father", text=x) # 패턴을 포함하지 않은 경우 -1 반환

bla <- c("I like statistics", 
         "I like R programming", 
         "I like bananas", 
         "Estates and statues are too expensive")

grepl(pattern="like", x=bla)

grepl(pattern="are", x=bla)

grepl(pattern="(like|are)", x=bla)

# 찾고자 하는 패턴을 두 그룹으로 나눌 때 유용
gregexpr(pattern="stat", text=bla) 
gregexpr(pattern="(st)(at)", text=bla) 

regexec(pattern="(st)(at)", text=bla) 

?strsplit
x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
strsplit(x=x, split="e")   # split x on the letter e


jude <- c("Hey Jude, don't make it bad", 
          "Take a sad song and make it better", 
          "Remember to let her into your heart", 
          "Then you can start to make it better")
strsplit(x=jude, split=" ")


jude_w2 <- strsplit(x=jude, split="\\s|'") # 공백, 쉼표가 있는 경우 구분
jude_w2


# 5. 정규표현식 

# 메타문자 (Metacharacters)

money = "$money"
sub(pattern="$", replacement="", x=money)

sub(pattern="\\$", replacement="", x=money)    # $를 없앰

library(stringr)
str <- sentences[1:10]    # 페키지 stringr에 있는 sentences는 문자열 연습을 위한 720개의 표본 문자 벡터임
str2 <- str[1:2]      # 마침표가 있는 위치 반환
str2 
regexpr(pattern=".", text=str2)


regexpr("\.", str2) # 에러 출력

regexpr("\\.", str2)   # 정확한 표현

gsub(x="([\ab])", pattern="[\\$]", replacement="abc and ABC")
gsub(x="([\ab+])", pattern="[\\$, \\+]", replacement="abc and ABC")
gsub(x="([\ab+])", pattern="[\\$, \\+]", replacement="abc and ABC")
gsub(x="($[\ab+])", pattern="[\\$, \\+]", replacement="TT")

gsub(x="([\ab+$ta])", pattern="[\\$ \\+]", replacement="TTT")
gsub(x="([\ab+$ta])", pattern="[\\$, \\+]", replacement="TTT")

gsub(x="([\ab+$ta])", pattern="[\\$ \\+]", replacement= "TTT")
gsub(x= "([\ab+$ta]\u)", pattern= "[\\$ \\+]", replacement= "TTT")
gsub(x= "([\ab+$ta\\])", pattern= "[\\$ \\+]", replacement= "TTT")
gsub(x= "([\ab+$ta\\S])", pattern= "\\+", replacement= "T")

gsub(x= "([\ab+$ta])\\\\", pattern= "[\\$]", replacement= "T")
gsub(x= "([\ab+$ta])\\", pattern= "[\\$]", replacement= "T")
gsub(x= "([\ab+$ta])\\", pattern= "[\\]", replacement= "T")
gsub(x= "([\ab+$ta])\\\\", pattern= "\\+", replacement= "T")
gsub(x= "([\ab+$ta])\\\\", pattern= "[\\]", replacement= "T")
gsub(x= "([\ab+$ta])\\\\", pattern= "\\", replacement= "T")
gsub(x= "([\ab+$ta]) \\\\", pattern= "[\\+]", replacement= "T")  

jude <- c("Hey Jude, don't make it bad", 
          "Take a sad song and make it better", 
          "Remember to let her into your heart", 
          "Then you can start to make it better")


grepl(pattern=".", x=jude)   # 문자열 자체가 존재하니까 참값 반환
grepl(pattern=".", x="#@#%@FDSAGF$%") 

grepl(pattern=".", x="")     # 문자없음 ""

 
bla2 <- c("aac", "aab", "accb", "acadb")
g <- grepl(pattern="a.b", x=bla2)  # a로 시작하고 중간에 어떤 글자가 하나 존재하고 b로 끝나는 패턴
bla2[g]

g <- grepl(pattern="a..b", x=bla2) # a와 b 사이 어떤 두 문자 존재하는 패턴
bla2[g]

grepl(pattern="a+", x=c("ab", "aa", "aab", "aaab", "b")) # "a"를 적어도 하나 이상 포함한 원소 반환

# "l"과 "n" 사이에 "o"가 하나 이상인 원소 반환
grepl(pattern="lo+n", x=c("bloon", "blno", "leno", "lnooon", "lololon"))

gsub(x= "([\ab+$ta\\S])", pattern= "[\\+]", replacement= "T")  # “+”도 변환하고 “\”도 변환
gsub(x= "([\ab+$ta\\S])", pattern= "\\+", replacement= "T")

gsub(x= "([\ab+$ta\\S])", pattern= "\\", replacement= "T") # pattern= "\\"를 사용하면 에러 발생
gsub(x= "([\ab+$ta]) \\\\", pattern= "[\\]", replacement= "T")  

gsub(x= "([\ab+$ta]) \\\\", pattern= "[\\+]", replacement= "T")  

# xx가 "a"를 0 또는 1개 이상 포함하고 있는가?
xx <- c("bbb", "acb", "def", "cde", "zde", "era", "xsery")

g <- grepl(pattern="a*", x=xx)  # "a" 존재와 상관 없이 모든 문자열이 조건에 부합
xx[g]

# "aab"와 "c" 사이에 "d"가 없거나 하나 이상인 경우 
# "caabec"인 경우 "aab"와 "c" 사이에 "e"가 존재하기 때문에 FALSE
grepl(pattern="aabd*c", x=c("aabddc", "caabec", "aabc"))

xx <- c("ac", "abbc", "abc", "abcd", "abbdc")

g <- grepl(pattern="ab?c", x=xx) ## "a"와 "c" 사이 "b"가 0개 또는 1개 포함
xx[g]

yy <- c("aabc", "aabbc", "daabec", "aabbbc", "aabbbbc")
g <- grepl(pattern="aabb?c", x=yy) ## "aab"와 "c" 사이에 "b"가 0개 또는 1개 있는 경우 일치
yy[g]


g <- grepl(pattern="^The", x=str)  # str에서 "The"로 시작하는 문자열 반환
str[g]

# [^]: 대괄호(straight bracket) 안에 첫 번째 문자가 ^인 경우 ^뒤에 있는 문자들을 제외한 모든 문자와 매치

xx <- c("abc", "def", "xyz", "werx", "wbcsp", "cba", 'tabc')
grep(pattern="[^abc]", x=xx, value=T) # "a", "b", "c"로 시작한 문자열 제외

grep(pattern="^[abc]", x=xx, value=T)

# ^[]: [] 안에 들어간 문자 중 어느 한 단어로 시작하는 문자열 반환
xx <- c("def", "wasp", "sepcial", "statisitc", "abbey load", "cross", "batman")
g <- grepl(pattern="^[abc]", x=xx)
xx[g]

x <- c("Darth Vader: If you only knew the power of the Dark Side. 
         Obi-Wan never told you what happend to your father", 
       "Luke: He told me enough! It was you who killed him!", 
       "Darth Vader: No. I'm your father")

g <- grepl(pattern="father$", x=x)
g
x[g]
writeLines(x[g])



# {} 앞의 문자 패턴이 {} 안에 숫자만큼 반복되는 패턴을 매치
# {n}: 정확히 n 번 매치
# {n,m}: n 번에서 m 번 매치
# {n, }: 적어도 n 번 이상 매치



xx <- c("tango", "jazz", "swing jazz", "hip hop", "groove", "rock'n roll", "heavy metal")

g <- grepl(pattern="z{2}", x=xx)  # "z"가 정확히 2번 반복되는 원소 반환
xx[g]

yy <- c("deer", "abacd", "abcd", "daaeb", "eel", "greeeeg")
g <- grepl(pattern="e{2,}", x=yy)  # "e"가 2번 이상 반복되는 원소 반환
g
yy[g]

# "b"가 2번 이상 4번 이하 반복되고 앞에 "a"가 있는 원소 반환
zz <- c("ababababab", "abbb", "cbbe", "xabbbbcd")
g <- grepl(pattern="ab{2,4}", x=zz)
zz[g]

# *는 {0,}, +는 {1,}, ?는 {0,1}과 동일한 의미를 가짐

# ab가 1~4회 이상 반복되는 문자열 반환
g <- grepl(pattern="(ab){1,4}", x=zz)
zz[g]

# "The"로 시작하고  "punch"가 포함된 문자열 반환
g <- grepl(pattern="^(The)+.*(punch)", x=str)
str[g]

g <- grepl(pattern="(is|was)", x=str)
str[g]

g <- grepl(pattern="(are|were)", x=str)
str[g]

# 수열 (sequences)

# 처음 나오는 숫자를 '_'로 대체
sub("\\d", "_", "Avengers: Infinity War, 2018")

# 모든 숫자를 '_'로 대체
 gsub("\\d", "_", "Avengers: Infinity War, 2018")

# 숫자가 아닌 처음 나오는 문자를 '-'로 대체
sub("\\D", "-", "Avengers: Infinity War, 2018")

# 숫자가 아닌 모든 문자를 '-'로 대체
gsub("\\D", "-", "Avengers: Infinity War, 2018")

# 처음 나오는 공백을 '_'로 대체
sub("\\s", "_", "Avengers: Infinity War, 2018")

# 모든 공백을 '_'로 대체
gsub("\\s", "_", "Avengers: Infinity War, 2018")


# 처음 나오는 단어 경계(zero width word boundary) 위치를  '_'로 대체
sub("\\b", "_", "Avengers - Infinity War, 2018 !")


# 모든 단어 경계(word boundary) 위치를  '_'로 대체
gsub("\\b", "_", "Avengers - Infinity War, 2018 !")

# 처음 나오는 non word boundary (단어 경계가 아닌 위치)를  '_'로 대체
sub("\\B", "_", "Avengers: Infinity War, 2018 !")

# 모든 non word boundary (단어 경계가 아닌 위치)를  '_'로 대체
gsub("\\B", "_", "Avengers: Infinity War, 2018 !")

# 처음 나오는 단어의 문자(word character)를 '_'로 대체     
sub("\\w", "_", "Avengers: Infinity War, 2018 !")       # word character의 의미: 영어 대소문자, 숫자 

# 모든 단어의 문자(word character)를  '_'로 대체
gsub("\\w", "_", "Avengers: Infinity War, 2018 !")


# 처음 나오는 단어가 아닌 문자(non word)를 '_'로 대체
sub("\\W", "_", "Avengers: Infinity War, 2018 !")            

# 모든 단어가 아닌 문자(non word)를  '_'로 대체
gsub("\\W", "_", "Avengers: Infinity War, 2018 !")


#  \w 를 이용해 email 추출

email <- c("demo@naver.com", 
           "sample@gmail.com", 
           "coffee@daum.net", 
           "redbull@nate.com", 
           "android@gmail.com", 
           "secondmoon@gmail.com", 
           "zorba1997@korea.re.kr")

# 이메일 주소가 naver 또는 gmail만 추출
g <- grepl(pattern="\\w+@(naver|gmail)\\.\\w+", x=email)
email[g]

# 숫자를 포함하는 문자열 추출: \d
ex <- c("ticket", "51203", "+-.,!@#", "ABCD", "_", "010-123-4567")
g <- grepl(pattern="\\d", x=ex)
ex[g]

# 뒤쪽 공백문자 제거
xx <- c("some text on the line 1; \n and then some text on line two        ")
sub(pattern="\\s+$", "", x=xx)

# 영문자(소문자 및 대문자 포함), 숫자, 언더바(_)를 제외한 문자 포함 
g <- grepl(pattern="\\W", x=ex)
ex[g]

# 숫자를 제외한 모든 문자 반환
g <- grepl(pattern="\\D", x=ex)
ex[g]


# 영문자, 숫자, 언더바를 제외한 모든 문자 포함하고
# 숫자와 특수문자를 포함하는 문자열도 제외
g <- grepl(pattern="\\W\\D", x=ex)
ex[g]

## 공백, 탭을 제외한 모든 문자 포함

blank <- c(" ", "_", "abcd", "\t", "%^$#*#*") 
g <- grepl(pattern="\\S", x=blank)
blank[g]

movie <- c("terminator 3: rise of the machiens", 
           "les miserables", 
           "avengers: infinity war", 
           "iron man", 
           "indiana jones: the last crusade", 
           "irish man", 
           "mission impossible", 
           "the devil wears prada", 
           "parasite (gisaengchung)", 
           "once upon a time in hollywood")

# 각 영화제목의 첫글자를 대문자로 변경
# \b는 단어의 양쪽 가장 자리의 빈 문자를 의미
# \\1은 () 첫 번째 그룹, \\U는 대문자(perl)
gsub(pattern="\\b(\\w)", "\\U\\1", x=movie)
gsub(pattern="\\b(\\w)", "\\U\\1", x=movie, perl = T)
gsub(pattern="\\b(\\w)", "\\U", x=movie, perl = F)
gsub(pattern="\\b(\\w)", "\\1", x=movie, perl = T)

gsub(x="([\ab+])", pattern="[\\$, \\+]", replacement="ttt and uuu")
grepl(pattern=".", x="#@#%@FDSAGF$%") 

?substr

x <- c("Darth Vader: If you only knew the power of the Dark Side. 
         Obi-Wan never told you what happend to your father", 
       "Luke: He told me enough! It was you who killed him!", 
       "Darth Vader: No. I'm your father")

idx <- regexpr(pattern="father", text=x)    # 패턴을 포함하지 않은 경우 -1 반환
k=substr(x=x, start=idx, stop=idx + attr(idx, "match.length") - 1)

k=substr(x=x, start=idx, stop=idx+5)

# 문자 집단(character classes)

# 엑셀에서 ()로 표시된 음수 데이터를 읽어온 경우
# 이를 음수로 표시
num <- c("0.123", "0.456", "(0.45)", "1.25")
gsub(pattern="\\(([0-9.]+)\\)", "-\\1", x=num)

gsub(pattern="\\(([0-9]+)\\)", "-\\1", x=num)

gsub(pattern="\\(([0-9 \\.]+)\\)", "-\\1", x=num)

# some string
(transport = c("car", "bike", "plane", "boat"))

# e 또는 I 가 있는 위치를 나타냄
grep(pattern = "[ei]", transport) 


# some numeric strings
(numerics = c("123", "17-April", "I-II-III", "R 3.0.1"))


# 0 또는 1이 있는 문자열을 나타냄
grep(pattern = "[01]", numerics, value = TRUE)

# 숫자(digit)를 포함하는 문자열을 나타냄
grep(pattern = "[0-9]", numerics, value = TRUE)

# 숫자(digit)외의 문자를 포함하는 문자열을 나타냄
grep(pattern = "[^0-9]", numerics, value = TRUE)

txt <- c("        신종 코로나바이러스 감염증(코로나19) 환자 가운데 회복해서 항체가
         생긴 사람 중 절반가량은 체내에 바이러스가 남아 있는 것으로 나타났다.   ")
txt
# 모근 공백 제거
gsub(pattern ="\\s", "", x=txt)

# 앞쪽 공백만 제거
gsub(pattern ="^\\s+", "", x=txt)

# 뒤쪽 공백만 제거
gsub(pattern ="\\s+$", "", x=txt)

# 양쪽에 존재하는 공백들 제거
gsub(pattern ="(^\\s+|\\s+$)", "", x=txt)

# 가운데 \n 뒤에 존재하는 공백들을 없애려면??
gsub(pattern ="(^\\s+| {2,}|\\s+$)", "", x=txt)

# 필요한 표현식

# 처음 세 자리: ^(01)\\d{1}
# 가운데 3~4자리: -\\d{3,4}
# 마지막 4자리: -\\d{4}

phone <- c("042-868-9999", "02-3345-1234", 
           "010-5661-7578", "016-123-4567", 
           "063-123-5678", "070-5498- 1904", 
           "011-423-2912", "010-6745-2973")

g <- grepl(pattern ="^(01)\\d{1}-\\d{3,4}-\\d{4}", x=phone)
phone[g]


# POSIX 문자 집단(Character Classes)

movie <- c("terminator 3: rise of the machiens", 
           "les miserables", 
           "avengers: infinity war", 
           "iron man", 
           "indiana jones: the last crusade", 
           "irish man", 
           "mission impossible", 
           "the devil wears prada", 
           "parasite (gisaengchung)", 
           "once upon a time in hollywood")

# 각 영화제목의 첫글자를 대문자로 변경
# \b는 단어의 양쪽 가장 자리의 빈 문자를 의미
# \\1은 () 첫 번째 그룹, \\U는 대문자(perl)
gsub(pattern="\\b(\\w)", "\\U\\1", x=movie, perl = T)

# 엑셀에서 ()로 표시된 음수 데이터를 읽어온 경우
# 이를 음수로 표시
num <- c("0.123", "0.456", "(0.45)", "1.25")
gsub(pattern="\\(([0-9.]+)\\)", "-\\1", x=num)

library(stringr)

# 문자열 잇기 : str_c()

?word
?str_c
?str_length
?str_sub
?str_dup
?str_trim
?str_pad
?str_wrap
?sub
?nchar
?substr 

(str <- 'abc.def..123.4568.999') 
word(string=str, start=1, sep = fixed('..'))         #  sep는 단어의 사이를 구분 짓는 분리자
word(string=str, start=2, sep = fixed('..'))

install.packages("stringr")
library(stringr)
str_c("I", "am", "very", "happy", "to", "see", "you","!")

paste0("I", "am", "very", "happy", "to", "see", "you","!")

str_c("I", "am", "very", "happy", "to", "see", "you","!", sep="_")

paste("I", "am", "very", "happy", "to", "see", "you","!", sep="_")

str_c("I", "am", "very", "happy", "to", "see", "you","!", sep=" ")

paste("I", "am", "very", "happy", "to", "see", "you","!")
?paste

str_count(c("a.", "...", ".a.a"), ".")
str_count(c("a.", "...", ".a.a"), "\\.")
str_count(c("a.", "...", ".a.a"), fixed("."))


some_text = c("one", "two", "three", NA, "five")


nchar(some_text)
str_length(some_text)

some_factor = factor(c(1, 1, 1, 2, 2, 2), labels = c("good", "bad"))
some_factor

nchar(as.character(some_factor)) 

str_length(some_factor)

warning = "아빠 밥좀많이먹지마세요"
str_sub(warning, start=1, end=5)




substr(warning, start=1, stop=5) # base::substr

str_sub("알았다니까", start=1:3)
str_sub("알았다니까", start=-4, end=-1)

substr("알았다니까", start=-4, stop=-2)

text.a = c("abcde", "가나다라마", "12345")
str_sub(text.a, start=-4, end=-1)

(warning = "아빠 밥좀많이먹지마세요")
str_sub(warning, 1, 2) <-"엄마"
warning

str_sub(warning, -5, -1) <-"드세요" 
warning

str_sub(warning,  c(1,4), c(2,5)) <-c("아빠", "고기좀")
warning

str_dup("엄마,사랑해!", times=3)

str_dup("엄마,사랑해!", times=1:3)

words=c("수박", "바나나", "포도", "사과", "딸기")
str_dup(words, 2)
str_dup(words, 1:5)

letters

str_pad("몰라", width=10)
str_pad("몰라", width=10, side="right")
str_pad("몰라", width=10, side="both")
str_pad("몰라", width=10, pad="#")
str_pad("몰라", width=10, side="right",  pad="#")
str_pad("몰라", width=10, side="both", pad="#")
str_pad(string="몰라", width=10, side="both", pad="#")
        

bad_text = c("This", " example ", "has several ", " whitespaces ")
str_trim(bad_text, side = "left")
str_trim(bad_text, side = "right")
str_trim(bad_text, side = "both")
str_trim(bad_text) # default: both


# 3. R 정규 표현식

help(regex)
help(regexp)
?sub
money = "$money"
sub(pattern="$", replacement="", x=money)

sub(pattern="\\$", replacement="", x=money)

x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
# split x on the letter e
strsplit(x=x, split="e")


?grep
# 처음 나오는 숫자를 '_'로 대체
sub("\\d", "_", "Avengers: Infinity War, 2018")

# 모든 숫자를 '_'로 대체
gsub("\\d", "_", "Avengers: Infinity War, 2018")

# 숫자가 아닌 처음 나오는 문자를 '-'로 대체
sub("\\D", "-", "Avengers: Infinity War, 2018")

# 숫자가 아닌 모든 문자를 '-'로 대체
gsub("\\D", "-", "Avengers: Infinity War, 2018")

# 처음 나오는 공백을 '_'로 대체
sub("\\s", "_", "Avengers: Infinity War, 2018")

# 모든 공백을 '_'로 대체
gsub("\\s", "_", "Avengers: Infinity War, 2018")


#처음 나오는 단어경계(zero width word boundary) 위치를  '_'로 대체
sub("\\b", "_", "Avengers - Infinity War, 2018 !")

#모든 단어경계(word boundary) 위치를  '_'로 대체
gsub("\\b", "_", "Avengers - Infinity War, 2018 !")

#처음 나오는 non word boundary (단어경계가 아닌 위치)를  '_'로 대체
sub("\\B", "_", "Avengers: Infinity War, 2018 !")

#모든 non word boundary (단어경계가 아닌 위치)를  '_'로 대체
gsub("\\B", "_", "Avengers: Infinity War, 2018 !")

#처음 나오는 단어의 첫글자(word character)를 '_'로 대체
sub("\\w", "_", "Avengers: Infinity War, 2018 !")

#모든 단어의 글자(word character)를  '_'로 대체
gsub("\\w", "_", "Avengers: Infinity War, 2018 !")

#처음 나오는 단어가 아닌 문자(non word)를 '_'로 대체
sub("\\W", "_", "Avengers: Infinity War, 2018 !")

#모든 단어가 아닌 문자(non word)를  '_'로 대체
gsub("\\W", "_", "Avengers: Infinity War, 2018 !")


## Character Classes


# some string
(transport = c("car", "bike", "plane", "boat"))

# look for e or i
grep(pattern = "[ei]", transport) 

grep(pattern = "[ei]", transport, value = TRUE)
?grepl
?regexpr
?strsplit

# some numeric strings
(numerics = c("123", "17-April", "I-II-III", "R 3.0.1"))

# match strings with 0 or 1
grep(pattern = "[01]", numerics, value = TRUE)

# match any digit
grep(pattern = "[0-9]", numerics, value = TRUE)

# negated digit
grep(pattern = "[^0-9]", numerics, value = TRUE)

strings <- c("abcd", "cdab", "cabd", "c abd")
strings
grep("ab", strings, value = TRUE)
grep("^ab", strings, value = TRUE)
grep("ab$", strings, value = TRUE)
grep("\\bab", strings, value = TRUE)


#  Quantifier

# people names
people = c("rori", "emilia", "matteo", "mehmet", "filipe", "anna", "tyler", "rasmus", "jacob", "youna", "flora", "adi")
people

# match m at most once
grep(pattern = "m?", people, value = TRUE)

# match m exactly once
grep(pattern = "m{1}", people, value = TRUE, perl = FALSE)

# match m  zero or more times, and t
grep(pattern = "m*t", people, value = TRUE)

# match t zero or more times, and m
grep(pattern = "t*m", people, value = TRUE)

# match m one or more times
grep(pattern = "m+", people, value = TRUE)

# match m one or more times, and t
grep(pattern = "m+.t", people, value = TRUE)

# match t exactly twice
grep(pattern = "t{2}", people, value = TRUE)



strings <- c("a", "ab", "acb", "accb", "acccb", "accccb")
strings
grep("ac*b", strings, value = TRUE)
grep("ac+b", strings, value = TRUE)
grep("ac?b", strings, value = TRUE)
grep("ac{2}b", strings, value = TRUE)
grep("ac{2,}b", strings, value = TRUE)
grep("ac{2,3}b", strings, value = TRUE)
stringr::str_extract_all(strings, "ac{2,3}b", simplify = TRUE)

strings <- c("^ab", "ab", "abc", "abd", "abe", "ab 12")
strings
grep("ab.", strings, value = TRUE)
grep("ab[c-e]", strings, value = TRUE)
grep("ab[^c]", strings, value = TRUE)
grep("^ab", strings, value = TRUE)
grep("\\^ab", strings, value = TRUE)
grep("abc|abd", strings, value = TRUE)

?gsub
gsub(pattern="(ab) 12", replacement="\\1 34", x=strings)

?word

# 4. Regex functions in stringr




?str_detect

# some objects
objs = c("pen", "pencil", "marker", "spray")

# detect pen
str_detect(objs, "pen")

# select detected macthes
objs[str_detect(objs, "pen")]

# some strings
strings = c("12.Jun 2002","12 Jun 2002", " 8 September 2004 ", "22-July-2009 ","01 01 2001", "date", "02.06.2000","xxx-yyy-zzzz", "$2,600")
# date pattern (month as text)
dates = "([0-9]{1,2})[- .]([a-zA-Z]+)[- .]([0-9]{4})"
dates = "([0-9]{1,2})[-   .]([a-zA-Z]+)[- .]([0-9]{4})"
dates = "([0-9]{1,2})[ ]([a-zA-Z]+)[- .]([0-9]{4})"
str_detect(strings, pattern=dates)

?str_extract

# tweets about Paris
paris_tweets = c(
  "#Paris is chock-full of cultural and culinary attractions",
  "Some time in #Paris along Canal St.-Martin famous by #Amelie",
  "While you're in #Paris, stop at cafe: http://goo.gl/yaCbW",
  "Paris, the city of light")

# paris_tweets

# hashtag pattern
hash = "#[a-zA-Z]{1,}"

# extract (first) hashtag
str_extract(paris_tweets, pattern=hash)

# extract (all) hashtags
str_extract_all(paris_tweets, pattern="#[a-zA-Z]{1,}")

?str_extract_all

?str_match

# string vector
strings = c("12 Jun 2002", " 8 September 2004 ", "22-July-2009 ", 
            "01 01 2001", "date", "02.06.2000",
            "xxx-yyy-zzzz", "$2,600")

# date pattern (month as text)
dates = "([0-9]{1,2})[- .]([a-zA-Z]+)[- .]([0-9]{4})"

# extract first matched group
str_match(strings, pattern=dates)

?str_match_all

# tweets about Paris
paris_tweets = c(
  "#Paris is chock-full of cultural and culinary attractions",
  "Some time in #Paris along Canal St.-Martin famous by #Amelie",
  "While you're in #Paris, stop at cafe: http://goo.gl/yaCbW",
  "Paris, the city of light")

# match (all) hashtags in paris_tweets
str_match_all(paris_tweets, pattern="#[a-zA-Z]{1,}")


?str_locate

# locate position of (first) hashtag
str_locate(paris_tweets, pattern="#[a-zA-Z]{1,}")



# locate (all) hashtags in 
paris_tweets

str_locate_all(paris_tweets, pattern="#[a-zA-Z]{1,}")

?str_replace

# city names
cities = c("San Francisco", "Barcelona", "Naples", "Paris")

# replace first matched vowel
str_replace(cities, pattern="[aeiou]", replacement=";")

# replace all matched vowel
str_replace_all(cities, pattern = "[aeiou]", replacement=";")

# replace all matched consonants
str_replace_all(cities, pattern = "[^aeiou]", ";")

txt <- "치킨은!! 맛있다. xyz 정말 맛있다!@#"
txt
str_replace_all(string = txt, pattern = "[^가-힣]", replacement = " ")

str_trim("  String with trailing and leading white space\t")
str_trim("\n\nString with trailing and leading white space\n\n")

?str_squish
str_squish("  String with trailing,  middle, and leading white space\t")
str_squish("\n\nString with excess,  trailing and leading white   space\n\n")

?str_split

fruits <- c(
  "apples and oranges and pears and bananas",
  "pineapples and mangos and guavas"
)

str_split(string=fruits, pattern=" and ")
str_split(fruits, pattern=" and ", simplify = TRUE)

# Specify n to restrict the number of possible matches
str_split(fruits, " and ", n = 3)
str_split(fruits, " and ", n = 2)
# If n greater than number of pieces, no padding occurs
str_split(fruits, " and ", n = 5)

# Use fixed to return a character matrix
str_split_fixed(fruits, " and ", 3)
str_split_fixed(fruits, " and ", 4)

str_split(fruits, pattern=" and ", n=3,  simplify = TRUE)

Text1 = "  String with trailing and leading white space \t"
str_trim(Text1)

Text2 = " \n \nString with trailing and leading white space \n \n"
str_trim(Text2)

Text3 = "  String with trailing,  middle, and leading white space\t"
str_squish(Text3)

Text4 = "\n\nString with excess,  trailing and leading white   space\n\n"
str_squish(Text4)


raw_moon <- readLines("DATA/문재인출마선언문.txt", encoding = "UTF-8")    # 문자열 벡터임

moon <- raw_moon %>%
  str_replace_all("[^가-힣]", " ") %>%  # 한글만 남기기
  str_squish()   %>%                        # 연속된 공백 제거
  as_tibble()    %>%                        # tibble로 변환
  filter(value!="")

write.csv(x=moon, file="moon.csv")
write_csv(x=moon, file="moon.csv")
write_csv(x=moon, file="moon.csv", locale=locale('ko',encoding='UTF-8'))
write_delim(x=moon, file="moon.csv", delim = ",")
moon2 =read.csv("moon.csv", locale=locale('ko',encoding='cp949'))

moon
    
# 6. stringr 패키지로 문자열 다루기 

library(stringr)                
?word

play = c("아빠 나랑 놀아줘요!", "나도 같이 놀고 싶다.")

word(string=play, 1); word(string=play, 2)


word(play, -1)

play = c("아빠 나랑 놀아줘요!", "나도 같이 놀고 싶다.")
word(play, 1, 2)
word(play, 1, 3)

word(play, 2, -1)

play = c("아빠 나랑 놀아줘요!", "나도 같이 놀고 싶다.")
word(play[2], 1, 1:4)

word(play[2], 1:4, -1)

(str <- 'abc.def..123.4568.999') 
word(str, 1, sep = fixed('..'))
word(str, 2, sep = fixed('..'))
