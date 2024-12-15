### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ ab0ab2c0-0c3d-45d6-8fee-69a5b42fcd9b
begin 
	using PlutoUI
	using Latexify
	using PlutoTest
	TableOfContents(depth=4)
end

# ╔═╡ 3a69c428-c832-46d3-b3ed-d6abb1fe3de9
md"""
# CS401 Assignment 3
"""

# ╔═╡ 9e54e3b7-4289-411b-82da-12c53b787710
md"""
## Define the dual number type
"""

# ╔═╡ ad62b7ff-e7b8-483e-a074-08f7220e2e07
md"""
This requires the use of a struct to define the `Dual` data type and the definition of dual methods for mathematical operators in the Base module.
"""

# ╔═╡ 865a8d4c-f3b9-4853-bad4-124fad98d0ce
struct D <: Number # D is a function-derivative pair
	f::Tuple{Float64, Float64}
end

# ╔═╡ 0a955caa-c84f-11ed-3456-8f61b7cf94e3
md"""
#### (1) Derivative of `sin(x)` using Dual numbers:
"""

# ╔═╡ dbbe5058-e740-404e-9cc8-8b0099101f2f
md"""
!!! info "Task 1"
	In addition to the operator methods defined in the AD lecture notebook, you must provide the following additional three methods for Dual numbers:
	- sin(x::D)
	- exp(x::D)
	- -(x::D)
"""

# ╔═╡ 829ba0f6-3349-4dbe-a7d3-483e0f039b31
begin
	# basic operations
	Base.:+(a::Number, x::D) = D((a + x.f[1], x.f[2]))
	Base.:+(x::D, y::D) = D((x.f[1] + y.f[1], x.f[2] + y.f[2]))
	Base.:+(x::D, a::Number) = a + x
	Base.:-(a::Number, x::D) = D((a - x.f[1], -x.f[2]))
	Base.:-(x::D, a::Number) = D((x.f[1] - a, x.f[2]))
	Base.:*(x::D, y::D) = D((x.f[1] * y.f[1], x.f[1] * y.f[2] + x.f[2] * y.f[1]))
	Base.:*(a::Number, x::D) = D((a * x.f[1], a * x.f[2]))
	Base.:/(x::D, y::D) = D((x.f[1] / y.f[1], (x.f[2] * y.f[1] - x.f[1] * y.f[2]) / y.f[1]^2))
	Base.:^(x::D, p::Int) = D((x.f[1]^p, p * x.f[1]^(p - 1) * x.f[2]))

	# tasks
	Base.sin(x::D) = D((sin(x.f[1]), cos(x.f[1]) * x.f[2]))
	Base.exp(x::D) = D((exp(x.f[1]), exp(x.f[1]) * x.f[2]))
	Base.:-(x::D) = D((-x.f[1], -x.f[2]))

	const ϵ = D((0.0, 1.0))
end

# ╔═╡ 1c978a76-aeb4-46e9-a5d8-bd5877cca053
md"""
Extend the `round` function for Dual numbers to make testing answers more convenient
"""

# ╔═╡ f6cfbbaa-a273-4b5f-9f21-67a3f2274a04
function Base.round(d::D; sigdigits::Integer=0, base::Integer=10)
    # Round the real part and leave the dual part unchanged
    rounded_real = round(d.f[1]; sigdigits=sigdigits, base=base)
	rounded_dual = round(d.f[2]; sigdigits=sigdigits, base=base)
    return D((rounded_real, rounded_dual))
end

# ╔═╡ 4a6969e3-4948-4ac1-bf82-5501b14cea72
md"""
Test the definition of the Dual-based method for `sin`
"""

# ╔═╡ 75fb1a0e-d70c-47a6-a0fe-b0eb00f21084
@test round(sin(2+ϵ); sigdigits=3) == D((0.909, -0.416))

# ╔═╡ aa5cd24e-a1ed-4889-913b-ef5729b74176
md"""
Compare result to the analytic solution:
"""

