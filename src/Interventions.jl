module Interventions

using ModelingToolkit

abstract type Trigger end

# Apply the equations at a given time
struct TimedTrigger <: Trigger
  time::Float64
end

# Threshold intervention
struct ThresholdTrigger <: Trigger
  variable::Symbolic
  threshold::Float64
end

abstract type Effect end

struct SetEffect <: Effect
  variable::Symbolic
  value::Float64
end

struct Policy
  trigger::Trigger
  effect::Effect
end

end
