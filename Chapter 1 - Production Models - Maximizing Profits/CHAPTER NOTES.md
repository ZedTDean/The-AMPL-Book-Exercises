
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
