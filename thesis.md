Learning Through Practices
========================================================
author: Junhen Feng
autosize: true



Main Result
========================================================
type: section

- A model of Learning Through Practice (LTP)
    - define the efficacy of practice in relation to a dynamic learning process
    - incorporate learner engagement, including stop decision and effort decision

- Identification and Estimation of the LTP model

- Empirical Application
    - Stop Decision:  A majority of the observed learning gain is dynamic selection bias due to sample attrition
    - Effort Decision:  Identify statistical significant effect in a RCT where DID failed to do


Motivation
========================================================
type: section


For a Better Intelligent Tutoring System (ITS)
========================================================

- Human teacher collaborates with an ITS is the future of education

- Dual roles of Practice
    - assessment 
    - instruction
    
- When the question bank is given
    - selection
    - sequencing
    

Computerized Adaptive Testing (CAT) is not Sufficient
========================================================

- CAT aims to measure the latent ability with certain precision by as few questions as possible

- A good exam question can be a bad practice question
    - A good exam question: 
    
    A learner above the threshold will succeed while a learner below the threshold will fail
    
    - A good practice question: 
    
    A learner below the threshold has a shot at solving the problem with hints and helps
    
- Item Response Theory (IRT) implicitly assumes no learning


Understanding Learner Heterogeneity is Essential
========================================================

- User heterogeneity is the essential reason for individualization

- Learner heterogeneity:
    - Different level of current mastery (Assessment)
    - Different gain to the same pedagogy (Instruction)

- Efficacy of practice = Learning Gain


Mastery, Learning, Practice and Efficacy
========================================================

- Mastery:

The capability to solve a  problem or perform a task in a particular domain

- Learning:

A process in which a learner becomes capable of solving a problem that she is unable to previously

- Practice:

Solving a sequence of problems

- Efficacy:

The probability of moving a learner from a lower mastery state to a higher one



Navigation
========================================================

