export RegressionTester

struct RegressionTester
    cache::AbstractDict{String, Any}
    read_cache_action::Function # :: RegressionTester -> key -> computed -> (cached, computed)
    result_action::Function # :: RegessionTester -> key -> cached -> computed -> result -> Any
end

function read_cache_action(r::RegressionTester, args...;kw...)
    r.read_cache_action(r, args...; kw...)
end
function result_action(r::RegressionTester, args...; kw...)
    r.result_action(r, args...;kw...)
end

function prompt_missing_keys(r, key, computed)
    if key ∈ keys(r.cache)
        cached = r.cache[key]
    elseif readbool("$key is missing. Should $computed be inserted?")
        cached = get!(r.cache, key, computed)
    else
        throw(KeyError(key))
    end
    cached, computed
end

pass_result(r,key,cached,computed,result) = result

function prompt_replace(r,key,cached,computed,result)
    if !result
        println("Regression test failure:")
        println("Key: $key")
        println("Cached: $cached")
        println("Computed: $computed")
        replace = readbool("Should the current cached value be replaced, with the computed value?")
        if replace
            r.cache[key] = computed
            cached = computed
            return true
        end
    end
    result
end

function readbool(msg)
    println(msg)
    println("provide true/false")
    try
        return parse(Bool, readline())
    catch e
        println(e, "provide true/false")
        readbool(msg)
    end
end

function RegressionTester(path::AbstractString; kw...)
    cache = JLDBackedCache(path)
    RegressionTester(cache; kw...)
end
function RegressionTester(cache::AbstractDict,
                          read_cache_action=prompt_missing_keys,
                          result_action=pass_result)
    RegressionTester(cache, read_cache_action, result_action)
end

function (r::RegressionTester)(f, key, computed; opts...)
    cached, computed = read_cache_action(r, key, computed)
    result = f(cached, computed)
    result_action(r, key, cached, computed, result)
end