# ╔═╡ 5ae94cd0-1ef7-42c9-aabe-32b95786ee30
@test (round(sin(2);sigdigits=3), round(cos(2);sigdigits=3)) == (0.909, -0.416)

# ╔═╡ 18b00a09-a8c3-439c-ad87-90ef3d791e4a
md"""
#### (2) Derivative of $$$x^2 + y^2$$$
"""

# ╔═╡ dd140783-6d04-43dc-ab7a-3a8251353e41
md"""
Define the function and its partial derivatives using Dual numbers:
"""

# ╔═╡ 0c26e063-e487-49e0-89d0-7c1a031c277a
md"""
!!! info "Task 2a"
	Your code here
"""

# ╔═╡ 58940c8c-8d51-45f9-a0aa-072a56092b5a
function f(x::D, y::D)
    real_part = x.f[1]^2 + y.f[1]^2
    dual_part = 2 * x.f[1] * x.f[2] + 2 * y.f[1] * y.f[2]
    return D((real_part, dual_part))
end


# ╔═╡ 996d2f35-e35b-4658-a16d-27f9e20b00d5
function f(x, y)
    x_dual = isa(x, D) ? x : D((x, 0.0))
    y_dual = isa(y, D) ? y : D((y, 0.0))
    return f(x_dual, y_dual)
end

# ╔═╡ 8db6a5a8-76af-4068-8d1d-0d40bd31eb62
md"""
Apply it to a simple test example:
"""

# ╔═╡ 1505b123-8c63-43b4-9212-2d38d177ccb2
@test f(1+ϵ, 2+ϵ) == D((5.0, 6.0))

# ╔═╡ 99d18a17-40dc-4654-b50c-b7e0a98884a9
md"""
Compare to the analytic result:
"""

# ╔═╡ 42740f93-c500-4a8c-bed3-6085cce79cea
md"""
!!! info "Task 2b"
	Your code here
"""

# ╔═╡ d2e8b724-23b1-4493-b2ba-9a43494309cc
function f_deriv(x::Real, y::Real)
    f_value = x^2 + y^2
    df_dx = 2 * x
    df_dy = 2 * y

    gradient_sum = df_dx + df_dy

	# Expected output
    return (f_value, gradient_sum)
end

# ╔═╡ e36e1ab0-2576-4d61-b1d2-ab31ea4fb752
@test f_deriv(1, 2) == (5,6)

# ╔═╡ ce0c19c6-3f51-46a7-bab3-ffa92abfb707
md"""
#### (3) Derivative of a polynomial function using Dual numbers
"""

# ╔═╡ bf1b1e72-90fe-42d2-b336-b26ae5539077
md"""
The polynomial looks like the following for an array `a` of length **`n=4`**:
"""

# ╔═╡ 5a90a302-d115-42e7-944a-ae2b02bc2541
latexify("a[1]x^(n-1) + a[2]x^(n-2) + a[3]x^(n-3) + a[4]x^(n-4)")

# ╔═╡ dd90a813-f590-4f62-b8f8-02efc9cd4561
md"""
Define a function to calculate the polynomial and its derivative using Dual numbers
"""

# ╔═╡ c89d70f0-ed7e-4948-980e-3f70bcead213
md"""
!!! info "Task 3a"
	Your code here
"""

# ╔═╡ 9c6d73e8-52c8-4dca-a68e-273706d783ca
function calc_poly(a::Vector, x::D)
    n = length(a)
    result = D((0.0, 0.0))
    
    for i in 1:n
        result += a[i] * (x^(n - i))
    end
    
    return result
end

# ╔═╡ 70d56ed9-4384-4860-91d8-b6fd97b879f9
md"""
Test it on simple data
"""

# ╔═╡ 61736a69-92bf-4dd4-b9fa-f80277091a37
@test calc_poly([1,2,3,4], 0.5+ϵ) == D((6.125, 5.75))

# ╔═╡ 273af20e-5473-4ffe-ab41-c4262d8b87f4
md"""
Calculate the same derivative analytically (note that last term below is zero):
"""

