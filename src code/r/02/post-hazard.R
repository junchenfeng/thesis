library(dplyr)
library(tidyr)


complete_likelihood<-function(x,y,h,pi,c,hr){
  # P(X,Y,H) = P(Y|X)P(H|X)P(X)
  pyx = y*c+(1-y)*(1-c)
  px = x*pi + (1-x)*(1-pi)
  phx = h*hr+(1-h)*(1-hr)
  return(pyx*px*phx)
}

conditional_x_density_xh <-function(pi,l,h0,h1){
  # p(X_t=1|H_t-1=0) = p(X_t=1,H_t-1=0)/(p(X_t=1,H_t-1=0)+p(X_t=0,H_t-1=0))

  # p(X_t=1,H_t-1=0) = P(X_t=1,X_t-1=0,Ht-1=0)+P(X_t=1,X_t-1=1,Ht-1=0)
  p10 = l*(1-pi)*(1-h0) + pi*(1-h1)
  # p(X_t=0,H_t-1=0) = P(X_t=0,X_t-1=0,Ht-1=0)
  p00 = (1-l)*(1-pi)*(1-h0)

  return(p10/(p10+p00))
}

trans_x2y_hazard<-function(pi,c0,c1,h0,h1, idx){
  # P(H|Y) = P(Y,H)/(P(Y,H=1)+P(Y,H=0))
  # P(Y,H)== P(X=1,Y,H)+P(X=0,Y,H)
  # PXYH

  if (idx==1){
    p111 = complete_likelihood(1,1,1,pi,c1,h1)
    p011 = complete_likelihood(0,1,1,pi,c0,h0)
    p010 = complete_likelihood(0,1,0,pi,c0,h0)
    p110 = complete_likelihood(1,1,0,pi,c1,h1)
    p11 = p111+p011
    p10 = p110+p010
    h = p11/(p11+p10)
  }else{
    p101 = complete_likelihood(1,0,1,pi,c1,h1)
    p001 = complete_likelihood(0,0,1,pi,c0,h0)
    p100 = complete_likelihood(1,0,0,pi,c1,h1)
    p000 = complete_likelihood(0,0,0,pi,c0,h0)
    p01 = p101+p001
    p00 = p100+p000
    h = p01/(p01+p00)
  }
  return(h)
}


gather_hr <- function(hr_data){
  h_data = hr_data %>% select(t,yhmean,whmean) %>% rename(correct=yhmean,incorrect=whmean) %>% gather(res,h,-t)
  hmax_data = hr_data %>% select(t,yhmax,whmax) %>% rename(correct=yhmax,incorrect=whmax) %>% gather(res,hmax,-t)
  hmin_data = hr_data %>% select(t,yhmin,whmin) %>% rename(correct=yhmin,incorrect=whmin) %>% gather(res,hmin,-t)
  data = merge(h_data,hmax_data, by=c('t','res'))
  data = merge(data,hmin_data, by=c('t','res'))
  return(data)
}

imputate_hazard_rate <- function(test_data, Tmax){
  alldata = data.frame(t=seq(1,Tmax), hr=as.numeric(0), pc = as.numeric(0), pw = as.numeric(0),Nc=as.numeric(0),Nw=as.numeric(0))
  for (t in seq(1,Tmax)){
    base_num = sum(test_data$t==t)
    exit_num = sum(test_data$t==t & test_data$idx==1)
    base_yes_num = sum(test_data$t==t & test_data$atag==1)
    base_no_num = sum(test_data$t==t & test_data$atag==0)
    exit_yes_num = sum(test_data$t==t & test_data$atag==1 & test_data$idx==1)
    exit_no_num =  sum(test_data$t==t & test_data$atag==0 & test_data$idx==1)
    alldata[t,] = c(t, exit_num/base_num, exit_yes_num/base_yes_num, exit_no_num/base_no_num, base_yes_num, base_no_num)
  }
  alldata =  alldata %>% mutate(sdc=sqrt(pc*(1-pc)/Nc),sdw=sqrt(pw*(1-pw)/Nw))

  hr_point = alldata %>% select(t,pc,pw) %>% rename(correct=pc,incorrect=pw) %>% gather(res,h,-t)
  hr_sd = alldata %>% select(t,sdc,sdw) %>% rename(correct=sdc,incorrect=sdw) %>% gather(res,sd_h,-t)
  harzard_rate_data = merge(hr_point,hr_sd,by=c('t','res'))
  return(harzard_rate_data)
}


