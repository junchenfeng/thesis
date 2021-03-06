library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
proj_dir = getwd()

# MISSING the raw data generation


###
# Appendix II: Identification of
###
file_path = paste0(proj_dir,'/_data/03/work_dataset_exp_merged.RData')
load(file_path)

meta_24921$cmt_timelen = meta_24921$cmt_timelen/1000
meta_24921$cmt_timelen[meta_24921$cmt_timelen>240] = 240
bkp_meta_24921 = meta_24921


# # filter
test_data = meta_24921 %>% filter(eid %in% c('Q_10201056658103') & atag<1) %>%
 group_by(answers) %>% summarize(n=n(),avg_time=mean(cmt_timelen)) %>%
 arrange(desc(n))
#
# meta_24921 %>% filter(eid %in% c('Q_10201056658103') & atag<1) %>% summarize(sum(atag<1), sum(giveup))


identify_giveup <- function(data, target_eid){
  data$giveup=0
  data$is_slip = 0
  data$wrong_shape = 0
  data$is_circ_right = 0
  data$is_area_right
  data$is_blank_ans = 0

  # Rule of thumb, all wrong except for the following answers are identified as giveups
  data$giveup[data$atag_pct==0 & data$eid==target_eid] = 1

  # error type format:
  # careless
  # calculate the small rectangle
  # sensible circumference, right area
  # right circumference, sensible area

  if(target_eid=='Q_10201056649366'){
    sensible_errors = c('[["3680",""]]','[["36","800"]]','[["36","8"]]','[["36","88"]]','[["80","36"]]','[["36.80",""]]','[["360","80"]]',
                        '[["26","40"]]','[["26",""]]',
                        '[["","80"]]','[["18","80"]]','[["26","80"]]','[["32","80"]]','[["34","80"]]','[["35","80"]]','[["38","80"]]','[["39","80"]]','[["40","80"]]','[["42","80"]]','[["44","80"]]','[["52","80"]]',
                        '[["36",""]]','[["36","18"]]','[["36","36"]]','[["36","40"]]','[["36","160"]]'
                        )
    blank_error = '[["",""]]'
  }
  else if (target_eid %in% c('Q_10201056655901','Q_10201058056988')){
    sensible_errors = c('[["2848",""]]',
                        '[["20","24"]]','[["20",""]]',
                        '[["","48"]]','[["14","48"]]','[["20","48"]]','[["24","48"]]','[["26","48"]]','[["32","48"]]','[["40","48"]]','[["48","48"]]',
                        '[["28",""]]','[["28","24"]]','[["28","28"]]','[["28","40"]]'
                        )
    blank_error = '[["",""]]'
  }
  else if (target_eid=='Q_10201056658103'){
    sensible_errors = c('[["6","8"],["28"],["48"]]','[["8","4"],["28"],["48"]]',
                        '[["6","4"],["20"],["24"]]','[["12","4"],["32"],["48"]]',
                        '[["8","6"],[],[]]',
                        '[["8","6"],[],["48"]]','[["8","6"],["14"],["48"]]','[["8","6"],["20"],["48"]]','[["8","6"],["24"],["48"]]','[["8","6"],["26"],["48"]]','[["8","6"],["32"],["48"]]','[["8","6"],["40"],["48"]]','[["8","6"],["48"],["48"]]',
                        '[["8","6"],["28"],[]]','[["8","6"],["28"],["24"]]','[["8","6"],["28"],["28"]]','[["8","6"],["28"],["40"]]')
    blank_error = '[["",""],[],[]]'
  }
  else if(target_eid == 'Q_10201056666357'){
    sensible_errors = c('[["4280",""]]','[["42","800"]]','[["42","8"]]','[["42","08"]]',
                        '[["26","40"]]','[["26",""]]',
                        '[["","80"]]','[["22","80"]]','[["21","80"]]','[["26","80"]]','[["32","80"]]','[["41","80"]]','[["52","80"]]',
                        '[["42",""]]','[["42","21"]]','[["42","42"]]','[["42","40"]]','[["42","60"]]','[["42","82"]]','[["42","83"]]','[["42","90"]]'
                        )
    blank_error = '[["",""]]'
  }
  else if(target_eid=='Q_10200351208705'){
    # cannot determine which goes wrong
    sensible_errors = c('[[\"36\"]]','[[\"72\"]]','[[\"12\"]]','[[\"6\"]]')
    blank_error = '[[""]]'
  }

  data$is_sensible_ans[data$answers %in% sensible_errors & data$eid==target_eid & data$giveup==1] = 1
  data$is_blank_ans[data$answers == blank_error & data$eid==target_eid] = 1


  # reverse the sensible ans
  data$giveup[data$eid==target_eid&data$is_sensible_ans==1] = 0

  # Exception Rules
  return(data)
}


meta_24921 = identify_giveup(meta_24921, 'Q_10201056649366') # baseline

meta_24921 = identify_giveup(meta_24921, 'Q_10201056655901') # naive
meta_24921 = identify_giveup(meta_24921, 'Q_10201056658103') # vocabulary
meta_24921 = identify_giveup(meta_24921, 'Q_10201058056988') # video

meta_24921 = identify_giveup(meta_24921, 'Q_10201056666357') # first assessment
meta_24921 = identify_giveup(meta_24921, 'Q_10200351208705') # second assessment


# prepare for the figure in appendix 2
c2a2f1_data = meta_24921 %>% filter(atag<1) %>% select(cmt_timelen, giveup,is_blank_ans)

