
CHAPTER 1 NOTES
===============


Exercise 1-1 (a)
================

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




Exercise 1-1 (b)
================
...




Exercise 1-1 (c)
================
...




Exercise 1-1 (d)
================

Question 1
  Update min_buy for mag_pages to 2

Question 2
  Adding max_buy parameter for ADUNITS allows us to stipulate maximum 
  purchases for a given ADUNIT. Also update Objective ‘Buy’ to observe 
  ‘max_buy’ values.




Exercise 1-2 (a)
================
...




Exercise 1-2 (b)
================
...




Exercise 1-2 (c)
================

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




Exercise 1-2 (d)
================

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


"If the minimum shares are 0.4 for bands and plate, and 0.1 for coils, 
what is the solution?" - it is ...

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


"Verify that if you change minimum shares to 0.5 for bands and plate, and 
0.1 for coils, the linear program gives an optimal solution that produces 
nothing, at zero profit." - Yes, that's correct ...

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


"Explain why this makes sense." - OK. We get a no-production, zero-profit 
result when our aggregate 'min_share' values add up to over 1 because then 
the 'Make[k]' argument in the Share constraint is higher than the possible 
total tons produceable (or Make[p]) for any k in {PROD}. This then makes 
the 'Share' constraint un-satisfiable because it begins with ...

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
