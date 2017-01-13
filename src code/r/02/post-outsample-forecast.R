library(dplyr)
library(tidyr)
library(ggplot2)


proj_dir = getwd()
kpids = c('87','138')
kpnames = c('Two Digit Multiplication', 'Vertical Division')

types = c('xh','yh')

for (type in types){
  tmp_data = read.table(paste0(proj_dir,'/_data/02/outsample_87_',type,'.txt'),sep=',',col.names=c('uid','t','y','h','prob'))
  tmp_data$type = type
  if (type=='xh'){
    pred_data = tmp_data
  }else{
    pred_data = rbind(pred_data, tmp_data)
  }
}

pred_data = pred_data %>% arrange(type,uid,t) %>% group_by(type,uid) %>% mutate(p=lag(prob))
pred_stat = pred_data %>% ungroup() %>% filter(t!=1) %>% group_by(type,t) %>% summarize(rmse=sqrt(mean((y-p)^2)))



