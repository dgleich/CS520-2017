"""
GRADIENT_DESCENT_1 A simple implementation of pure gradient descent

x = gradient_descent_1(f,x0) computes x, the argmin of f using a pure
gradient descent algorithm.  This routine SHOULD NOT be used for anything
other than pedagogical purposes as it does not include any technique to
make gradient descent a practical algorithm.

The function f(x0) must return both the function value and the gradient
at x0, i.e. [fx,gx] = f(x0);  See FCOMBINE for a helper function or
ROSENBROCK for an example.

[x,f,g,hist,histx] = gradient_descent_1(...) returns the final function 
value, final gradient, a history of iteration data, and a history of 
all the iterates x.  Memory for histx is only allocated if this output is
requested as it could grow rather large.

The function call
[...] = gradient_descent_1(f,x0;key=value)
provide optional arguments to the function that all have reasonable
default values set.
 
The options are:

   maxiter (Int) : the maximum number of iterations/function evaluations
   tol (Float32) : the stopping tolerance in terms of the infinity norm of the
     gradient
   quiet (Bool): do not display iteration output 
   histx (Array) : an array that will be updated with the history of iterates, 
     each is pushed on the back

Example:
using Optim
   x = gradient_descent_1(@rosenbrock,[1+0.1;1+0.1]); % does not converge
"""
function gradient_descent_1(fg,x0;
    maxiter=10000,tol=1.0e-8,quiet=false,histx=[],gamma=0.0001)
    
    x = copy(x0)
    n = length(x)

    hist = zeros(2,maxiter)
    savehistx = eltype(histx) == Vector{Float64} ? true : false

    f = Inf
    normg = Inf
    lastiter = 0
    g = Vector{Float64}()

    if !quiet
        @printf("  %6s  %9s %9s %9s\n", "iter", 
            "val", "normg", "fdiff");
    end

    for iter=1:maxiter
        if savehistx
            push!(histx, x)
        end
    
        if iter>1
            x = x - gamma*g
        end
    
        flast = f
        f,g = fg(x)
        normg = norm(g,Inf)
       
        fdiff = flast - f
    
        if !quiet
            @printf("  %6i  %9.2e %9.2e %9.2e\n", 
                iter, f, normg, fdiff)
        end
    
        hist[:,iter] = [f; normg]
        lastiter = iter
    
        if normg <= tol 
            break 
        end
        if !isfinite(normg)
            break
        end
    end

    if lastiter < maxiter
        hist = hist[:,1:lastiter]
    end

    if normg > tol
        warn("Did not converge")
    end
    
    return x,f,g,hist
end


"""
GRADIENT_DESCENT_2 A simple implementation of pure gradient descent 
with normalized gradients 

x = gradient_descent_1(f,x0) computes x, the argmin of f using a pure
gradient descent algorithm.  This routine SHOULD NOT be used for anything
other than pedagogical purposes as it does not include any technique to
make gradient descent a practical algorithm.

The function f should return both the function and gradient at the 
provided point. 

x,f,g,hist = gradient_descent_1(...) returns the final function 
value, final gradient, a history of iteration data, and a history of 
all the iterates x.  

The function call
[...] = gradient_descent_1(f,x0;key=value)
provide optional arguments to the function that all have reasonable
default values set.
 
The options are:

   maxiter (Int) : the maximum number of iterations/function evaluations
   tol (Float32) : the stopping tolerance in terms of the infinity norm of the
     gradient
   quiet (Bool): do not display iteration output 
   histx (Array) : an array that will be updated with the history of iterates, 
     each is pushed on the back
   gamma (Float64) : A scaling of the _normalized_ gradient 

Example:
using Optim
   x = gradient_descent_1(@rosenbrock,[1+0.1;1+0.1]); % does not converge
"""
function gradient_descent_2(fg,x0;
    maxiter=10000,tol=1.0e-8,quiet=false,histx=[],gamma=1.0)
    
    x = copy(x0)
    n = length(x)

    hist = zeros(2,maxiter)
    savehistx = eltype(histx) == Vector{Float64} ? true : false

    f = Inf
    normg = Inf
    lastiter = 0
    g = Vector{Float64}()

    if !quiet
        @printf("  %6s  %9s %9s %9s\n", "iter", 
            "val", "normg", "fdiff");
    end

    for iter=1:maxiter
        if savehistx
            push!(histx, x)
        end
    
        if iter>1
            x = x - gamma*g/norm(g)
        end
    
        flast = f
        f,g = fg(x)
        normg = norm(g,Inf)
       
        fdiff = flast - f
    
        if !quiet
            @printf("  %6i  %9.2e %9.2e %9.2e\n", 
                iter, f, normg, fdiff)
        end
    
        hist[:,iter] = [f; normg]
        lastiter = iter
    
        if normg <= tol 
            break 
        end
        if !isfinite(normg)
            break
        end
    end

    if lastiter < maxiter
        hist = hist[:,1:lastiter]
    end

    if normg > tol
        warn("Did not converge")
    end
    
    return x,f,g,hist
end


