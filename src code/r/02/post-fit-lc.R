library(dplyr)
library(tidyr)

# generate three fit
update_mastery <- function(mastery, learn_rate){
  return (mastery + (1-mastery)*learn_rate)
}

compute_success_rate <- function(slip, guess, mastery){
  return ( guess*(1-mastery) + (1-slip)*mastery )
}

generate_learning_curve <- function(slip, guess, init_mastery, learn_rate, Tl){
  p = init_mastery
  lc = data.frame(t= seq(1,Tl), ypct = as.numeric(0), xpct=as.numeric(0) )

  lc$ypct[1] = compute_success_rate(slip, guess, p)
  lc$xpct[1] = p

  for (t in seq(2,Tl)){
    p = update_mastery(p,learn_rate)
    lc$ypct[t] = compute_success_rate(slip, guess, p)
    lc$xpct[t] = p
  }
  return(lc)
}

conditional_x_density_xh <-function(pi,l,h0,h1){
  # p(X_t=1|H_t-1=0) = p(X_t=1,H_t-1=0)/(p(X_t=1,H_t-1=0)+p(X_t=0,H_t-1=0))
  # p(X_t=1,H_t-1=0) = P(X_t=1,X_t-1=0,Ht-1=0)+P(X_t=1,X_t-1=1,Ht-1=0)
  p10 = l*(1-pi)*(1-h0) + pi*(1-h1)
  # p(X_t=0,H_t-1=0) = P(X_t=0,X_t-1=0,Ht-1=0)
  p00 = (1-l)*(1-pi)*(1-h0)

  return(p10/(p10+p00))
}

generate_learning_curve_hazard<-function(slip,guess,pi,learn_rate,h0_vec,h1_vec,Tl){
  p = pi
  lc = data.frame(t= seq(1,Tl), ypct = as.numeric(0), xpct=as.numeric(0) )
  lc$ypct[1] = compute_success_rate(slip, guess, p)
  lc$xpct[1] = p
  for (t in seq(2,Tl)){
    # impute the posterior density of x
    p_post = impute_x_hazard(p, h0_vec[t], h1_vec[t])
    p = update_mastery(p_post,learn_rate)
    lc$ypct[t] = compute_success_rate(slip, guess, p)
    lc$xpct[t] = p
  }
  return(lc)
}

# No closed form for upate Y
joint_likelihood <- function(x1,x0,y0,pi,l,c){
  if (x0==1){
    L = 1
  }else{
    if (x1==1){
      L = l
    }else{
      L = 1-l
    }
  }

  pyx = y0*c+(1-y0)*(1-c)
  px = (x0*pi + (1-x0)*(1-pi))*L

  return(pyx*px)
}

complete_likelihood_xy<-function(x1, y, pi,l,c1,c0){
  # P(X1,Y0) =  P(X1,X0=0,Y0) + P(X1,X0=1,Y0)
  if (x1==1){
    ell = joint_likelihood(x1,0,y,pi,l,c1)+joint_likelihood(x1,1,y,pi,l,c1)
  }else{
    ell = joint_likelihood(x1,0,y,pi,l,c0)
  }
  return(ell)
}

conditional_x_density_yh<-function(pi,l,c0,c1,h0, h1){
  # P(X_t=1|H_t-1=0) = P(X_t=1,H_t-1=0)/(P(X_t=1,H_t-1=0) + P(X_t=0,H_t-1=0))
  # P(Xt,H_t-1=0) = sumY(P(X_t,Y_t-1,H_t-1=0))
  # P(X_t,Y_t-1,H_t-1=0) = P(X_t,Y_t-1)P(H_t-1=0|Y-t_1)
    p110 = complete_likelihood_xy(1,1,pi,l,c1,c0)*(1-h1)
    p100 = complete_likelihood_xy(1,0,pi,l,c1,c0)*(1-h0)
    p000 = complete_likelihood_xy(0,0,pi,l,c1,c0)*(1-h0)
    p010 = complete_likelihood_xy(0,1,pi,l,c1,c0)*(1-h1)
    pi = (p110+p100)/(p110+p100+p000+p010)

  return(pi)
}


