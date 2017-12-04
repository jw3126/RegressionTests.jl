using RegressionTests
using Base.Test

@testset "RegressionTester" begin
    path = tempname()
    r = RegressionTester(path)
    r2 = RegressionTester(path)
    r.cache["one"] = 1
    @test r(≈, "one", 1)
    @test !r(≈, "one", 2)
    r("one", 2) do ca, co
        @test ca === 1
        @test co === 2
    end
    x = randn()
    r.cache["foo"] = x
    @test r(==, "foo", x)
    @test r2(==, "foo", x)
    rm(path, force=true)
end

@testset "JLDBackedCache" begin
    path = tempname()
    o = RegressionTests.JLDBackedCache(path)
    @test isempty(o)
    o["a"] = 1
    o["b"] = 2
    @test o["a"] == 1
    @test o["b"] == 2
    @test length(o) == 2
    @test Dict(o) == Dict("b" =>2, "a" => 1)
    o2 = RegressionTests.JLDBackedCache(path)
    @test Dict(o2) == Dict(o)
    rm(path, force=true)
end
