module PlotRegion

using QuickHull
using Combinatorics
using FixedSizeArrays
using Plots

function basic_feasible_point(A::Matrix,b::Vector,set::Vector)
    m,n = size(A)
    @assert length(set) == m "need more indices to define a BFP"
    binds = set # basic variable indices
    ninds = setdiff(1:size(A,2),binds) # non-basic
    B = A[:,binds]
    N = A[:,ninds]
    #cb = c[binds]
    #cn = c[ninds]
    
    if rank(B) != m
        return (:Infeasible, 0)
    end
    
    xb = B\b
    x = zeros(eltype(xb),n)
    x[binds] = xb
    x[ninds] = zero(eltype(xb))    
    
    if any(xb .< 0)
        return (:Infeasible, x)
    else
        #lam = B'\cb
        #sn = cn - N'*lam
        return (:Feasible, x)
    end
end

"""
Plot the feasible polytope 
Ax = b, x >= 0
for the first two components of x.
"""
function plotregion(A::Matrix,b::Vector)
    m,n = size(A)
    verts = Vector{Vec{2,Float64}}()
    for inds in combinations(1:n,m)
        bfp=basic_feasible_point(A,b,inds)
        if bfp[1] == :Feasible
            push!(verts, Vec(bfp[2][1], bfp[2][2]) )
        end
    end
    hull = qhull(verts)
    plot(Shape(hull),fillalpha=0.5, fillcolor="grey", label="")
end

export plotregion
end