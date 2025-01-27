"""
	generateinstancenames()

	Return a Dict{Symbol, Tuple{String, Int}} Instance Symbol Name => filepath, Number of nodes
"""
function generateinstancenames()
    fd_small = joinpath(@__DIR__, "instances", "Instances_small")
    fd_15 = joinpath(@__DIR__, "instances", "Instances_15")
    fd_25 = joinpath(@__DIR__, "instances", "Instances_25")
    fd_40 = joinpath(@__DIR__, "instances", "Instances_40")
    fd_50 = joinpath(@__DIR__, "instances", "Instances_50")
    fd_article = joinpath(@__DIR__, "instances", "Instances_journal_article/journal")


    return Dict{Symbol,Tuple{String,Int}}(
        :TinyInstance_10_3 => ("$fd_small/tiny_instance_10_3.txt", 10),
        :TinyInstance_12_2 => ("$fd_small/tiny_instance_12_2.txt", 12),
        :Instance_15_1_0_3_1 => ("$fd_15/Instance_15_1.0_3_1.dat", 15),
        :Instance_15_1_0_5_1 => ("$fd_15/Instance_15_1.0_5_1.dat", 15),
        :Instance_25_1_0_3_1 => ("$fd_25/Instance_25_1.0_3_1.dat", 25),
        :Instance_25_1_0_3_3 => ("$fd_25/Instance_25_1.0_3_3.dat", 25),
        :Instance_25_1_0_5_2 => ("$fd_25/Instance_25_1.0_5_2.dat", 25),
        :Instance_25_3_0_7_1 => ("$fd_25/Instance_25_3.0_7_1.dat", 25),
        :Instance_25_1_0_7_4 => ("$fd_25/Instance_25_1.0_7_4.dat", 25),
        :Instance_25_9_0_9_5 => ("$fd_25/Instance_25_9.0_9_5.dat", 25),
        :Instance_40_1_0_9_1 => ("$fd_40/Instance_40_1.0_9_1.dat", 40),
        :Instance_50_4_0_5_1 => ("$fd_50/Instance_50_4.0_5_1.dat", 50),
        :eil51 => ("$fd_article/eil51.tsp", 51),
        :berlin52 => ("$fd_article/berlin52.tsp", 52),
        :brazil58 => ("$fd_article/brazil58.tsp2", 58),
        :st70 => ("$fd_article/st70.tsp", 70),
        :eil76 => ("$fd_article/eil76.tsp", 76),
        :pr76 => ("$fd_article/pr76.tsp", 76),
        :gr96 => ("$fd_article/gr96.tsp", 96),
        :rat99 => ("$fd_article/rat99.tsp", 99),
        :kroA100 => ("$fd_article/kroA100.tsp", 100),
        :kroB100 => ("$fd_article/kroB100.tsp", 100),
        :kroC100 => ("$fd_article/kroC100.tsp", 100),
        :kroD100 => ("$fd_article/kroD100.tsp", 100),
        :kroE100 => ("$fd_article/kroE100.tsp", 100),
        :rd100 => ("$fd_article/rd100.tsp", 100),
        :eil101 => ("$fd_article/eil101.tsp", 101),
        :lin105 => ("$fd_article/lin105.tsp", 105),
        :pr107 => ("$fd_article/pr107.tsp", 107),
        :gr120 => ("$fd_article/gr120.tsp2", 120),
        :pr124 => ("$fd_article/pr124.tsp", 124),
        :bier127 => ("$fd_article/bier127.tsp", 127),
        :ch130 => ("$fd_article/ch130.tsp", 130),
        :pr136 => ("$fd_article/pr136.tsp", 136),
        :gr137 => ("$fd_article/gr137.tsp", 137),
        :pr144 => ("$fd_article/pr144.tsp", 144),
        :ch150 => ("$fd_article/ch150.tsp", 150),
        :kroA150 => ("$fd_article/kroA150.tsp", 150),
        :kroB150 => ("$fd_article/kroB150.tsp", 150),
        :pr152 => ("$fd_article/pr152.tsp", 153),
        :u159 => ("$fd_article/u159.tsp", 159),
        :rat195 => ("$fd_article/rat195.tsp", 195),
        :d198 => ("$fd_article/d198.tsp", 198),
        :kroA200 => ("$fd_article/kroA200.tsp", 200),
        :kroB200 => ("$fd_article/kroB200.tsp", 200),
        :RandomInstance => ("", 0),
    )
