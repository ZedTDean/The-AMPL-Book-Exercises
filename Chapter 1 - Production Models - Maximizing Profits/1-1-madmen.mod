set ADUNITS; # advertising units available to purchase

param dollars >= 0; # dollars in the campaign budget

param reach 		{ADUNITS} > 0;  # audience reached per ad unit (in millions)
param cost 			{ADUNITS};      # cost per ad unit
param min_buy 		{ADUNITS} >= 0; # min order qty per ad unit
param person_weeks 	{ADUNITS};      # person-weeks needed to make each ad unit
param talent_time >= 0; # campaign's total talent_time in person_weeks


var Buy {p in ADUNITS} >= min_buy[p]; # ad units bought


maximize Total_Reach: sum {p in ADUNITS} reach[p] * Buy[p];
# Objective: total reach of ad campaign

subject to Budget: sum {p in ADUNITS} cost[p] * Buy[p] <= dollars;
# Constraint: total costs used by all 
# Purchases of ad units may not exceed budget available

subject to Total_Person_Weeks: sum {p in ADUNITS} (person_weeks[p]) * Buy[p] <= talent_time;
# Constraint: total person_weeks used by all ADUNITS
# ADUNITS choices may not exceed dollars available
