proj_dir = 'C:/Users/junchen/Documents/GitHub/pyMLC/data/bkt/test/'

y_data = read.table(paste0(proj_dir,'single_sim_y.txt'), sep=',', col.names=c('i','t','y','x','e','a'))
y_data$type = 'Y'
x_data = read.table(paste0(proj_dir,'single_sim_x.txt'), sep=',', col.names=c('i','t','y','x','e','a'))
x_data$type = 'X'

raw_data = rbind(y_data, x_data)
raw_data$type = factor(raw_data$type)
library(ggplot2)
library(dplyr)

qplot(data=raw_data%>%filter(a==1)%>%group_by(type,t)%>%summarize(pct=mean(y)), x=t,y=pct,geom='line',col=type)
qplot(data=raw_data%>%filter(a==1)%>%group_by(type,t)%>%summarize(pct=mean(x)), x=t,y=pct,geom='line',col=type)
