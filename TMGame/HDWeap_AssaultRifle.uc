//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_AssaultRifle extends HDConventionalWeapon
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

// Recoil function 2
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

// Recoil Function 3
simulated function CalculateRecoilFuncThree()
{
	local vector tmp, tmpmax;

	tmp = (ZoomState == ZST_Zoomed)? RecoilPerShoot*0.6 : RecoilPerShoot;
	tmpmax = (ZoomState == ZST_Zoomed)? RecoilZoomMax : RecoilMax;
	if ( direction == 0 )
		tmp.y = - tmp.y;

    if ( Rand(RecoilRandSeed) == 0 )
        tmp *= 5.3f;
	tmp = tmp + punch_angle;
	tmp.x = FClamp( tmp.x, 0, tmpmax.x );
    tmp.y = FClamp( tmp.y, -tmpmax.y, tmpmax.y );
    punch_angle = VInterpTo( punch_angle, tmp, WorldInfo.DeltaSeconds, RecoilTime);
	if (Rand(RecoilRandSeed) == 0)
		direction = 1 - direction;
}


// Function 2: WK
simulated function RecoverRecoilFuncThree( float DeltaTime )
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

simulated function PostEquipped();
/**
 * State WeaponEquipping
 * The Weapon is in this state while transitioning from Inactive to Active state.
 * Typically, the weapon will remain in this state while its selection animation is being played.
 * While in this state, the weapon cannot be fired.
 */
simulated state WeaponEquipping
{
	simulated function WeaponEquipped()
	{
       PostEquipped();
       Super.WeaponEquipped();
	}
}

// change zoom function
simulated function ChangeZoomFunction( bool bUp );

// switch common fire type: EFST_MORE <-> EFST_ONE
simulated function SwitchFireType()
{
    local EFireShotType NewMode;
    NewMode = (ReFireFlag[0]==EFST_ONE)? default.ReFireFlag[0] : EFST_ONE;
    // only for switch fire mode 0
    if( Role < Role_Authority )
	{
		// if we're a client, synchronize server
		ServerSetFireTypeFlag(NewMode);
	}
    // Start fire locally
	SetFireTypeFlag(NewMode);
}

reliable server function ServerSetFireTypeFlag( EFireShotType newMode )
{
    SetFireTypeFlag(newMode);
}

simulated function SetFireTypeFlag( EFireShotType newMode )
{
    ReFireFlag[0] = newMode;
    bMuzzleFlashPSCLoops = (newMode == EFST_ONE)? TRUE : FALSE;
    bClipBulletPSCLoops = bMuzzleFlashPSCLoops;
}

