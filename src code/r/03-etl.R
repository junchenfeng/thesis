rm(list=ls())
library(dplyr)
library(ggplot2)
library(tidyr)
proj_dir = getwd()

# MISSING the raw data generation


###
# Appendix II: Identification of
###
file_path = paste0(proj_dir,'/_data/02/production_data.RData')
load(file_path)

# rank the first question by time

obs_rank = workdata %>% filter(eid=='Q_10201056649366')  %>% arrange(gid,cmt_time) %>%
  group_by(gid) %>% mutate(rank=row_number()) %>%
  ungroup() %>% select(uid, rank)

# extract the data
orig_data = workdata %>% filter(eid=='Q_10201056649366')%>% filter(y<1) %>% select(uid,gid)

first_data = workdata %>% filter(eid=='Q_10201056666357') %>%
  select(uid,gid,y,giveup,is_retain) %>% mutate(y=as.integer(y==1)) %>%
  filter(uid %in% orig_data$uid) %>%
  filter(is_retain==1)

second_data = workdata %>% filter(eid=='Q_10200351208705') %>%
  select(uid,gid,y,giveup,is_retain) %>% mutate(y=as.integer(y==1))%>%
  filter(uid %in% orig_data$uid) %>%
  filter(is_retain==1)



# 0 means
first_diff = merge(first_data, obs_rank) %>% select(gid,y,rank)%>% arrange(gid,rank) %>% group_by(gid) %>% mutate(rank=row_number())
second_diff = merge(second_data, obs_rank)%>% select(gid,y,rank) %>% arrange(gid,rank) %>% group_by(gid) %>% mutate(rank=row_number())


# write out the csv
output_file_path_1st = paste0(proj_dir, '/_data/03/first_assessment_data.csv')
output_file_path_2nd = paste0(proj_dir, '/_data/03/second_assessment_data.csv')

write.csv(first_diff, file=output_file_path_1st, quote=F,row.names=F)
write.csv(second_diff, file=output_file_path_2nd, quote=F,row.names=F)

# sort the sim result

sim_exp = read.csv(paste0(proj_dir,'/_data/03/sim_exp_data.txt'),header=F, col.names=c('q','g','is_finish','best_arm','runs','pval','ret'))

# power
power_res = sim_exp %>% group_by(q,g) %>% summarize(tpower=mean(pval<0.05),bpower=mean(as.integer(is_finish==1&best_arm==1)))

# ret saving
ret_res = sim_exp %>% group_by(q,g) %>% summarize(avg_ret = mean(ret))
ret_res$org_ret = c(sum(first_diff$y[first_diff$gid != 4])/length(first_diff$y[first_diff$gid != 4]),
                   sum(first_diff$y[first_diff$gid != 2])/length(first_diff$y[first_diff$gid != 2]),
                   sum(second_diff$y[second_diff$gid != 4])/length(second_diff$y[second_diff$gid != 4]),
                   sum(second_diff$y[second_diff$gid != 2])/length(second_diff$y[second_diff$gid != 2]))

# runs saving
runs_res = sim_exp %>% group_by(q,g) %>% summarize(avg_run = mean(runs))
runs_res$org_runs = c(length(first_diff$y[first_diff$gid != 4]),
                      length(first_diff$y[first_diff$gid != 2]),
                      length(second_diff$y[second_diff$gid != 4]),
                      length(second_diff$y[second_diff$gid != 2]))

rm(list=setdiff(ls(),c('proj_dir','power_res','ret_res','runs_res')))
output_file_path = paste0(proj_dir,'/_data/03/production_data.RData')

save.image(output_file_path)
