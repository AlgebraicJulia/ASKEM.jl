### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 82d23846-7045-11ed-152b-49bacb843ba4
begin
	using Pkg
	Pkg.activate("..")
	using Revise, ASKEM
	using DifferentialEquations
	using Plots

	using Catlab.Theories
	using Catlab.Graphics
	using Catlab.CategoricalAlgebra
	using Catlab.Programs.RelationalPrograms

	using AlgebraicPetri
	using AlgebraicPetri.Epidemiology

	using ModelingToolkit
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ b003c833-8d56-4a7d-af3d-7007328368ef
sir_uwd = @relation (s, i, r) where (s, i, r) begin
    infection(s, i)
    recovery(i, r)
end;

# ╔═╡ ede2718c-489d-42df-a39f-fdec4646a9c1
sir_petri = apex(oapply_epi(sir_uwd));

# ╔═╡ f62b4be9-9da4-41c9-a6e4-7da5653403e7
sir = ASKEM.PetriMTK.rate_equation(sir_petri; name=:sir)

# ╔═╡ 33775194-bc2e-4eef-88c4-cf4e42f4392b
S,I,R,inf,rec = states(sir)

# ╔═╡ 42daf93a-900c-4743-ab65-fe88058af7db
t = ModelingToolkit.get_iv(sir)

# ╔═╡ b895c52e-1592-4905-a38c-7c9d70b92509
@named sir_with_event = ModelingToolkit.compose(ODESystem([], t; continuous_events = [sir.I ~ 200.0] => [sir.inf ~ 0.5 * sir.inf], name=:intervention), sir)

# ╔═╡ bbc73193-584e-4681-b30f-e6b19438eae7
@bind init Sliders("Initial Concentrations", ["S" => 0:50.0:1000, "I" => 0:5.0:100, "R" => 0:5.0:100])

# ╔═╡ 10d681a1-2634-4de2-97d0-0ab91d83f22a
Revise.retry()

# ╔═╡ c6c820af-1a8c-46c2-827e-547b9ab817c5
@bind rates Sliders("Rates", ["inf" => 0:0.001:0.1, "rec" => 0:0.1:2.0])

# ╔═╡ fce68171-13a9-4af3-a012-8d8b1ce763c6
prob = ODEProblem(sir_with_event, [init..., rates...], (0.0, 2.0), [])

# ╔═╡ 66f0ce87-2c08-4ad7-838b-56f9ed5029ac
plot(solve(prob))

# ╔═╡ 72daa7df-e8c2-4913-b445-9fbbd8b885ec
md"""
Policies:
- Implement restrictions at fixed date
- Implement restrictions after cases are above a given number

Real world challenges:
- Have to give people time to prepare for lockdown
- Reported cases lag behind actual cases
- Effects of lockdown on transmission unknown

Problem:
Make a toolkit for evaluating different policies in different scenarios. This should include explorative evaluation and probabilistic evaluation.
"""

# ╔═╡ 16704ffe-7ba3-4f5c-8cdb-ca54e2c1df92
md"""
Models:
- SIR
- SIRD
- SEIRD
- SIR with hospitalization
- ...

For each model, we want to expose the variables of interest: number of hospitalizations over time. We also want to be able to query its maximum. Finally, we want to explore the effects of different assumptions.

For each policy, we want to translate it into the language of each model. We also want to give control over parameters of the policy.
"""

# ╔═╡ 482a2bff-8234-4c9b-942b-e8862f0ee3a1


# ╔═╡ Cell order:
# ╠═82d23846-7045-11ed-152b-49bacb843ba4
# ╠═b003c833-8d56-4a7d-af3d-7007328368ef
# ╠═ede2718c-489d-42df-a39f-fdec4646a9c1
# ╠═f62b4be9-9da4-41c9-a6e4-7da5653403e7
# ╠═33775194-bc2e-4eef-88c4-cf4e42f4392b
# ╠═42daf93a-900c-4743-ab65-fe88058af7db
# ╠═b895c52e-1592-4905-a38c-7c9d70b92509
# ╠═bbc73193-584e-4681-b30f-e6b19438eae7
# ╠═10d681a1-2634-4de2-97d0-0ab91d83f22a
# ╠═c6c820af-1a8c-46c2-827e-547b9ab817c5
# ╠═fce68171-13a9-4af3-a012-8d8b1ce763c6
# ╠═66f0ce87-2c08-4ad7-838b-56f9ed5029ac
# ╟─72daa7df-e8c2-4913-b445-9fbbd8b885ec
# ╟─16704ffe-7ba3-4f5c-8cdb-ca54e2c1df92
# ╠═482a2bff-8234-4c9b-942b-e8862f0ee3a1
