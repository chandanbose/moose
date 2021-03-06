[Mesh]
  [file]
    type = FileMeshGenerator
    file = twoblocks.e
  []

  [block_1]
    type = SideSetsAroundSubdomainGenerator
    input = file
    block = 'left'
    new_boundary = 'hull_1'
  []

  [block_2]
    type = SideSetsAroundSubdomainGenerator
    input = block_1
    block = 'right'
    new_boundary = 'hull_2'
  []
[]

# This input file is intended to be run with the "--mesh-only" option so
# no other sections are required
