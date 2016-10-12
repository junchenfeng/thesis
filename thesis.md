
Learning Through Practices
========================================================
author: Junhen Feng
autosize: true



Motivation
========================================================
type: section

Practice Makes Perfect
========================================================
- Merriam Webster: To do repeated exercises for proficiency

- Very effective for K-12 STEM learning

- Repetition is necessary but not sufficient nor efficient


The Inefficiency of non-personalized Practices
========================================================

- 2.41-meter high practice exams in 1 year to prepare for the Chinese SAT

![plot of chunk unnamed-chunk-1](fig/mot.jpg)

- How to Improve Efficiency

    + Optimal Stopping (Assessment)

    + Optimal Recommendation (Instruction)


Pedagogical Efficacy
========================================================
type: prompt

- pedagogical efficacy = What makes practices effective

    + A hard question without a clear answer

    + Key to a successful recommendation system

- The thesis aims to measure, not to explain, the pedagogical efficacy


Navigation
========================================================

- [Chapter 1](#/chp1): A General Model
- [Chapter 2](#/chp2): Selection Bias of the Exit Decision in the Pedagogical Efficacy Estimation
- [Chapter 3](#/chp3)：Effort Induced Measurement Error in the Pedagogical Efficacy Estimation

Chapter I: A General Model of Learning Through Practices
========================================================
id: chp1
type: section

- [The Model](#/model)

- [Identification] (#/identify)

- [Estimation](#/mcmc)


Event Sequence
========================================================
id: model

+ The learner is presented with a practice item

+ The learner decides the effort level

    * With effort, (probabilistic) learning happens depending on the item efficacy
    * Without effort, no learning

+ The learner produces a response and receives grading on the response

    * Assume feedback is not important to learning. Only exposure to item matters

+ The learner choose to stop

    * No: start from the first step


Notation
========================================================
- $j$: The item id
- $t$: The sequence id. [*Not calendar time*]
- $X$: The latent state of knowledge mastery
- $Y$: The observed response grade
- $E$: The observed effort
- $A()$: The assignment function.
    + $A(t)=j$: The item $j$ is at $t^{th}$ practice sequence



The Learning Process (1)
========================================================
- **Assumption 1**: $X_t$ is unidimensional

    + Avoid mapping knowledge space to item

- **Assumption 2**: $X_t$ is discrete with $M_x$ number of states


The Learning Process (2)
========================================================

- Learning is moving from a lower state to a higher state.

$$P(X_t=m|X_{t-1}=n,A(1),\dots,A(t-1),j)$$

- **Assumption 3**: Pedagogical efficacy is independent of the sequence order
- **Assumption 4**: No substitution or complementarity in sequence composition
- **Assumption 5**: Learning is gradual. Transit one state at a time.

$$p(X_t=m|X_{t-1}=n, j) =0 \quad \forall t,j \quad\text{where} \quad m-n>1$$

- **Assumption 6**: No forgetting.

$$p(X_t=m|X_{t-1}=n, j) = 0 \quad \forall t,j \quad\text{where} \quad m < n$$

The Learning Process (3)
========================================================
Define the **pedagogical efficacy**  as
$$\ell^k_j =P(X_t=k+1|X_{t-1}=k,j)$$

Define the **initial mastery distribution** as
$$\pi^k = P(X_1=k)$$


The Observed Response (Without Effort Decision)
========================================================

- **Assumption 7**: The response is only a function of the latent knowledge mastery
- **Assumption 8**: The response is discrete with $M_y$ number of state

Define the **correct rate** as
$$
c^{k,m}_j = P(Y_{j,t}=m|X_t=k)
$$



Learning Process as A Hidden Markov Process
========================================================
id: hmm1
- $\{\pi^k\}, \{\ell^k_j\}, \{c^{k,m}_j\}$ describes a hidden markove process

***

![plot of chunk unnamed-chunk-2](fig/hmm_1.png)

Examples
========================================================
- [Bayesian Knowledge Tracing Model](#/bkt):
- [Zone of Proximal Development](#/zpd)

The Effort Decision(1)
========================================================
**Assumption 9**: Effort is a binary choice.

- Let the effort be determined by a Roy model of choice where:
    + $\beta_j$ is expected return of a correct response
    + $\epsilon_{j,t}$ is the cost of making the learning effort
    + The expected cost of a wrong response is standardized to 0

$$
E_{j,t} = I(\beta_j P(Y_{j,t}=1) - \epsilon_{j,t}>0)
$$

The Effort Decision(2)
========================================================
**Assumption 10**: The $\epsilon_{j,t}$ is I.I.D.

- It implies that conditions on latent ability, effort choice is
    + independent of sequence position and sequence composition
    + dependent on the item characteristic
$$
P(E_{j,t}=1|X_t=k) = e_j^k
$$

The Effort Decision(3)
========================================================
**Assumption 11**: No pain no gain.

$P(X_t=k+1|X_{t-1}=k, j, E_{j,t}=0) = 0$


**Assumption 12**: No educated guess

$P(Y_{j,t}=0|E_{j,t}=0) = 1$

[to Chapter 3](#/chp3)

The Stop Decision
========================================================
*To be continued...*


Identification
========================================================
id: identify
*To be continued...*

Estimation
========================================================
id: mcmc
*To be continued...*

Chapter II: Selection Bias of the Exit Decision in the Pedagogical Efficacy Estimation
========================================================
id: chp2
type: section

- [Motivation](#/chp2mot)

- [Characterize the Bias](#/chp2theory)

- [Case Study](#/chp2case)

Motivation
=======================================================
id: chp2mot

Characterize the Bias
=======================================================
id: chp2mot

Case Study
=======================================================
id: chp2case

Chapter III: Effort Induced Measurement Error in the Pedagogical Efficacy Estimation
========================================================
id: chp3
type: section

- [Motivation](#/chp3mot)

- [Characterize the Bias](#/chp3theory)

- [Case Study](#/chp3case)

Motivation
=======================================================
id: chp3mot

- Consider an RCT that compares pedagogical efficacies of two items
    + Random assignment of the items
    + Balanced random attrition
    + standard DID design

$$
Y_{i,T} = \beta_d D_i + \beta_t T + \gamma D_i T + \epsilon_{i,T}
$$

- If items induce differential efforts and the effort influences the performance
    + The observed performance has non-zero mean measurement error
    + The DID estimator may not even have the right sign

Task Engagement (or Lack Thereof)
=======================================================
- The lack of effort is a salient feature in the low stake learning environment
    + Baker et al(2004) and Wixon et al(2012) report the lack of student engagement in digital learning
    + Pardos et al(2013) documents the lack of student engagement in classroom learning

- Effort is largely absent from other literature because it is hard to monitor


Characterize the Bias(1)
=======================================================
id: chp3theory

- To show the intuition, assume a very simple structure
    + $M_x=M_y=2$, $j=1$
    + $c^{11}=1$, $c^{01}=0$. No slip and no guess
    + $e^1=1$. Mastered student always exerts effort
    + $0< e^0 <1$. Unmastered student slacks some of the time

- It can be proved that the estimated pedagogical efficacy is biased downwards

$$
E(\hat{\ell}- \ell)  =  \ell(e^0-1) <0
$$




Characterize the Bias(2)
=======================================================
- In the motivating RCT example, the ATE is

$$
E(\hat{\gamma}) = \ell_1e^0_1-\ell_0e^0_0
$$
- For the sign to be correct: $(\ell_1-\ell_0)(\frac{l_1}{l_0}-\frac{e_0}{e_1})>0$

    + It implies more pedagogical effective item also induces more effort
    + Not true in general



Case Study
=======================================================
id: chp3case

- [The Learning Environment] (#/learningenv)

- [The Experiment Design] (#/expdesign)

- [The Identification of Effort] (#/effortident)

- [Result] (#/chp3res)


"Gamified" Learning
=======================================================
id: learningenv

<img src="fig/initial.png" title="Level Initiation" alt="Level Initiation" style="display: block; margin: auto;" />
Practice Interface
=======================================================
<img src="fig/practice.png" title="Practice Interface" alt="Practice Interface" style="display: block; margin: auto;" />

Low Stake Incentive
=======================================================
<img src="fig/completion.png" title="Level Completion" alt="Level Completion" style="display: block; margin: auto;" />


The Experiment Design (1)
=======================================================
id: expdesign

- The learning task / pre-test
- Calculate the circumference and area of the large rectangle
- Student fills in the blanks

***

<img src="fig/f1.png" title="Pre-test" alt="Pre-test" style="display: block; margin: auto;" />



The Experiment Design (2)
=======================================================


- Post-test
<img src="fig/f3.png" title="Post-test" alt="Post-test" style="display: block; margin: auto;" />

The Experiment Design (3)
=======================================================

- Same Training Question

![plot of chunk unnamed-chunk-8](fig/f2.png)

***


- Different Delivery Methods
    + No Scaffolding
    + Vocabulary Scaffolding
        * What is the new length and width
        * What is the circumference
        * What is the area
    + Video Scaffolding [not compulsory] that reveals the post-test question
    [(link)](http://my.polyv.net/front/video/preview?vid=36488cc9164c53d6616869d83fbfd1b3_3)

The Experiment Design (4)
=======================================================
- Group Status
    + Group 1: pre-test + no-scaffolding + post-test
    + Group 2: no-scaffolding + post-test
    + Group 3: pre-test + vocabulary-scaffolding + post-test
    + Group 4: vocabulary-scaffolding + post-test
    + Group 5: pre-test + video-scaffolding + post-test

- Group Assignment
    + Assign learners to the group based on the remainder of their user id divided by 5


Summary Statistics(1)
=======================================================
- Total learners recruited: 13939
- Average retention rate is 84%. Pre-test hurts retention.

***

![plot of chunk unnamed-chunk-9](fig/exp_attrition.png)

Summary Statistics(2)
=======================================================
- The no scaffolding and video scaffolding group has almost no difference
- The vocabulary scaffolding has worse efficacy than the no scaffolding

***

![plot of chunk unnamed-chunk-10](fig/exp_stat.png)

The Identification of Effort: Identification
=======================================================
id: effortident

- [effort classification](#/ans_class)
  + Slack/Give up: blank answer, non-blank wrong answer
  + Valid Effort: Slip, partial right and all right


Validity(1)
=======================================================
- The learner spent significantly less time to submit a blank answer in repeated exercises
  + Compare no scaffolding with and without pre-test
- [Not Shown] Submitting a blank answer is highly serial correlated

***

![plot of chunk unnamed-chunk-11](fig/blank_ans_time_dist.png)

Validity(2)
=======================================================
- Non-blank answer is also likely to be slacking:
  + In repeated exercises, skewed toward left, similar to the blank answer
  + Has lower mean compare to the other two

- Valid Error and Correct has no position shift and similar distribution

***

![plot of chunk unnamed-chunk-12](fig/non_blank_ans_time_dist.png)



Pattern(1)
=======================================================
- Increase by sequence
- Higher for the vocabulary scaffolding

***

![plot of chunk unnamed-chunk-13](fig/exp_giveup.png)

Pattern(2)
=======================================================
- Highly serial correlated
- [Left panel] All-giveup has higher probability mass than a binomal model would predict.

***

![plot of chunk unnamed-chunk-14](fig/exp_giveup_seq.png)

The Result
=======================================================
id: chp3res

- The model is estimated with MCMC algorithm
  + The learning parameter has a beta prior B(1,1)
  + Chain length 1000. First 30% is burn-in sample.
  + Sample every 10 iterations
- Only groups with both pre-test and post-test are included in the sample
- Two-state model, binary grade; Three-state model, partial grade

The Result (Two-state model)
=======================================================
id: chp3res
- Position shifts (correct for downward bias)
- Weakly separate out video scaffolding

***

![plot of chunk unnamed-chunk-15](fig/mcmc_2_param.png)

The Result (Three-state model: 0->1)
=======================================================
- The pedagogical efficacy with effort is not well estimated
  + Because low effort rate and low initial density, too few observations

***

![plot of chunk unnamed-chunk-16](fig/mcmc_3_param_01.png)



The Result (Three-state model: 1->2)
=======================================================

- More robust to effort decision
- Clear separation of item characteristic

***

![plot of chunk unnamed-chunk-17](fig/mcmc_3_param_12.png)

Q&A
=======================================================
type: section

Special Case 1: Bayesian Knowledge Tracing Model
=======================================================
id: bkt

- Developed by Corbert and Anderson(1996)
- The equivalent of Rasch model in the literature of the learning analytics
- $M_x=2$, $M_y=2$, $j=1$
- The guess rate is $c^{0,1}$, The slip rate is $c^{1,0}$.

[return](#/hmm1)


Special Case 2: Zone of Proximal Development
=======================================================
id: zpd

- Developed by Vygosky(1976)
    + Development lags task requirement and fail the task no matter what
    + Development lags task requirement but may succeed in the task with guidance or collaboration [**The zone**]
    + Development leads task requirement and succeed on their own

- $M_x=3$, $M_y=3$, $j=1$
    + $X=0$ is the unprepared. $X=1$ is the zone. $X=2$ is the mastered
    + $Y=0$ is failure. $Y=1$ is partial success. $Y=2$ is complete success
    + $c^{0,2}=0$, the unprepared never fully succeed
    + $c^{2,0}=0$, the mastered never fully fail

- Allow for **learning reinforcement** where positive performance leads to better performance

[return](#/hmm1)


Answer Classification (1)
=======================================================
id: ans_class
The answers are initially classified into six categories:

(1) Blank answer: The learner submits nothing on the circumference and the area

(2) Non-blank wrong answer: Neither circumference nor area is correctly calculated and not includes in the slip or the wrong shape category

(3) Slip: The answer is correctly calculated but the learner inputs in a wrong way

Answer Classification (2)
=======================================================

(4) Wrong Shape: The learner calculates correctly either the circumference or the area of the small rectangle

(5) right circumference: The learner correctly calculates the circumference of the large rectangle

(6) right area: The learner correctly calculates the area of the large rectangle

(7) Correct Answer: Both circumference and area of the large rectangle are correctly calculated

Answer Classification (3)
=======================================================


|    Group     | Task  | Blank Ans(%) | Non Blank Wrong Ans (%) | Slip(%) |
|:------------:|:-----:|:------------:|:-----------------------:|:-------:|
|     No-3     |  pre  |     10.8     |           14            |  1.09   |
| Vocabulary-3 |  pre  |     10.4     |           15            |  0.82   |
|    Video     |  pre  |     11.4     |           15            |  0.73   |
|     No-3     | train |     14.6     |           16            |  0.32   |
|     No-2     | train |     9.8      |           13            |  0.48   |
| Vocabulary-3 | train |     18.2     |           15            |  0.27   |
| Vocabulary-2 | train |     13.1     |           24            |  0.32   |
|    Video     | train |     16.3     |           18            |  0.37   |
|     No-3     | post  |     18.4     |           17            |  0.81   |
|     No-2     | post  |     16.7     |           18            |  0.52   |
| Vocabulary-3 | post  |     21.4     |           16            |  0.73   |
| Vocabulary-2 | post  |     24.2     |           18            |  0.61   |
|    Video     | post  |     18.2     |           17            |  0.69   |

Answer Classification (4)
=======================================================


|    Group     | Task  | Wrong Shape(%) | Right Circ(%) | Right Area(%) | Correct(%) |
|:------------:|:-----:|:--------------:|:-------------:|:-------------:|:----------:|
|     No-3     |  pre  |      8.8       |      8.8      |     11.2      |     46     |
| Vocabulary-3 |  pre  |      7.4       |      8.0      |     11.9      |     47     |
|    Video     |  pre  |      7.7       |      8.9      |     11.0      |     45     |
|     No-3     | train |      5.1       |      5.3      |     12.2      |     47     |
|     No-2     | train |      10.2      |      8.3      |     14.8      |     44     |
| Vocabulary-3 | train |      10.6      |      9.7      |     17.7      |     28     |
| Vocabulary-2 | train |      20.7      |      6.3      |     18.4      |     17     |
|    Video     | train |      3.5       |      4.9      |     12.5      |     45     |
|     No-3     | post  |      1.9       |     10.0      |      7.6      |     44     |
|     No-2     | post  |      3.5       |     11.8      |      8.0      |     42     |
| Vocabulary-3 | post  |      2.5       |     10.5      |      7.0      |     41     |
| Vocabulary-2 | post  |      5.3       |     11.7      |      6.1      |     34     |
|    Video     | post  |      1.6       |     10.1      |      8.6      |     43     |


[Back](#\effortident)
