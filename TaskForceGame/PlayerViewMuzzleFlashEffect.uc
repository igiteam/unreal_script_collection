//=============================================================================
// PlayerViewMuzzleFlash.
//=============================================================================
class PlayerViewMuzzleFlashEffect extends StaticMeshActor;

var(PlayerViewMuzzleFlash)	float 	vRelativeLocationOffset; 
var(PlayerViewMuzzleFlash)	name  	LocationBoneName;	// name of the bone used as the initial
								// location of the muzzle flash
var(PlayerViewMuzzleFlash) ELightType FlashLightType;
var(PlayerViewMuzzleFlash) ELightEffect FlashLightEffect;

var int TickCount;	// How long to display it


simulated function Flash()
{
	LightBrightness=default.LightBrightness;
	GotoState('Visible');
}

simulated function SubduedFlash()
{
    LightBrightness=default.LightBrightness*0.40;
	GotoState('Visible');
}

simulated state Visible
{
	simulated event Tick(float Delta)
	{
		if (TickCount>3)
			gotoState('');
			
		TickCount++;
	}
	
	simulated function EndState()
	{
		bHidden=true;
		bDynamicLight = false;

		LightEffect=LE_None;
		LightType=LT_None;
	}
	
	simulated function BeginState()
	{
		TickCount=0;

		bHidden=false;
		bDynamicLight = true;

		LightEffect=LE_NonIncidence;
		LightType=LT_Steady;
	}
		
}


// Decompiled with UE Explorer.
defaultproperties
{
    LightBrightness=60.0000000
    LightRadius=6.0000000
    LightHue=28
    LightSaturation=65
    StaticMesh=StaticMesh'CBS_DYN_Weapon.MuzzleFlash.generic_1st_mflash'
    bStatic=false
    bHidden=true
    bWorldGeometry=false
    DrawScale=0.4000000
    bShadowCast=false
    bStaticLighting=false
    bCollideActors=false
    bBlockActors=false
    bBlockPlayers=false
    bEdShouldSnap=false
}