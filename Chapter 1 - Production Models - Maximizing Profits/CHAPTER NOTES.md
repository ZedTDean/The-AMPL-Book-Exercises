
CHAPTER 1 NOTES
===============

 Exercise 1-1
 ============

// 
/  1-1. This exercise starts with a two-variable linear program similar 
/  in structure to the one of Sections 1.1 and 1.2, but with a quite 
/  different story behind it.
/
/    (a) You are in charge of an advertising campaign for a new product, 
/    with a budget of $1 million. You can advertise on TV or in 
/    magazines. One minute of TV time costs $20,000 and reaches 1.8
/    million potential customers; a magazine page costs $10,000 and 
/    reaches 1 million. You must sign up for at least 10 minutes of TV 
/    time. How should you spend your budget to maximize your audience?
/
/    Formulate the problem in AMPL and solve it. Check the solution by 
/    hand using at least one of the approaches described in Section 1.1.
//

My advertising campaign model 1-1-madmen.mod is a re-skinning of the
steel3.mod production model presented in this chapter. I’ve relabelled
my elements accordingly:

Sets:
  {PROD}  -> {ADUNITS}

Parameters:
  avail    -> dollars
  rate     -> reach
  profit   -> cost
  commit   -> min_buy

  (Note: the parameter ‘market’ in steel.mod is eliminated as there is no
  limit on how many ad-units we can buy)

Variables:
  Make -> Buy

Objectives:
  Total_Profit -> Total_Reach

Constraints:
  Time -> Budget




//
/    (b) It takes creative talent to create effective advertising; in your
/    organization, it takes three person-weeks to create a magazine page, 
/    and one person-week to create a TV minute. You have only 100 person-
/    weeks available. Add this constraint to the model and determine how 
/    you should now spend your budget.
//

See commit:
  "Add 'Total_Person_Weeks' constraint, params and vars for 1-1 (b)"




//
/    (c) Radio advertising reaches a quarter million people per minute, 
/    costs $2,000 per minute, and requires only 1 person-day of time. How 
/    does this medium affect your solutions?
//

See commit:
  "Add 'radio_mins' as a new ADUNIT in data file for 1-1 (c)"




//
/    (d) How does the solution change if you have to sign up for at least 
/    two magazine pages? A maximum of 120 minutes of radio?
//

For first question, see commit: 
  "Update min_buy for mag_pages to 2, as per 1-1 (d) question 1"

For second question, see commit:
  "Add max_buy parameter for ADUNITS as per 1-1 (d) question 2"




 Exercise 1-2
 ============

//
/  1-2. The steel model of this chapter can be further modified to reflect 
/  various changes in production requirements. For each part below, 
/  explain the modifications to Figures 1-6a and 1-6b that would be 
/  required to achieve the desired changes. (Make each change separately, 
/  rather than accumulating the changes from one part to the next.)
//

To fulfill this requirement, I add the steel4.mod and steel4.dat files to 
the master branch on the commit named ...
  "Add steel4.mod and steel4.dat files as prep for Exercise 1-2"

... and then I branch the code out for each question, naming the branches:
  "Chapter-1-Exercise-1-2-(x)", etc.




//
/    (a) How would you change the constraints so that total hours used by 
/    all products must equal the total hours available for each stage? 
/    Solve the linear program with this change, and verify that you get 
/    the same results. Explain why, in this case, there is no difference 
/    in the solution.
//

See branch "Chapter-1-Exercise-1-2-(a)"




//
/    (b) How would you add to the model to restrict the total weight of 
/    all products to be less than a new parameter, max_weight? Solve the 
/    linear program for a weight limit of 6500 tons, and explain how this 
/    extra restriction changes the results.
//

See branch "Chapter-1-Exercise-1-2-(b)"




//
/    (c) The incentive system for mill managers may tend to encourage them 
/    to produce as many tons as possible. How would you change the 
/    objective function to maximize total tons? For the data of our 
/    example, does this make a difference to the optimal solution?
//

