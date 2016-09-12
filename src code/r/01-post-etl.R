proj_dir = getwd()

library(dplyr)
library(tidyr)
library(ggplot2)

proj_dir = getwd()
sim_data_path = paste0(proj_dir,'/_data/01/res/2/sim.txt')
data_2 = read.table(sim_data_path, sep=',', col.names=c('i', 't', 'y', 'x', 'e', 'a'))
data_2$kpid=2
sim_data_path = paste0(proj_dir,'/_data/01/res/87/sim.txt')
data_87 = read.table(sim_data_path, sep=',', col.names=c('i', 't', 'y', 'x', 'e', 'a'))
data_87$kpid=87
sim_data_path = paste0(proj_dir,'/_data/01/res/138/sim.txt')
data_138 = read.table(sim_data_path, sep=',', col.names=c('i', 't', 'y', 'x', 'e', 'a'))
data_138$kpid=138

data = rbind(data_2, data_87, data_138)

full_lc = data%>% group_by(t,kpid) %>% summarize(pct=mean(y))
full_lc$type='Full'
obs_lc = data%>% filter(a==1)%>%group_by(t,kpid) %>% summarize(pct=mean(y))
obs_lc$type='Obs'
lc = rbind(full_lc, obs_lc)

#qplot(data=lc, x=t, y = pct, col=factor(type), geom='line', facets=.~kpid)

rm(list=setdiff(ls(),c('proj_dir','lc')))
output_file_path = paste0(proj_dir,'/_data/01/fit_lc_data.RData')
save.image(output_file_path)
