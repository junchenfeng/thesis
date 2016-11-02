library(dplyr)
library(tidyr)
library(ggplot2)
library(stargazer)
library(gridExtra)
library(knitr)
proj_dir = getwd()


params_effort_man = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_manual.txt'), sep=',')
params_no_effort = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_no_effort.txt'), sep=',')

params_effort_man = params_effort_man[, seq(4)]
params_no_effort = params_no_effort[, seq(4)]

names(params_effort_man) = c('pre','no','vocabulary','video')
names(params_no_effort) = c('pre','no','vocabulary','video')

lrate = params_no_effort %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m1 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,0.5))
lrate = params_effort_man %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m2 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort')+xlim(c(0,0.5))

grid.arrange(m1,m2)

params_effort_man_3 = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_manual_y3_ipc.txt'), sep=',')
params_no_effort_3 = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_no_effort_y3_ipc.txt'), sep=',')

params_effort_man_3_0 = params_effort_man_3 %>% select(V1,V4,V7,V10)
params_effort_man_3_1 = params_effort_man_3 %>% select(V2,V5,V8,V11)
params_effort_man_3_2 = params_effort_man_3 %>% select(V3,V6,V8,V12)

params_no_effort_3_0 = params_no_effort_3 %>% select(V1,V4,V7,V10)
params_no_effort_3_1 = params_no_effort_3 %>% select(V2,V5,V8,V11)
params_no_effort_3_2 = params_no_effort_3 %>% select(V3,V6,V9,V12)


names(params_effort_man_3_0) = c('pre','no','vocabulary','video')
names(params_effort_man_3_1) = c('pre','no','vocabulary','video')
names(params_effort_man_3_2) = c('pre','no','vocabulary','video')

names(params_no_effort_3_0) = c('pre','no','vocabulary','video')
names(params_no_effort_3_1) = c('pre','no','vocabulary','video')
names(params_no_effort_3_2) = c('pre','no','vocabulary','video')

lrate = params_no_effort_3_0 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m3 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,1))
lrate = params_effort_man_3_0 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m4 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort ')+xlim(c(0,1))

grid.arrange(m3,m4)

lrate = params_no_effort_3_1 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m5 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,0.5))
lrate = params_effort_man_3_1 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m6 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort')+xlim(c(0,0.5))

grid.arrange(m5,m6)


lrate = params_no_effort_3_2 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m7 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,1))
lrate = params_effort_man_3_2 %>% select(-pre)%>% gather(group,val)
lrate$group = factor(lrate$group)
m8 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort')+xlim(c(0,1))

grid.arrange(m7,m8)
