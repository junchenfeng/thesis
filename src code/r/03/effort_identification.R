# The script is devoted to the identifcation of the error type
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)
library(stargazer)
proj_dir = getwd()

# MISSING the raw data generation


###
# Appendix II: Identification of
###
file_path = paste0(proj_dir,'/_data/03/work_dataset_exp_merged.RData')
load(file_path)

meta_24921$cmt_timelen = meta_24921$cmt_timelen/1000
meta_24921$cmt_timelen[meta_24921$cmt_timelen>240] = 240

meta_24921$answers = as.character(meta_24921$answers)

#write.table(meta_24921%>%select(id,eid,answers), file=paste0(proj_dir,'/_data/03/question_ans.txt'),quote=F,row.names = F,col.names = F, sep='\t')

ans_data = read.table(paste0(proj_dir,'/_data/03/question_ans_parsed.txt'), sep='\t', col.names=c('id','eid','ans1','ans2','sans1','sans2','raw_ans'), quote = "", stringsAsFactors = F)

# only retain users that have done 3 items
meta_24921_1st_attempt = meta_24921 %>%
  group_by(uid,eid) %>%
  arrange(uid,eid,cmt_time) %>%
  slice(1) %>%
  ungroup() %>%
  arrange(uid,cmt_time)

meta_24921_1st_attempt = meta_24921_1st_attempt %>% transform(gid=uid%%5) %>% filter(eid != 'Q_10200351208705')
meta_24921_1st_attempt$group = factor(meta_24921_1st_attempt$gid, labels=c('No-3','No-2','Vocabulary-3','Vocabulary-2','Video'))
meta_24921_1st_attempt$type = 0
meta_24921_1st_attempt$type[meta_24921_1st_attempt$group %in% c('No-2', 'Vocabulary-2')] = 1
meta_24921_1st_attempt$type = factor(meta_24921_1st_attempt$type, labels=c('Pretest','No Pretest'))


# retain users with full responses
valid_user_sum = meta_24921_1st_attempt %>%
  group_by(uid,group) %>%
  summarize(k=length(unique(eid)))  %>%
  transform(is_valid_user = (k==3&group %in%c('No-3','Vocabulary-3','Video')) | (k==2&group %in%c('No-2','Vocabulary-2')) )

# generate graphs

user_retention_stat = valid_user_sum %>% group_by(group,k) %>% summarize(n=n())
user_retention_stat = merge(user_retention_stat, user_retention_stat %>% group_by(group) %>% summarize(N=sum(n)))
user_retention_stat = user_retention_stat %>% mutate(pct=n/N) %>% group_by(group) %>% mutate(cumpct=cumsum(pct))

user_retention_stat_3 = user_retention_stat %>% filter(group %in% c('No-3','Vocabulary-3','Video'))
user_retention_stat_2 = user_retention_stat %>% filter(group %in% c('No-2','Vocabulary-2'))

# Get the attrition
m1=ggplot(data=user_retention_stat_3, aes(x=k, y=pct, fill=group))+
  geom_bar(stat = "identity",position="dodge") +
  xlab('Last Item') + ylab('Pct') +
  ggtitle('Attrition Percentage-pretest') +
  theme(legend.position = "bottom") + ylim(c(0,1))

m2=ggplot(data=user_retention_stat_2, aes(x=k, y=pct, fill=group))+
  geom_bar(stat = "identity",position="dodge") +
  xlab('Last Item') + ylab('Pct') +
  ggtitle('Attrition Percentage- No pretest') +
  theme(legend.position = "bottom") + ylim(c(0,1))

grid.arrange(m1,m2, ncol=2)

# Compare the last response
work_data = meta_24921_1st_attempt %>% filter(uid %in% valid_user_sum$uid[valid_user_sum$is_valid_user])
last_res_stat = work_data %>% filter(eid %in% c('Q_10201056666357','Q_10201056649366'))
last_res_stat$qid = factor(last_res_stat$eid, labels=c('pretest','posttest'))


last_res_stat = last_res_stat%>% group_by(type,qid,group) %>% summarize(pct=mean(atag))

