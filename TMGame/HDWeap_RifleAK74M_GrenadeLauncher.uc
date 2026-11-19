//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_RifleAK74M_GrenadeLauncher extends HDWeap_RifleAK74M;

var Texture2D CrosshairImage2nd;
var() float   HUDScale;

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
    if ( CurrentFireModeType == ECFMT_PRIMARY )
    {
        return Super.GetAdjustedAim(StartFireLoc);
    }
    else
    {
        return Super(TMWeapon).GetAdjustedAim(StartFireLoc);
    }
}


simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
    local HDWeaponAttachment    HDWA;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();
    HDWA = HDWeaponAttachment(HDPawn(Instigator).CurrentWeaponAttachment);
    if ( HDWA != None )
        HDWA.PlayFPFireEffect(Self);

	if( Role == ROLE_Authority )
	{
        RealStartLoc = GetPhysicalFireStartLoc();
		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		if(DummyWeaponDamage > 0.0)
		{
		    SpawnedProjectile.Damage = DummyWeaponDamage;
        }

		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector(GetAdjustedAim( RealStartLoc )) );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}

simulated function DrawWeaponCrosshair( Hud H )
{
	local float x,y, ScreenX, ScreenY, ScaleValue;

    if ( CurrentFireModeType ==  ECFMT_PRIMARY )
    {
        Super.DrawWeaponCrosshair(H);
        return;
    }

    if ( !bShowHud )  return;

    ScaleValue = (H.Canvas.ClipX >= H.Canvas.ClipY)? H.Canvas.ClipY/1024.0 : H.Canvas.ClipX/1024.0;
    ScaleValue *= HUDScale;
	X = H.Canvas.ClipX * 0.5;
	Y = H.Canvas.ClipY * 0.5;
	ScreenX = X - (128 * 0.5 * ScaleValue);
	ScreenY = Y - (128 * 0.5 * ScaleValue);
	if ( CrosshairImage2nd != none )
	{
		CrosshairColor = Default.CrosshairColor;
		H.Canvas.DrawColor = CrosshairColor;
		H.Canvas.SetPos(ScreenX, ScreenY);
		H.Canvas.DrawTile(CrosshairImage2nd,128*ScaleValue, 128*ScaleValue, 0, 0, 128,128);
	}
}

