

# condition on correct train

summary(lm(data=complete_data %>% filter(uid %in% cond_train$uid &type!='train'), atag~type*group))