# ╔═╡ f3676b5c-5abc-41bd-b516-280d088cdabc
latexify("a[1](n-1)x^(n-2) + a[2](n-2)x^(n-3) + a[3](n-3)x^(n-4) + a[4](n-4)x^(n-5)")

# ╔═╡ b2620ce7-fa7a-496a-ad7b-0385138f96a6
md"""
!!! info "Task 3b"
	Your code here
"""

# ╔═╡ dca93ca9-9c1d-4ee8-9828-c58aee40b6cf
function calc_poly_deriv(a::Vector, x::Float64)
    n = length(a)
    poly_value = 0.0
    poly_deriv = 0.0
    
    for i in 1:n
        exponent = n - i
        poly_value += a[i] * x^exponent

        if exponent > 0
            poly_deriv += a[i] * exponent * x^(exponent - 1)
        end
    end
    
    return (poly_value, poly_deriv)
end


# ╔═╡ 21b3d6d8-702e-46bf-8216-56937b7a85d6
@test calc_poly_deriv([1,2,3,4], 0.5) == (6.125, 5.75)

# ╔═╡ aa70805b-de57-48e4-a408-0f9f7b222f32
md"""
#### (4) Derivative of the logistic function using Dual numbers:
"""

# ╔═╡ 5df3cd0b-5ca3-4d1f-a8b9-07458bbd75db
md"""
Define the logistic function

"""

# ╔═╡ 2260621c-60c3-4a7b-a06f-d82cbe167c66
latexify("f(x) = 1/(1 + e^-x)")

# ╔═╡ f58ed181-e2e9-4792-a250-8c791ef4a835
md"""
!!! info "Task 4a"
	Your code here
"""

# ╔═╡ dcc76725-817b-4497-be33-74a73a3d6f11
function logistic(x::D)
    real_part = 1 / (1 + exp(-x.f[1]))
    dual_part = real_part * (1 - real_part) * x.f[2]
    return D((real_part, dual_part))
end

# ╔═╡ 550b1a34-8cf4-4609-aa2a-641d7af53d7d
function logistic(x::Float64)
    return 1 / (1 + exp(-x))
end

# ╔═╡ df613628-5903-47c4-ba30-a60d93e0c26f
md"""
Test with a Dual number:
"""

# ╔═╡ 431c5a5c-760c-425e-9148-fb953a2f41df
@test round(logistic(D((1,1))); sigdigits=3) == D((0.731, 0.197))

# ╔═╡ ad7d1240-0192-46cd-a992-372497f2abbd
md"""
Compare result with analytic derivative
"""

# ╔═╡ 8b9ceb21-aa11-4b69-9099-b3a10a382c0c
md"""
!!! info "Task 4b"
	Your code here
"""

# ╔═╡ 892cec2a-478a-4b4c-b240-03dbfd6d0c56
function logistic_deriv(x::Float64)
    f_x = logistic(x)
    return f_x * (1 - f_x)
end

# ╔═╡ 4cb324e2-21b1-42aa-9db9-072dd6864033
@test (round(logistic(1.0); sigdigits=3), round(logistic_deriv(1.0), sigdigits=3)) == (0.731, 0.197)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Latexify = "~0.15.18"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.1"
manifest_format = "2.0"
project_hash = "5a918a0e97d8b0ed7f3028cc0334174c39663786"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Formatting]]
deps = ["Logging", "Printf"]
git-tree-sha1 = "fb409abab2caf118986fc597ba84b50cbaf00b87"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.3"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "8c57307b5d9bb3be1ff2da469063628631d4d51e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.21"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    DiffEqBiologicalExt = "DiffEqBiological"
    ParameterizedFunctionsExt = "DiffEqBase"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    DiffEqBiological = "eb300fae-53e8-50a0-950c-e21f52c2b7e0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═ab0ab2c0-0c3d-45d6-8fee-69a5b42fcd9b
