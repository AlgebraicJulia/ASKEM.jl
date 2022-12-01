module TestStratify 

using ASKEM
using Catlab, Catlab.CategoricalAlgebra
using AlgebraicPetri
using Test 

SIRD = LabelledPetriNet([:S, :I, :R, :D],
    :inf => ((:S,:I) => (:I,:I)),
    :recover => (:I=>:R),
    :death => (:I=>:D))
    
Quarantine = LabelledPetriNet([:Q,:NQ],
    :quarantine => ((:NQ)=>(:Q)),
    :unquarantine => ((:Q)=>(:NQ)))

types′ = LabelledPetriNet([:Pop],
    :infect=>((:Pop, :Pop)=>(:Pop, :Pop)),
    :disease=>(:Pop=>:Pop),
    :strata=>(:Pop=>:Pop))

types = map(types′, Name=name->nothing)

SIRD_typed = homomorphism(SIRD, types;
    initial=(T=[1,2,2],I=[1,2,3,3],O=[1,2,3,3]),
    type_components=(Name=x->nothing,))

Quarantine_typed = homomorphism(Quarantine, types;
    initial=(T=[3,3],), type_components=(Name=x->nothing,))

naive_stratification = apex(pullback(SIRD_typed, Quarantine_typed))
@test nt(naive_stratification) == 0 

res = stratify(SIRD_typed=>[[:strata],[:strata],[:strata],[]], # S I R D
                Quarantine_typed=>[[:disease], [:disease,:infect]],# Q NQ 
                types′) 
res2 = stratify_except(SIRD_typed=>[4=>[:strata]], 
                        Quarantine_typed=>[1=>[:infect]], types′)

@test is_isomorphic(res, res2)

@test nt(age_strata(2)) == 5

end # module