proj_dir = getwd()
kpids = c('87','138')
kpnames = c('Two Digit Multiplication', 'Vertical Division')
maxT= 4

## Prop Model
for (i in seq(2)){
  # read in data
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/yh.txt')
  y_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','lambda0','beta0','lambda1','beta1'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/xh.txt')
  x_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','lambda0','beta0','lambda1','beta1'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/spell_data_',kpids[i],'.csv')
  kp_spell_data = read.csv(file_path, col.names=c('spell_id','t','atag','idx'),header=F)

  # get the hazard rates
  for (j in seq(nrow(y_param_data))){
    tmp = data.frame(t=seq(4), yh=y_param_data$lambda1[j]*exp(y_param_data$beta1[j]*(seq(4)-1)), wh=y_param_data$lambda0[j]*exp(y_param_data$beta0[j]*(seq(4)-1)),idx=j)
    if (j==1){
      y_hr_dist=tmp
    }else{
      y_hr_dist = rbind(y_hr_dist,tmp)
    }
  }

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
    tmp = data.frame(t=seq(4),yh=as.numeric(0),wh=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = conditional_x_density_xh(pi, l, x_hrs$wh[t-1], x_hrs$yh[t-1])
      }
      tmp$yh[t]=trans_x2y_hazard(pi,c0,c1,x_hrs$wh[t],x_hrs$yh[t],1)
      tmp$wh[t]=trans_x2y_hazard(pi,c0,c1,x_hrs$wh[t],x_hrs$yh[t],0)
    }

    if (j==1){
      xy_hr_dist = tmp
    }else{
      xy_hr_dist = rbind(xy_hr_dist, tmp)
    }
  }

  # calculate the mean and the 95 credible interval
  y_hr = y_hr_dist %>% group_by(t) %>% summarize(yhmean=mean(yh),whmean=mean(wh),
                                                 yhmax=quantile(yh,prob=0.95), whmax=quantile(wh,prob=0.95),
                                                 yhmin=quantile(yh,prob=0.05), whmin=quantile(wh,prob=0.05))
  xy_hr = xy_hr_dist %>% group_by(t) %>% summarize(yhmean=mean(yh),whmean=mean(wh),
                                                   yhmax=quantile(yh,prob=0.95), whmax=quantile(wh,prob=0.95),
                                                   yhmin=quantile(yh,prob=0.05), whmin=quantile(wh,prob=0.05))
  y_h_data = gather_hr(y_hr)
  y_h_data$type = 'Response Dependent'
  xy_h_data = gather_hr(xy_hr)
  xy_h_data$type = 'State Dependent'

  # compute the real data
  emp_h_data = imputate_hazard_rate(kp_spell_data, maxT)
  emp_h_data$res = factor(emp_h_data$res)
  emp_h_data =  emp_h_data %>% mutate(hmax=h+1.97*sd_h,hmin=h-1.97*sd_h) %>% select(t,res,h) %>% rename(hd=h)

  tmp_data = rbind(y_h_data, xy_h_data)
  tmp_data = merge(tmp_data, emp_h_data)
  tmp_data$kp = kpnames[i]

  if(i==1){
    all_data = tmp_data
  }else{
    all_data = rbind(all_data,tmp_data)
  }
}


qplot(data=all_data, x=t,y=h,geom='line', col=res) +  facet_grid(kp~type)+
  geom_errorbar(aes(x=t, ymin=hmin, ymax=hmax,color=res),width=0.1) +  facet_grid(kp~type)+
  geom_line(aes(x=t,y=hd,col=res),linetype='dashed')+
  theme(legend.position="top")


