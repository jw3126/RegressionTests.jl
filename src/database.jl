using JLD2
using FileIO

struct JLDBackedCache <: Associative{String, Any}
    path::String
    function JLDBackedCache(path)
        if !ispath(path)
            jldopen(path, "w") do file
                file["dict"] = Dict{String, Any}()
            end
        end
        new(path)
    end
end

function with_dict(f, o::JLDBackedCache, args...)
    d = jldopen(o.path, "r") do file
        file["dict"]
    end
    ret = f(d, args...)
    jldopen(o.path, "w") do file
        file["dict"] = d
    end
    ret
end

for f in [:keys, :values, :Dict, 
        :getindex, 
        :setindex, :setindex!,
        :get, :get!,
        :start, :next, :done,
        :length,
    ]
    @eval (Base.$f)(d::JLDBackedCache, args...) = with_dict($f, d, args...)
end
