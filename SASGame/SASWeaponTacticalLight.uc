//=============================================================================
// SASWeaponTacticalLight.uc
//
// Abstract base class for tactical light attachment modules for weapons.
//=============================================================================

class SASWeaponTacticalLight extends SASWeaponModule;


var float				mBeamRange;
var float				mBeamFOV;
var float				mBeamDrawScale;
var Texture				mBeamProjectorTex;
var vector				mBeamRelativeLocation;

var DynamicProjector	mBeamProjector;
var float				mTacLightBrightness;


///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas, 
	out float	aYL, 
	out float	aYPos)
{
	aCanvas.DrawText("TAC LIGHT; Brightness="$LightBrightness);
	aYPos += aYL;
	aCanvas.SetPos(32,aYPos);
}

simulated function InitFor(
	Inventory	aInv)
{
	Super.InitFor(aInv);

	// Store light brightness
	mTacLightBrightness = LightBrightness;
	LightBrightness = 0;

	InitBeamProjector();

	// Turn projector off
	mBeamProjector.Disable('Tick');
	mBeamProjector.DetachProjector();
}

simulated function InitBeamProjector()
{
	mBeamProjector = Spawn(class'DynamicProjector');

	mBeamProjector.FOV = 0;
	mBeamProjector.SetDrawScale(mBeamDrawScale);
	mBeamProjector.MaxTraceDistance		= mBeamRange;
	mBeamProjector.bGradient			= true;
	mBeamProjector.bAlwaysRelevant		= true;
	mBeamProjector.bClipBSP				= false;
	mBeamProjector.bClipStaticMesh		= false;
	mBeamProjector.ProjTexture			= mBeamProjectorTex;

	mBeamProjector.bProjectBSP			= false;
	mBeamProjector.bProjectTerrain		= true;
	mBeamProjector.bProjectStaticMesh	= true;
	mBeamProjector.bProjectParticles	= false;
	mBeamProjector.bProjectActor		= true;

	mBeamProjector.LifeSpan				= 0.0;
	mBeamProjector.bGameRelevant		= true;

	mBeamProjector.bHardAttach = true;
	mBeamProjector.SetBase(self);
	mBeamProjector.SetRelativeLocation(mBeamRelativeLocation);
}

simulated event Activate()
{
	Super.Activate();

	// Turn on light
	LightBrightness = mTacLightBrightness;

	// Turn projector on
	mBeamProjector.Enable('Tick');
}

simulated event DeActivate()
{
	Super.DeActivate();

	// Turn off light
	LightBrightness = 0;

	// Turn projector off
	mBeamProjector.Disable('Tick');
	mBeamProjector.DetachProjector();
}




// Decompiled with UE Explorer.
defaultproperties
{
    mBeamRange=2048.0000000
    mBeamFOV=30.0000000
    mBeamDrawScale=0.1300000
    LightBrightness=255.0000000
    LightRadius=64.0000000
    LightType=1
    LightEffect=12
    LightSaturation=255
    LightCone=32
    bDynamicLight=true
}