ggplot(data=last_res_stat, aes(x=qid, y=pct, fill=group))+
  geom_bar(stat = "identity",position="dodge") +
  facet_grid(.~type)+
  xlab('Item') + ylab('Success Rate') +
  ggtitle('Test Result') +
  theme(legend.position = "bottom") + ylim(c(0,1))


work_data = merge(meta_24921_1st_attempt %>% filter(uid %in% valid_user_sum$uid[valid_user_sum$is_valid_user]), ans_data)

work_data$ans1 = trimws(work_data$ans1)
work_data$ans2 = trimws(work_data$ans2)


# Re grade the whole question Q_10201056658103
work_data$score = work_data$atag_pct
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1=='28'&work_data$ans2=='48'] = 1.0
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1=='28'&work_data$ans2!='48'] = 0.5
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1!='28'&work_data$ans2=='48'] = 0.5
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1!='28'&work_data$ans2!='48'] = 0
work_data$score[work_data$eid=='Q_10201056666357'&work_data$ans1=='36'&work_data$ans2=='80'] = 0


identify_giveup <- function(data, target_eid){
  data$is_slip = 0
  data$wrong_shape = 0
  data$circ_right = 0
  data$area_right = 0
  data$blank_ans = 0


  # error type format:
  # careless
  # calculate the small rectangle
  # sensible circumference, right area
  # right circumference, sensible area


  if(target_eid=='Q_10201056649366'){
    right_1_idx = grep('36', data$ans1)
    right_2_idx = grep('80', data$ans2)

    both_right_idx = intersect(right_1_idx, right_2_idx)

    is_slip = append(unique(data$raw_ans[both_right_idx]), c('[["3680",""]]','[["80","36"]]')
    )
    circ_right = setdiff(unique(data$raw_ans[right_1_idx]), is_slip)
    area_right = setdiff(unique(data$raw_ans[right_2_idx]), is_slip)
    wrong_shape = c('[["26","40"]]','[["26",""]]','[["","40"]]','[["26","26"]]','[["40","40"]]','[["40","26"]]','[["40",""]]','[["","26"]]')
    blank_error = c('[["",""]]')

  }
  else if (target_eid %in% c('Q_10201056655901','Q_10201058056988','Q_10201056658103')){
    right_1_idx = grep('28', data$ans1)
    right_2_idx = grep('48', data$ans2)

    both_right_idx = intersect(right_1_idx, right_2_idx)
    is_slip = append(unique(data$raw_ans[both_right_idx]), c('[["2848",""]]','[["48","28"]]'))
    circ_right = append(setdiff(unique(data$raw_ans[right_1_idx]), is_slip), c('[["","28"]]'))
    area_right = append(setdiff(unique(data$raw_ans[right_2_idx]), is_slip), c('[["48",""]]'))

    wrong_shape = c('[["20","24"]]','[["20",""]]','[["","24"]]','[["20","20"]]','[["24","24"]]','[["24","20"]]','[["24",""]]','[["","20"]]')
    blank_error = c('[["",""]]','[[],[]]')
  }
  else if (target_eid=='Q_10201056658103-o'){
    right_1_idx = grep('28', data$ans1)
    right_2_idx = grep('48', data$ans2)

    both_right_idx = intersect(right_1_idx, right_2_idx)

    is_slip = c('[["6","8"],["28"],["48"]]','[["",""],["28"],["48"]]','[["8","6"],["48"],[]]','[["6","4"],["28"],["48"]]','[["8","4"],["28"],["48"]]',
                '[["86",""],["28"],["48"]]','[["6","8"],["48"],["28"]]','[["6","8"],["48"],[]]','[["8","6"],["128"],["48"]]','[["8","6"],["228"],["48"]]',
                '[["8","6"],["2828"],["48"]]','[["8","6"],["48"],["28"]]','[["8","8"],["28"],["48"]]','[["8åŽ˜ç±³","6åŽ˜ç±³"],["28"],["48"]')
    circ_right = append(setdiff(unique(data$raw_ans[right_1_idx]), is_slip), c('[["","28"]]'))
    area_right = append(setdiff(unique(data$raw_ans[right_2_idx]), is_slip), c('[["48",""]]'))


    wrong_shape = c('[["20","24"]]','[["20",""]]','[["","24"]]','[["20","20"]]','[["24","24"]]','[["24","20"]]','[["24",""]]','[["","20"]]')

    blank_error = c('[["8","6"],[],[]]','[["",""],[],[]]','[["6","4"],[],[]]')
  }
  else if(target_eid == 'Q_10201056666357'){
    right_1_idx = grep('42', data$ans1)
    right_2_idx = grep('80', data$ans2)

    both_right_idx = intersect(right_1_idx, right_2_idx)
    is_slip = append(unique(data$raw_ans[both_right_idx]), c('[["4280",""]]','[["80","42"]]','[["41","80"]]','[["42","90"]]','[["42","08"]]'))
    circ_right = setdiff(unique(data$raw_ans[right_1_idx]), is_slip)
    # copy the same answer from q1 is not a valid attempt
    area_right = setdiff(unique(data$raw_ans[right_2_idx]), append(is_slip, c('[["36","80"]]')))
    wrong_shape = c('[["26","40"]]','[["26",""]]','[["","40"]]','[["26","26"]]','[["40","40"]]','[["40","26"]]','[["40",""]]','[["","26"]]')
    blank_error = c('[["",""]]')
  }

  if (target_eid=='Q_10201056658103-o'){
    data$is_slip[data$answers %in% is_slip & data$atag_pct!=1] = 1
    data$blank_ans[data$answers %in% blank_error & data$atag_pct!=1] = 1
    data$wrong_shape[data$raw_ans %in% wrong_shape & data$atag_pct!=1] = 1
    data$circ_right[data$raw_ans %in% circ_right & data$atag_pct!=1] = 1
    data$area_right[data$raw_ans %in% area_right & data$atag_pct!=1] = 1
  }else{
    data$is_slip[data$raw_ans %in% is_slip & data$score!=1] = 1
    data$blank_ans[data$raw_ans %in% blank_error & data$score!=1] = 1
    data$wrong_shape[data$raw_ans %in% wrong_shape & data$score!=1] = 1
    data$circ_right[data$raw_ans %in% circ_right & data$score!=1] = 1
    data$area_right[data$raw_ans %in% area_right & data$score!=1] = 1
  }
  # Exception Rules
  return(data)
}


