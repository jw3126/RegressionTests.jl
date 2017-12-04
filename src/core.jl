struct RegressionTester
    cache::Associative{String, Any}
end
function readbool(msg)
    println(msg)
    try
        return parse(Bool, readline())
    catch e
        println(e, "provide true/false")
        readbool(msg)
    end
end
function RegressionTester(path::AbstractString)
    cache = JLDBackedCache(path)
    RegressionTester(cache)
end
function (r::RegressionTester)(f, key, computed; opts...)
    if key ∈ keys(r.cache)
        cached = r.cache[key]
    elseif readbool("$key is missing. Should $computed be inserted?")
        cached = get!(r.cache, key, computed)
    else
        throw(KeyError(key))
    end
    f(cached, computed)
end
