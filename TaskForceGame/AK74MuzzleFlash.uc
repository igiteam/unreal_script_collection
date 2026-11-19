class AK74MuzzleFlash extends MuzzleFlashAttachment;

function PreBeginPlay()
{
	SetStaticMesh(StaticMesh(DynamicLoadObject("CBS_DYN_Weapon.MuzzleFlash.generic_3rd_mflash", class'StaticMesh')));
}

function PostBeginPlay()
{
	Super.PostBeginPlay(); 
}


// Decompiled with UE Explorer.
defaultproperties
{
    FlashLightType=1
    LightBrightness=70.0000000
    LightRadius=7.0000000
    LightHue=28
    LightSaturation=65
    DrawType=8
    DrawScale=0.5000000
    Skins[0]=none
}