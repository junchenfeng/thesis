proj_dir = getwd()

library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

################################### Load Raw Data #################################
## Create spell data from raw data
raw_data_path = paste0(proj_dir,'/_data/01/raw_data.RData')
load(raw_data_path)

# raw data has about 68 million
# delete users whose log entry is smaller than 50. They are not regular.
user_cnt_stat = raw_data %>% filter(appid==1) %>% group_by(uid) %>% summarize(n=n())
# 15 are 50%, 50 are 80%

raw_data = raw_data %>% filter(appid==1)
raw_data = raw_data %>% filter(uid %in% user_cnt_stat$uid[user_cnt_stat$n>=50])
rm(list=c('user_cnt_stat'))

# retain 42 millions data
raw_data = raw_data %>% select(uid, kpid, time, atag)
raw_data = raw_data %>% filter(!(uid %in% c(30002, 32320,33234))) # get rid of test user

# it should be noticed that the same kpid have same time stamp because the data are received in batch (preserving the sequence)
# Therefore each batch repesents a spell

# take representative knowledge points
item_stat = raw_data %>% group_by(kpid) %>% summarize(pct=mean(atag), n=n())
# there are good clustering above log(8) and 0.75
# qplot(data=item_stat, x=pct, y=log(n))

# kpid:138 pct 88%, n 285466 # vertial division
# kpid:87  pct 93%, n 698166 #两位数减一位数
# kpid:2   pct 96%, n 534991 # 1~5几和第几

# retain 2 million data
select_data = raw_data %>% filter(kpid %in% c(2, 87, 138))
rm(list=c('item_stat','raw_data'))



# Each unique combination of uid, eid and time-stamp defines a spell
spell_idx_data = select_data %>% group_by(uid,kpid,time) %>% summarize(spell_T=n()) %>% ungroup() %>% mutate(spell_id=row_number())
#spell_T_stat = spell_idx_data %>% group_by(kpid, spell_T) %>% summarize(n=n())
#spell_N_stat = spell_idx_data %>% group_by(kpid) %>% summarize(N=n())
#spell_stat = merge(spell_T_stat, spell_N_stat) %>% mutate(pct=n/N)
#for (i in c(2,87,137,138)){
#  spell_stat$pct[spell_stat$spell_T==6&spell_stat$kpid==i] = 1 - sum(spell_stat$pct[spell_stat$spell_T<=5&spell_stat$kpid==i])
#}
#spell_stat = spell_stat %>% filter(spell_T<=6)
#qplot(data=spell_stat, x=spell_T, y=pct, geom='line', col=factor(kpid) )
spell_data = merge(select_data, spell_idx_data, by=c('uid','kpid','time')) %>% select(uid,kpid,atag,spell_id)
rm(list=c('select_data','spell_idx_data'))


# need to calculate two practice sequence stat
# local sequence: rank within spell
spell_data = spell_data %>% ungroup() %>% group_by(spell_id) %>% mutate(t = row_number()) %>% ungroup()
# global sequence: rank within the data set. The global sequence is not truly global since it does not reflect the whole practice history | do not use

spell_data_path = paste0(proj_dir,'/_data/01/spell_data.RData')
rm(list=setdiff(ls(), c('spell_data_path','spell_data')))


################################### Load Spell data #################################
# From spell data to python estimation data
file_path = paste0(proj_dir,'/_data/01/spell_data.RData')
load(file_path)

spell_data = spell_data %>% arrange(uid, spell_id, desc(t))
spell_data = spell_data %>% transform(raw = t-lag(t,1), idx=as.integer((t-lag(t,1))>=0))
spell_data$idx[1] = 1

output_spell_data = spell_data %>% select(kpid, spell_id, t, atag, idx) %>% arrange(spell_id, t)

output_file_path = paste0(proj_dir,'/_data/01/spell_data_2.csv')
write.table(output_spell_data %>% filter(t<=5) %>% filter(kpid==2) %>% select(-kpid) %>% filter(spell_id %% 100 %in% c(10,23) ), file=output_file_path, row.names=F, col.names=F, sep=',')

