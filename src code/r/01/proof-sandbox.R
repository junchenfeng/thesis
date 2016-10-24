library(ggplot2)
library(dplyr)
library(tidyr)

proj_dir = getwd()

file_path = paste0(proj_dir, '/_data/02/baker_01_sim.txt')
raw_data_1 = read.table(file_path, sep=',')
file_path = paste0(proj_dir, '/_data/02/baker_02_sim.txt')
raw_data_2 = read.table(file_path, sep=',')
file_path = paste0(proj_dir, '/_data/02/baker_03_sim.txt')
raw_data_3 = read.table(file_path, sep=',')


names(raw_data_1) = c('i','t','j','y','x')
names(raw_data_2) = c('i','t','j','y','x')
names(raw_data_3) = c('i','t','j','y','x')


wide_data_1 = raw_data_1 %>% select(i,t,y) %>% filter(t<=1) %>% spread(t,y) %>% mutate(type='1')
wide_data_2 = raw_data_2 %>% select(i,t,y) %>% filter(t<=1) %>% spread(t,y) %>% mutate(type='2')
wide_data_3 = raw_data_3 %>% select(i,t,y) %>% filter(t<=1) %>% spread(t,y) %>% mutate(type='3')
wide_data = rbind(wide_data_1,wide_data_2,wide_data_3)
wide_data$type = factor(wide_data$type)

names(wide_data) = c('i','t1','t2','type')

join_dist = wide_data %>% group_by(type,t1,t2) %>% summarize(n=n())


join_dist$y = paste0(join_dist$t1,join_dist$t2)



ggplot(data=join_dist, aes(x=y,y=n, fill=type))+ geom_bar(stat = "identity",position="dodge") + xlab('Slack Pattern') + ylab('Frequency') + ggtitle('Y1,Y2,Y3')