# prepare for the main analysis
# retention rate
meta_24921_1st_attempt = meta_24921 %>%
  group_by(uid,eid) %>%
  arrange(uid,eid,cmt_time) %>%
  slice(1) %>%
  ungroup() %>%
  arrange(uid,cmt_time)

# filter out the last attempt
meta_24921_1st_attempt = meta_24921_1st_attempt %>% transform(gid=uid%%5) %>% filter(eid != 'Q_10200351208705')
meta_24921_1st_attempt$group = factor(meta_24921_1st_attempt$gid, labels=c('No-3','No-2','Vocabulary-3','Vocabulary-2','Video'))
meta_24921_1st_attempt$type = 0
meta_24921_1st_attempt$type[meta_24921_1st_attempt$group %in% c('No-2', 'Vocabulary-2')] = 1
meta_24921_1st_attempt$type = factor(meta_24921_1st_attempt$type, labels=c('Pretest','No Pretest'))


# retain users with full responses to 3 items for group 0,2,4 and 2 items for group 1,3
valid_user_sum = meta_24921_1st_attempt %>%
  group_by(uid,group) %>%
  summarize(k=length(unique(eid)))  %>%
  transform(is_valid_user = (k==3&group %in%c('No-3','Vocabulary-3','Video')) | (k==2&group %in%c('No-2','Vocabulary-2')) )




# generate the data for the regression model
# placebo_status = meta_24921_1st_attempt %>% filter(eid=='Q_10201056649366') %>% mutate(is_placebo = as.numeric(atag_pct==1)) %>% select(uid, is_placebo)
# train_time = meta_24921_1st_attempt %>% filter(eid %in% c('Q_10201056655901','Q_10201058056988','Q_10201056658103')) %>% select(uid,cmt_timelen)
#
# workdata = meta_24921_1st_attempt %>%
#   filter(uid %in% valid_user_sum$uid[valid_user_sum$k==4]) %>%
#   select(uid,gid,eid,atag_pct,giveup,cmt_time,is_blank_ans) %>% rename(y=atag_pct)
#
# workdata = merge(placebo_status, workdata, by='uid')
# workdata = merge(train_time, workdata, by='uid')


# check which questions the user failed
workdata = meta_24921_1st_attempt %>%
  filter(uid %in% valid_user_sum$uid[valid_user_sum$is_valid_user]) %>%
  select(uid,gid,eid,atag_pct,giveup,cmt_time,is_blank_ans) %>% rename(y=atag_pct)

workdata$seq_id = 2
workdata$seq_id[workdata$eid=='Q_10201056649366'] = 1
workdata$seq_id[workdata$eid=='Q_10201056666357'] = 3
workdata$seq_id[workdata$eid=='Q_10200351208705'] = 4

user_giveup_profile = workdata %>% select(uid, seq_id, giveup) %>% spread(seq_id, giveup)
names(user_giveup_profile) = c('uid','q1','q2','q3','q4')
retain_user_profile = user_giveup_profile %>% filter(q2==0)

workdata$is_retain = 0
workdata$is_retain[workdata$uid %in%retain_user_profile$uid] = 1



# Alternative Giveup Identification


bkp_meta_24921_1st_attempt = meta_24921_1st_attempt
bkp_meta_24921_1st_attempt$giveup = bkp_meta_24921_1st_attempt$is_blank_ans

# retain the 0,2,4
bkp_meta_24921_1st_attempt = bkp_meta_24921_1st_attempt %>% transform(gid=uid%%5) %>% filter(gid%in%c(0,2,4))

# retain users with full responses to 4 items
bkp_valid_user_sum = bkp_meta_24921_1st_attempt %>%
  group_by(uid,gid) %>%
  summarize(k=length(unique(eid)))  %>%
  transform(is_valid_user = k==4)



# generate the data for the regression model
bkp_placebo_status = bkp_meta_24921_1st_attempt %>% filter(eid=='Q_10201056649366') %>% mutate(is_placebo = as.numeric(atag_pct==1)) %>% select(uid, is_placebo)
bkp_train_time = bkp_meta_24921_1st_attempt %>% filter(eid %in% c('Q_10201056655901','Q_10201058056988','Q_10201056658103')) %>% select(uid,cmt_timelen)

bkp_data = bkp_meta_24921_1st_attempt %>%
  filter(uid %in% bkp_valid_user_sum$uid[bkp_valid_user_sum$k==4]) %>%
  select(uid,gid,eid,atag_pct,giveup,cmt_time) %>% rename(y=atag_pct)

bkp_data = merge(bkp_placebo_status, bkp_data, by='uid')
bkp_data = merge(bkp_train_time, bkp_data, by='uid')


# check which questions the user failed
bkp_data$seq_id = 2
bkp_data$seq_id[bkp_data$eid=='Q_10201056649366'] = 1
bkp_data$seq_id[bkp_data$eid=='Q_10201056666357'] = 3
bkp_data$seq_id[bkp_data$eid=='Q_10200351208705'] = 4

bkp_user_giveup_profile = bkp_data %>% select(uid, seq_id, giveup) %>% spread(seq_id, giveup)
names(bkp_user_giveup_profile) = c('uid','q1','q2','q3','q4')
bkp_retain_user_profile = bkp_user_giveup_profile %>% filter(q2==0)

bkp_data$is_retain = 0
bkp_data$is_retain[bkp_data$uid %in%bkp_retain_user_profile$uid] = 1


# output
rm(list=setdiff(ls(),c('proj_dir','c2a2f1_data','user_retention_stat','workdata','bkp_data')))
output_file_path = paste0(proj_dir,'/_data/02/production_data.RData')

save.image(output_file_path)

