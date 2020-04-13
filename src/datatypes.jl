################################################################################
#                                INDEX TYPES
################################################################################
"""
    AbstractInfOptIndex

An abstract type for all index objects used in `InfiniteOpt`.
"""
abstract type AbstractInfOptIndex end

"""
    ObjectIndex <: AbstractInfOptIndex

An abstract type for indices of objects stored in `MOI.Utilities.CleverDicts`.
"""
abstract type ObjectIndex <: AbstractInfOptIndex end

"""
    IndependentParameterIndex <: ObjectIndex

A `DataType` for storing the index of a [`IndependentParameter`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct IndependentParameterIndex <: ObjectIndex
    value::Int
end

"""
    DependentParametersIndex <: ObjectIndex

A `DataType` for storing the index of a [`DependentParameters`](@ref) object.

**Fields**
- `value::Int`: The index value.
"""
struct DependentParametersIndex <: ObjectIndex
    value::Int
end

"""
    DependentParameterIndex <: AbstractInfOptIndex

A `DataType` for storing the index of an indiviudal parameter in a
[`DependentParameters`](@ref) object.

**Fields**
- `object_index::DependentParametersIndex`: The index of the parameter collection.
- `param_index::Int`: The index of the individual parameter in the above object.
"""
struct DependentParameterIndex <: AbstractInfOptIndex
    object_index::DependentParametersIndex
    param_index::Int
end

# Define convenient alias for infinite parameters
const InfiniteParameterIndex = Union{IndependentParameterIndex, DependentParameterIndex}

"""
    FiniteParameterIndex <: ObjectIndex

