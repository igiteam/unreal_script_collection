//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_Unarmed extends HDConventionalWeapon;

simulated function PostBeginPlay()
{
	Super.PostbeginPlay();
}



/**
 * This function is called from the pawn when the visibility of the weapon changes
 */
simulated function ChangeVisibility(bool bIsVisible)
{
	Super.ChangeVisibility(bIsVisible);
}

simulated function StartFire(byte FireModeNum);
simulated function StopFire(byte FireModeNum);
simulated function EndFire(byte FireModeNum);
simulated function ConsumeAmmo( byte FireModeNum );
simulated function DrawWeaponCrosshair( Hud HUD );
simulated function Reload();


