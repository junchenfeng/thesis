# compare the sufficient statistics with
library(ggplot2)
library(dplyr)
library(tidyr)


proj_dir = getwd()

data_dir = paste0(proj_dir,'/_data/02/sim/')
raw_data = read.table(paste0(data_dir,'y_data.txt'), header = F, sep=',')
names(raw_data) = c('i','t','S','H','y')

Tmax = 1
invalid_data = raw_data %>% group_by(i) %>% filter(t<=(Tmax-1) & H==1)
valid_data = raw_data %>% filter(t<=Tmax & !(i %in% invalid_data$i)) %>% select(i,y,t) %>% spread(t,y)
names(valid_data) = c('i','y0','y1')
suff_stat = valid_data %>% group_by(y0,y1)%>% summarize(n=n()/nrow(valid_data))

# check if the that is generated
pi=0.4
ell=0.3
c0=0.2
c1=0.9
suff_stat_no = data.frame(y=c('11','01','10','00'),
                       p=c(
                         (1-pi)*(1-ell)*c0**2+(1-pi)*ell*c0*c1+pi*c1**2,
                         (1-pi)*(1-ell)*c0*(1-c0)+(1-pi)*ell*(1-c0)*c1+pi*c1*(1-c1),
                         (1-pi)*(1-ell)*c0*(1-c0)+(1-pi)*ell*c0*(1-c1)+pi*c1*(1-c1),
                         (1-pi)*(1-ell)*(1-c0)**2+(1-pi)*ell*(1-c0)*(1-c1)+pi*(1-c1)**2
                       ))


# How much are deterministic hazard rate



file_path = paste0(proj_dir,'/_data/02/spell_data.RData')
load(file_path)
spell_data = spell_data %>% arrange(uid, spell_id, desc(t))
spell_data = spell_data %>% transform(raw = t-lag(t,1), idx=as.integer((t-lag(t,1))>=0))
spell_data$idx[1] = 1

# take the first spell from the uid
valid_spell_id = spell_data%>% group_by(uid) %>% summarize(first_spell_id=min(spell_id), last_spell_id=max(spell_id))
spell_data_fst = spell_data %>% filter(spell_id %in% valid_spell_id$first_spell_id)
spell_data_lst = spell_data %>% filter(spell_id %in% valid_spell_id$last_spell_id)

output_spell_data = spell_data_fst %>% select(kpid, spell_id, t, atag, idx) %>% arrange(spell_id, t)

test_data = output_spell_data %>% filter(kpid==138)
test_data = test_data %>% group_by(spell_id) %>% mutate(cum_err=cumsum(1-atag))
cum_h_stat = test_data %>% group_by(cum_err) %>% summarize(h=mean(idx),n=n())

first_stat = spell_data_fst%>% filter(kpid==138)%>% group_by(t) %>% summarize(p=mean(atag))  %>% filter(t<=5)
last_stat = spell_data_lst%>% filter(kpid==138)%>% group_by(t) %>% summarize(p=mean(atag))  %>% filter(t<=5)

first_stat$type='f'
last_stat$type='l'


qplot(data=rbind(first_stat,last_stat),x=t,y=p,geom='line',col=type)
