library(dplyr)
library(tidyr)
library(ggplot2)
library(stargazer)
library(gridExtra)
rm(list=ls())

proj_dir = getwd()
input_file_path = paste0(proj_dir,'/_data/02/production_data.RData')
load(input_file_path)


data = workdata %>% select(uid, giveup, seq_id) %>% spread(seq_id, giveup)

names(data) = c('uid','s1','s2','s3','s4')

pattern_cnt = data %>% group_by(s1,s2,s3,s4)%>% summarize(n=n())

# condition on make an valid effort in 2nd question, what is the probability of making an effort later
pattern_stat = pattern_cnt %>% group_by(s2) %>% summarize(n0=sum(n[s3==0&s4==0]),n1r=sum(n[s3==1&s4==0]),n1t=sum(n[s3==0&s4==1]),n2=sum(n[s3==1&s4==1]))


raw_params = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain.txt'), sep=',')
lrate = data.frame(q1=raw_params$V23,q2=raw_params$V24,q3=raw_params$V25)
lrate = lrate %>% gather(qid,val)
qplot(data=lrate, x=val, col=factor(qid), geom='density')
