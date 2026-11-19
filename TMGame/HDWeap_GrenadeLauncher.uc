//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_GrenadeLauncher extends HDSpecialWeapon
    abstract;

var Texture2D CrosshairImage2nd;
var() float   HUDScale;

simulated function Projectile ProjectileFire()
{
	local vector		RealStartLoc;
	local Projectile	SpawnedProjectile;
//	local TMSkeletalMeshComponent MeshComponent;

    local HDWeaponAttachment    HDWA;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();
    HDWA = HDWeaponAttachment(HDPawn(Instigator).CurrentWeaponAttachment);
    if ( HDWA != None )
        HDWA.PlayFPFireEffect(Self);

	if( Role == ROLE_Authority )
	{
//		// this is the location where the projectile is spawned.
//		MeshComponent = TMSkeletalMeshComponent(Mesh);
//		if ( (MeshComponent != none && !bDummyWeapon) && Instigator != None && Instigator.IsFirstPerson() )
//		{
//			MeshComponent.GetSocketWorldLocationAndRotation( 'MuzzleFlashSocket', RealStartLoc,,0);
//		}
//		else
//		{
//			RealStartLoc = GetPhysicalFireStartLoc();
//		}
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

    if ( !bShowHud )  return;

    ScaleValue = (H.Canvas.ClipX >= H.Canvas.ClipY)? H.Canvas.ClipY/1024.0 : H.Canvas.ClipX/1024.0;
    ScaleValue *= HUDScale;
	X = H.Canvas.ClipX * 0.5;
	Y = H.Canvas.ClipY * 0.5;
	ScreenX = X - (128 * 0.5 * ScaleValue);
	ScreenY = Y - (128 * 0.5 * ScaleValue);
	if ( CrosshairImage != none )
	{
		CrosshairColor = Default.CrosshairColor;
		H.Canvas.DrawColor = CrosshairColor;
		H.Canvas.SetPos(ScreenX, ScreenY);
		H.Canvas.DrawTile(CrosshairImage2nd,128*ScaleValue, 128*ScaleValue, 0, 0, 128,128);
	}
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	local HDDroppedPickup DP;
	local HDPickupObject OldDP;


	// By default, you can only carry a single item of a given class.
	if ( ItemClass == class )
	{
	    // if ammo max deny pick
        if ( ClipBulletCount[0] >= default.ClipBulletCount[0] )
        {
            return true;
        }
        DP = HDDroppedPickup(Pickup);
        OldDP = HDPickupObject(Pickup);
		if (DP != None)
		{
			if ( DP.Instigator == Instigator )
			{
				// weapon was dropped by this player - disallow pickup
				return true;
			}
			// take the ammo that the dropped weapon has
            AddBulletCount(HDWeapon(DP.Inventory).ClipBulletCount[0], 0);
			if ( OldDP != None && OldDP.bInfinit )
            {
                ;
                OldDP.PickedUpBy(Instigator);
            }
			else
			{
                DP.PickedUpBy(Instigator);
            }
			AnnouncePickup(Instigator);
		}
		return true;
	}

	return false;
}

// do not switch NV and gasmask
simulated  function bool ToggleNightVision(bool bIsNightVision);
simulated  function bool ToggleGasMask(bool bIsEquip );
simulated  function  ZoomFireMode();