pre_data = identify_giveup(work_data %>%filter(eid=='Q_10201056649366'), 'Q_10201056649366' ) # baseline

control_data = identify_giveup(work_data %>%filter(eid=='Q_10201056655901'), 'Q_10201056655901' ) # naive
treat1_data = identify_giveup(work_data %>%filter(eid=='Q_10201056658103'), 'Q_10201056658103' ) # vocabulary
treat2_data = identify_giveup(work_data %>%filter(eid=='Q_10201058056988'), 'Q_10201058056988' ) # video

post_data = identify_giveup(work_data %>%filter(eid=='Q_10201056666357'), 'Q_10201056666357' ) # first assessment

data = rbind(pre_data, control_data, treat1_data, treat2_data, post_data)

# convert slip to correct
data$score[data$is_slip==1]=1


# first_step_success_idx = which((treat1_data$sans1=='8'&treat1_data$sans2=='6')|(treat1_data$sans1=='6'&treat1_data$sans2=='8'))
# success_user = treat1_data$uid[first_step_success_idx]
# failed_user = treat1_data$uid[-first_step_success_idx]


data = data %>%  mutate(valid = score<1 &(is_slip |wrong_shape| area_right | circ_right),
                        right=score==1,
                        nonblank = !right & !valid & !blank_ans)

data$ans_type = 'correct'
data$ans_type[data$wrong_shape==1] = 'wrong shape'
data$ans_type[data$area_right==1] = 'right area'
data$ans_type[data$circ_right==1] = 'right circumference'
data$ans_type[data$nonblank==1] = 'non-blank ans'
data$ans_type[data$blank_ans==1] = 'blank ans'
data$ans_type[data$is_slip==1] = 'slip'