# ╟─3a69c428-c832-46d3-b3ed-d6abb1fe3de9
# ╟─9e54e3b7-4289-411b-82da-12c53b787710
# ╟─ad62b7ff-e7b8-483e-a074-08f7220e2e07
# ╠═865a8d4c-f3b9-4853-bad4-124fad98d0ce
# ╟─0a955caa-c84f-11ed-3456-8f61b7cf94e3
# ╟─dbbe5058-e740-404e-9cc8-8b0099101f2f
# ╠═829ba0f6-3349-4dbe-a7d3-483e0f039b31
# ╟─1c978a76-aeb4-46e9-a5d8-bd5877cca053
# ╠═f6cfbbaa-a273-4b5f-9f21-67a3f2274a04
# ╟─4a6969e3-4948-4ac1-bf82-5501b14cea72
# ╠═75fb1a0e-d70c-47a6-a0fe-b0eb00f21084
# ╟─aa5cd24e-a1ed-4889-913b-ef5729b74176
# ╠═5ae94cd0-1ef7-42c9-aabe-32b95786ee30
# ╟─18b00a09-a8c3-439c-ad87-90ef3d791e4a
# ╟─dd140783-6d04-43dc-ab7a-3a8251353e41
# ╟─0c26e063-e487-49e0-89d0-7c1a031c277a
# ╠═58940c8c-8d51-45f9-a0aa-072a56092b5a
# ╠═996d2f35-e35b-4658-a16d-27f9e20b00d5
# ╟─8db6a5a8-76af-4068-8d1d-0d40bd31eb62
# ╠═1505b123-8c63-43b4-9212-2d38d177ccb2
# ╟─99d18a17-40dc-4654-b50c-b7e0a98884a9
# ╟─42740f93-c500-4a8c-bed3-6085cce79cea
# ╠═d2e8b724-23b1-4493-b2ba-9a43494309cc
# ╠═e36e1ab0-2576-4d61-b1d2-ab31ea4fb752
# ╟─ce0c19c6-3f51-46a7-bab3-ffa92abfb707
# ╟─bf1b1e72-90fe-42d2-b336-b26ae5539077
# ╟─5a90a302-d115-42e7-944a-ae2b02bc2541
# ╟─dd90a813-f590-4f62-b8f8-02efc9cd4561
# ╟─c89d70f0-ed7e-4948-980e-3f70bcead213
# ╠═9c6d73e8-52c8-4dca-a68e-273706d783ca
# ╟─70d56ed9-4384-4860-91d8-b6fd97b879f9
# ╠═61736a69-92bf-4dd4-b9fa-f80277091a37
# ╟─273af20e-5473-4ffe-ab41-c4262d8b87f4
# ╠═f3676b5c-5abc-41bd-b516-280d088cdabc
# ╟─b2620ce7-fa7a-496a-ad7b-0385138f96a6
# ╠═dca93ca9-9c1d-4ee8-9828-c58aee40b6cf
# ╠═21b3d6d8-702e-46bf-8216-56937b7a85d6
# ╟─aa70805b-de57-48e4-a408-0f9f7b222f32
# ╟─5df3cd0b-5ca3-4d1f-a8b9-07458bbd75db
# ╟─2260621c-60c3-4a7b-a06f-d82cbe167c66
# ╟─f58ed181-e2e9-4792-a250-8c791ef4a835
# ╠═dcc76725-817b-4497-be33-74a73a3d6f11
# ╠═550b1a34-8cf4-4609-aa2a-641d7af53d7d
# ╟─df613628-5903-47c4-ba30-a60d93e0c26f
# ╠═431c5a5c-760c-425e-9148-fb953a2f41df
# ╟─ad7d1240-0192-46cd-a992-372497f2abbd
# ╟─8b9ceb21-aa11-4b69-9099-b3a10a382c0c
# ╠═892cec2a-478a-4b4c-b240-03dbfd6d0c56
# ╠═4cb324e2-21b1-42aa-9db9-072dd6864033
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
