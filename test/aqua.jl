using RingStarProblems
using Aqua

@testset "Aqua.jl" begin
    Aqua.test_all(
        RingStarProblems;
        stale_deps=(;ignore=[:GLPK, :Gurobi, :LiveServer]),
        ambiguities = (exclude = [], broken = false),
        piracies = false,
    )
end
