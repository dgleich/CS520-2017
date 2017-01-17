## Setup the Gurobi software outside of Julia
#=
 1. Download Gurobi from Gurobi.com
 2. Get an account and request a university license
 3. Setup with Grb
=# 

## Install Gurobi.jl and test
Pkg.add("Gurobi")

## Test that Gurobi works
Pkg.test("Gurobi")
