# Test queries
@testset "Queries" begin
    # initialize the model, references, and other info
    m = InfiniteModel()
    @infinite_parameter(m, 0 <= par <= 1)
    @infinite_variable(m, inf(par))
    @point_variable(m, inf(0.5), pt)
    @global_variable(m, x)
    data = DiscreteMeasureData(par, [1], [1])
    meas = measure(inf + par - x, data)
    # test objective_sense
    @testset "JuMP.objective_sense" begin
        # test default
        @test objective_sense(m) == MOI.FEASIBILITY_SENSE
        # change sense
        m.objective_sense = MOI.MIN_SENSE
        # test new sense
        @test objective_sense(m) == MOI.MIN_SENSE
        # undo changes
        m.objective_sense = MOI.FEASIBILITY_SENSE
    end
    # test objective_function_type
    @testset "JuMP.objective_function_type" begin
        # test default
        @test objective_function_type(m) == GenericAffExpr{Float64,
                                                           FiniteVariableRef}
        # change function
        m.objective_function = x + meas + pt
        # test new function
        @test objective_function_type(m) == GenericAffExpr{Float64,
                                                       MeasureFiniteVariableRef}
        # undo changes
        m.objective_function = zero(GenericAffExpr{Float64, FiniteVariableRef})
    end
    # test objective_function
    @testset "JuMP.objective_function" begin
        # test default
        @test objective_function(m) == zero(GenericAffExpr{Float64,
                                                           FiniteVariableRef})
        # change function
        m.objective_function = x + meas + pt
        # test new function
        @test objective_function(m) == x + meas + pt
        # undo changes
        m.objective_function = zero(GenericAffExpr{Float64, FiniteVariableRef})
    end
    # test objective_function (internal)
    @testset "JuMP.objective_function (internal)" begin
        # test normal
        @test objective_function(m, GenericAffExpr{Float64,
                                    FiniteVariableRef}) == zero(GenericAffExpr{Float64,
                                                                FiniteVariableRef})
        # test new sense
        @test_throws InexactError objective_function(m, GlobalVariableRef)
    end
end

# Test definition methods
@testset "Definition" begin
    # initialize the model, references, and other info
    m = InfiniteModel()
    @infinite_parameter(m, 0 <= par <= 1)
    @infinite_variable(m, inf(par))
    @point_variable(m, inf(0.5), pt)
    @global_variable(m, x)
    data = DiscreteMeasureData(par, [1], [1])
    meas = measure(inf + par - x, data)
    # set_objective (expr)
    @testset "JuMP.set_objective (Expr)" begin
        # test first set
        @test isa(set_objective(m, MOI.MIN_SENSE, x + meas + pt), Nothing)
        @test objective_function(m) == x + meas + pt
        @test objective_sense(m) == MOI.MIN_SENSE
        @test used_by_objective(x)
        @test used_by_objective(pt)
        @test used_by_objective(meas)
        @test !optimizer_model_ready(m)
        # test reset
        @test isa(set_objective(m, MOI.MAX_SENSE, pt), Nothing)
        @test objective_function(m) == pt
        @test objective_sense(m) == MOI.MAX_SENSE
        @test !used_by_objective(x)
        @test used_by_objective(pt)
        @test !used_by_objective(meas)
        # test errors
        @test_throws ErrorException set_objective(m, MOI.MAX_SENSE, inf + pt)
        @test_throws ErrorException set_objective(m, MOI.MAX_SENSE, par + pt)
    end
    # set_objective (number)
    @testset "JuMP.set_objective (Number)" begin
        # test normal
        @test isa(set_objective(m, MOI.MIN_SENSE, 3), Nothing)
        @test objective_function(m) == GenericAffExpr{Float64,
                                                      GlobalVariableRef}(3)
        @test objective_sense(m) == MOI.MIN_SENSE
        @test !used_by_objective(x)
        @test !used_by_objective(pt)
        @test !used_by_objective(meas)
    end
    # set_objective_sense
    @testset "JuMP.set_objective_sense" begin
        # test normal
        @test isa(set_objective_sense(m, MOI.MAX_SENSE), Nothing)
        @test objective_function(m) == GenericAffExpr{Float64,
                                                      GlobalVariableRef}(3)
        @test objective_sense(m) == MOI.MAX_SENSE
    end
end