## Nonparametric Model
for (i in seq(2)){
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/yh_np.txt')
  y_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','h01','h02','h03','h04','h11','h12','h13','h14'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/res/',kpids[i],'/xh_np.txt')
  x_param_data = read.table(file_path, col.names=c('l','pi','c0','c1','h01','h02','h03','h04','h11','h12','h13','h14'), header=F,sep=',')
  file_path = paste0(proj_dir,'/_data/02/spell_data_',kpids[i],'.csv')
  kp_spell_data = read.csv(file_path, col.names=c('spell_id','t','atag','idx'),header=F)


  for (j in seq(nrow(y_param_data))){

    h0s = c(y_param_data$h01[j],y_param_data$h02[j],y_param_data$h03[j],y_param_data$h04[j])
    h1s = c(y_param_data$h11[j],y_param_data$h12[j],y_param_data$h13[j],y_param_data$h14[j])
    tmp = data.frame(t=seq(4), yh=h1s, wh=h0s,idx=j)
    if (j==1){
      y_hr_dist=tmp
    }else{
      y_hr_dist = rbind(y_hr_dist,tmp)
    }
  }


  for (j in seq(nrow(x_param_data))){
    lambda0 = x_param_data$lambda0[j]
    lambda1 = x_param_data$lambda1[j]
    beta0 = x_param_data$beta0[j]
    beta1 = x_param_data$beta1[j]
    l = x_param_data$l[j]
    pi = 1-x_param_data$pi[j]
    c0 = x_param_data$c0[j]
    c1 = x_param_data$c1[j]

    h0s = c(x_param_data$h01[j],x_param_data$h02[j],x_param_data$h03[j],x_param_data$h04[j])
    h1s = c(x_param_data$h11[j],x_param_data$h12[j],x_param_data$h13[j],x_param_data$h14[j])

    tmp = data.frame(t=seq(4),yh=as.numeric(0),xh=as.numeric(0))
    for (t in seq(4)){
      if (t!=1){
        pi = conditional_x_density_xh(pi, l, x_hrs$wh[t-1], x_hrs$yh[t-1])
      }
      tmp$yh[t]=trans_x2y_hazard(pi,c0,c1,h0s[t],h1s[t],1)
      tmp$wh[t]=trans_x2y_hazard(pi,c0,c1,h0s[t],h1s[t],0)
    }

    if (j==1){
      xy_hr_dist = tmp
    }else{
      xy_hr_dist = rbind(xy_hr_dist, tmp)
    }
  }

  # calculate the mean and the 95 credible interval

  y_hr = y_hr_dist %>% group_by(t) %>% summarize(yhmean=mean(yh),whmean=mean(wh),
                                                 yhmax=quantile(yh,prob=0.95), whmax=quantile(wh,prob=0.95),
                                                 yhmin=quantile(yh,prob=0.05), whmin=quantile(wh,prob=0.05))
  xy_hr = xy_hr_dist %>% group_by(t) %>% summarize(yhmean=mean(yh),whmean=mean(wh),
                                                   yhmax=quantile(yh,prob=0.95), whmax=quantile(wh,prob=0.95),
                                                   yhmin=quantile(yh,prob=0.05), whmin=quantile(wh,prob=0.05))
  y_h_data = gather_hr(y_hr)
  y_h_data$type = 'Response Dependent'
  xy_h_data = gather_hr(xy_hr)
  xy_h_data$type = 'State Dependent'

  # compute the real data
  emp_h_data = imputate_hazard_rate(kp_spell_data, maxT)
  emp_h_data$res = factor(emp_h_data$res)
  emp_h_data =  emp_h_data %>% mutate(hmax=h+1.97*sd_h,hmin=h-1.97*sd_h) %>% select(t,res,h) %>% rename(hd=h)

  tmp_data = rbind(y_h_data, xy_h_data)
  tmp_data = merge(tmp_data, emp_h_data)
  tmp_data$kp = kpnames[i]

  if(i==1){
    all_data = tmp_data
  }else{
    all_data = rbind(all_data,tmp_data)
  }
}


qplot(data=all_data, x=t,y=h,geom='line', col=res) +  facet_grid(kp~type)+
  geom_errorbar(aes(x=t, ymin=hmin, ymax=hmax,color=res),width=0.1) +  facet_grid(kp~type)+
  geom_line(aes(x=t,y=hd,col=res),linetype='dashed')+
  theme(legend.position="top")