A `DataType` for storing the index of a [`FiniteParameter`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct FiniteParameterIndex <: ObjectIndex
    value::Int
end

"""
    InfiniteVariableIndex <: ObjectIndex

A `DataType` for storing the index of a [`InfiniteVariable`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct InfiniteVariableIndex <: ObjectIndex
    value::Int
end

"""
    ReducedInfiniteVariableIndex <: ObjectIndex

A `DataType` for storing the index of a [`ReducedInfiniteVariable`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct ReducedInfiniteVariableIndex <: ObjectIndex
    value::Int
end

"""
    PointVariableIndex <: ObjectIndex

A `DataType` for storing the index of a [`PointVariable`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct PointVariableIndex <: ObjectIndex
    value::Int
end

"""
    HoldVariableIndex <: ObjectIndex

A `DataType` for storing the index of a [`HoldVariable`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct HoldVariableIndex <: ObjectIndex
    value::Int
end

"""
    MeasureIndex <: ObjectIndex

A `DataType` for storing the index of a [`Measure`](@ref).

**Fields**
- `value::Int`: The index value.
"""
struct MeasureIndex <: ObjectIndex
    value::Int
end

"""
    ConstraintIndex <: ObjectIndex

A `DataType` for storing the index of constraint objects.

**Fields**
- `value::Int`: The index value.
"""
struct ConstraintIndex <: ObjectIndex
    value::Int
end

## Extend the CleverDicts key access methods
# index_to_key IndependentParameterIndex
function MOIUC.index_to_key(::Type{IndependentParameterIndex},
                            index::Int)::IndependentParameterIndex
    return IndependentParameterIndex(index)
end

# index_to_key DependentParametersIndex
function MOIUC.index_to_key(::Type{DependentParametersIndex},
                            index::Int)::DependentParametersIndex
    return DependentParametersIndex(index)
end

# index_to_key FiniteParameterIndex
function MOIUC.index_to_key(::Type{FiniteParameterIndex},
                            index::Int)::FiniteParameterIndex
    return FiniteParameterIndex(index)
end

# index_to_key InfiniteVariableIndex
function MOIUC.index_to_key(::Type{InfiniteVariableIndex},
                            index::Int)::InfiniteVariableIndex
    return InfiniteVariableIndex(index)
end

# index_to_key ReducedInfiniteVariableIndex
function MOIUC.index_to_key(::Type{ReducedInfiniteVariableIndex},
                            index::Int)::ReducedInfiniteVariableIndex
    return ReducedInfiniteVariableIndex(index)
end

# index_to_key PointVariableIndex
function MOIUC.index_to_key(::Type{PointVariableIndex},
                            index::Int)::PointVariableIndex
    return PointVariableIndex(index)
end

# index_to_key HoldVariableIndex
function MOIUC.index_to_key(::Type{HoldVariableIndex},
                            index::Int)::HoldVariableIndex
    return HoldVariableIndex(index)
end

# index_to_key MeasureIndex
function MOIUC.index_to_key(::Type{MeasureIndex},
                            index::Int)::MeasureIndex
    return MeasureIndex(index)
end

# index_to_key ConstraintIndex
function MOIUC.index_to_key(::Type{ConstraintIndex},
                            index::Int)::ConstraintIndex
    return ConstraintIndex(index)
end

# key_to_index
function MOIUC.key_to_index(key::ObjectIndex)::Int
    return key.value
end

# Extend Base.length
Base.length(index::AbstractInfOptIndex)::Int = 1
Base.broadcastable(index::AbstractInfOptIndex) = Ref(index)
Base.iterate(index::AbstractInfOptIndex) = (index, true)
Base.iterate(index::AbstractInfOptIndex, state) = nothing

################################################################################
#                            INFINITE SET TYPES
################################################################################
"""
    AbstractInfiniteSet

An abstract type for sets that characterize infinite parameters.
"""
abstract type AbstractInfiniteSet end

"""
    InfiniteScalarSet <: AbstractInfiniteSet

An abstract type for infinite sets that are one-dimensional.
"""
abstract type InfiniteScalarSet <: AbstractInfiniteSet end

"""
    IntervalSet <: InfiniteScalarSet

A `DataType` that stores the lower and upper interval bounds for infinite
parameters that are continuous over a certain that interval. This is for use
with a [`IndependentParameter`](@ref).

**Fields**
- `lower_bound::Float64` Lower bound of the infinite parameter.
- `upper_bound::Float64` Upper bound of the infinite parameter.
"""
struct IntervalSet <: InfiniteScalarSet
    lower_bound::Float64
    upper_bound::Float64
    function IntervalSet(lower::Real, upper::Real)
        if lower > upper
            error("Invalid interval set bounds, lower bound is greater than " *
                  "upper bound.")
        end
        return new(lower, upper)
    end
end

"""
    UniDistributionSet{T <: Distributions.UnivariateDistribution} <: InfiniteScalarSet

A `DataType` that stores the distribution characterizing an infinite parameter that
is random. This is for use with a [`IndependentParameter`](@ref).

**Fields**
- `distribution::T` Distribution of the random parameter.
"""
struct UniDistributionSet{T <: Distributions.UnivariateDistribution} <: InfiniteScalarSet
    distribution::T
end

"""
    InfiniteArraySet <: AbstractInfiniteSet

An abstract type for multi-dimensional infinite sets.
"""
abstract type InfiniteArraySet <: AbstractInfiniteSet end

# Make convenient Union for below
const NonUnivariateDistribution = Union{Distributions.MultivariateDistribution,
                                        Distributions.MatrixDistribution}

"""
    MultiDistributionSet{T <: NonUnivariateDistribution} <: InfiniteArraySet

A `DataType` that stores the distribution characterizing a collection of
infinite parameters that follows its form. This is for use with
[`DependentParameters`](@ref).

**Fields**
- `distribution::T` Distribution of the random parameters.
"""
struct MultiDistributionSet{T <: NonUnivariateDistribution} <: InfiniteArraySet
    distribution::T
end

"""
    CollectionSet{T <: InfiniteScalarSet} <: InfiniteArraySet

A `DataType` that stores a collection of `InfiniteScalarSet`s characterizing a
collection of infinite parameters that follows its form. This is for use with
[`DependentParameters`](@ref).

**Fields**
- `sets::Array{T}` The collection of scalar sets.
"""
struct CollectionSet{T <: InfiniteScalarSet} <: InfiniteArraySet
    sets::Vector{T}
end

################################################################################
#                              PARAMETER TYPES
################################################################################
"""
    InfOptParameter <: JuMP.AbstractVariable

An abstract type for all parameters used in InfiniteOpt.
"""
abstract type InfOptParameter <: JuMP.AbstractVariable end

"""
    ScalarParameter <: InfOptParameter

An abstract type for scalar parameters used in InfiniteOpt.
"""
abstract type ScalarParameter <: InfOptParameter end

"""
    IndependentParameter{T <: InfiniteScalarSet} <: ScalarParameter

A `DataType` for storing independent scalar infinite parameters.

**Fields**
- `set::T`: The infinite set that characterizes the parameter.
- `supports::DataStructures.SortedDict{Float64, Set{Symbol}}`: The support points
   used to discretize the parameter and their associated type labels stored as
   `Symbol`s.
"""
struct IndependentParameter{T <: InfiniteScalarSet} <: ScalarParameter
    set::T
    supports::DataStructures.SortedDict{Float64, Set{Symbol}} # Support to label set
end

"""
    FiniteParameter <: ScalarParameter

A `DataType` for storing finite parameters meant to be nested in expressions
and replaced with their values at runtime.

**Fields**
- `value::Float64`: The parameter value.
"""
struct FiniteParameter <: ScalarParameter
    value::Float64
end

"""
    DependentParameters{T <: InfiniteArraySet} <: InfOptParameter

A `DataType` for storing a collection of dependent infinite parameters.

**Fields**
- `set::T`: The infinite set that characterizes the parameters.
- `supports::Array{Float64, 2}`: The support points used to discretize
  the parameters stored column-wise.
- `labels::Vector{Set{Symbol}}`: The support label sets.
"""
struct DependentParameters{T <: InfiniteArraySet} <: InfOptParameter
    set::T
    supports::Array{Float64, 2} # rows are vectorized params, columns are supports
    labels::Vector{Set{Symbol}} # support (column) index to label set
end

"""
    AbstractDataObject

An abstract type for `DataType`s that store core variable `DataType`s and their
model specific information (e.g., dependency mappings). These are what are
stored in the `InfiniteModel` `CleverDict`s.
"""
abstract type AbstractDataObject end

"""
    ScalarParameterData{P <: ScalarParameter} <: AbstractDataObject

A mutable `DataType` for storing `ScalarParameter`s and their data.

**Fields**
- `parameter::P`: The scalar parameter.
- `name::String`: The name used for printing.
- `infinite_var_indices::Vector{InfiniteVariableIndex}`: Indices of dependent
   infinite variables.
- `measure_indices::Vector{MeasureIndex}`: Indices of dependent measures.
- `constraint_indices::Vector{ConstraintIndex}`: Indices of dependent constraints.
"""
mutable struct ScalarParameterData{P <: ScalarParameter} <: AbstractDataObject
    parameter::P
    name::String
    infinite_var_indices::Vector{InfiniteVariableIndex}
    measure_indices::Vector{MeasureIndex}
    constraint_indices::Vector{ConstraintIndex}
    function ScalarParameterData(param::P,
                                 name::String = ""
                                 ) where {P <: ScalarParameter}
        return new{P}(param, name, InfiniteVariableIndex[], MeasureIndex[],
                   ConstraintIndex[])
    end
end

"""
    MultiParameterData{T <: InfiniteArraySet} <: AbstractDataObject

A mutable `DataType` for storing [`DependentParameters`](@ref) and their data.

**Fields**
- `parameters::DependentParametersP`: The parameter collection.
- `names::Vector{String}`: The names used for printing each parameter.
- `infinite_var_indices::Vector{Vector{InfiniteVariableIndex}}`: Indices of
   dependent infinite variables.
- `measure_indices::Vector{Vector{MeasureIndex}}`: Indices of dependent measures.
- `constraint_indices::Vector{Vector{ConstraintIndex}}`: Indices of dependent
  constraints.
"""
mutable struct MultiParameterData{T <: InfiniteArraySet} <: AbstractDataObject
    parameters::DependentParameters{T}
    names::Vector{String}
    infinite_var_indices::Vector{Vector{InfiniteVariableIndex}}
    measure_indices::Vector{Vector{MeasureIndex}}
    constraint_indices::Vector{Vector{ConstraintIndex}}
    function MultiParameterData(params::DependentParameters{T},
                                names::Vector{String}
                                ) where {T <: InfiniteArraySet}
        return new{T}(params, names,
                   [InfiniteVariableIndex[] for i in eachindex(names)],
                   [MeasureIndex[] for i in eachindex(names)],
                   [ConstraintIndex[] for i in eachindex(names)])
    end
end

################################################################################
#                             PARAMETER BOUNDS
################################################################################
"""
    ParameterBounds{P <: GeneralVariableRef}

A `DataType` for storing intervaled bounds of parameters. This is used to define
subdomains of [`HoldVariable`](@ref)s and [`BoundedScalarConstraint`](@ref)s.
Note that the GeneralVariableRef must pertain to infinite parameters.

**Fields**
- `intervals::Dict{GeneralVariableRef, IntervalSet}`: A dictionary
  of interval bounds on infinite parameters.
"""
struct ParameterBounds{P <: JuMP.AbstractVariableRef}
    intervals::Dict{P, IntervalSet}
end

################################################################################
#                               VARIABLE TYPES
################################################################################
"""
    InfOptVariable <: JuMP.AbstractVariable

An abstract type for infinite, reduced, point, and hold variables.
"""
abstract type InfOptVariable <: JuMP.AbstractVariable end

"""
    InfiniteVariable{S, T, U, V, P <: GeneralVariableRef} <: InfOptVariable

A `DataType` for storing core infinite variable information. Note that indices
that refer to the same dependent parameter group must be in the same tuple element.
Also, the variable reference type `P` must pertain to infinite parameters.

**Fields**
- `info::JuMP.VariableInfo{S, T, U, V}` JuMP variable information.
- `parameter_refs::VectorTuple{P}` The infinite parameter references that
                                    parameterize the variable.
"""
struct InfiniteVariable{S, T, U, V, P <: JuMP.AbstractVariableRef} <: InfOptVariable
    info::JuMP.VariableInfo{S, T, U, V}
    parameter_refs::VectorTuple{P}
end

"""
    ReducedInfiniteVariable{I <: GeneralVariableRef} <: InfOptVariable

A `DataType` for storing reduced infinite variables which partially support an
infinite variable.

**Fields**
- `infinite_variable_index::I` The original infinite variable.
- `eval_supports::Dict{Int, Float64}` The original parameter tuple linear indices
                                     to the evaluation supports.
"""
struct ReducedInfiniteVariable{I <: JuMP.AbstractVariableRef} <: InfOptVariable
    infinite_variable_ref::I
    eval_supports::Dict{Int, Float64}
end

"""
    PointVariable{S, T, U, V, I <: GeneralVariableRef} <: InfOptVariable

A `DataType` for storing point variable information. Note that the elements
`parameter_values` field must match the format of the parameter reference tuple
defined in [`InfiniteVariable`](@ref)

**Fields**
- `info::JuMP.VariableInfo{S, T, U, V}` JuMP Variable information.
- `infinite_variable_ref::I` The infinite variable reference
    associated with the point variable.
- `parameter_values::VectorTuple{Float64}` The infinite parameter values
    defining the point.
"""
struct PointVariable{S, T, U, V, I <: JuMP.AbstractVariableRef} <: InfOptVariable
    info::JuMP.VariableInfo{S, T, U, V}
    infinite_variable_ref::I
    parameter_values::VectorTuple{Float64} # TODO maybe replace with Vector
end

"""
    HoldVariable{S, T, U, V, P <: GeneralVariableRef} <: InfOptVariable

A `DataType` for storing hold variable information.

**Fields**
- `info::JuMP.VariableInfo{S, T, U, V}` JuMP variable information.
- `parameter_bounds::ParameterBounds{P}` Valid parameter sub-domains
"""
struct HoldVariable{S, T, U, V, P <: JuMP.AbstractVariableRef} <: InfOptVariable
    info::JuMP.VariableInfo{S, T, U, V}
    parameter_bounds::ParameterBounds{P}
end

"""
    VariableData{V <: InfOptVariable} <: AbstractDataObject

A mutable `DataType` for storing `InfOptVariable`s and their data.

**Fields**
- `variable::V`: The scalar variable.
- `name::String`: The name used for printing.
- `lower_bound_index::Union{ConstraintIndex, Nothing}`: Index of lower bound constraint.
- `upper_bound_index::Union{ConstraintIndex, Nothing}`: Index of upper bound constraint.
- `fix_index::Union{ConstraintIndex, Nothing}`: Index on fixing constraint.
- `zero_one_index::Union{ConstraintIndex, Nothing}`: Index of binary constraint.
- `integrality_index::Union{ConstraintIndex, Nothing}`: Index of integer constraint.
- `measure_indices::Vector{MeasureIndex}`: Indices of dependent measures.
- `constraint_indices::Vector{ConstraintIndex}`: Indices of dependent constraints.
- `in_objective::Bool`: Is this used in objective?
- `point_var_indices::Vector{PointVariableIndex}`: Indices of dependent point variables.
- `reduced_var_indices::Vector{ReducedInfiniteVariableIndex}`: Indices of dependent reduced variables.
"""
mutable struct VariableData{V <: InfOptVariable} <: AbstractDataObject
    variable::V
    name::String
    lower_bound_index::Union{ConstraintIndex, Nothing}
    upper_bound_index::Union{ConstraintIndex, Nothing}
    fix_index::Union{ConstraintIndex, Nothing}
    zero_one_index::Union{ConstraintIndex, Nothing}
    integrality_index::Union{ConstraintIndex, Nothing}
    measure_indices::Vector{MeasureIndex}
    constraint_indices::Vector{ConstraintIndex}
    in_objective::Bool
    point_var_indices::Vector{PointVariableIndex} # InfiniteVariables only
    reduced_var_indices::Vector{ReducedInfiniteVariableIndex} # InfiniteVariables only
    function VariableData(var::V, name::String = "") where {V <: InfOptVariable}
        return new{V}(var, name, nothing, nothing, nothing, nothing, nothing,
                   MeasureIndex[], ConstraintIndex[], false, PointVariableIndex[],
                   ReducedInfiniteVariableIndex[])
    end
end

################################################################################
#                              DERIVATIVE TYPES
################################################################################
# TODO implement derivatives

################################################################################
#                               MEASURE TYPES
################################################################################
"""
    AbstractMeasureData

An abstract type to define data for measures to define the behavior of
[`Measure`](@ref).
"""
abstract type AbstractMeasureData end

"""
    DiscreteMeasureData{P <: GeneralVariableRef} <: AbstractMeasureData

A DataType for one dimensional measure abstraction data where the measure
abstraction is of the form:
``measure = \\int_{\\tau \\in T} f(\\tau) w(\\tau) d\\tau \\approx \\sum_{i = 1}^N \\alpha_i f(\\tau_i) w(\\tau_i)``.

**Fields**
- `parameter_ref::P` The infinite parameter over which the integration occurs.
- `coefficients::Vector{Float64}` Coefficients ``\\alpha_i`` for the above
                                   measure abstraction.
- `label::Symbol` Label to access the support points ``\\tau_i`` for the above
                               measure abstraction.
- `name::String` Name of the measure that will be implemented.
- `weight_function::Function` Weighting function ``w`` must map support value
                              input value of type `Number` to a scalar value.
"""
struct DiscreteMeasureData{P <: JuMP.AbstractVariableRef} <: AbstractMeasureData
    parameter_ref::P
    coefficients::Vector{Float64}
    label::Symbol
    name::String
    weight_function::Function
end

"""
    MultiDiscreteMeasureData{P <: GeneralVariableRef} <: AbstractMeasureData

A DataType for multi-dimensional measure abstraction data where the measure
abstraction is of the form:
``measure = \\int_{\\tau \\in T} f(\\tau) w(\\tau) d\\tau \\approx \\sum_{i = 1}^N \\alpha_i f(\\tau_i) w(\\tau_i)``.

**Fields**
- `parameter_refs::Vector{P}` The infinite parameters over which the
                                 integration occurs.
- `coefficients::Vector{Float64}` Coefficients ``\\alpha_i`` for the above
                                   measure abstraction.
- `label::Symbol` The label associated with the supports ``\\tau_i`` for the
                                above measure abstraction.
- `name::String` Name of the measure that will be implemented.
- `weight_function::Function` Weighting function ``w`` must map a numerical
                              support of type `JuMP.Containers.SparseAxisArray`
                              to a scalar value.
"""
struct MultiDiscreteMeasureData{P <: JuMP.AbstractVariableRef} <: AbstractMeasureData
    parameter_refs::Vector{P}
    coefficients::Vector{Float64}
    label::Symbol
    name::String
    weight_function::Function
end

"""
    Measure{T <: JuMP.AbstractJuMPScalar, V <: AbstractMeasureData}

A `DataType` for measure abstractions.

**Fields**
- `func::T` Infinite variable expression.
- `data::V` Data of the abstraction as described in a `AbstractMeasureData`
            subtype.
"""
struct Measure{T <: JuMP.AbstractJuMPScalar, V <: AbstractMeasureData}
    func::T
    data::V
end

# TODO store the transcription parameter indices in an appropriate way
"""
    MeasureData{T <: JuMP.AbstractJuMPScalar,
                V <: AbstractMeasureData} <: AbstractDataObject

A mutable `DataType` for storing [`Measure`](@ref)s and their data.

**Fields**
- `variable::V`: The scalar variable.
- `name::String`: The name used for printing.
- `measure_indices::Vector{MeasureIndex}`: Indices of dependent measures.
- `constraint_indices::Vector{ConstraintIndex}`: Indices of dependent constraints.
- `in_objective::Bool`: Is this used in objective?
"""
mutable struct MeasureData{T <: JuMP.AbstractJuMPScalar,
                           V <: AbstractMeasureData} <: AbstractDataObject
    measure::Measure{T, V}
    name::String
    measure_indices::Vector{MeasureIndex}
    constraint_indices::Vector{ConstraintIndex}
    in_objective::Bool
    function MeasureData(measure::Measure{T, V},
                         name::String
                         ) where {T <: JuMP.AbstractJuMPScalar,
                                  V <: AbstractMeasureData}
        return new{T, V}(measure, name, MeasureIndex[], ConstraintIndex[], false)
    end
end

################################################################################
#                              CONSTRAINT TYPES
################################################################################
"""
    BoundedScalarConstraint{F <: JuMP.AbstractJuMPScalar,
                             S <: MOI.AbstractScalarSet,
                             P <: GeneralVariableRef
                             } <: JuMP.AbstractConstraint

A `DataType` that stores scalar constraints that are defined over a sub-domain
of infinite parameters.

**Fields**
- `func::F` The JuMP object.
- `set::S` The MOI set.
- `bounds::ParameterBounds{P}` Set of valid parameter
    sub-domains that further boundconstraint.
- `orig_bounds::ParameterBounds{P}` Set of the constraint's
    original parameter sub-domains (not considering hold variables)
"""
struct BoundedScalarConstraint{F <: JuMP.AbstractJuMPScalar,
                               S <: MOI.AbstractScalarSet,
                               P <: JuMP.AbstractVariableRef
                               } <: JuMP.AbstractConstraint
    func::F
    set::S
    bounds::ParameterBounds{P}
    orig_bounds::ParameterBounds{P}
end

# TODO store the transcription parameter indices in an appropriate way
"""
    ConstraintData{C <: JuMP.AbstractConstraint} <: AbstractDataObject

A mutable `DataType` for storing constraints and their data.

**Fields**
- `constraint::C`: The scalar constraint.
- `name::String`: The name used for printing.
- `measure_indices::Vector{MeasureIndex}`: Indices of dependent measures.
- `is_info_constraint::Bool`: Is this is constraint based on variable info (e.g., lower bound)
"""
mutable struct ConstraintData{C <: JuMP.AbstractConstraint} <: AbstractDataObject
    constraint::C
    name::String
    measure_indices::Vector{MeasureIndex}
    is_info_constraint::Bool
    function ConstraintData(constraint::C,
                            name::String
                            ) where {C <: JuMP.AbstractConstraint}
        return new{C}(constraint, name, MeasureIndex[], false)
    end
end

################################################################################
#                                INFINITE MODEL
################################################################################
"""
    InfiniteModel <: JuMP.AbstractModel

A `DataType` for storing all of the mathematical modeling information needed to
model an optmization problem with an infinite-dimensional decision space.

**Fields**
- `independent_params::MOIUC.CleverDict{IndependentParameterIndex, ScalarParameterData{IndependentParameter}}`:
   The independent parameters and their mapping information.
- `dependent_params::MOIUC.CleverDict{DependentParameterIndex, MultiParameterData}`:
   The dependent parameters and their mapping information.
- `finite_params::MOIUC.CleverDict{FiniteParameterIndex, ScalarParameterData{FiniteParameter}}`:
   The finite parameters and their mapping information.
- `name_to_param::Union{Dict{String, AbstractInfOptIndex}, Nothing}`:
   Field to help find a parameter given the name.
- `infinite_vars::MOIUC.CleverDict{InfiniteVariableIndex, VariableData{InfiniteVariable}}`:
   The infinite variables and their mapping information.
- `reduced_vars::MOIUC.CleverDict{ReducedInfiniteVariableIndex, VariableData{ReducedInfiniteVariable}}`:
   The reduced infinite variables and their mapping information.
- `point_vars::MOIUC.CleverDict{PointVariableIndex, VariableData{PointVariable}}`:
   The point variables and their mapping information.
- `hold_vars::MOIUC.CleverDict{HoldVariableIndex, VariableData{HoldVariable}}`:
   The hold variables and their mapping information.
- `name_to_var::Union{Dict{String, AbstractInfOptIndex}, Nothing}`:
   Field to help find a variable given the name.
- `has_hold_bounds::Bool`:
   Does any variable have parameter bounds?
- `measures::MOIUC.CleverDict{MeasureIndex, MeasureData}`:
   The measures and their mapping information.
- `integral_defaults::Dict{Symbol}`:
   The default keyword arguments for [`integral`](@ref).
- `constraints::MOIUC.CleverDict{ConstraintIndex, ConstraintData}`:
   The constraints and their mapping information.
- `name_to_constr::Union{Dict{String, AbstractInfOptIndex}, Nothing}`:
   Field to help find a constraint given the name.
- `objective_sense::MOI.OptimizationSense`: Objective sense.
- `objective_function::JuMP.AbstractJuMPScalar`: Finite scalar function.
- `obj_dict::Dict{Symbol, Any}`: Store Julia symbols used with `InfiniteModel`
- `optimizer_constructor`: MOI optimizer constructor (e.g., Gurobi.Optimizer).
- `optimizer_model::JuMP.Model`: Model used to solve `InfiniteModel`
- `ready_to_optimize::Bool`: Is the optimizer_model up to date.
- `ext::Dict{Symbol, Any}`: Store arbitrary extension information.
"""
mutable struct InfiniteModel <: JuMP.AbstractModel
    # Parameter Data
    independent_params::MOIUC.CleverDict{IndependentParameterIndex, ScalarParameterData{IndependentParameter}}
    dependent_params::MOIUC.CleverDict{DependentParameterIndex, MultiParameterData}
    finite_params::MOIUC.CleverDict{FiniteParameterIndex, ScalarParameterData{FiniteParameter}}
    name_to_param::Union{Dict{String, AbstractInfOptIndex}, Nothing}

    # Variable Data
    infinite_vars::MOIUC.CleverDict{InfiniteVariableIndex, VariableData{InfiniteVariable}}
    reduced_vars::MOIUC.CleverDict{ReducedInfiniteVariableIndex, VariableData{ReducedInfiniteVariable}}
    point_vars::MOIUC.CleverDict{PointVariableIndex, VariableData{PointVariable}}
    hold_vars::MOIUC.CleverDict{HoldVariableIndex, VariableData{HoldVariable}}
    name_to_var::Union{Dict{String, AbstractInfOptIndex}, Nothing}
    has_hold_bounds::Bool

    # Measure Data
    measures::MOIUC.CleverDict{MeasureIndex, MeasureData}
    integral_defaults::Dict{Symbol}

    # Constraint Data
    constraints::MOIUC.CleverDict{ConstraintIndex, ConstraintData}
    name_to_constr::Union{Dict{String, AbstractInfOptIndex}, Nothing}

    # Objective Data
    objective_sense::MOI.OptimizationSense
    objective_function::JuMP.AbstractJuMPScalar

    # Objects
    obj_dict::Dict{Symbol, Any}

    # Optimize Data
    optimizer_constructor::Any
    optimizer_model::JuMP.Model
    ready_to_optimize::Bool

    # Extensions
    ext::Dict{Symbol, Any}
end

const sampling = :sampling # TODO REMOVE THIS WHEN MEASURES.JL IS IMPLEMENTED AGAIN
default_weight(t) = 1 # TODO REMOVE THIS WHEN MEASURES.JL IS IMPLEMENTED AGAIN
"""
    InfiniteModel([optimizer_constructor; seed::Bool = false,
                  OptimizerModel::Function = TranscriptionModel,
                  caching_mode::MOIU.CachingOptimizerMode = MOIU.AUTOMATIC,
                  bridge_constraints::Bool = true, optimizer_model_kwargs...])

Return a new infinite model where an optimizer is specified if an
`optimizer_constructor` is given. The `seed` argument indicates if the stochastic
sampling used in conjunction with the model should be seeded. The optimizer
can also later be set with the [`JuMP.set_optimizer`](@ref) call. By default
the `optimizer_model` data field is initialized with a
[`TranscriptionModel`](@ref), but a different type of model can be assigned via
[`set_optimizer_model`](@ref) as can be required by extensions.

**Example**
```jldoctest
julia> using InfiniteOpt, JuMP, Ipopt;

julia> model = InfiniteModel()
An InfiniteOpt Model
Feasibility problem with:
Variables: 0
Optimizer model backend information:
Model mode: AUTOMATIC
CachingOptimizer state: NO_OPTIMIZER
Solver name: No optimizer attached.

julia> model = InfiniteModel(Ipopt.Optimizer)
An InfiniteOpt Model
Feasibility problem with:
Variables: 0
Optimizer model backend information:
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: Ipopt
```
"""
function InfiniteModel(; seed::Bool = false,
                       OptimizerModel::Function = TranscriptionModel,
                       kwargs...)::InfiniteModel
    if seed
        Random.seed!(0)
    end
    return InfiniteModel(# Parameters
                         MOIUC.CleverDict{IndependentParameterIndex, ScalarParameterData{IndependentParameter}}(),
                         MOIUC.CleverDict{DependentParameterIndex, MultiParameterData}(),
                         MOIUC.CleverDict{FiniteParameterIndex, ScalarParameterData{FiniteParameter}}(),
                         nothing,
                         # Variables
                         MOIUC.CleverDict{InfiniteVariableIndex, VariableData{InfiniteVariable}}(),
                         MOIUC.CleverDict{ReducedInfiniteVariableIndex, VariableData{ReducedInfiniteVariable}}(),
                         MOIUC.CleverDict{PointVariableIndex, VariableData{PointVariable}}(),
                         MOIUC.CleverDict{HoldVariableIndex, VariableData{HoldVariable}}(),
                         nothing, false,
                         # Measures
                         MOIUC.CleverDict{MeasureIndex, MeasureData}(),
                         Dict(:eval_method => sampling,
                              :num_supports => 10,
                              :weight_func => default_weight,
                              :name => "integral",
                              :use_existing_supports => false),
                         # Constraints
                         MOIUC.CleverDict{ConstraintIndex, ConstraintData}(),
                         nothing,
                         # Objective
                         MOI.FEASIBILITY_SENSE,
                         zero(JuMP.GenericAffExpr{Float64, GeneralVariableRef}),
                         # Object dictionary
                         Dict{Symbol, Any}(),
                         # Optimize data
                         nothing, OptimizerModel(;kwargs...), false,
                         # Extensions
                         Dict{Symbol, Any}()
                         )
end

## Set the optimizer_constructor depending on what it is
# MOI.OptimizerWithAttributes
function _set_optimizer_constructor(model::InfiniteModel,
                                    constructor::MOI.OptimizerWithAttributes)::Nothing
    model.optimizer_constructor = constructor.optimizer_constructor
    return
end

# No attributes
function _set_optimizer_constructor(model::InfiniteModel, constructor)::Nothing
    model.optimizer_constructor = constructor
    return
end

# Dispatch for InfiniteModel call with optimizer constructor
function InfiniteModel(optimizer_constructor;
                       seed::Bool = false,
                       OptimizerModel::Function = TranscriptionModel,
                       kwargs...)::InfiniteModel
    model = InfiniteModel(seed = seed)
    model.optimizer_model = OptimizerModel(optimizer_constructor; kwargs...)
    _set_optimizer_constructor(model, optimizer_constructor)
    return model
end

# Define basic InfiniteModel extensions
Base.broadcastable(model::InfiniteModel) = Ref(model)
JuMP.object_dictionary(model::InfiniteModel)::Dict{Symbol, Any} = model.obj_dict

################################################################################
#                             OBJECT REFERENCES
################################################################################
"""
    GeneralVariableRef <: JuMP.AbstractVariableRef

A `DataType` that serves as the principal variable reference in `InfiniteOpt`
for building variable expressions. It contains the needed information to
create a variable type specifc reference (e.g., [`InfiniteVariableRef`](@ref))
via [`dispatch_variable_ref`](@ref) to obtain the correct subtype of
[`DispatchVariableRef`](@ref) based off of `index_type`. This allows us to
construct expressions using concrete containers unlike previous versions of
`InfiniteOpt` which provides us a significant performance boost.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `raw_index::Int`: The raw index to be used in the `index_type` constructor.
- `index_type::DataType`: The concrete [`AbstractInfOptIndex`](@ref) type/constructor.
- `param_index::Int`: The index of a parameter in [`DependentParameters`](@ref).
  This is ignored for other variable types.
"""
struct GeneralVariableRef <: JuMP.AbstractVariableRef
    model::InfiniteModel
    raw_index::Int
    index_type::DataType
    param_index::Int # for DependentParameterRefs
    function GeneralVariableRef(model::InfiniteModel, raw_index::Int,
                               index_type::DataType, param_index::Int = -1)
       return new(model, raw_index, index_type, param_index)
    end
end

"""
    DispatchVariableRef <: JuMP.AbstractVariableRef

An abstract type for variable references that are created from
[`GeneralVariableRef`](@ref)s and are used to dispatch to the appropriate
methods for that particular variable/parameter/measure type.
"""
abstract type DispatchVariableRef <: JuMP.AbstractVariableRef end

"""
    IndependentParameterRef <: DispatchVariableRef

A `DataType` for independent infinite parameters references that parameterize
infinite variables.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::IndependentParameterIndex`: Index of the parameter in model.
"""
struct IndependentParameterRef <: DispatchVariableRef
    model::InfiniteModel
    index::IndependentParameterIndex
end

"""
    DependentParameterRef <: DispatchVariableRef

A `DataType` for dependent infinite parameter references that parameterize
infinite variables.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::DependentParameterIndex`: Index of the dependent parameter.
"""
struct DependentParameterRef <: DispatchVariableRef
    model::InfiniteModel
    index::DependentParameterIndex
end

"""
    InfiniteVariableRef <: DispatchVariableRef

A `DataType` for untranscripted infinite dimensional variable references (e.g.,
second stage variables, time dependent variables).

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::InfiniteVariableIndex`: Index of the variable in model.
"""
struct InfiniteVariableRef <: DispatchVariableRef
    model::InfiniteModel
    index::InfiniteVariableIndex
end

"""
    ReducedInfiniteVariableRef <: DispatchVariableRef

A `DataTyp`e for partially transcripted infinite dimensional variable references.
This is used to expand measures that contain infinite variables that are not
fully transcripted by the measure.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::ReducedInfiniteVariableIndex`: Index of the variable in model.
"""
struct ReducedInfiniteVariableRef <: DispatchVariableRef
    model::InfiniteModel
    index::ReducedInfiniteVariableIndex
end

"""
    MeasureFiniteVariableRef <: DispatchVariableRef

An abstract type to define finite variable and measure references.
"""
abstract type MeasureFiniteVariableRef <: DispatchVariableRef end

"""
    MeasureRef <: FiniteVariableRef

A `DataType` for referring to measure abstractions.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::MeasureIndex`: Index of the measure in model.
"""
struct MeasureRef <: MeasureFiniteVariableRef
    model::InfiniteModel
    index::MeasureIndex
end

"""
    FiniteVariableRef <: MeasureFiniteVariableRef

An abstract type to define new finite variable references.
"""
abstract type FiniteVariableRef <: MeasureFiniteVariableRef end

"""
    PointVariableRef <: FiniteVariableRef

A `DataType` for variables defined at a transcipted point (e.g., second stage
variable at a particular scenario, dynamic variable at a discretized time point).

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::PointVariableIndex`: Index of the variable in model.
"""
struct PointVariableRef <: FiniteVariableRef
    model::InfiniteModel
    index::PointVariableIndex
end

"""
    HoldVariableRef <: FiniteVariableRef

A `DataType` for finite fixed variable references (e.g., first stage variables,
steady-state variables).

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::HoldVariableIndex`: Index of the variable in model.
"""
struct HoldVariableRef <: FiniteVariableRef
    model::InfiniteModel
    index::HoldVariableIndex
end

"""
    FiniteParameterRef <: FiniteVariableRef

A `DataType` for finite parameters references who are replaced with their values
at the transcription step.

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::FiniteParameterIndex`: Index of the parameter in model.
"""
struct FiniteParameterRef <: FiniteVariableRef
    model::InfiniteModel
    index::FiniteParameterIndex
end

"""
    InfOptConstraintRef

An abstract type for constraint references in `InfiniteOpt`.
"""
abstract type InfOptConstraintRef end

"""
    InfiniteConstraintRef{S <: JuMP.AbstractShape} <: InfOptConstraintRef

A `DataType` for infinite constraints that are in `InfiniteModel`s

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::ConstraintIndex`: Index of the constraint in model.
- `shape::JuMP.AbstractShape`: Shape of the constraint
"""
struct InfiniteConstraintRef{S <: JuMP.AbstractShape} <: InfOptConstraintRef
    model::InfiniteModel
    index::ConstraintIndex
    shape::S
end

"""
    FiniteConstraintRef{S <: JuMP.AbstractShape} <: InfOptConstraintRef

A `DataType` for finite constraints that are in `InfiniteModel`s

**Fields**
- `model::InfiniteModel`: Infinite model.
- `index::ConstraintIndex`: Index of the constraint in model.
- `shape::JuMP.AbstractShape`: Shape of the constraint
"""
struct FiniteConstraintRef{S <: JuMP.AbstractShape} <: InfOptConstraintRef
    model::InfiniteModel
    index::ConstraintIndex
    shape::S
end

################################################################################
#                        PARAMETER BOUND METHODS
################################################################################
## Modify parameter dictionary to expand any multidimensional parameter keys
# Case where dictionary is already in correct form
function _expand_parameter_dict(
    param_bounds::Dict{GeneralVariableRef, IntervalSet}
    )::Dict{GeneralVariableRef, IntervalSet}
    return param_bounds
end

# Case where dictionary contains vectors
function _expand_parameter_dict(
    param_bounds::Dict{<:Any, IntervalSet}
    )::Dict{GeneralVariableRef, IntervalSet}
    # Initialize new dictionary
    new_dict = Dict{GeneralVariableRef, IntervalSet}()
    # Find vector keys and expand
    for (key, set) in param_bounds
        # expand over the array of parameters if this is
        if isa(key, AbstractArray)
            for param in key
                new_dict[param] = set
            end
        # otherwise we have parameter reference
        else
            new_dict[key] = set
        end
    end
    return new_dict
end

# Case where dictionary contains vectors
function _expand_parameter_dict(param_bounds::Dict)
    error("Invalid parameter bound dictionary format.")
end

# Constructor for expanding array parameters
function ParameterBounds(intervals::Dict)::ParameterBounds{GeneralVariableRef}
    return ParameterBounds(_expand_parameter_dict(intervals))
end

# Default method
function ParameterBounds()::ParameterBounds{GeneralVariableRef}
    return ParameterBounds(Dict{GeneralVariableRef, IntervalSet}())
end

# TODO Extend Base methods