end

@with_kw mutable struct RRSPInstance
    n::Int
    V::UnitRange{Int} = 1:n
    tildeV::Vector{Int} = 2:n
    F::Float64
    o::Vector{Float64}
    @assert length(o) == n
    α::Float64
    c::Dict{Tuple{Int,Int},Float64}
    c′::Dict{Tuple{Int,Int},Float64}
    d::Dict{Tuple{Int,Int},Float64}
    d′::Dict{Tuple{Int,Int},Float64}
    x::Vector{Float64}
    y::Vector{Float64}
end

function printinst(inst::RRSPInstance, pars)
    V = inst.V
    str = "F = $(inst.F)\ntildeV = $(inst.tildeV)\n"
    str *= "opening hub costs\n"
    for i in V
        str *= "$i:$(inst.o[i]) "
    end
    str *= "\nc = \n      "
    rpad_value = 4
    for i in V
        str *= "$(rpad(i,rpad_value)) "
    end
    str *= '\n'
    for i in V
        for j ∈ 1:inst.n
            if j == 1
                str *= "$(rpad(i,rpad_value))"
            end
            if i < j
                str *= "$(lpad(Int(inst.c[i,j]),rpad_value)) "
            else
                str *= rpad("  .  ", rpad_value)
            end
        end
        str *= '\n'
    end
    str *= "\nd = \n "
    for i in V
        str *= "$(rpad(i,rpad_value)) "
    end
    str *= '\n'
    for i in V
        for j in V
            if j == 1
                str *= "$(rpad(i,rpad_value ))"
            end
            if i != j
                str *= "$(lpad(Int(inst.d[i,j]),rpad_value)) "
            else
                str *= rpad("  . ", rpad_value)
            end
        end
        str *= '\n'
    end
    str *= "\nc'=$(pars.backup_factor)c and d'=$(pars.backup_factor)d"

end

