//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_LMG extends HDConventionalWeapon
    abstract;

simulated event vector GetMuzzleLoc()
{
	local vector RealStarLoc;
	local TMSkeletalMeshComponent MeshComponent;

	MeshComponent = TMSkeletalMeshComponent(Mesh);
	if ( MeshComponent != none )
	{
		MeshComponent.GetSocketWorldLocationAndRotation( 'MuzzleFlashSocket', RealStarLoc,,0);
		return RealStarLoc;
	}
	return Super.GetMuzzleLoc();
}


// Recoil function
simulated function CalculateRecoil()
{
	CalculateRecoilFuncTwo();
}

simulated function RecoverRecoil( float DeltaTime )
{
	RecoverRecoilFuncTwo(DeltaTime);
}

simulated function CalculateRecoilFuncTwo()
{
	local vector tmp;

	tmp = (ZoomState == ZST_Zoomed)? RecoilZoomMax : RecoilMax;
	if ( direction == 0 )
		tmp.y = - tmp.y;

	punch_angle = VInterpTo( punch_angle, tmp, WorldInfo.DeltaSeconds, RecoilTime);
	if (Rand(RecoilRandSeed) == 0)
		direction = 1 - direction;
}


// Function 2: WK
simulated function RecoverRecoilFuncTwo( float DeltaTime )
{
	if ( VSize(punch_angle) > 0.0316f )
	{
        if ( GetStateName() != 'WeaponFiring' )
        {
		    punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, 0, DeltaTime,  RecoilRecoverTime );
		    punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, 0, DeltaTime,  RecoilRecoverTime );
        }
	}
}


// change zoom function
simulated function ChangeZoomFunction( bool bUp );


