params_effort_man = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_manual.txt'), sep=',')
params_no_effort = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_no_effort.txt'), sep=',')
names(params_effort_man) = c('pre','no','vocabulary','video','post')
names(params_no_effort) = c('pre','no','vocabulary','video','post')

sample_idx = seq(300,1000,10)
lrate = params_no_effort[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m1 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,1))
lrate = params_effort_man[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m2 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort')+xlim(c(0,1))

grid.arrange(m1,m2)

params_effort_man_3 = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_with_effort_manual_y3.txt'), sep=',')
params_no_effort_3 = read.table(paste0(proj_dir,'/_data/03/chp3_parameter_chain_no_effort_y3.txt'), sep=',')

params_effort_man_3_0 = params_effort_man_3 %>% select(V1,V3,V5,V7,V9)
params_effort_man_3_1 = params_effort_man_3 %>% select(V2,V4,V6,V8,V10)

params_no_effort_3_0 = params_no_effort_3 %>% select(V1,V3,V5,V7,V9)
params_no_effort_3_1 = params_no_effort_3 %>% select(V2,V4,V6,V8,V10)

names(params_effort_man_3_0) = c('pre','no','vocabulary','video','post')
names(params_effort_man_3_1) = c('pre','no','vocabulary','video','post')
names(params_no_effort_3_0) = c('pre','no','vocabulary','video','post')
names(params_no_effort_3_1) = c('pre','no','vocabulary','video','post')

sample_idx = seq(300,1000,10)
lrate = params_no_effort_3_0[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m3 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,1))
lrate = params_effort_man_3_0[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m4 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort ')+xlim(c(0,1))

grid.arrange(m3,m4)

lrate = params_no_effort_3_1[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m5 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('No Effort')+xlim(c(0,1))
lrate = params_effort_man_3_1[sample_idx,] %>% select(-pre,-post)%>% gather(group,val)
lrate$group = factor(lrate$group)
m6 = qplot(data=lrate, x=val, col=group, linetype=group, geom='density')+ggtitle('With Effort')+xlim(c(0,1))

grid.arrange(m5,m6)