function createinstance_rrsp(filename, α, pars)
    
    random_filepath =
        eval(@__DIR__) * "/instances/Instances_journal_article/RAND/$(filename[2]).dat"
    if pars.nrand > 0 && !isfile(random_filepath)
        n = pars.nrand
        data = [1:1000 rand(1:1000, 1000) rand(1:1000, 1000)]

        V = 1:n
        tildeV = 2:Int(ceil(n * pars.tildeV / 100))
        E = [(i, j) for i in V, j in V if i < j]
        A = [(i, j) for i in V, j in V]
        Ac = [(i, j) for i in V, j in V if i != j]

        if α == 0
            error("Please define α")
        end
        xs = data[1:n, 2]
        ys = data[1:n, 3]
        c, d = createweights(xs, ys, A, pars.r_ij, pars.s_ij)

        o = zeros(Float64, n)
        if pars.o_i == RandomInterval
            o = rand(RandomInterval.a:RandomInterval.b, n)
        elseif typeof(pars.o_i) == UInt
            o = pars.o_i*ones(Float64, n)
        end

        open(random_filepath, "w") do f
            println(f, "$n 0.0 $α")
            for i ∈ 1:n
                println(f, "$i $(xs[i]) $(ys[i])")
            end
            println(f, "opening costs")
            for i ∈ 1:n
                print(f, o[i], " ")
            end
            println(f)
            println(f, "star costs")
            for i ∈ 1:n
                for j ∈ 1:n
                    print(f, s[i, j], " ")
                end
                println(f)
            end
        end
        c′ = Dict{Tuple{Int,Int},Float64}()
        d′ = Dict{Tuple{Int,Int},Float64}()
        for kv in c
            c′[kv[1]] = c[kv[1]] * pars.backup_factor
        end
        for kv in d
            d′[kv[1]] = d[kv[1]] * pars.backup_factor
        end
        return RRSPInstance(n, V, tildeV, pars.F, o, α, c, c′, d, d′, xs, ys)

    elseif pars.nrand == 0

        data = readdlm(filename[1])
        n = filename[2]
        V = 1:n
        tildeV = 2:Int(ceil(n * pars.tildeV / 100))
        E = [(i, j) for i in V, j in V if i < j]
        A = [(i, j) for i in V, j in V]
        Ac = [(i, j) for i in V, j in V if i != j]



        o = zeros(Float64, n)
        if pars.o_i == RandomInterval
            o = rand(RandomInterval.a:RandomInterval.b, n)
        elseif typeof(pars.o_i) == UInt
            o = pars.o_i*ones(Float64, n)
        end

        if filename[1][end-12:end] == "brazil58.tsp2"
            c = Dict((e[1], e[2]) => ceil_labbe(data[7+e[1], e[2]-e[1]] * α) for e in E)
            d = Dict(
                (a[1], a[2]) =>
                    a[1] == a[2] ? 0.0 :
                    (
                        a[1] < a[2] ? ceil_labbe(data[7+a[1], a[2]-a[1]] * (10 - α)) :
                        ceil_labbe(data[7+a[2], a[1]-a[2]] * (10 - α))
                    ) for a in A
            )

            for i ∈ 2:n
                c[i, n+1] = c[1, i]
            end
            c[1, n+1] = 0
            c′ = Dict{Tuple{Int,Int},Float64}()
            d′ = Dict{Tuple{Int,Int},Float64}()
            for kv in c
                c′[kv[1]] = c[kv[1]] * pars.backup_factor
            end
            for kv in d
                d′[kv[1]] = d[kv[1]] * pars.backup_factor
            end
            return RRSPInstance(
                n,
                V,
                2:Int(ceil(n * pars.tildeV / 100)),
                pars.F,
                o,
                α,
                c,
                c′,
                d,
                d′,
                zeros(Int, n),
                zeros(Int, n),
            )
        else
            shift_n = 0
            if filename[1][end-7:end] == "120.tsp2"
                shift_n = 414 - 7
            end

            xs, ys = readcoordinates(data)

            c = Dict(
                (e[1], e[2]) => ceil_labbe(
                    distance(
                        [xs[e[1]], ys[e[1]]],
                        [xs[e[2]], ys[e[2]]],
                    ) * (α),
                ) for e in E
            )


            for i ∈ 2:n
                c[i, n+1] = c[1, i]
            end
            c[1, n+1] = 0


            d = Dict(
                (a[1], a[2]) => ceil_labbe(
                    distance(
                        [xs[a[1]], ys[a[1]]],
                        [xs[a[2]], ys[a[2]]],
                    ) * (10 - α),
                ) for a in A
            )

            c′ = Dict{Tuple{Int,Int},Float64}()
            d′ = Dict{Tuple{Int,Int},Float64}()
            for kv in c
                c′[kv[1]] = c[kv[1]] * pars.backup_factor
            end
            for kv in d
                d′[kv[1]] = d[kv[1]] * pars.backup_factor
            end
            return RRSPInstance(n, V, tildeV, pars.F, o, α, c, c′, d, d′, xs, ys)
        end

    else
        data = readdlm(random_filepath)
        n = Int64(data[1, 1])
        V = 1:n
        tildeV = 2:Int(ceil(n * pars.tildeV / 100))
        E = [(i, j) for i in V, j in V if i < j]
        A = [(i, j) for i in V, j in V]
        Ac = [(i, j) for i in V, j in V if i != j]
        xs, ys = readcoordinates(data)
        o = data[n+3, 1:n]

        c, d = createweights(xs, ys, A, pars.r_ij, pars.s_ij)

        d_data = data[n+5:2n+4, 1:n]
        d = Dict((a[1], a[2]) => d_data[a[1], a[2]] for a in A)
        c′ = Dict{Tuple{Int,Int},Float64}()
        d′ = Dict{Tuple{Int,Int},Float64}()
        for kv in c
            c′[kv[1]] = c[kv[1]] * pars.backup_factor
        end
        for kv in d
            d′[kv[1]] = d[kv[1]] * pars.backup_factor
        end

        return RRSPInstance(n, V, tildeV, pars.F, o, α, c, c′, d, d′, xs, ys)
    end