output_file_path = paste0(proj_dir,'/_data/01/spell_data_87.csv')
write.table(output_spell_data%>% filter(t<=5) %>% filter(kpid==87) %>% select(-kpid) %>% filter(spell_id %% 100 %in% c(9,99) ), file=output_file_path, row.names=F, col.names=F, sep=',')

output_file_path = paste0(proj_dir,'/_data/01/spell_data_138.csv')
write.table(output_spell_data%>% filter(t<=5) %>% filter(kpid==138) %>% select(-kpid) %>% filter(spell_id %% 100 %in%c(10,23,19,86)), file=output_file_path, row.names=F, col.names=F, sep=',')


output_file_path = paste0(proj_dir,'/_data/01/spell_data_2_outsample.csv')
write.table(output_spell_data %>% filter(t<=5) %>% filter(kpid==2) %>% select(-kpid) %>% filter(spell_id %% 100 %in% c(50) ), file=output_file_path, row.names=F, col.names=F, sep=',')

output_file_path = paste0(proj_dir,'/_data/01/spell_data_87_outsample.csv')
write.table(output_spell_data%>% filter(t<=5) %>% filter(kpid==87) %>% select(-kpid) %>% filter(spell_id %% 100 %in% c(50) ), file=output_file_path, row.names=F, col.names=F, sep=',')

output_file_path = paste0(proj_dir,'/_data/01/spell_data_138_outsample.csv')
write.table(output_spell_data%>% filter(t<=5) %>% filter(kpid==138) %>% select(-kpid) %>% filter(spell_id %% 100 %in%c(50,0)), file=output_file_path, row.names=F, col.names=F, sep=',')



# clean
spell_data = spell_data %>% arrange(spell_id, t)
spell_data$ans_tag = factor(spell_data$atag, labels=c('Wrong','Right'))






lag_spell_path = paste0(proj_dir,'/_data/01/spell_data_lag_3.csv')
lag_spell_data = read.csv(lag_spell_path,sep=',', col.names=c('atag','end_idx','spell_id','rank','seq_id','streak_id'))
lag_spell_data$ans_tag = factor(lag_spell_data$atag, labels=c('Wrong','Right'))


# WRONG RESPONSE HETEROGENEITY
# identify the end of the spell

#calculate the
wrong_stop_by_item_stat = spell_data %>% group_by(ans_tag,kpid) %>% summarize(pct=mean(as.integer(idx)),n=n())
fig_1_data = wrong_stop_by_item_stat %>% filter(n>100)

#############
#qplot(data=fig_1_data, x=pct, col=ans_tag,geom='density')
############

# DURATION DEPENDENCE
# calculate the harzard rate
wrong_stop_by_rank_stat = spell_data %>% group_by(ans_tag,rank) %>% summarize(pct=mean(as.integer(idx)),n=n())
fig_2_data = wrong_stop_by_rank_stat%>% filter(rank<=20 & rank>1) %>%
  rename(hazard_rate=pct, period=rank)
####
#qplot(data=fig_2_data, x=period, y=hazard_rate, col=ans_tag,geom='line')
####


# HOT STREAK

# group by identical item id
cell_summary = lag_spell_data %>% group_by(seq_id) %>% summarize(n=n()) %>%
  ungroup()%>% arrange(desc(n)) %>% filter(n>=400)

# label the streak data
test_stat = lag_spell_data %>% filter(seq_id %in% cell_summary$seq_id) %>% group_by(seq_id, streak_id, ans_tag) %>% summarize(pct=mean(end_idx))
test_sum_stat = test_stat %>% group_by(seq_id) %>% summarize(n=n()) %>% filter(n==8)
fig_3_data = test_stat %>% filter(seq_id %in% test_sum_stat$seq_id)
####
#qplot(data=fig_3_data, x=pct, col=factor(streak_id),geom='density', facets=.~ans_tag)
####




# CLEAN and SAVE
rm(list=setdiff(ls(),c('fig_1_data','fig_2_data','fig_3_data')))
save.image(paste0(getwd(),'/_data/01/production_data.RData'))




