# RegressionTests

[![Build Status](https://travis-ci.org/jw3126/RegressionTests.jl.svg?branch=master)](https://travis-ci.org/jw3126/RegressionTests.jl)
[![codecov.io](https://codecov.io/github/jw3126/RegressionTests.jl/coverage.svg?branch=master)](http://codecov.io/github/jw3126/RegressionTests.jl?branch=master)
```julia
using RegressionTester
using Base.Test

r = RegressionTester("mypath.jld)

r("important simulation", my_complicated_simulation) do status_quo, result
    @test status_quo == result
end
```
