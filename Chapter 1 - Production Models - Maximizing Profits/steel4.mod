set PROD; # products
set STAGE; # stages

param rate {PROD,STAGE} > 0; # tons per hour in each stage
param avail {STAGE} >= 0; # hours available/week in each stage

param profit {PROD}; # profit per ton
param min_share {PROD} >= 0; # minimum share of all tons sold in week
param market {PROD} >= 0; # upper limit on tons sold in week

var Make {p in PROD} <= market[p]; # tons produced

maximize Total_Profit: sum {p in PROD} profit[p] * Make[p];
# Objective: total profits from all products

subject to Time {s in STAGE}:
sum {p in PROD} (1/rate[p,s]) * Make[p] <= avail[s];
# In each stage: total of hours used by all
# products may not exceed hours available