# simulate the observed response curve given hybrid model
import numpy as np
import os
proj_dir =  os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))


import ipdb

import sys
kpid = sys.argv[1]

# read the paramter
parameter_file_path = proj_dir + '/_data/01/res/%s/full_point_estimation.txt' % kpid

with open(parameter_file_path) as f:
	for line in f:
		mod_name, s_s, g_s, pi_s, l_s, h01_s, h02_s, h03_s, h04_s, h05_s, h11_s, h12_s, h13_s, h14_s, h15_s = line.strip().split(',')
		if mod_name == 'mcmc_s':
			break
			
# model parameters
s = float(s_s)
g = float(g_s)
pi = float(pi_s)
l = float(l_s)
h0_vec = [float(h01_s), float(h02_s), float(h03_s), float(h04_s), float(h05_s)]
h1_vec = [float(h11_s), float(h12_s), float(h13_s), float(h14_s), float(h15_s)]

# sim parameters
N = 5000
T = 5

hazard_matrix = np.array([h0_vec, h1_vec])
state_init_dist = np.array([1-pi, pi])
state_transit_matrix = np.array([[1-l, l],[0, 1]])
observ_matrix = np.array([[1-g,g],[s,1-s]])

# The data format is
# id, t, y, is_observed, x
data = []
for i in range(N):
	end_of_spell = 0
	is_observ = 1
	for t in range(T):
		if t ==0:
			S = int( np.random.binomial(1, state_init_dist[1]) )
		else:
			S = int( np.random.binomial(1, state_transit_matrix[S, 1]) )
		
		y = int( np.random.binomial(1, observ_matrix[S, 1]) )
				
		# update if observed
		if end_of_spell == 1:
			is_observ = 0
		# the end of the spell check is later than the is_observ check so that the last spell is observed
		if end_of_spell == 0:
			# check if the spell terminates
			if np.random.uniform() < hazard_matrix[y,t]:
				end_of_spell = 1
	
		data.append((i, t, y, S, end_of_spell, is_observ))
		

		
with open(proj_dir + '/_data/01/res/%s/sim.txt'% kpid,'w') as f:
	for log in data:
		f.write('%d,%d,%d,%d,%d,%d\n' % log)