proj_dir = getwd()
kpids = c('87','138')
kpnames = c('Two Digit Multiplication', 'Vertical Division')
maxT= 4

fit_log1 = read.table(paste0(proj_dir,'/_data/02/spell_data_87.csv'),sep=',',col.names=c('uid','t','y','h'))
fit_log1$kp=kpnames[1]
fit_log2 = read.table(paste0(proj_dir,'/_data/02/spell_data_138.csv'),sep=',',col.names=c('uid','t','y','h'))
fit_log2$kp=kpnames[2]
fit_log = rbind(fit_log1, fit_log2)

pred_log1 = read.table(paste0(proj_dir,'/_data/02/spell_data_87_outsample.csv'),sep=',',col.names=c('uid','t','y','h'))
pred_log1$kp=kpnames[1]
pred_log2 = read.table(paste0(proj_dir,'/_data/02/spell_data_138_outsample.csv'),sep=',',col.names=c('uid','t','y','h'))
pred_log2$kp=kpnames[2]
pred_log = rbind(pred_log1,pred_log2)

########
# Proportional
########
for (i in seq(2)){
  # read in data
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/yh.txt')
  y_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','lambda0','beta0','lambda1','beta1'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/xh.txt')
  x_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','lambda0','beta0','lambda1','beta1'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/spell_data_',kpids[i],'.csv')
  kp_spell_data = read.csv(file_path, col.names=c('spell_id','t','atag','idx'),header=F)

  # Non dependent
  for (j in seq(nrow(y_param_data))){

    l = y_param_data$l[j]
    pi = 1-y_param_data$pi[j]
    c0 = y_param_data$c0[j]
    c1 = y_param_data$c1[j]
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = pi+(1-pi)*l
      }
      tmp$py[t]= compute_success_rate(1-c1,c0,pi)
      tmp$px[t]= pi
    }

    if (j==1){
      no_lc_dist = tmp
    }else{
      no_lc_dist = rbind(no_lc_dist, tmp)
    }
  }
  # Y depdent
  for (j in seq(nrow(y_param_data))){
    pi = 1-y_param_data$pi[j]
    l = y_param_data$l[j]
    c0 = y_param_data$c0[j]
    c1 = y_param_data$c1[j]
    # get the hazard rate
    hr = data.frame(t=seq(4), yh=y_param_data$lambda1[j]*exp(y_param_data$beta1[j]*(seq(4)-1)), wh=y_param_data$lambda0[j]*exp(y_param_data$beta0[j]*(seq(4)-1)),idx=j)
    # update the process
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(maxT)){
      if (t==1){
        tmp$py[t]= compute_success_rate(1-c1,c0,pi)
        pi_0 = pi
      }else{
        # update pi
        pi_0 = conditional_x_density_yh(pi_0,l,c0,c1,hr$wh[t-1], hr$yh[t-1])
        tmp$py[t]= compute_success_rate(1-c1,c0,pi_0)
      }
      tmp$px[t]= pi_0
    }
    if (j==1){
      y_lc_dist = tmp
    }else{
      y_lc_dist = rbind(y_lc_dist, tmp)
    }
  }
  # X depdent
  for (j in seq(nrow(x_param_data))){
    lambda0 = x_param_data$lambda0[j]
    lambda1 = x_param_data$lambda1[j]
    beta0 = x_param_data$beta0[j]
    beta1 = x_param_data$beta1[j]
    l = x_param_data$l[j]
    pi = 1-x_param_data$pi[j]
    c0 = x_param_data$c0[j]
    c1 = x_param_data$c1[j]
    x_hrs = data.frame(t=seq(4), yh=lambda1*exp(beta1*(seq(4)-1)), wh=lambda0*exp(beta0*(seq(4)-1)))
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = conditional_x_density_xh(pi, l, x_hrs$wh[t-1], x_hrs$yh[t-1])
      }
      tmp$py[t]= compute_success_rate(1-c1,c0,pi)
      tmp$px[t]= pi
    }

    if (j==1){
      x_lc_dist = tmp
    }else{
      x_lc_dist = rbind(x_lc_dist, tmp)
    }
  }

  # calculate the mean and the 95 credible interval
  no_lc = no_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                 pmax=quantile(py,prob=0.95),
                                                 pmin=quantile(py,prob=0.05))
  y_lc = y_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                 pmax=quantile(py,prob=0.95),
                                                 pmin=quantile(py,prob=0.05))
  x_lc = x_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                 pmax=quantile(py,prob=0.95),
                                                 pmin=quantile(py,prob=0.05))
  no_lc$type = 'Responses Only'
  y_lc$type = 'Response Dependent'
  x_lc$type = 'State Dependent'

  # compute the real data
  emp_lc = kp_spell_data %>% group_by(t) %>% summarize(p=mean(atag))

  tmp_data = rbind(no_lc, y_lc, x_lc)
  tmp_data = merge(tmp_data, emp_lc)
  tmp_data$kp = kpnames[i]

  if(i==1){
    all_data = tmp_data
  }else{
    all_data = rbind(all_data,tmp_data)
  }
}

