using Gurobi
function sudoku_gurobi(X)
# SUDOKU_GUROBI Solve a sedoku puzzle using Gurobi for an Binary LP
#
# S=sudoku_gurobi(X)
#   X has a set of initial conditions where anything ~= 1 ... 9 is an
#   unknown
# S is the solved sudoku puzzle

    assert(all(size(X) == (9, 9)))
    # create variables
    nvars = 9*9*9

    # index the variables for easier access
    vars = zeros(Int64, 9, 9, 9)
    ind = 1
    for i = 1:9
        for j = 1:9
            for v = 1:9
                vars[i, j, v] = ind
                ind = ind + 1
            end
        end
    end

    #obj = ones(Int64, 1, nvars) # no objective, just constraints

    # add known cells as constraints

    A = spzeros(nvars, 0)
    b = ones(1, 0)

    for i = 1:9
        for j = 1:9
            if X[i, j] < 1 || X[i, j] > 9
                # this is a free variable, ignore
            else
                # this is a constraint, add it
                cons = zeros(nvars)
                cons[vars[i, j, X[i, j]]] = 1
                A = [A sparse(cons)] # append a row
                b = [b 1]
            end
        end
    end

    #
    # add sudoku constraints
    #

    # each cell only has one value
    for i = 1:9
        for j = 1:9
            cons = zeros(Int64, nvars)
            for v = 1:9
                cons[vars[i, j, v]] = 1
            end
            A = [A sparse(cons)]
            b = [b 1]
        end
    end

    # each row has 1-9
    for i = 1:9
        for v = 1:9
            cons = zeros(nvars)
            # the value v only appears in each row once
            for j = 1:9
                cons[vars[i, j, v]] = 1
            end
            A = [A sparse(cons)]
            b = [b 1]
        end
    end

    # each column has 1-9
    for j = 1:9
        for v = 1:9
            cons = zeros(nvars)
            # the value v only appears in each row once
            for i = 1:9
                cons[vars[i, j, v]] = 1
            end
            A = [A sparse(cons)]
            b = [b 1]
        end
    end

    # subgrid has 1-9
    for v = 1:9
        for i0 = 0:2
            for j0 = 0:2
                cons = zeros(nvars)
                for i = 1:3
                    for j = 1:3
                        cons[vars[i+3*i0, j+3*j0, v]] = 1
                    end
                end
                A = [A sparse(cons)]
                b = [b 1]
            end
        end
    end

    # setup Gurobi call
    env = Gurobi.Env()

    model = Gurobi.Model(env, "sudoku_blp", :minimize)

    # add binary variables
    add_bvars!(model, zeros(nvars))

    # have the variables incorporated into the model
    update_model!(model)

    add_constrs_t!(model, A, '=', vec(b))

    # run optimization
    optimize(model)

    # get results
    x = get_solution(model)

    # assign solution
    S = zeros(Int64, 9 ,9)
    for i = 1:9
        for j = 1:9
            for v = 1:9
                if x[vars[i, j, v]] > 0
                    S[i, j] = v
                end
            end
        end
    end
    return S
end

##
X = [0 0 8 0 0 0 6 0 0;
     0 2 0 0 0 0 0 1 0;
     5 0 0 6 0 0 0 0 9;
     0 0 7 0 4 0 0 0 3;
     0 4 0 2 0 9 0 6 0;
     6 0 0 0 1 0 8 0 0;
     9 0 0 0 0 7 0 0 4;
     0 5 0 0 0 0 0 7 0;
     0 0 1 0 0 0 5 0 0];
S = sudoku_gurobi(X)

##

X = [0 0 4 9 3 0 0 0 5
     2 8 0 0 0 0 0 6 0
     0 1 0 0 2 0 0 4 0
     0 0 5 0 4 0 0 0 7
     0 2 0 0 0 5 0 0 0
     0 0 0 0 0 6 0 0 0
     0 0 0 1 0 0 0 8 2
     8 0 0 0 9 0 0 0 1
     0 7 0 0 0 0 0 0 0];
S = sudoku_gurobi(X)

##
X = [0 6 0 0 0 0 9 0 0;
     1 7 0 0 0 0 0 0 0;
     0 0 5 0 1 0 0 8 6;
     0 0 0 0 0 0 7 0 0;
     0 0 0 0 8 6 0 9 0;
     0 4 0 0 9 0 0 0 2;
     0 3 8 0 0 0 0 1 0;
     6 0 0 0 0 5 0 2 0;
     0 0 0 0 0 0 3 0 0];
S = sudoku_gurobi(X)

##
# http://www.nytimes.com/crosswords/game/sudoku/hard
