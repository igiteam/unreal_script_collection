//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_PistolDE extends HDWeap_Pistol;
// Recoil
var transient	bool	bRecoilFlag;
var transient   vector  RecoilValue;

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

    bRecoilFlag = true;
	// delay calculate recoil
	tmp = (ZoomState == ZST_Zoomed)? RecoilZoomMax : RecoilMax;
	RecoilValue = punch_angle + RecoilPerShoot;
	RecoilValue.X = FClamp( RecoilValue.X, 0, tmp.X );
   	RecoilValue.Y = FClamp( RecoilValue.Y, 0, tmp.Y );
    if ( direction == 0 )
		RecoilValue.y = - RecoilValue.y;
	if (Rand(7) == 0)
		direction = 1 - direction;
}

simulated function RecoverRecoilFuncTwo( float DeltaTime )
{
	if ( bRecoilFlag )
	{
		punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, RecoilValue.X, DeltaTime,  RecoilTime );
		punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, RecoilValue.Y, DeltaTime,  RecoilTime );
        if ( Abs(VSize(punch_angle) - VSize(RecoilValue)) < 0.0001f )
			bRecoilFlag = false;
	}
	else if ( !bRecoilFlag )
	{
		if ( VSize(punch_angle) > 0.0001f && GetStateName() != 'WeaponFiring' )
		{
		    punch_angle.X = FWeaponInterpConstantTo( punch_angle.X, 0, DeltaTime,  RecoilRecoverTime );
		    punch_angle.Y = FWeaponInterpConstantTo( punch_angle.Y, 0, DeltaTime,  RecoilRecoverTime );
		}
	}
}


