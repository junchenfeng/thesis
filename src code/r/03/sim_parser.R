# load the data set
library(dplyr)
library(ggplot2)
proj_dir = getwd()
data_dir = paste0(proj_dir, '/_data/03/sim/')

exp1_data = read.table(paste0(data_dir, 'exp1.txt'),sep=',',col.names=c('i','t','j','y'))
treat_status = exp1_data %>% filter(t==1) %>% mutate(D=j-1) %>% select(i,D)
analysis_data = merge(exp1_data %>% filter(t!=1) %>% mutate(t=t/2) %>% select(i,t,y), treat_status)
summary(lm(data=analysis_data, y~t*D))
mcmc_param =  read.table(paste0(data_dir, 'exp1_param.txt'),sep=',') %>% select(V2,V3) %>% rename(l0=V2,l1=V3) %>% mutate(ldif=l1-l0)


exp_data = read.table(paste0(data_dir, 'exp2.txt'),sep=',',col.names=c('i','t','j','y'))
treat_status = exp_data %>% filter(t==1) %>% mutate(D=j-1) %>% select(i,D)
analysis_data = merge(exp_data %>% filter(t!=1) %>% mutate(t=t/2) %>% select(i,t,y), treat_status)
summary(lm(data=analysis_data, y~t*D))
mcmc_param =  read.table(paste0(data_dir, 'exp2_param.txt'),sep=',') %>% select(V2,V3) %>% rename(l0=V2,l1=V3) %>% mutate(ldif=l1-l0)
qplot(data=mcmc_param, x=ldif, geom='density')


exp3_data = read.table(paste0(data_dir, 'exp3.txt'),sep=',',col.names=c('i','t','j','y','h','e'))
treat_status = exp3_data %>% filter(t==1) %>% mutate(D=j-1) %>% select(i,D,e)
analysis_data = merge(exp3_data %>% filter(t!=1) %>% mutate(t=t/2) %>% select(i,t,y), treat_status)
summary(lm(data=analysis_data, y~t*D))
summary(lm(data=analysis_data %>% filter(i %in% treat_status$i[treat_status$e==1]), y~t*D))



mcmc_param =  read.table(paste0(data_dir, 'exp3_param.txt'),sep=',') %>% select(V2,V3) %>% rename(l0=V2,l1=V3) %>% mutate(ldif=l1-l0)
qplot(data=mcmc_param, x=ldif, geom='density')