data$item_type = 'train'
data$item_type[data$eid=='Q_10201056649366'] = 'pre-test'
data$item_type[data$eid=='Q_10201056666357'] = 'post-test'
data$item_type = factor(data$item_type, levels=c('pre-test','train','post-test'))

data$etype='blank'
data$etype[data$right]='correct'
data$etype[data$valid]='valid'
data$etype[data$nonblank]='non-blank'

data$seq_id = 2
data$seq_id[data$eid=='Q_10201056649366'] = 1
data$seq_id[data$eid=='Q_10201056666357'] = 3

data$qtype = factor(data$seq_id, labels=c('pre','train','post'))
data$y = as.numeric(data$score==1)

data$nonblank[data$qtype=='pre'&data$wrong_shape==T] = 0
data$valid[data$qtype=='pre'&data$wrong_shape==T] = 1
data = data %>% mutate(giveup = blank_ans | nonblank)

## Do additional grading

# give grade to area and circumference
# The sequential thinking is
# (1) correctly identifies shape
# (2) correctly calculate the circumference
# (3) correctly calculate the area

# the unclassified only accounts for a very small percentage of the right shape, <1%
#data %>% filter(wrong_shape==0&giveup==0&score==0&is_slip==0) %>% group_by(eid) %>% summarize(n=n())
data = data %>% mutate(score0 = as.numeric(wrong_shape==0&giveup==0))


data$score1 = 0
data$score1[data$score==1] = 1
data$score1[data$score!=1&data$score!=0&data$ans1=='36'&data$eid=='Q_10201056649366'] = 1
data$score1[data$score!=1&data$score!=0&data$ans1=='42'&data$eid=='Q_10201056666357'] = 1
data$score1[data$score!=1&data$score!=0&data$ans1=='28'&data$eid %in% c('Q_10201056655901','Q_10201056658103','Q_10201058056988')] = 1

data$score1[data$score!=1&data$ans1=='26'&data$wrong_shape==1&data$eid %in% c('Q_10201056649366', 'Q_10201056666357')] = 1
data$score1[data$score!=1&data$ans1=='20'&data$wrong_shape==1&data$eid %in% c('Q_10201056655901','Q_10201056658103','Q_10201058056988')] = 1


# make up the wrong shape

data$score2 = 0
data$score2[data$score==1] = 1
data$score2[data$score==1] = 1
data$score2[data$score!=1&data$score!=0&data$ans2=='80'&data$eid %in% c('Q_10201056649366', 'Q_10201056666357')] = 1
data$score2[data$score!=1&data$score!=0&data$ans2=='48'&data$eid %in% c('Q_10201056655901','Q_10201056658103','Q_10201058056988')] = 1

data$score2[data$score!=1&data$ans2=='40'&data$wrong_shape==1&data$eid %in% c('Q_10201056649366', 'Q_10201056666357')] = 1
data$score2[data$score!=1&data$ans1=='24'&data$wrong_shape==1&data$eid %in% c('Q_10201056655901','Q_10201056658103','Q_10201058056988')] = 1

#
# data$giveup1 = data$giveup
# data$giveup1[data$ans1==''] = 1
# data$blank_ans1 = data$blank_ans
# data$blank_ans1[data$ans1==''] = 1
#
#
# data$giveup2 = data$giveup
# data$giveup2[data$ans2==''] = 1
# data$blank_ans2 = data$blank_ans
# data$blank_ans2[data$ans2==''] = 1

right_shape_stat = data %>% filter(giveup==0) %>% group_by(group,item_type) %>% summarize(p=mean(score0))
ggplot(data=right_shape_stat, aes(x=item_type, y=1-p, fill=group))+geom_bar(stat='identity',position='dodge')

circ_stat = data %>% filter(giveup==0)%>% group_by(group,item_type) %>% summarize(p=mean(score1))
ggplot(data=circ_stat, aes(x=item_type, y=1-p, fill=group))+geom_bar(stat='identity',position='dodge')

