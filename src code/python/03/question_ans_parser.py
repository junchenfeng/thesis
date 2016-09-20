# encoding:utf-8
# parse the question answer
import ast
import ipdb
data = []
with open('C:/Users/junchen/Documents/GitHub/thesis/_data/03/question_ans.txt',encoding="utf8") as f:
	for line in f:
		id, eid, ans_str = line.strip().split('\t')
		
		
		ans = ast.literal_eval(ans_str)
		if id == '1_1534481':
			ans[0][0] = ''
		if id == '1_1232192':
			ans[0] = ''
		if id == '1_1753511':
			ans[0] = [[''],['']]
		
		if eid in ['Q_10201056649366', 'Q_10201056655901', 'Q_10201058056988', 'Q_10201056666357']:
			if len(ans[0]) ==2:
				ans1, ans2 = ans[0]
			elif len(ans[0]) == 1:
				ans1 = ans[0][0]
				ans2 = ''
			sub_ans_1 = ''; sub_ans_2 = ''
		elif eid == 'Q_10201056658103':
			ans3, ans1, ans2 = ans
			
			ans1 = ans1[0] if ans1 else ''	
			ans2 = ans2[0] if ans2 else ''
			sub_ans_1, sub_ans_2 = ans3
		else:
			continue
		data.append((id,eid,ans1,ans2,sub_ans_1, sub_ans_2, '[["%s","%s"]]'%(ans1,ans2)))
		
with open('C:/Users/junchen/Documents/GitHub/thesis/_data/03/question_ans_parsed.txt','w',encoding="utf8") as f2:
	for log in data:
		f2.write('%s\t%s\t%s\t%s\t%s\t%s\t%s\n' % log)