end

"""
    createinstance_rrsp(xycoordinates, α, pars)
    `x` and `y` are coordinates of points

    Return an RRSPInstance
"""
function createinstance_rrsp(instdataname::Tuple{Vector{Tuple{Int, Int}},Int}, α, pars)
    n = length(instdataname[2])

    xs, ys = first.(instdataname[1]), last.(instdataname[1])

    V = 1:n
    tildeV = 2:Int(ceil(n * pars.tildeV / 100))
    E = [(i, j) for i in V, j in V if i < j]
    A = [(i, j) for i in V, j in V]
    Ac = [(i, j) for i in V, j in V if i != j]

    o = zeros(Float64, n)
    if pars.o_i == RandomInterval
        o = rand(RandomInterval.a:RandomInterval.b, n)
    elseif typeof(pars.o_i) == UInt
        o = pars.o_i*ones(Float64, n)
    end

    c = Dict(
        (e[1], e[2]) => ceil_labbe(
            distance(
                [xs[e[1]], ys[e[1]]],
                [xs[e[2]], ys[e[2]]],
            ) * (α),
        ) for e in E
    )


    for i ∈ 2:n
        c[i, n+1] = c[1, i]
    end
    c[1, n+1] = 0


    d = Dict(
        (a[1], a[2]) => ceil_labbe(
            distance(
                [xs[a[1]], ys[a[1]]],
                [xs[a[2]], ys[a[2]]],
            ) * (10 - α),
        ) for a in A
    )

    c′ = Dict{Tuple{Int,Int},Float64}()
    d′ = Dict{Tuple{Int,Int},Float64}()
    for kv in c
        c′[kv[1]] = c[kv[1]] * pars.backup_factor
    end
    for kv in d
        d′[kv[1]] = d[kv[1]] * pars.backup_factor
    end
    return RRSPInstance(n, V, tildeV, pars.F, o, α, c, c′, d, d′, xs, ys)
end






"""
    readcoordinates(data)

    first line and column of data contains the number of nodes and is ignored
    Return two vectors of coordinates read from data
"""
function readcoordinates(data)

    n_start = 2
    xs = Float64[]
    ys = Float64[]
    while length(xs) == 0
        try
            if data[end, 2] == ""
                xs = Float64.(data[n_start:end-1, 2])
            else
                xs = Float64.(data[n_start:end, 2])
            end
        catch
            n_start += 1
        end
    end
    n_start = 2
    while length(ys) == 0
        try
            if data[end, 2] == ""
                ys = Float64.(data[n_start:end-1, 3])
            else
                ys = Float64.(data[n_start:end, 3])
            end
        catch
            n_start += 1
        end
    end
    return xs, ys
end


function createweights(xs, ys, A, r_ij, s_ij)
    if r_ij isa RandomInterval
        c = Dict(
            (a[1], a[2]) =>
                a[1] == a[2] ? 0 : rand(pars.r_ij[1]:pars.r_ij[2])
            for a in A
        )
    end
    if r_ij isa Euclidian
        c = Dict(
            (e[1], e[2]) => ceil_labbe(
                distance([xs[e[1]], ys[e[1]]], [xs[e[2]], ys[e[2]]]),
            ) for e in E
        )
    end

    if s_ij isa RandomInterval
        d = Dict(
            (a[1], a[2]) =>
                a[1] == a[2] ? 0 : rand(pars.r_ij[1]:pars.r_ij[2])
            for a in A
        )
    end
    if s_ij isa Euclidian
        d = Dict(
            (a[1], a[2]) => ceil_labbe(
                distance(
                    [xs[a[1]], ys[a[1]]],
                    [xs[a[2]], ys[a[2]]],
                ),
            ) for a in A
        )
    end
    
    for i ∈ 2:n
        c[i, n+1] = c[1, i]
    end
    c[1, n+1] = 0


    return c, d
end