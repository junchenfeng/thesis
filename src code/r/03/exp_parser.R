# load the data set
library(dplyr)
library(tidyr)
library(ggplot2)
proj_dir = getwd()
data_dir = paste0(proj_dir, '/_data/03/exp/')

# whole question
no_param = read.table(paste0(data_dir,'chp3_parameter_chain_no_effort.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='no effort')
auto_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_auto.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='auto coding')
manual_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_manual.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='manual coding')
param = rbind(no_param, auto_param,manual_param)
param$model = factor(param$model, levels=c('no effort','auto coding','manual coding'))
qplot(data=param, x=val, col=group, geom='density', facets=.~model)

# circumference
no_param = read.table(paste0(data_dir,'chp3_parameter_chain_no_effort_1.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='no effort')
auto_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_1_auto.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='auto coding')
manual_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_1_manual.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='manual coding')
param = rbind(no_param, auto_param,manual_param)
param$model = factor(param$model, levels=c('no effort','auto coding','manual coding'))
qplot(data=param, x=val, col=group, geom='density', facets=.~model)



# area
no_param = read.table(paste0(data_dir,'chp3_parameter_chain_no_effort_2.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='no effort')
auto_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_2_auto.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='auto coding')
manual_param = read.table(paste0(data_dir,'chp3_parameter_chain_with_effort_2_manual.txt'),sep=',') %>%
  select(V2,V3,V4) %>% rename(no=V2,vocab=V3,video=V4) %>%
  gather(group,val) %>%
  mutate(model='manual coding')
param = rbind(no_param, auto_param,manual_param)
param$model = factor(param$model, levels=c('no effort','auto coding','manual coding'))
qplot(data=param, x=val, col=group, geom='density', facets=.~model)