all_data$type = factor(all_data$type, levels=c('Responses Only','Response Dependent','State Dependent'))
qplot(data=all_data, x=t,y=pmean,geom='line') +  facet_grid(kp~type)+
  geom_errorbar(aes(x=t, ymin=pmin, ymax=pmax), width=0.1) +  facet_grid(kp~type)+
  geom_line(aes(x=t,y=p),linetype='dashed')+
  theme(legend.position="top")+ggtitle('Proportional Hazard Model')

pred_param = all_data %>% select(kp,type,t,pmean)


pred_data = merge(pred_param, pred_log)
pred_rmse = pred_data %>% group_by(kp,type,t) %>% summarize(rmse=sqrt(mean((y-pmean)^2)))
pred_rmse$sample = 'outsample'


fit_data = merge(pred_param, fit_log)
fit_rmse = fit_data %>% group_by(kp,type,t) %>% summarize(rmse=sqrt(mean((y-pmean)^2)))
fit_rmse$sample = 'insample'


rmse = rbind(pred_rmse,fit_rmse)
qplot(data=rmse,x=t,y=rmse,col=type,facets=kp~sample,geom='line')

########
# Nonparametric
########

for (i in seq(2)){
  # read in data
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/yh_np.txt')
  y_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','h01','h02','h03','h04','h11','h12','h13','h14'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/xh_np.txt')
  x_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','h01','h02','h03','h04','h11','h12','h13','h14'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/spell_data_',kpids[i],'.csv')
  kp_spell_data = read.csv(file_path, col.names=c('spell_id','t','atag','idx'),header=F)

  # Non dependent
  for (j in seq(nrow(y_param_data))){

    l = y_param_data$l[j]
    pi = 1-y_param_data$pi[j]
    c0 = y_param_data$c0[j]
    c1 = y_param_data$c1[j]
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = pi+(1-pi)*l
      }
      tmp$py[t]= compute_success_rate(1-c1,c0,pi)
      tmp$px[t]= pi
    }

    if (j==1){
      no_lc_dist = tmp
    }else{
      no_lc_dist = rbind(no_lc_dist, tmp)
    }
  }
  # Y depdent
  for (j in seq(nrow(y_param_data))){
    pi = 1-y_param_data$pi[j]
    l = y_param_data$l[j]
    c0 = y_param_data$c0[j]
    c1 = y_param_data$c1[j]
    # get the hazard rate
    h0s = c(y_param_data$h01[j],y_param_data$h02[j],y_param_data$h03[j],y_param_data$h04[j])
    h1s = c(y_param_data$h11[j],y_param_data$h12[j],y_param_data$h13[j],y_param_data$h14[j])
    # update the process
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(maxT)){
      if (t==1){
        tmp$py[t]= compute_success_rate(1-c1,c0,pi)
        pi_0 = pi
      }else{
        # update pi
        pi_0 = conditional_x_density_yh(pi_0,l,c0,c1,h0s[t-1], h1s[t-1])
        tmp$py[t]= compute_success_rate(1-c1,c0,pi_0)
      }
      tmp$px[t]= pi_0
    }
    if (j==1){
      y_lc_dist = tmp
    }else{
      y_lc_dist = rbind(y_lc_dist, tmp)
    }
  }
  # X depdent
  for (j in seq(nrow(x_param_data))){

    l = x_param_data$l[j]
    pi = 1-x_param_data$pi[j]
    c0 = x_param_data$c0[j]
    c1 = x_param_data$c1[j]
    h0s = c(x_param_data$h01[j],x_param_data$h02[j],x_param_data$h03[j],x_param_data$h04[j])
    h1s = c(x_param_data$h11[j],x_param_data$h12[j],x_param_data$h13[j],x_param_data$h14[j])
    tmp = data.frame(t=seq(4),py=as.numeric(0),px=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = conditional_x_density_xh(pi, l, h0s[t-1], h1s[t-1])
      }
      tmp$py[t]= compute_success_rate(1-c1,c0,pi)
      tmp$px[t]= pi
    }

    if (j==1){
      x_lc_dist = tmp
    }else{
      x_lc_dist = rbind(x_lc_dist, tmp)
    }
  }

  # calculate the mean and the 95 credible interval
  no_lc = no_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                   pmax=quantile(py,prob=0.95),
                                                   pmin=quantile(py,prob=0.05))
  y_lc = y_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                 pmax=quantile(py,prob=0.95),
                                                 pmin=quantile(py,prob=0.05))
  x_lc = x_lc_dist %>% group_by(t) %>% summarize(pmean=mean(py),
                                                 pmax=quantile(py,prob=0.95),
                                                 pmin=quantile(py,prob=0.05))
  no_lc$type = 'Responses Only'
  y_lc$type = 'Response Dependent'
  x_lc$type = 'State Dependent'

  # compute the real data
  emp_lc = kp_spell_data %>% group_by(t) %>% summarize(p=mean(atag))

  tmp_data = rbind(no_lc, y_lc, x_lc)
  tmp_data = merge(tmp_data, emp_lc)
  tmp_data$kp = kpnames[i]

  if(i==1){
    all_data = tmp_data
  }else{
    all_data = rbind(all_data,tmp_data)
  }
}

all_data$type = factor(all_data$type, levels=c('Responses Only','Response Dependent','State Dependent'))
qplot(data=all_data, x=t,y=pmean,geom='line') +  facet_grid(kp~type)+
  geom_errorbar(aes(x=t, ymin=pmin, ymax=pmax), width=0.1) +  facet_grid(kp~type)+
  geom_line(aes(x=t,y=p),linetype='dashed')+
  theme(legend.position="top")+ggtitle('Non-parametric Hazard Model')


pred_param = all_data %>% select(kp,type,t,pmean)


pred_data = merge(pred_param, pred_log)
pred_rmse = pred_data %>% group_by(kp,type,t) %>% summarize(rmse=sqrt(mean((y-pmean)^2)))
pred_rmse$sample = 'outsample'


fit_data = merge(pred_param, fit_log)
fit_rmse = fit_data %>% group_by(kp,type,t) %>% summarize(rmse=sqrt(mean((y-pmean)^2)))
fit_rmse$sample = 'insample'


rmse = rbind(pred_rmse,fit_rmse)
qplot(data=rmse,x=t,y=rmse,col=type,facets=kp~sample,geom='line')