- [Chapter 2](#/chp2): The Learning Through Practice Model
- [Chapter 3](#/chp3): Identification
- [Chapter 4](#/chp4): Estimation
- [Chapter 5](#/chp5): Dynamic Selection Bias
- [Chapter 6](#/chp6):Effectiveness V.S.Efficacy



Chapter 2: A Model of Learning Through Practice
========================================================
id: chp2
type: section

- [The Learning Process](#/lp)

- [The Effort Decision] (#/ed)

- [The Stop Decision](#/sd)



Event Sequence
========================================================
id: lp

1. A learner is presented with a practice item

2. The learner produces a response based on her state of latent mastery

3. The learner receives feedback on the observed response.

4. The learner learns (elevates her latent mastery) probabilistically.


Assumptions on Latent Mastery 
========================================================

**Assumption 1**:  Latent mastery ($X_t$) is a unidimenstional ordered discrete variable with $M_x$ number of states.

+ Avoid factorial state representation (mapping of knowledge points to items)

+ As flexible as a continuous latent mastery if the number of states is allowed to vary


Assumptions on Efficacy (1)
========================================================

- A general definition of efficacy: 

The probability of practice item $j$ moving the state of mastery of a learner of type $z$ from $m$ to $n$ ($m\leq n$) at sequence position $t$, after exposing to feedback ($Y_t$) on the current item $j$ and feedback ($\mathbf{Y}_{1,t-1}$) on the preceding items ($\mathbf{A}_{1,t-1}$) 

**Assumption 2**: Pedagogical efficacy does not dependent on responses conditional on the previous latent mastery.

**Assumption 3**: There is no complementarity or substitution effect in the item composition.

**Assumption 4**: The pedagogical efficacy is independent of the sequence position.

- The working definition of efficacy:

The probability of practice item $j$ moving the state of mastery of a learner of type $z$ from $m$ to $n$

$\ell^{z;m,n}_{j} \equiv P(X_t=n|X_{t-1}=m;Z=z;A_t=j)$


Efficacy and Heterogeneity
========================================================


- Heterogeneity Based on State: $\ell^{z;m,n}_j\neq\ell^{z;k,n}_j$

A first grade and a college freshman learn calculus. 

Same destination different starting point.


- Heterogeneity Based on Type: $\ell^{z;m,n}_j\neq\ell^{k;m,n}_j$

An art major and an econ major learn calculus. 

Same starting point and destination but different speed.


Assumptions on Efficacy (2)
========================================================

**Assumption 5**: The latent mastery never regresses.

$$
\ell^{z;m,n}_{j} = 0 \quad \forall t,z,j \quad\text{where} \quad m < n
$$


Assumptions on Observed Response
========================================================
id:lp2

**Assumption 6**: The distribution of observed response ($Y_t$) conditional the latent mastery is the same for all learner types.

$P(Y_{t}=r|X_t=k,A_t=j)  \equiv c^{r,k}_j$

[Example 1: Bayesian Knowledge Tracing Model](#/bkt)


Learning Through Practice With Learner Engagement
========================================================

- The duration and the intensity of learner engagement are imperfect in a low stake learning environment
    + Duration: the stop decision
    + Intensity: the effort decision
    
- New Event Sequence

1. A learner is presented with a practice question.

2. The learner exerts a level of effort based on her state of latent mastery

3. The learner produces a response based on the effort level and her state of latent mastery. 

4. The learner receives feedback on the observed response.

5. If the learner has exerted effort, she learns probabilistically. Otherwise, she does not learn.

6. The learner can choose or be forced to exit. If the learner continues, repeat from (1); else data collection stops.


The Effort Decision (1)
========================================================
id: ed
**Assumption 6**: Effort is a binary choice with value 0 and 1.

**Assumption 7**: Conditioning on the latent mastery and the item, the effort choice is independent

$$
P(E_t=1|Z=z,X_t=k,A_t=j) = \gamma_j^{z;k}
$$


- Grit is a characteristic of the state of mastery, not the learner



The Effort Decision (2)
========================================================
**Assumption 8** (No pain no gain): If a learner does not exert effort, she does not learn

$P(X_t=n|X_{t-1}=m, Z=z, A_t=j, E_t=0) = 0 \quad \forall z,t,j, \text{and }m > n$

**Assumption 9** (No Educated Guess): If a learner does not exert effort, she makes a wrong response for sure

$P(Y_t=0|E_t=0,A_t=j) = 1  \quad \forall j,t$

[to Chapter 5](#/chp5)


The Stop Decision
========================================================
id: sd

- Depdence Structure
    + Stop-by-rule: Learners are forced to exit based on responses
        - X-strike rule: Three mistakes and out (Old Duolingo)

    + Stop-by-choice: Learners are forced to exit based on latent mastery
        - Boredom V.S. Frustration 

- Functional Form ($h_t^k \equiv P(H_t=1|H_{t-1}=0,S_t=k)$):
    + Proportional Hazard: $h_t^k= \lambda_k e^{\beta_k t}$
    + Non-parametric: $h_{t}^k$


**Assumption 10**: Stop decision is independent of item characteristics

[to Chapter 6](#/chp6)



Express Learning Theories with the LTP model
========================================================
id: ltp_example
- [Zone of Proximal Development](#/zpd)

- [Reinforcement Learning](#/rl)


Chapter 3: Model Identification
========================================================
id: chp3
type: section



Identification of the BKT Model (1)
========================================================

- The BKT is considered as the BKT model by the learning analytics literature

    + The following model specification has the same learning curve



|     model     |  pi  |  l  |  g   |  s   |
|:-------------:|:----:|:---:|:----:|:----:|
|   Knowledge   | 0.56 | 0.1 | 0.00 | 0.05 |
|     Guess     | 0.36 | 0.1 | 0.30 | 0.05 |
| Reading Tutor | 0.01 | 0.1 | 0.53 | 0.05 |

***

![plot of chunk unnamed-chunk-2](thesis-figure/unnamed-chunk-2-1.png)

Identification of the BKT Model (2)
========================================================

- These models have different distribution of joint responses
    + They are sufficient statistics
    + It implies different likelihood and model identification


***

![plot of chunk unnamed-chunk-3](thesis-figure/unnamed-chunk-3-1.png)


Identification of the BKT Model (3)
========================================================
id: bkt_id
- In Bayesian analysis, identification (in the frequestist sense) implies:
    + The posterior distribution of parameters with a non-informative prior is single modality
    + The mean of such posterior distributions converges to the "true" parameter in large sample

[formal proof](#/bkt_proof)

![plot of chunk unnamed-chunk-4](thesis-figure/unnamed-chunk-4-1.png)


Necessary Identification Conditions
=======================================================
id: ltp_id

- The data generating system described by the LTP model has sufficient statistics

- The sufficient statistics are moment conditions for identification

- Identification Conditions:
    + More moment conditions than parameters
    + Jacobian matrix at the local optimal solution has full column matrix

[formal proof](#/ltp_proof)


Label Switching and Rank Order Condition
=======================================================

- Label Switching
    + In latent state model, the label of states is arbitrary.
    + Arbitrary labels in MCMC algorithm results in poor mixture

- Rank Order Condition:
    + States: A learner with higher state of mastery has higher probability of correct response

    $$P(Y_t=1|X_t=m) < P(Y_t=1|X_t=n) \forall m < n$$

    + Type: A learner with higher type has higher probability of  initial mastery

    $$P(X_1=1|Z=w) < P(X_1=1|Z=v) \forall w < v$$

Chapter 4: Model Estimation
========================================================
id: chp4
type: section


An Overview of Monte Carlo Markov Chain Algorithm
========================================================

- General Strategy:
    + First augment the observed data with latent states given parameters
    + Update parameters with Gibbs sampler given the augmented data


Priors
========================================================

- Parameters that follow a multinomial distribution is the non-informative Dirichelet distribution $Dir(1,\dots,1)$
    + Initial mastery probability ($\pi_0,\dots,\pi_{M_X-1}$)
    + Type Density ($\alpha_1,\dots,\alpha_{M_Z}$)
    + Pedagogical efficacy conditional on latent mastery $k$ ($\ell^{z;k,k+1}_j,\dots,\ell^{z;k,M_X-1}_j$)
    + Response Probability conditional on latent mastery $k$ ($c_j^{0,k},\dots,c_j^{M_Y-1,k}$)
    + Nonparametric hazard rate condition on state $k$ and position $t$ ($h^t_k$)

- Proportional hazard model ($\gamma_j^{z,k},\beta_j^{z,k}$) follows uniform distrubtion


Notation
========================================================
- $j$: The item id
- $t$: The sequence id. [*Not clock time*]
- $X_t$: The latent state of knowledge mastery
- $Y_t$: The observed response grade
- $E_t$: The observed effort
- $H_t$: If the learner stops at sequence $t$
- $A_t$: The item $j$ is at $t^{th}$ practice sequence


Notation
========================================================
+ $i$: the the learner id
+ $N$: the number of learners
+ $T_i$:the sequence length of learner $i$.
+ $\mathbf{X}_{1,T_i}^i$: The latent state sequence. $(X^i_1,\dots,X^i_{T_i})$
+ $\mathbf{Y}_{1,T_i}^i$: The answer sequence. $(Y^i_1,\dots,Y^i_{T_i})$
+ $\mathbf{A}_{1,T_i}^i$: The item sequence.   $(A^i_1,\dots,A^i_{T_i})$
+ $\mathbf{E}_{1,T_i}^i$: The effort sequence. $(E^i_1,\dots,E^i_{T_i})$
+ $\mathbf{H}_{1,T_i}^i$: The stop sequence.   $(H^i_1,\dots,H^i_{T_i})$

Likelihood (1)
========================================================

- Likelihood of observed data

$$
P(\mathbf{Y},  \mathbf{E}, \mathbf{H}|\mathbf{A},\Theta) \propto \sum_{Z=1}^{M_Z}(P(Z) \sum_{X_1}\dots\sum_{X_{T}}P(\mathbf{Y}, \mathbf{E}, \mathbf{H}, \mathbf{X}|Z,\mathbf{A},\Theta))
$$

- Conditional on Learner Type $z$

$$
P(\mathbf{Y},  \mathbf{E}, \mathbf{H}, \mathbf{X}|Z,\mathbf{A},\Theta)
= P(\mathbf{H}|Z,\mathbf{X},\mathbf{Y},\Theta)P(\mathbf{Y}|Z,\mathbf{X},\mathbf{A},\mathbf{E},\Theta)P(\mathbf{E},\mathbf{X}|Z,\mathbf{A},\Theta)
$$

- Conditional likelihood of Observed Response

$$
P(\mathbf{Y}|Z,\mathbf{X},\mathbf{E},\mathbf{A},\Theta) = \prod_{t=1}^{T} \prod_{k=0}^{M_X-1}\prod_{j=1}^J[ \prod_{r=0}^{M_Y-1} (c_j^{r,k})^{I(A_t=j,Y_t=r,X_t=k,E_t=1)}\prod_{r=1}^{M_Y-1}0^{I(A_t=j,Y_t=r,X_t=k,E_t=0)}]
$$

- Conditional likelihood of Hazard Rate

$$
\begin{aligned}
P(\mathbf{H}|Z,\mathbf{X},\Theta) &=  \prod_{t=1}^{T}\prod_{k=0}^{M_X-1}(\lambda_{z;k}e^{\beta_{z;k}t})^{I(H_t=1,X_t=k,Z=z)}(1-\lambda_{z;k}e^{\beta_{z;k}t})^{I(H_t=0,X_t=k,Z=z)}\\
P(\mathbf{H}|Z,\mathbf{S},\Theta) &=  \prod_{t=1}^{T}\prod_{k=0}^{M_S-1}(h_t^{z;k})^{I(H_t=1,S_t=k,Z=z)}(1-h_t^{z;k})^{I(H_t=0,Z=z,S_t=k)}
\end{aligned}
$$

Likelihood (2)
========================================================

- Conditional likelihood of the Effort and the Latent State

$$
\begin{aligned}
P(\mathbf{X},\mathbf{E}|\mathbf{A},\Theta,Z) &= P(X_1|Z)P(E_1|X_1,Z)\prod_{t=2}^{T}P(X_t|X_{t-1},Z,E_{t-1})P(E_t|X_t,Z)\\
P(X_1|Z) &= \prod_{k=0}^{M_X-1}(\pi^{z;k})^{I(X_1=k,Z=z)}\\
P(E_t|X_t,Z,\mathbf{A}) &=\prod_{j=1}^J(\gamma_j^{z;k})^{I(A_t=j,Z=z,X_t=k,E_t=1)}(1-\gamma_j^{z;k})^{I(A_t=j,Z=z,X_t=k,E_t=0)}\\
P(X_t|X_{t-1},E_{t-1},Z,\mathbf{A})&=\prod_{j=1}^J\{[\prod_{k=1}^{M_X-2} (1-\sum_{n=k+1}^{M_X-1} \ell^{z;k,n}_j)1^{I(A_{t-1}=j,X_{t-1}=k,X_t=n,Z=z,E_t=1)}]\\
&[\prod_{m=1}^{M_X-2}\prod_{n=k+1}^{M_X-1}(\ell^{z;m,n}_j)^{I(A_{t-1}=j,X_{t-1}=m,X_t=n,Z=z,E_t=1)}]\}
\end{aligned}
$$



Augment State (Brute Force)
========================================================

- The latent states can be generated by rule. Given the latent states, calculate the likelihood marginalizing out nuisance states.

$$
\begin{aligned}
P(X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)&=\sum_{X_1}\dots\sum_{X_{t-1}}\sum_{X_{t+1}}\dots\sum_{X_T} P(\mathbf{X},\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)\\
P(X_{t-1}=m,X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)&=\sum_{X_1}\dots\sum_{X_{t-2}}\sum_{X_{t+1}}\dots\sum_{X_T} P(\mathbf{X},\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta) \quad \text{(4.1)}
\end{aligned}
$$

- The backward sampling scheme is
    + Sample the latest latent state $X_T$ by  $P(X_T=n|\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)$
    + Given the sampled $X_{t+1}$, sample the last latent state $X_t$ by $P(X_{t-1}=m|,X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)$

$$
\begin{aligned}
P(X_T=n|\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)&=  \frac{P(X_T=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)}{\sum_{k=0}^{M_X-1}P(X_T=k,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)}\\
P(X_{t-1}=m|,X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta) &= \frac{P(X_{t-1}=m,X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)}{P(X_t=n,\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},Z,\Theta)}
\end{aligned}
$$

Augment State (Forward Recusion and Backward Sampling)
========================================================

- The FRBS algorithm is essentially the brute force algorithm

- The computation cost is reduced by leveraging the conditional independence of the First Order Markov Chain

[details](#/frbs)

Augment Learner Type
========================================================

$$
P(Z=z|\mathbf{Y},\mathbf{E},\mathbf{H},\mathbf{A},\Theta) = \frac{\alpha_zP(\mathbf{Y},\mathbf{E},\mathbf{H}|\mathbf{A}Z=z,\Theta)}{\sum_{w=1}^{M_Z}(\alpha_wP(\mathbf{Y},\mathbf{E},\mathbf{H}|\mathbf{A},Z=w,\Theta))}
$$

Gibbs Sampling: Conjugate Posterior
========================================================

- The mixture density

$Dir(a_{Z_1},\dots,a_{Z_{M_Z}})$ where $a_{Z_k} = 1+\sum_{i=1}^N I(Z^i_1=k)$.

- The initial state density of learner type $z$

$Dir(a_{X_0;z},\dots,a_{X_{M_X-1};z})$ where $a_{X_k;z} = 1+\sum_{i=1}^N I(X^i_1=k,Z^i=z)$.

- The effort rates conditional on the latent state mastery ($X=k$) of learner type $z$

$Beta(a_{E_0;z},a_{E_1;z})$ where $a_{E_e;z} = 1+\sum_{t=1}^T\sum_{i=1}^N I(E_t=e, X^i_t=k,Z^i=z)$.

- The response rates conditional on the latent state mastery ($X=k$)

$Dir(a_{Y_0},\dots,a_{Y_{M_Y-1}})$ where $a_{Y_r} = 1+\sum_{t=1}^T\sum_{i=1}^N I(Y^i_t=r,X^i_t=k,E_t=1)$.

- (Nonparametric) The hazard rate conditional on the latent mastery $k$ of learner type $z$

$Beta(a_{H^{z;k}_{t,0}},a_{H^{z;k}_{t,1}})$ where $a_{H^{z;k}_{t,h}} = 1+\sum_{i=1}^N I(X^i_t=k,Z^i=z,H_t=h)$



Gibbs Sampling: Non-conjugate Posterior
========================================================
- The parameters of the hazard model can still be drew by full conditional distribution
- No conjugate prior -> draw new parameter is expensive
- Adaptive Rejection Sampler uses the log concavity to speed up
  + Key is to reduce the number of the expensive evaluations of the target likelihood function
  + Use upper hull and lower hull to sandwich the target likelihood function by splines
  + draw from the area between the upper hull and lower hull
- The conditional distribution of $\lambda$ and $\beta$ are log concave
  + $\lambda e^{\beta T}<1$ contrains the initial sampling point

[details](#/ars)


Chapter 5: Dynamic Selection Bias of Sample Attrition
========================================================
type:section
id:chp5


Motivation
=======================================================

- Which practice has better efficacy?
    + Conventional wisdom says long division because the learning curve rises more sharply
    
***

![plot of chunk unnamed-chunk-5](thesis-figure/unnamed-chunk-5-1.png)


Dynamic Selection Bias
=======================================================

- Assume the composition of latent types are static when it is chaning

- Assume the change in composition of latent types are from efficacy while it is partly from differential attrition
    + Let the true efficacy be zero. The true learning curve is flat
    + Let learners without mastery be more likely to dropout
    + The proportion of learners without mastery descreases overtime, which results in an upward sloping learning curve

- Differential attrition is a Necessary, but not Sufficient, condition for bias in the estimated parameters
    + The dependence structure of the stop decision matters
    
Stop-by-rule or Stop-by-choice 
=======================================================

- Stop-by-rule:

    + The exit from practice due to a system rule, which is usually based on the observed response.

    + E.g. In old Duolingo, a learner can make three errors before being forced to stop

![plot of chunk unnamed-chunk-6](fig/duolingo_screenshot.png)

***

- Stop-by-choice:
    + The exit from practice due to learner's own initiative when she could have continued to practice, which is usually the consequence of learner's non-cognitive skill
    + Link (different) non-cognitive skills to states of latent mastery
        - Without mastery: resiliance against frustration
        - With mastery: resiliance against boredom

Dependence Structure and Dynamic Selection Bias
=======================================================

- If the stop decision is stop-by-rule
    + Both BKT and LTP consistently estimate parameters of the learning process

- If the stop decision is stop-by-choice
    + Only LTP consistently estiamte parameters of the learning process

- Key Intuition: 
    + The parameter learning in BKT is already conditioning on responses. 
    + In stop-by-rule, conditioning on stop decision, as a function of responses, has no information value

- [Formal proof](#stop_proof):       

A Revisit of the Motivation Example
=======================================================

- [The learning environment] (#/babel)

- The system stop decision is stop-by-rule:
    + The practice ends if learners accumulate 2-3 errors or 3-4 successes

- The empirical hazard rate shows that there are stop-by-choice
    + Hazard rate is not zero in the first period

- Long division has bigger selective sample attrition
    
***
![plot of chunk unnamed-chunk-7](thesis-figure/unnamed-chunk-7-1.png)

Hazard Rates are Reasonably Estimated 
=======================================================
![plot of chunk unnamed-chunk-8](fig/hr-fit.png)

Majority of the Observed Learning Gain is Spurious
=======================================================

- The counterfactual learning curve without selection

![plot of chunk unnamed-chunk-9](fig/lc_fit_efficacy.png)

***

- The predicted learning curve with selection

![plot of chunk unnamed-chunk-10](fig/lc_fit_attrition.png)


Chapter 6: Effort Choice and Efficacy Ranking
========================================================
id: chp6
type: section


Motivation: Learner Engagement in a Low Stake Learning Environment
========================================================

- An emerging literature on students not giving their best at learning
    + The problem has been recognized for a decade in the learning analytics
    + The problem starts to get attraction in economics due to Levitt's work on incentive
    
- If a program does not have effectiveness:
    + No pedagogical efficacy
    + Has pedagogical efficacy but also low effort appeal
    
- Randomized Control Trial design does not preclude the problem of effort

Difference in Difference as a Measure of Effectiveness
========================================================

- RCT allows the estimation of ATE

$$
ATE = [E(Y|D=T,t=1)-E(Y|D=C,t=1)]-[E(Y|D=T,t=0)-E(Y|D=C,t=0)]  \quad \text{(6.1)}
$$

- DID estimates the ATE by

$$
Y_{i,t} = \beta_0 + \beta_d D_i + \beta_t t + \gamma D_i t + \epsilon_{i,t}
$$

- But DID is really estimating

$$
\begin{aligned}
O_{i,t} &= Y_{i,t}E_{i,t}\\
O_{i,t} &= \beta_0 + \beta_d D_i + \beta_t t + \gamma D_i t + \epsilon_{i,t}
\end{aligned}
$$

Does DID Estimate the Same Efficacy Rank Order
========================================================

- Yes: When the control group has a null efficacy
    + Essentially a power problem
    
- No: Otherwise
    + E.g. Same Efficacy but can generate different sign of relative effectiveness with different effort specification
    + The problem does not go away in large sample

[formal proof](#/did_proof)


Case Study
========================================================

- [The learning environment](#/afenti)
    + a low stake learning environment
    + learners are known to exert low effort sometimes
![plot of chunk unnamed-chunk-11](fig/practice_screenshot.png)

***

- The experiment 
    + Goal: compare the efficacy of practice question with or without video instruction
![plot of chunk unnamed-chunk-12](fig/item.png)
- Instruction:
    + Calculate the circumference and the area of the small rectangle
    
    + To get the circumference of the large rectangle, multiply the circumference of the small rectangle by two and subtract two times of the length of the joined side
    
    + To get the area of the large rectangle,  multiply the area of the small rectangle by two


Effort Identification
========================================================

- No Effort
    + Blank Answer
    + Nonsensical answer (E.g. Emoji)

- Valid Effort:
    + An honest error
        - Mis-identified the length or width of the large rectangle
        - Either circumference or the area is correctly calculated
    + Correct answer




|   Group   | Task  | No-Effort(%) | No-Effort(SE) | Honest Error (%) | Honest Error (SE) | Correct(%) | Correct(SE) |
|:---------:|:-----:|:------------:|:-------------:|:----------------:|:-----------------:|:----------:|:-----------:|
|  Control  |  pre  |      25      |     0.87      |        28        |       0.91        |     47     |     1.0     |
| Treatment |  pre  |      27      |     0.95      |        27        |       0.95        |     46     |     1.1     |
|  Control  | train |      30      |     0.93      |        23        |       0.84        |     47     |     1.0     |
| Treatment | train |      34      |     1.01      |        21        |       0.87        |     45     |     1.1     |
|  Control  | post  |      35      |     0.96      |        16        |       0.74        |     49     |     1.0     |
| Treatment | post  |      36      |     1.03      |        16        |       0.79        |     48     |     1.1     |

Robustness of the Effort Identification
========================================================

- Distribution of Time Spent on Item without Effort 

![plot of chunk unnamed-chunk-14](thesis-figure/unnamed-chunk-14-1.png)

***


Distribution of Time Spent on Item With Effort 

![plot of chunk unnamed-chunk-15](thesis-figure/unnamed-chunk-15-1.png)


Differential Effort Level Choice
========================================================
- Fill-in-the-blanks has close to zero guess rate

- Learners who answer the pre-test item correctly must have mastery
    + The effort gap rate is 2% in the training question
    
- Learners who answer the pre-test item incorrectly either has no mastery or exert no effort
    + The effort gap rate for learners without mastery is at least 4% in the training question

- A non-zero effort gap at the pre-test
    + The RCT is not perfectly executed


| Period |   Group   | Mean Effort Rate(Y=0) | S.E(Y=0) | Mean Effort Rate(Y=1) | S.E(Y=1) |
|:------:|:---------:|:---------------------:|:--------:|:---------------------:|:--------:|
|  pre   |  Control  |         0.54          |   0.01   |         1.00          |    0     |
|  pre   | Treatment |         0.51          |   0.01   |         1.00          |    0     |
| train  |  Control  |         0.48          |   0.01   |         0.94          |    0     |
| train  | Treatment |         0.44          |   0.01   |         0.92          |    0     |
|  post  |  Control  |         0.43          |   0.01   |         0.90          |    0     |
|  post  | Treatment |         0.43          |   0.01   |         0.90          |    0     |

Result for Aggregate Score
========================================================


| Model | Est. Rel  Effectivness | Est. Rel  Efficacy | 95% CI(L) | 95% CI(H) | Treatment Better? |
|:-----:|:----------------------:|:------------------:|:---------:|:---------:|:-----------------:|
|  DID  |          0.01          |         NA         |   -0.03   |   0.05    |         N         |
|  LTP  |           NA           |        0.12        |   0.01    |   0.23    |         Y         |

Result for Component Score
========================================================


| Knowledge Component | Model | Est. Rel  Effectiveness | Est. Rel  Efficacy | 95% CI(L) | 95% CI(H) |
|:-------------------:|:-----:|:-----------------------:|:------------------:|:---------:|:---------:|
|        Area         |  LTP  |           NA            |        0.03        |   -0.12   |   0.19    |
|        Area         |  DID  |          0.02           |         NA         |   -0.02   |   0.06    |
|    Circumference    |  LTP  |           NA            |        0.23        |   0.09    |   0.40    |
|    Circumference    |  DID  |          0.01           |         NA         |   -0.03   |   0.05    |
|        Shape        |  LTP  |           NA            |        0.02        |   -0.11   |   0.15    |
|        Shape        |  DID  |          0.01           |         NA         |   -0.02   |   0.05    |

Thank You
=======================================================
type: section

<font size="80"> Q&A </font> 


Example 1: Bayesian Knowledge Tracing Model
=======================================================
id: bkt

- Developed by Corbert and Anderson(1996)
- The model is defined by four parameters:
    + Initial probability of mastery $\pi = P(X_1=1)$
    + Learning rate $\ell = P(X_t=1|X_{t-1}=0) \equiv \ell^{1;0,1}_1$
    + Guess rate: $g = P(Y_t=1|X_t=0) \equiv c^{1,0}_1$
    + Slip rate: $s = P(Y_t=0|X_t=1) \equiv 1-c^{1,1}_1$


[return](#/lp2)


Example 2: Zone of Proximal Development
=======================================================
id: zpd

- Developed by Vygosky(1976)
    + Development lags task requirement and fail the task no matter what
    + Development lags task requirement but may succeed in the task with guidance or collaboration [**The zone**]
    + Development leads task requirement and succeed on their own

- LTP representation: $M_X=3, M_Y=2,M_Z=1$ with effort decision.

$$
\begin{aligned}
P(Y_t=0|X_t=0) &\approx 1\\
P(E_t=0|X_t=0) &\approx 1\\
P(X_t=2|X_{t-1}=0) &\approx 0\\
P(Y_t=0|X_t=2) &\approx 0
\end{aligned}
$$
[return](#/ltp_example)


Example 3: Reinforcement Learning
=======================================================
id: rl

- Reinforcement learning
    + People repeat actions that reward them with pleasure and avoid actions that punish them with pain
    + The more successes a learner get, the more engaged she is; the more failures a learner gets, the less engaged she is

- LTP representation:
    + The stop decision depends on the latent mastery and the hazard rate is negatively correlated with the latent mastery
    + The effort rate is positively correlated with the latent mastery

[return](#/ltp_example)


BKT Identification :
=======================================================
id: bkt_proof

- Theorem 1:
The Bayesian Knowledge Tracing model is identified on practice sequences with length three if $\pi\neq 1$, $0 \leq \ell<1$ and $c^{1,0} \neq c^{1,1}$.

- Proof:

Let $p_{ijk} = P(Y_1=i,Y_2=j,Y_3=k)$, $p_{i,j}=P(Y_1=i,Y_2=j)$, and $p_i=P(Y_1=i)$. Let $c_1=c^{1,1}$, $c_0=c^{1,0}$. Excluding $p_{0,0,0}$, the rest seven moment conditions are:

$$
\begin{aligned}
p_{111} &=(1-\pi)(1-\ell)c_0^3+(1-\pi)(1-\ell)\ell c_0^2c_1 + (1-\pi)\ell c_0c_1^2+\pi c_1^3 \\
p_{110} &=(1-\pi)(1-\ell)c_0^2(1-c_0)+(1-\pi)(1-\ell)\ell c_0^2(1-c_1) + (1-\pi)\ell c_0c_1(1-c_1)+\pi c_1^2(1-c_1)\\
p_{101} &=(1-\pi)(1-\ell)c_0^2(1-c_0)+(1-\pi)(1-\ell)\ell c_0(1-c_0)c_1 + (1-\pi)\ell c_0(1-c_1)c_1+\pi c_1^2(1-c_1)\\
p_{011} &=(1-\pi)(1-\ell)c_0^2(1-c_0)+(1-\pi)(1-\ell)\ell (1-c_0)c_0c_1 + (1-\pi)\ell (1-c_0)c_1^2+\pi c_1^2(1-c_1)\\
p_{100} &=(1-\pi)(1-\ell)c_0(1-c_0)^2+(1-\pi)(1-\ell)\ell c_0(1-c_0)(1-c_1) + (1-\pi)\ell c_0(1-c_1)^2+\pi c_1(1-c_1)^2\\
p_{010} &=(1-\pi)(1-\ell)c_0(1-c_0)^2+(1-\pi)(1-\ell)\ell (1-c_0)c_0(1-c_1) + (1-\pi)\ell (1-c_0)(1-c_1)c_1+\pi c_1(1-c_1)^2\\
p_{001} &=(1-\pi)(1-\ell)c_0(1-c_0)^2+(1-\pi)(1-\ell)\ell (1-c_0)^2c_1 + (1-\pi)\ell (1-c_0)(1-c_1)c_1+\pi c_1(1-c_1)^2
\end{aligned}
$$

BKT Identification (1) :
=======================================================

From these base moments, derive the following moments by marginalizing over nuisance periods. For example $p_{11} = p_{111}+p_{110}$.

$$
\begin{aligned}
p_{11} &= (1-\pi)(1-\ell)c_0^2+(1-\pi)\ell c_0c_1+\pi c_1^2\\
p_{01} &= (1-\pi)(1-\ell)(1-c_0)c_0+(1-\pi)\ell (1-c_0)c_1+\pi (1-c_1)c_1\\
p_{10} &= (1-\pi)(1-\ell)c_0(1-c_0)+(1-\pi)\ell c_0(1-c_1)+\pi c_1(1-c_1)\\
p_1 &= (1-\pi)c_0+\pi c_1
\end{aligned}
$$

With some algebra, it is easy to show that if $\pi \neq 1$, $0 \leq \ell<1$ and $c_1 \neq c_0$,
$$
\begin{aligned}
c_1 = \frac{p_{101}-p_{011}}{p_{01} - p_{10}}\\
c_0=\frac{p_{110}-p_{101}}{p_{110}-p_{101}+p_{001}-p_{010}}
\end{aligned}
$$

Plug $c_1$ and $c_0$ into $p_1$ to solve for $\pi$

$$
\pi = \frac{p_{10}+p_{01}-\frac{p_{110}-p_{101}}{p_{110}-p_{101}+p_{001}-p_{010}}}{\frac{p_{101}-p_{011}}{p_{01} - p_{10}} - \frac{p_{110}-p_{101}}{p_{110}-p_{101}+p_{001}-p_{010}}}
$$

Plug $c_1$, $c_0$ and $\pi$ into any of the equations above to solve for $\ell$. This proof chooses $p_{01}-p_{10}$.
$$
\ell = \frac{p_{01}-p_{10}}{(1-\pi)(c_1-c_0)} = \frac{p_{01}-p_{10}}{\frac{p_{101}-p_{011}}{p_{01} - p_{10}}-(p_{11}+p_{10})}
$$



BKT Identification (2) :
=======================================================


Now that one solution to the system is found, it is necessary to prove that it is the only solution. $c_1$ and $c_0$ are both solutions to a linear equation with one unknown, therefore they are unique. $\pi$ is also the unique solution to a linear equation with one unknown when $c_1$ and $c_0$ are plugged in. When $c_1$, $c_0$ and $\pi$ are solved, $\ell$ is the unique solution to a linear equation in any equations. In sum, the solution is unique although the representation of the solution is not.

BKT Identification (3) :
=======================================================

Now consider the special cases wheen the model is not identified.

If $\pi=1$ but $0<\ell<1$, $\ell$ and $c_0$ are not identified because they are never observed.

If $\ell=1$ but $0<\pi<1$, $\pi$ and $c_0$ are not identified because $p_1$ is a linear equation with two unknowns.

If $c_1=c_0$, $\pi$ and $\ell$ are not uniquely identified because the latent variable collapses to one state.


BKT Identification (4) :
=======================================================

- Theorem 2:

The Bayesian Knowledge Tracing model is identified if at least three periods of response are observed, $\pi\neq 1$, $0 \leq \ell<1$ and $c^{1,0} \neq c^{1,1}$.

- Proof:

The equivalent representation of Theorem 3.4 is that the BKT model is identified if the three-response sequence BKT model is identified.

Assume the BKT model based on sequences of length three is identified, but the model on sequences of length $T$ is not identified. Let m ($m\geq2$) be the size of the observation equivalent parameter sets. The parameters sets are denoted as $\Theta_1, \dots, \Theta_m$. Because that the parameter space is the same for the BKT model on sequences with length three and that with length $T$, $\Theta_1, \dots, \Theta_m$ also generates the observation for the BKT model on sequences with length three. However, it is uniquely identified, therefore $\Theta_1=\dots=\Theta_m=\Theta$, and the BKT model on sequences with length $T$ is identified.


BKT Identification (5) :
=======================================================

- The practice identification is influence by the magnitude of $\pi$.

- The read tutor has $\pi$ close to 0 and requires longer practice sequence to identify

[return](#/bkt_id)




```
Error in `$<-.data.frame`(`*tmp*`, "seq", value = integer(0)) : 
  replacement has 0 rows, data has 6
```
