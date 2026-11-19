//=============================================================================
// SASWeaponLaserSight.uc
//
// Base class for laser sight attachment modules for weapons.
//=============================================================================

class SASWeaponLaserSight extends SASWeaponModule
	abstract
	native;


var Texture				mLaserProjectorTex;
var vector				mLaserStartRelativeLocation;
var float				mLaserRange;

var DynamicProjector	mLaserProjector;
var bool				mbProjectorEnabled;


function InitFor(
	Inventory	aInv)
{
	Super.InitFor(aInv);

	bHardAttach = false;
	SetBase(None);

	InitLaserProjector();
	DisableProjector();
}


function InitLaserProjector()
{
	mLaserProjector = Spawn(class'DynamicProjector');

	mLaserProjector.FOV = 0;
	mLaserProjector.SetDrawScale(0.13);
	mLaserProjector.MaxTraceDistance	= 16.0;
	mLaserProjector.bAlwaysRelevant		= true;
	mLaserProjector.bClipBSP			= false;
	mLaserProjector.bClipStaticMesh		= false;
	mLaserProjector.ProjTexture			= mLaserProjectorTex;

	mLaserProjector.bProjectBSP			= false;
	mLaserProjector.bProjectTerrain		= true;
	mLaserProjector.bProjectStaticMesh	= true;
	mLaserProjector.bProjectParticles	= false;
	mLaserProjector.bProjectActor		= true;

	mLaserProjector.LifeSpan			= 0.0;
	mLaserProjector.bGameRelevant		= true;
}


///////////////////////////////////////////////////////////////////////////////
// Activate
//
simulated event Activate()
{
	Super.Activate();
	EnableProjector();
}

simulated event DeActivate()
{
	Super.DeActivate();
	DisableProjector();
}

event EnableProjector ()
{
	mLaserProjector.Enable('Tick');
	mbProjectorEnabled = true;
}

event DisableProjector ()
{
	mLaserProjector.Disable('Tick');
	mLaserProjector.DetachProjector();
	mbProjectorEnabled = false;
}



// Decompiled with UE Explorer.
defaultproperties
{
    mLaserProjectorTex=Texture'SFXTx.Bullet_Hole.FxBH_bullet01'
    mLaserRange=2048.0000000
}