//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_RifleAK74M extends HDWeap_AssaultRifle;

// Recoil function
simulated function CalculateRecoil()
{
	CalculateRecoilFuncThree();
}

simulated function RecoverRecoil( float DeltaTime )
{
	RecoverRecoilFuncThree(DeltaTime);
}

