module common_types

  implicit none
  
  type :: kxkyz_layout_type
     sequence
     integer :: iproc
     integer :: nzgrid, nzed, ntubes, naky, nakx, nvgrid, nvpa, nmu, nspec
     integer :: llim_world, ulim_world, llim_proc, ulim_proc, ulim_alloc, blocksize
  end type kxkyz_layout_type
  
  type :: kxyz_layout_type
     sequence
     integer :: iproc
     integer :: nzgrid, nzed, ntubes, ny, naky, nakx, nvgrid, nvpa, nmu, nspec
     integer :: llim_world, ulim_world, llim_proc, ulim_proc, ulim_alloc, blocksize
  end type kxyz_layout_type

  type :: xyz_layout_type
     sequence
     integer :: iproc
     integer :: nzgrid, nzed, ntubes, ny, naky, nx, nakx, nvgrid, nvpa, nmu, nspec
     integer :: llim_world, ulim_world, llim_proc, ulim_proc, ulim_alloc, blocksize
  end type xyz_layout_type
  
  type :: vmu_layout_type
     sequence
     logical :: xyz
     integer :: iproc
     integer :: nzgrid, nzed, ntubes, nalpha, ny, naky, nx, nakx, nvgrid, nvpa, nmu, nspec
     integer :: llim_world, ulim_world, llim_proc, ulim_proc, ulim_alloc, blocksize
  end type vmu_layout_type

  type :: flux_surface_type
     real :: rmaj
     real :: rgeo
     real :: kappa
     real :: kapprim
     real :: tri
     real :: triprim
     real :: rhoc
     real :: dr
     real :: shift
     real :: qinp
     real :: shat
     real :: betaprim
     real :: betadbprim
     real :: d2qdr2
     real :: d2psidr2
     real :: dpsitordrho
     real :: d2psitordrho2
     real :: rhotor
     real :: drhotordrho
     real :: psitor_lcfs
     real :: zed0_fac
  end type flux_surface_type
  
  type spec_type
     integer :: nspec
     real :: z
     real :: mass
     real :: dens, temp
     real :: tprim, fprim
     real :: vnew_ref
     real :: stm, zstm, tz, smz, zt
     real :: d2ndr2, d2Tdr2
     ! pre-2003 Fortran does not support
     ! allocatable arrays within derived types
     ! so set size large enough that it should be a problem
     ! should be nspec large
     real, dimension (10) :: vnew
     integer :: type
  end type spec_type

  type :: eigen_type
     complex, dimension (:,:), pointer :: zloc => null()
     integer, dimension (:), pointer :: idx => null()
  end type eigen_type

  type :: response_matrix_type
     type (eigen_type), dimension (:), pointer :: eigen => null()
  end type response_matrix_type

  type coupled_alpha_type
     integer :: max_idx
     complex, dimension (:), pointer :: fourier => null()
  end type coupled_alpha_type

end module common_types
