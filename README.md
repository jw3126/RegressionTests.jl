# RegressionTests
```julia
using RegressionTester
using Base.Test

r = RegressionTester("mypath.jld)

r("important simulation", my_complicated_simulation) do status_quo, result
    @test status_quo == result
end
```
