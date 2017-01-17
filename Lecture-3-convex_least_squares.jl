## Lecture-3-Least-squares-CVX

## Here are the packages we'll use
using Convex
using Plots
plotlyjs() # need to use plotlyjs on my machine for plots.

## Step 1: Create a set of data with a linear model
m=40
n=2
A = randn(m,n)
xex = [5;1]      # "b" = 5 in ax+b and a=1
pts = -10+20*rand(m,1)
A = [ones(m,1) pts]
b = A*xex + .5*randn(m,1)

## Show the linear model
scatter(pts,b)
xlabel!("x")
ylabel!("y")

##
x = Variable(n)
problem = minimize(sumsquares(b - A*x))
solve!(problem)
xls = x.value
@show x
## Show the least squares fit
scatter(pts,b;label="data")
plot!([-11; 11], [1 -11; 1 11]*xls;label="fit")
#xaxis!([-11 11])
title!("Least-square fit")
xlabel!("x")
ylabel!("y")

## Now we add outliers
outliers = [-9.5; 9]
outvals = [20; -15]
A = [A; ones(length(outliers),1) outliers]
b = [b; outvals]
m = size(A,1)
pts = [pts;outliers]

## Show the new data
scatter(pts,b)
xlabel!("x")
ylabel!("y")

## Look at the LS fit
x = Variable(n)
problem = minimize(sumsquares(b - A*x))
solve!(problem)
xls = x.value
plot!([-11; 11], [1 -11; 1 11]*xls;label="fit")

## Solve the Huber problem and look at the fit
x = Variable(n)
problem = minimize(sum(huber(b - A*x)))
solve!(problem)
xr = x.value
plot!([-11; 11], [1 -11; 1 11]*xr;label="fit_huber")
