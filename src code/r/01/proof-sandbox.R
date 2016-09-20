library(ggplot2)
library(dplyr)



update_mastery <- function(pi, l){
  return (pi + (1-pi)*l)
}

posterior_pi <- function(pi,s,g,h0,h1){
  c1 = pi*s*(1-h0)+pi*(1-s)*(1-h1)
  c0 = (1-pi)*(1-g)*(1-h0) + (1-pi)*g*(1-h1)
  return (c1/(c1+c0))
}

Ti = 20
pi_vec = seq(0.1,0.9,0.1)
l_vec = seq(0.1,0.9,0.1)
s_vec = seq(0,0.3,0.1)
g_vec = seq(0,0.5,0.1)
h0_vec = seq(0,0.7,0.1)
h1_vec = seq(0,0.7,0.1)

res = expand.grid(pi=pi_vec,l=l_vec,s=s_vec,g=g_vec,h0=h0_vec,h1=h1_vec,err=0)

pi = 0.2
l = 0.3
s = 0.1
g = 0.1
h0 = 0.7
h1 = 0.3


for (pi in pi_vec){
  for (l in l_vec){
    for (s in s_vec) {
      for(g in g_vec){
        for (h0 in h0_vec){
          for (h1 in h1_vec){
            if (h1>=h0){
              next
            }
            test_h = data.frame(t=seq(1,Ti),x=as.numeric(0),lhat=as.numeric(0))
            test_h$x[1] = pi
            for (t in seq(2,Ti)){
              # calculate the posterior x
              x_survive = posterior_pi(test_h$x[t-1],s,g,h0,h1)
              test_h$x[t] = update_mastery(x_survive,l)
              test_h$lhat[t] = (test_h$x[t]- test_h$x[t-1])/(1-test_h$x[t-1])
            }
            # asympotic error
            res$err[res$pi==pi&res$l==l&res$s==s&res$g==g&res$h0==h0&res$h1==h1] =  test_h$lhat[Ti]-l
          }
        }
      }
    }
  }
}

posterior_pi(0.7,0.05,0.2,0.5,0.0)

