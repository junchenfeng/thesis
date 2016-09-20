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

# retain the 0,2,4
meta_24921_1st_attempt = meta_24921_1st_attempt %>% transform(gid=uid%%5) %>% filter(gid%in%c(0,2,4))

# retain users with full responses to 4 items
valid_user_sum = meta_24921_1st_attempt %>%
  filter(eid!='Q_10200351208705') %>%
  group_by(uid,gid) %>%
  summarize(k=length(unique(eid)))  %>%
  transform(is_valid_user = k==3)

work_data = merge(meta_24921_1st_attempt %>% filter(uid %in% valid_user_sum$uid[valid_user_sum$is_valid_user]), ans_data)



# Re grade the whole question Q_10201056658103
work_data$score = work_data$atag_pct
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1=='28'&work_data$ans2=='48'] = 1.0
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1=='28'&work_data$ans2!='48'] = 0.5
work_data$score[work_data$eid=='Q_10201056658103'&work_data$ans1!='28'&work_data$ans2=='48'] = 0.5




identify_giveup <- function(data, target_eid){
  data$is_slip = 0
  data$wrong_shape = 0
  data$circ_right = 0
  data$area_right = 0
  data$blank_ans = 0
  data$wrong_shape_w = 0


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
    wrong_shape_w = c()
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
    wrong_shape_w = c()
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

    # # The wrong shape identification is different for the 2nd question
    # wrong_shape = c('[["6","4"],["20"],["24"]]',
    #                 '[["6","4"],["20"],[]]',
    #                 '[["6","4"],[],["24"]]',
    #                 '[["6",""],["20"],["24"]]',
    #                 '[["6",""],["20"],[]]',
    #                 '[["6",""],[],["24"]]',
    #                 '[["","4"],["20"],["24"]]',
    #                 '[["","4"],["20"],[]]',
    #                 '[["","4"],[],["24"]]',
    #                 '[["",""],["20"],["24"]]',
    #                 '[["4","6"],["20"],[]]',
    #                 '[["4","6"],[],["24"]]',
    #                 '[["6","4"],["20"],["24"]]')
    # wrong_shape_both = which(data$ans1=='20'&data$ans2=='24')
    # wrong_shape_circ = which(data$ans1=='20'&data$ans2=='')
    # wrong_shape_area = which(data$ans1==''&data$ans2=='24')
    # all_wrong_shape = unique(append(append(data$answers[wrong_shape_both],data$answers[wrong_shape_circ]),data$answers[wrong_shape_area]))
    # wrong_shape_w = setdiff(all_wrong_shape, wrong_shape)

    wrong_shape = c('[["20","24"]]','[["20",""]]','[["","24"]]')
    wrong_shape_w = c()

    blank_error = c('[["8","6"],[],[]]','[["",""],[],[]]','[["6","4"],[],[]]')
  }
  else if(target_eid == 'Q_10201056666357'){
    right_1_idx = grep('42', data$ans1)
    right_2_idx = grep('80', data$ans2)

    both_right_idx = intersect(right_1_idx, right_2_idx)
    is_slip = append(unique(data$raw_ans[both_right_idx]), c('[["4280",""]]','[["80","42"]]'))
    circ_right = setdiff(unique(data$raw_ans[right_1_idx]), is_slip)
    # copy the same answer from q1 is not a valid attempt
    area_right = setdiff(unique(data$raw_ans[right_2_idx]), append(is_slip, c('[["36","80"]]')))
    wrong_shape = c('[["26","40"]]','[["26",""]]','[["","40"]]','[["26","26"]]','[["40","40"]]','[["40","26"]]','[["40",""]]','[["","26"]]')
    blank_error = c('[["",""]]')
    wrong_shape_w = c()
  }

  if (target_eid=='Q_10201056658103-o'){
    data$is_slip[data$answers %in% is_slip & data$atag_pct!=1] = 1
    data$blank_ans[data$answers %in% blank_error & data$atag_pct!=1] = 1
    data$wrong_shape[data$raw_ans %in% wrong_shape & data$atag_pct!=1] = 1
    data$wrong_shape_w[data$raw_ans %in% wrong_shape_w & data$atag_pct!=1] = 1
    data$circ_right[data$raw_ans %in% circ_right & data$atag_pct!=1] = 1
    data$area_right[data$raw_ans %in% area_right & data$atag_pct!=1] = 1
  }else{
    data$is_slip[data$raw_ans %in% is_slip & data$score!=1] = 1
    data$blank_ans[data$raw_ans %in% blank_error & data$score!=1] = 1
    data$wrong_shape[data$raw_ans %in% wrong_shape & data$score!=1] = 1
    data$wrong_shape_w[data$raw_ans %in% wrong_shape_w & data$score!=1] = 1
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

# first_step_success_idx = which((treat1_data$sans1=='8'&treat1_data$sans2=='6')|(treat1_data$sans1=='6'&treat1_data$sans2=='8'))
# success_user = treat1_data$uid[first_step_success_idx]
# failed_user = treat1_data$uid[-first_step_success_idx]


data = data %>%  mutate(valid = score<1 &(is_slip |wrong_shape| area_right | circ_right),
                        right=score==1,
                        nonblank = !right & !valid&!blank_ans) %>%
                transform(gid=uid%%5)

data$ans_type = 'correct'
data$ans_type[data$wrong_shape==1] = 'wrong shape'
data$ans_type[data$area_right==1] = 'right area'
data$ans_type[data$circ_right==1] = 'right circumference'
data$ans_type[data$nonblank==1] = 'non-blank ans'
data$ans_type[data$blank_ans==1] = 'blank ans'
data$ans_type[data$is_slip==1] = 'slip'



data$etype='blank'
data$etype[data$right]='correct'
data$etype[data$valid]='valid'
data$etype[data$nonblank]='non-blank'

data$seq_id = 2
data$seq_id[data$eid=='Q_10201056649366'] = 1
data$seq_id[data$eid=='Q_10201056666357'] = 3

data$qtype = factor(data$seq_id, labels=c('pre','train','post'))
data$group = factor(data$gid, labels=c('ctrl','treat1','treat2'))
data$y = as.numeric(data$score==1)

data$nonblank[data$qtype=='pre'&data$wrong_shape==T] = 0
data$valid[data$qtype=='pre'&data$wrong_shape==T] = 1
data = data %>% mutate(giveup = blank_ans | nonblank)


placebo_status = data %>% filter(eid=='Q_10201056649366') %>% mutate(is_placebo = as.numeric(score==1)) %>% filter(is_placebo==1)
data$is_placebo = 0
data$is_placebo[data$uid %in% unique(placebo_status$uid)] = 1

retain_status = data %>% filter(qtype=='train') %>% mutate(is_retain = !giveup) %>% filter(is_retain==1)
data$is_retain = 0
data$is_retain[data$uid %in% unique(retain_status$uid)] = 1


################
# diagnostics
###############


ans_composition = data %>% group_by(group, qtype) %>%
  summarize(blank = mean(blank_ans),
            slip=mean(is_slip),
            wrongshape=mean(wrong_shape),
            nonblank=mean(nonblank),
            rightcirc=mean(circ_right),
            rightarea=mean(area_right),
            correct=mean(score==1))

ans_composition %>% arrange(qtype,group)



# do a breakdown analysis

type_ans_stat = data %>% group_by(qtype, eid, ans_type, raw_ans) %>% summarize(n=n()) %>%
  group_by(qtype,eid,ans_type) %>% arrange(desc(n))


type_stat = data %>% group_by(qtype,eid, ans_type) %>% summarize(N=n())

ans_stat = merge(type_ans_stat, type_stat) %>% mutate(pct=n/N) %>%
  filter(ans_type %in% c('wrong shape', 'non-blank ans', 'right area','right circumference')) %>%
  group_by(qtype,eid, ans_type) %>% arrange(qtype, eid, ans_type, desc(pct)) %>%
  mutate(cpct = cumsum(pct)) %>%
  mutate(idx = row_number()) %>% filter(idx<=5) %>%
  select(qtype,eid, ans_type, raw_ans,n, pct, cpct, idx)

#write.csv(ans_stat, paste0(proj_dir,'/_data/03/ans_stat.csv'), row.names = F, quote=FALSE)

###############
# mark giveup #
###############

# Check the sequence dependence
wide_data=  data %>%
  select(uid,gid,seq_id,giveup) %>%
  spread(seq_id,giveup)
names(wide_data) = c('uid','gid','t1','t2','t3')

effort_persistence = merge(wide_data %>% group_by(gid,t1,t2,t3) %>% summarize(n=n()), wide_data %>% group_by(gid) %>% summarize(N=n())) %>% mutate(pct=n/N)

effort_persistence$pattern = '0,0,0'
effort_persistence$pattern[effort_persistence$t1&effort_persistence$t2&!effort_persistence$t3] = '1,1,0'
effort_persistence$pattern[effort_persistence$t1&!effort_persistence$t2&!effort_persistence$t3] = '1,0,0'
effort_persistence$pattern[effort_persistence$t1&!effort_persistence$t2&effort_persistence$t3] = '1,0,1'
effort_persistence$pattern[effort_persistence$t1&effort_persistence$t2&effort_persistence$t3] = '1,1,1'
effort_persistence$pattern[!effort_persistence$t1&!effort_persistence$t2&effort_persistence$t3] = '0,0,1'
effort_persistence$pattern[!effort_persistence$t1&effort_persistence$t2&!effort_persistence$t3] = '0,1,0'
effort_persistence$pattern[!effort_persistence$t1&effort_persistence$t2&effort_persistence$t3] = '0,1,1'


effort_persistence$pattern = factor(effort_persistence$pattern)

ggplot(data=effort_persistence, aes(x=pattern,y=pct, fill=factor(gid)))+ geom_bar(stat = "identity",position="dodge")


#
#
#
# # the other way is to verify the anomaly in 010 and 011
# examine_users = wide_data %>% filter(!t1&t2&!t3)
# deeplook = merge(data %>% filter(uid %in% examine_users$uid, seq_id==2) %>% group_by(raw_ans,group) %>% summarize(n=n()),
#                   data %>% filter(uid %in% examine_users$uid, seq_id==2) %>% group_by(group) %>% summarize(N=n())) %>%
#             mutate(pct=n/N) %>% select(group, raw_ans, pct) %>% spread(group,pct, fill=0) %>%
#             mutate(diff = treat1-(ctrl+treat2)*0.5)
#
# head(deeplook %>% arrange(desc(diff)),20)
#
# # check the trend of learning
# data %>%group_by(qtype,gid) %>% summarize(N=sum(score<1),n=sum(wrong_shape)) %>% mutate(n/N)
#
# data$wrong_shape_1st = 0
# data$wrong_shape_1st[data$uid %in% pre_data$uid[pre_data$wrong_shape==T]] = 1
#
# data %>% group_by(qtype,wrong_shape_1st) %>% summarize(mean(wrong_shape))


# check the response time

qplot(data=data, x=cmt_timelen, geom='density', col=etype, facets=group~qtype)
qplot(data=data %>% filter(cmt_timelen<=120), x=cmt_timelen, geom='density', col=etype, facets=group~qtype)
qplot(data=data %>% filter(cmt_timelen<=120&!blank_ans), x=cmt_timelen, geom='density', col=etype,facets=group~qtype)


# output for the paper
rm(list=setdiff(ls(), c('proj_dir','data')))
file_path = paste0(proj_dir,'/_data/03/paper_data.RData')
save.image(file_path)


# output to bkt
# rename with user
user_info = data %>% group_by(uid) %>% summarise() %>% ungroup()%>% mutate(i=row_number()-1)
eid_info = data.frame(eid = c('Q_10201056649366','Q_10201056655901','Q_10201056658103','Q_10201058056988','Q_10201056666357'), j=seq(0,4,1))

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

write.csv(output_data, file=paste0(proj_dir, '/_data/03/exp_output.csv'), row.names = F, quote = F)
write.csv(output_data_effort_manual, file=paste0(proj_dir, '/_data/03/exp_output_effort_manual.csv'), row.names = F, quote = F)
write.csv(output_data_effort_auto, file=paste0(proj_dir, '/_data/03/exp_output_effort_auto.csv'), row.names = F, quote = F)

# after python estimate the model. Reload

params_effort_man = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_manual.txt'), sep=',')
params_effort_auto = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_automatic.txt'), sep=',')
params_no_effort = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_no_effort.txt'), sep=',')

sample_idx = seq(300,1000,10)

lrate = data.frame(q1=params_effort_man$V23[sample_idx],q2=params_effort_man$V24[sample_idx],q3=params_effort_man$V25[sample_idx])
lrate = lrate %>% gather(qid,val)
m1 = qplot(data=lrate, x=val, col=factor(qid), geom='density')

lrate = data.frame(q1=params_effort_auto$V23[sample_idx],q2=params_effort_auto$V24[sample_idx],q3=params_effort_auto$V25[sample_idx])
lrate = lrate %>% gather(qid,val)
m2 = qplot(data=lrate, x=val, col=factor(qid), geom='density')

lrate = data.frame(q1=params_no_effort$V23[sample_idx],q2=params_no_effort$V24[sample_idx],q3=params_no_effort$V25[sample_idx])
lrate = lrate %>% gather(qid,val)
m3 = qplot(data=lrate, x=val, col=factor(qid), geom='density')

grid.arrange(m1,m2,m3)


# Alternatively, only identify blank answer as giveups
#TODO: examine the MCMC results

##############
# Now do DID #
##############
library(stargazer)