area_stat = data %>% filter(giveup==0) %>% group_by(group,item_type) %>% summarize(p=mean(score2))
ggplot(data=area_stat, aes(x=item_type, y=1-p, fill=group))+geom_bar(stat='identity',position='dodge')




# diagnostics


giveup_stat = data %>% group_by(qtype, group, type) %>% summarize(pct=mean(giveup))

ggplot(data=giveup_stat, aes(x=qtype, y=pct, fill=group))+
  geom_bar(stat = "identity",position="dodge") +
  facet_grid(.~type)+
  xlab('Item') + ylab('Slack Rate') +
  ggtitle('Giveup Percentage') +
  theme(legend.position = "bottom") + ylim(c(0,1))

placebo_status = data %>% filter(eid=='Q_10201056649366') %>% mutate(is_placebo = as.numeric(score==1)) %>% filter(is_placebo==1)
data$is_placebo = 0
data$is_placebo[data$uid %in% unique(placebo_status$uid)] = 1

retain_status = data %>% filter(qtype=='train') %>% mutate(is_retain = !giveup) %>% filter(is_retain==1)
data$is_retain = 0
data$is_retain[data$uid %in% unique(retain_status$uid)] = 1





# check the response time

qplot(data=data, x=cmt_timelen, geom='density', col=etype, facets=group~qtype)

qplot(data=data %>% filter(cmt_timelen<=60&blank_ans), x=cmt_timelen, geom='density', facets=group~qtype) + xlab('time spent')

qplot(data=data %>% filter(cmt_timelen<=120&!blank_ans), x=cmt_timelen, geom='density', col=etype,facets=group~qtype) + xlab('time spent')+
  theme(legend.position = "bottom")


# output for the paper
rm(list=setdiff(ls(), c('proj_dir','data')))
file_path = paste0(proj_dir,'/_data/03/paper_data.RData')
save.image(file_path)


# output to csv

# only take 0,2,4
# only take the control and the video
data = data %>% filter(gid%%2==0) %>% filter(group %in% c('No-3','Video'))

# rename with user
user_info = data %>% group_by(uid) %>% summarise() %>% ungroup()%>% mutate(i=row_number()-1)
eid_info = data.frame(eid = c('Q_10201056649366','Q_10201056655901','Q_10201058056988','Q_10201056666357'), j=seq(0,3,1))



output_data = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, y) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,y)

output_data_effort_manual = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, y, giveup) %>%
  mutate(y=as.numeric(y==1.0), is_e=0, is_v=1-giveup) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,y,is_e,is_v)

output_data_effort_auto = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, y, blank_ans) %>%
  mutate(y=as.numeric(y==1.0), is_e=0, is_v=1-blank_ans) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,y,is_e,is_v)

write.csv(output_data, file=paste0(proj_dir, '/_data/03/output/exp_output.csv'), row.names = F, quote = F)
write.csv(output_data_effort_manual, file=paste0(proj_dir, '/_data/03/output/exp_output_effort_manual.csv'), row.names = F, quote = F)
write.csv(output_data_effort_auto, file=paste0(proj_dir, '/_data/03/output/exp_output_effort_auto.csv'), row.names = F, quote = F)


# output score 0
output_data_0 = merge(merge(data, user_info), eid_info) %>%select(i, seq_id, j, score0) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score0)

output_data_0_effort_manual = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score0, giveup) %>%
  mutate(is_e=0, is_v=1-giveup) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score0,is_e,is_v)

output_data_0_effort_auto = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score0, blank_ans) %>%
  mutate(is_e=0, is_v=1-blank_ans) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score0,is_e,is_v)

write.csv(output_data_0, file=paste0(proj_dir, '/_data/03/output/exp_output_0.csv'), row.names = F, quote = F)
write.csv(output_data_0_effort_manual, file=paste0(proj_dir, '/_data/03/output/exp_output_0_effort_manual.csv'), row.names = F, quote = F)
write.csv(output_data_0_effort_auto, file=paste0(proj_dir, '/_data/03/output/exp_output_0_effort_auto.csv'), row.names = F, quote = F)


