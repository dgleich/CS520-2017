## Setup the Julia optimization software
#=
 The following packages are for Julia optimization software
 http://www.juliaopt.org/
=#

Pkg.add("Optim")     # This is the closest to the software we'll build in this class

Pkg.add("JuMP")         # high level modeling language like CVX, AMPL
Pkg.add("Convex")       # Convex models like CVX
Pkg.add("MathProgBase") # probably included in above, but why not?

# These all involve installing software and are likely to be less reliable.
# But don't let that discourage you! Give them try as the authors are all
# committeed to wide compatiblity and will likely be amenable to help solving
# problems.

Pkg.add("NLopt")
Pkg.add("Ipopt")
Pkg.add("Clp")
Pkg.add("SCS")
Pkg.add("GLPK")
Pkg.add("CSDP")
