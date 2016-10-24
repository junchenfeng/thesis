library(dplyr)
library(tidyr)
# check if the wrong streak is too long
proj_dir = getwd()
file_path = paste0(proj_dir, '/_data/02/spell_data.RData')
load(file_path)

# take spell with length 3
max_spell_length = spell_data %>% group_by(spell_id) %>% summarize(maxt = max(t))
meta_spell = merge(spell_data, max_spell_length)

mT = 4
qualified_spell = meta_spell %>% filter(kpid==138) %>% filter(maxt>=mT) %>% filter(t<=mT)
# now spread
wide_spell_data = qualified_spell %>%select(t, atag, spell_id) %>% spread(t,atag)
names(wide_spell_data) = c('spell_id','t1','t2','t3','t4')
wide_spell_data %>% group_by(t1,t2,t3,t4) %>% summarize(n=n())

qualified_spell %>% group_by(spell_id) %>% summarize(nY=sum(atag),is_end=unique(maxt)==mT) %>% group_by(nY) %>% summarize(hr=mean(is_end),n=n())


# test for feedback difference
