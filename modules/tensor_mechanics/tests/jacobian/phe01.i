# Capped weak-plane plasticity, Kernel = PlasticHeatEnergy
[Mesh]
  type = GeneratedMesh
  dim = 3
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./silly_phe]
    type = PlasticHeatEnergy
    coeff = 0.5
    variable = disp_x
  [../]
  [./dummy_disp_y]
    type = TimeDerivative
    variable = disp_y
  [../]
  [./dummy_disp_z]
    type = TimeDerivative
    variable = disp_z
  [../]
[]

[UserObjects]
  [./coh]
    type = TensorMechanicsHardeningExponential
    value_0 = 1
    value_residual = 2
    rate = 1
  [../]
  [./tanphi]
    type = TensorMechanicsHardeningExponential
    value_0 = 1.0
    value_residual = 0.5
    rate = 2
  [../]
  [./tanpsi]
    type = TensorMechanicsHardeningExponential
    value_0 = 0.1
    value_residual = 0.05
    rate = 3
  [../]
  [./t_strength]
    type = TensorMechanicsHardeningExponential
    value_0 = 100
    value_residual = 100
    rate = 1
  [../]
  [./c_strength]
    type = TensorMechanicsHardeningCubic
    value_0 = 1
    value_residual = 0
    internal_0 = -2
    internal_limit = 0
  [../]
[]

[Materials]
  [./phe]
    type = ComputePlasticHeatEnergy
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    fill_method = symmetric_isotropic
    C_ijkl = '1 2'
  [../]
  [./strain]
    type = ComputeIncrementalSmallStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./admissible]
    type = ComputeMultipleInelasticStress
    inelastic_models = mc
    initial_stress = '0 0 0  0 0 1  0 1 -1.5'
    tangent_operator = nonlinear
  [../]
  [./mc]
    type = CappedWeakPlaneStressUpdate
    cohesion = coh
    tan_friction_angle = tanphi
    tan_dilation_angle = tanpsi
    tensile_strength = t_strength
    compressive_strength = c_strength
    max_NR_iterations = 20
    tip_smoother = 0
    smoothing_tol = 1
    yield_function_tol = 1E-10
    perfect_guess = false
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -snes_type'
    petsc_options_value = 'bcgs bjacobi 1E-15 1E-10 10000 test'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
[]
