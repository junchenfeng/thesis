proj_dir = getwd()

library(dplyr)
library(ggplot2)
#TODO: add in the script that produces spell data
file_path = paste0(proj_dir,'/_data/01/spell_data.RData')
load(file_path)

lag_spell_path = paste0(proj_dir,'/_data/01/spell_data_lag_3.csv')
lag_spell_data = read.csv(lag_spell_path,sep=',', col.names=c('atag','end_idx','spell_id','rank','seq_id','streak_id'))
lag_spell_data$ans_tag = factor(lag_spell_data$atag, labels=c('Wrong','Right'))


# WRONG RESPONSE HETEROGENEITY
# identify the end of the spell
spell_data = spell_data %>% arrange(uid, spell_id, desc(rank))
spell_data = spell_data %>% transform(idx=as.integer((rank-lag(rank,1))>0))
spell_data$idx[1] = 1
# clean
spell_data = spell_data %>% arrange(spell_id,rank)
spell_data = spell_data %>% select(kpid, atag, timelen, appid, spell_id, rank, idx)
spell_data$ans_tag = factor(spell_data$atag, labels=c('Wrong','Right'))

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

