# include "define.inc"

module ran
  ! <doc>
  !  A wrapper module for random number generator.
  !  Thie module provides real function ranf
  !  using intrinsic random_number/random_seed or
  !  Mersenne Twister 19937 (see mt19937.f90).
  !  Note that instrinsic function appears to use
  !  and integer vector seed of length 2, but this
  !  is implementation dependent.  If there is ever
  !  a system that uses seed integer vector of 
  !  different length, an error message will print.
  ! </doc>

  implicit none

  private

  public :: ranf
  public :: get_rnd_seed_length,get_rnd_seed,init_ranf

contains

!-------------------------------------------------------------------
  function ranf (seed)
    
    ! <doc>
    !  returns a uniform deviate in [0., 1.)
    !  The generator is initialized with the given seed if exists,
    !  otherwise uses the default seed.
    ! </doc>
    
# if RANDOM == _RANMT_
    use mt19937, only: sgrnd, grnd
# endif
    integer, intent(in), optional :: seed
    real :: ranf
    integer :: l
    integer, allocatable :: seed_in(:)
# if RANDOM == _RANMT_    
    if (present(seed)) call sgrnd(seed)
    ranf = grnd()
# else
    if (present(seed)) then
       call random_seed(size=l)
       allocate(seed_in(l))
       seed_in(:)=seed
       call random_seed(put=seed_in)
    endif
    call random_number(ranf)
# endif

  end function ranf
!-------------------------------------------------------------------
  function get_rnd_seed_length () result (l)
    ! <doc>
    !  get_rnd_seed_length gets the length of the integer vector for
    !      the random number generator seed
    ! </doc>
    integer :: l
# if RANDOM == _RANMT_    
    l=1
# else
    call random_seed(size=l)
# endif
    
  end function get_rnd_seed_length
!-------------------------------------------------------------------
  subroutine get_rnd_seed(seed)
    ! <doc>
    !  get_rnd_seed  random number seed integer vector
    ! </doc>
    integer, dimension(:), intent(out) :: seed
# if RANDOM == _RANMT_    
    !NOTE: If MT is generator, more codding needs to be done to
    !      extract seed, so this should be run using only randomize
    seed=0
# else
    call random_seed(get=seed)
# endif
    
  end subroutine get_rnd_seed
!-------------------------------------------------------------------
  subroutine init_ranf(randomize,init_seed)
    ! <doc>
    !  init_ranf seeds the choosen random number generator.
    !  if randomize=T, a random seed based on the date and time is used.
    !  Otherwise, it sets the seed using init_seed 
    !  In either case, it outputs the initial seed in init_seed
    ! </doc>
    implicit none
    logical, intent(in) :: randomize
    integer, intent(inout), dimension(:) :: init_seed
# if RANDOM == _RANMT_
    real :: rnd
    
    if (randomize) then
       !Use intrinsic function with randomized seed to generate seed for MT
       call random_seed()
       call random_number(rnd)
       init_seed=int(rnd*2.**31)
       call sgrnd(init_seed)
    else
       call sgrnd(init_seed)
    endif
# else
    if (randomize) then
       call random_seed()
       call random_seed(get=init_seed)
    else
       call random_seed(put=init_seed)
    endif
# endif

  end subroutine init_ranf
end module ran