# output score 1
output_data_1 = merge(merge(data, user_info), eid_info) %>%select(i, seq_id, j, score1) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score1)

output_data_1_effort_manual = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score1, giveup) %>%
  mutate(is_e=0, is_v=1-giveup) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score1,is_e,is_v)

output_data_1_effort_auto = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score1, blank_ans) %>%
  mutate(is_e=0, is_v=1-blank_ans) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score1,is_e,is_v)

write.csv(output_data_1, file=paste0(proj_dir, '/_data/03/output/exp_output_1.csv'), row.names = F, quote = F)
write.csv(output_data_1_effort_manual, file=paste0(proj_dir, '/_data/03/output/exp_output_1_effort_manual.csv'), row.names = F, quote = F)
write.csv(output_data_1_effort_auto, file=paste0(proj_dir, '/_data/03/output/exp_output_1_effort_auto.csv'), row.names = F, quote = F)

# output score 2
output_data_2 = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score2) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score2)

output_data_2_effort_manual = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score2, giveup) %>%
  mutate(is_e=0, is_v=1-giveup) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score2,is_e,is_v)

output_data_2_effort_auto = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score2, blank_ans) %>%
  mutate(is_e=0, is_v=1-blank_ans) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score2,is_e,is_v)

write.csv(output_data_2, file=paste0(proj_dir, '/_data/03/output/exp_output_2.csv'), row.names = F, quote = F)
write.csv(output_data_2_effort_manual, file=paste0(proj_dir, '/_data/03/output/exp_output_2_effort_manual.csv'), row.names = F, quote = F)
write.csv(output_data_2_effort_auto, file=paste0(proj_dir, '/_data/03/output/exp_output_2_effort_auto.csv'), row.names = F, quote = F)


# parse it into discrete choice
output_data_y3 = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score)

output_data_y3$y = 1
output_data_y3$y[output_data_y3$score==1] = 2
output_data_y3$y[output_data_y3$score==0] = 0
output_data_y3 = output_data_y3 %>% select(-score)


output_data_y3_effort_manual = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score, giveup) %>%
  mutate(is_e=0, is_v=1-giveup) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score,is_e,is_v)

output_data_y3_effort_manual$y = 1
output_data_y3_effort_manual$y[output_data_y3_effort_manual$score==1] = 2
output_data_y3_effort_manual$y[output_data_y3_effort_manual$score==0] = 0
output_data_y3_effort_manual = output_data_y3_effort_manual %>% select(-score)
output_data_y3_effort_manual = output_data_y3_effort_manual %>% select(i,t,j,y,is_e,is_v)


output_data_y3_effort_auto = merge(merge(data, user_info), eid_info) %>% select(i, seq_id, j, score, blank_ans) %>%
  mutate( is_e=0, is_v=1-blank_ans) %>%
  mutate(t=seq_id-1) %>% select(-seq_id) %>%
  arrange(i,t) %>%
  select(i,t,j,score,is_e,is_v)

output_data_y3_effort_auto$y = 1
output_data_y3_effort_auto$y[output_data_y3_effort_auto$score==1] = 2
output_data_y3_effort_auto$y[output_data_y3_effort_auto$score==0] = 0
output_data_y3_effort_auto = output_data_y3_effort_auto %>% select(-score)
output_data_y3_effort_auto = output_data_y3_effort_auto %>% select(i,t,j,y,is_e,is_v)


write.csv(output_data_y3, file=paste0(proj_dir, '/_data/03/output/exp_output_y3.csv'), row.names = F, quote = F)
write.csv(output_data_y3_effort_manual, file=paste0(proj_dir, '/_data/03/output/exp_output_effort_manual_y3.csv'), row.names = F, quote = F)
write.csv(output_data_y3_effort_auto, file=paste0(proj_dir, '/_data/03/output/exp_output_effort_auto_y3.csv'), row.names = F, quote = F)