See branch "Chapter-1-Exercise-1-2-(c)

I changed the ‘Total_Profit’ objective into a new objective ‘Total_Tons’ 
by simply deleting the ‘profit[p]’ argument which drops the old 
objective’s regard for profit and allows it to simply maximize for tons 
produced.

“For the data of our example, does this make a difference to the optimal 
solution?”  - No. 

Our optimal solution here renders 7000 maximum total tons produced, the 
same as that rendered by the old 'Total_Profit' objective, but with some 
differences in the tons produced per product type …

OLD OBJECTIVE:

  ampl: display Make;
  Make [*] :=
  bands  3833.33
  coils   500
  plate  2666.67
  ;

NEW OBJECTIVE:

  ampl: display Make;
  Make [*] :=
  bands  5750
  coils   500
  plate   750
  ; 

The new objective causes the number of tons of coils to be rendered at 
their 'commit' value of 500, same as before, but then renders plate also 
at its 'commit' value of 750, which is 1916.67 fewer tons than before, and 
commits these extra tons to production of bands, for a total of 5750 tons 
of bands, up from 3833.33.

The total number of product tons produced is still 7000, even though in 
the second stage of production, plate has a lower roll rate per hour of 
160 tons compared to 200 for bands. This seeming fluke is contingent on 
two things:

  The first stage - reheat - has only 35 hours available which when 
  multiplied by the 200 ton per hour rate at which all products reheat, 
  gives us 7000 total POTENTIAL tons.

  Subject to the other constraints and paramaters of the model, these 
  POTENTIAL total tons could translate into 7000 actual tons of product, 
  or less. In our case, even though plate takes longer to roll than bands, 
  we also have 5 more hours available in the second 'roll' stage than in 
  the reheat stage, and these extra 5 hours absorb the lower roll rate of 
  the plate completely, without affecting the 7000 total tons number.




//
/    (d) Suppose that instead of the lower bounds represented by commit[p] 
/    in our model, we want to require that each product represent a 
/    certain share of the total tons produced. In the algebraic notation 
/    of Figure 1-1, this new constraint might be represented as
/    
/    Xj ≥ Sj    Σ    Xk, for each j ∈ P
/             k ∈ P
/    
/    where Sj is the minimum share associated with project j. How would 
/    you change the AMPL model to use this constraint in place of the 
/    lower bounds commit[p]? 
//

See branch "Chapter-1-Exercise-1-2-(d)"

The easy part is updating the parameter 'commit' to 'min_share' in the 
model and data files, along with its values per product in the data file, 
which I've made fractions representing percentages of a whole = 1.

Next, scribble out ways to convert the constraint shown in algorithmic 
notation in the exercise's description in the book, into to the AMPL 
model.

The key is understanding what the constraint does - basically, for each 
product, it sets the 'min_share' parameter multiplied by the sum of all 
products made, as the minimum bound on tons to make of that product.

I eliminate the 'min_share' argument in the 'Make' variable's declaration 
(where the old 'commit' argument was) because we address everything in the 
constraint as follows: 

  subject to Share {p in PROD}:
  Make[p] >= min_share[p] * (sum {k in PROD} Make[k] );


//
/    If the minimum shares are 0.4 for bands and plate, and 0.1 for coils, 
/    what is the solution? 
//

  ampl: solve;
  MINOS 5.51: optimal solution found.
  4 iterations, objective 185828.5714

  ampl: display Make;
  Make [*] :=
  bands  3428.57       
  coils   685.714      
  plate  2742.86
  ;

  ampl: display Share;
  Share [*] :=
  bands   -5.43896e-15   <-- effectively zero
  coils  -10.4857
  plate   -1.80714
  ;


//
/    Verify that if you change the minimum shares to 0.5 for bands and 
/    plate, and 0.1 for coils, the linear program gives an optimal 
/    solution that produces nothing, at zero profit.
//

