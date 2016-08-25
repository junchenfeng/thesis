library(dplyr)
library(ggplot2)
library(tidyr)
proj_dir = getwd()

# MISSING the raw data generation


###
# Appendix II: Identification of
###
file_path = paste0(proj_dir,'/_data/02/work_dataset_exp_merged.RData')
load(file_path)


meta_24921$cmt_timelen = meta_24921$cmt_timelen/1000
meta_24921$cmt_timelen[meta_24921$cmt_timelen>240] = 240

identify_giveup <- function(data, target_eid){

  # Rule of thumb, all wrong except for the following answers are identified as giveups
  data$giveup[data$atag_pct==0 & data$eid==target_eid] = 1

  if(target_eid=='Q_10200744145981'){
    sensible_errors = c('[[\"120\"]]','[[\"600\"]]','[[\"30\"]]','[[\"80\"]]','[[\"12000\"]]','[[\"800\"]]','[[\"60\"]]')
  }else if(target_eid=='Q_10200256072764'){
    sensible_errors = c('[[\"1920\"]]','[[\"48\"]]','[[\"96\"]]','[[\"190\"]]','[[\"24\"]]')
  }else if(target_eid=='Q_10200351208705'){
    sensible_errors = c('[[\"36\"]]','[[\"72\"]]','[[\"12\"]]','[[\"6\"]]')
  }else if(target_eid=='Q_10201056649366'){
    sensible_errors = c('[["26","40"]]','[["26",""]]','[["80","40"]]','[["52","160"]]','[["52",""]]','[["16","40"]]','[["80",""]]','[["40","40"]]',
                        '[["13","40"]]','[["23","40"]]','[["80","36"]]','[["24","40"]]','[["38","40"]]','[["40","26"]]','[["16","40"]]','[["28","40"]]','[["52","40"]]')
  }else if (target_eid %in% c('Q_10201056655901','Q_10201058056988')){
    sensible_errors = c('[["20","24"]]','[["48","24"]]','[["20",""]]','[["24",""]]','[["48","28"]]','[["24","24"]]','[["48",""]]','[["20","40"]]','[["2848",""]]')
  }else if(target_eid == 'Q_10201056666357'){
    sensible_errors = c('[["26","40"]]','[["4280",""]]','[["80","40"]]','[["36","40"]]','[["26",""]]','[["52","160"]]','[["80","42"]]',
                        '[["52",""]]','[["16","40"]]','[["41","40"]]')
  }else if (target_eid=='Q_10201056658103'){
    sensible_errors = c('[["6","4"],["20"],["24"]]','[["12","8"],["40"],["96"]]','[["6","4"],[],["24"]]','[["6","4"],["20"],[]]',
                        '[["6","4"],[],[]]','[["6","4"],["24"],["24"]]','[["12","8"],["20"],["24"]]','[["6","8"],[],[]]')
  }
  data$is_sensible_ans[data$answers %in% sensible_errors & data$eid==target_eid & data$giveup==1] = 1


  # reverse the sensible ans
  data$giveup[data$eid==target_eid&data$is_sensible_ans==1] = 0

  # Exception Rules
  return(data)
}

meta_24921$giveup=0
meta_24921$is_sensible_ans = 0

meta_24921 = identify_giveup(meta_24921, 'Q_10201056649366') # baseline


meta_24921 = identify_giveup(meta_24921, 'Q_10201056655901')
meta_24921 = identify_giveup(meta_24921, 'Q_10201058056988')
meta_24921 = identify_giveup(meta_24921, 'Q_10201056658103')

meta_24921 = identify_giveup(meta_24921, 'Q_10201056666357') # first assessment
meta_24921 = identify_giveup(meta_24921, 'Q_10200351208705') # second assessment


# prepare for the figure in appendix 2
c2a2f1_data = meta_24921 %>% filter(atag==0) %>% select(cmt_timelen, giveup)

# prepare for the main analysis
# retention rate
meta_24921_1st_attempt = meta_24921 %>%
  group_by(uid,eid) %>%
  arrange(uid,eid,cmt_time) %>%
  slice(1) %>%
  ungroup() %>%
  arrange(uid,cmt_time)

# retain the 0,2,4
meta_24921_1st_attempt = meta_24921_1st_attempt %>% transform(gid=uid%%5) %>% filter(gid%in%c(0,2,4))

# retain users with full responses to 4 items
valid_user_sum = meta_24921_1st_attempt %>%
  group_by(uid,gid) %>%
  summarize(k=length(unique(eid)))  %>%
  transform(is_valid_user = k==4)

user_retention_stat = valid_user_sum %>% group_by(gid,k) %>% summarize(n=n())
user_retention_stat = merge(user_retention_stat, user_retention_stat %>% group_by(gid) %>% summarize(N=sum(n)))
user_retention_stat = user_retention_stat %>% mutate(pct=n/N) %>% group_by(gid) %>% mutate(cumpct=cumsum(pct))

# generate the data for the regression model
placebo_status = meta_24921_1st_attempt %>% filter(eid=='Q_10201056649366') %>% mutate(is_placebo = as.numeric(atag_pct==1)) %>% select(uid, is_placebo)
train_time = meta_24921_1st_attempt %>% filter(eid %in% c('Q_10201056655901','Q_10201058056988','Q_10201056658103')) %>% select(uid,cmt_timelen)

workdata = meta_24921_1st_attempt %>%
  filter(uid %in% valid_user_sum$uid[valid_user_sum$k==4]) %>%
  select(uid,gid,eid,atag_pct,giveup,cmt_time) %>% rename(y=atag_pct)

workdata = merge(placebo_status, workdata, by='uid')
workdata = merge(train_time, workdata, by='uid')


# check which questions the user failed
workdata$seq_id = 2
workdata$seq_id[workdata$eid=='Q_10201056649366'] = 1
workdata$seq_id[workdata$eid=='Q_10201056666357'] = 3
workdata$seq_id[workdata$eid=='Q_10200351208705'] = 4

user_giveup_profile = workdata %>% select(uid, seq_id, giveup) %>% spread(seq_id, giveup)
names(user_giveup_profile) = c('uid','q1','q2','q3','q4')
retain_user_profile = user_giveup_profile %>% filter(q2==0)

workdata$is_retain = 0
workdata$is_retain[workdata$uid %in%retain_user_profile$uid] = 1

rm(list=setdiff(ls(),c('proj_dir','c2a2f1_data','user_retention_stat','workdata')))
output_file_path = paste0(proj_dir,'/_data/02/production_data.RData')

save.image(output_file_path)