Yes, that's correct ...

  ampl: solve;
  MINOS 5.51: optimal solution found.
  2 iterations, objective 5.193605824e-24   <-- effectively zero

  ampl: display Make;
  Make [*] :=
  bands  1.11931e-25   <-- effectively zero
  coils  1.49242e-26   <-- effectively zero
  plate  6.71587e-26   <-- effectively zero
  ;

  ampl: display Share;
  Share [*] :=
  bands  -275
  coils  -270
  plate  -271
  ;


//
/    Explain why this makes sense.
//


OK. We get a no-production, zero-profit result when our aggregate 
'min_share' values add up to over 1 because then the sum of the 'Make[k]' 
argument over the set 'PROD' in our Share constraint is higher than the 
possible total tons produceable (or Make[p]) for any k in {PROD}. This 
then makes the 'Share' constraint un-satisfiable because it begins with ..

  'Make[p] >= ...'

To test this, just throw the operand '>=' around to a '<=' to see that an 
optimal solution is reached ...

  ampl: solve;
  MINOS 5.51: optimal solution found.
  3 iterations, objective 189937.5

  ampl: display Make;
  Make [*] :=
  bands  3312.5
  coils   187.5
  plate  3500
  ;

... but it ignores lower bounds completely because our 'Share' constraint 
is broken. :)




//
/    (e) Suppose there is an additional finishing stage for plates only, 
/    with a capacity of 20 hours and a rate of 150 tons per hour. Explain 
/    how you could modify the data, without changing the model, to 
/    incorporate this new stage.
//

The changes to the data file are straightforward: I added the stage 
'finish' and its related values to the set 'STAGE', to the table for the
values of parameter 'rate', and also to parameter 'avail'.

For the 'rate' table values, I had to do a little digging to find the 
appropriate way to communicate non-existent upper-bounds for both bands 
and coils, and in the AMPL Book's Appendix A found the answer on page 466, 
point A.7.2, which discusses Infinity.




Exercise 1-3
============

//
/  1-3. This exercise deals with some issues of ‘‘sensitivity’’ in the 
/  steel models.
/
/    (a) For the linear program of Figures 1-5a and 1-5b, display Time and 
/    Make.rc. What do these values tell you about the solution? (You may 
/    wish to review the explanation of marginal values and reduced costs 
/    in Section 1.6.)
//

Displaying 'Time' shows us a value of 4640, indicating that each hour 
on the production creates $4640 of profit, put another way, if we added 
one more hour to 'avail' then it would be worth another $4640.

Displaying Make.rc gives us the dollar impact on the total profit for each 
unit of bands, coils and plate respectively.



//
/    (b) Explain why the reheat time constraints added in Figure 1-6a 
/    result in a higher production of plate and a lower production of 
/    bands.
//

Before adding the reheat stage our Make values were ...

ampl: display Make;
Make [*] :=
bands  6000
coils   500
plate  1028.57
;

... and now with the reheat stage added they are ...

ampl: display Make
ampl? ;
Make [*] :=
bands  3833.33
coils   500
plate  2666.67
;

... and this is because the reduced costs (aka '.rc') for each product 
have changed from ...

ampl: display Make.rc;
Make.rc [*] :=
bands   1.8
coils  -3.14286
plate   0
;

... to...

ampl: display Make.rc
ampl? ;
Make.rc [*] :=
bands   1.77636e-15   <-- effectively zero
coils  -5.66667
plate   0
;

Adding the reheat stage caused a theoretical increase in the 'commit' for 
bands to impact the 'Total_Profit' objective negatively instead of 
positively as before. But why?

(This is a wordy answer, please suggest shorter / better) ...

Because the reheat stage runs for only 35 hours while the roll stage runs 
for 40, there are 5 hours in the production run when no more material can 
be reheated in stage one, ready for use in stage two. During these 5 
hours, the scarcest commodity is no longer time but is now the supply of 
reheated material itself. 

Rolling time still matters, but to some point, the product with the best 
ratio of profitability PER TON OF READY MATERIAL and rolling time will be 
prioritized by the solver. In our scenario, for the last five hours of the
production run, this is plate.


