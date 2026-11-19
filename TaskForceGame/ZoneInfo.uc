//=============================================================================
// ZoneInfo, the built-in Unreal class for defining properties
// of zones.  If you place one ZoneInfo actor in a
// zone you have partioned, the ZoneInfo defines the 
// properties of the zone.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class ZoneInfo extends Info
	native
	placeable;

#exec Texture Import File=Textures\ZoneInfo.dds Name=S_ZoneInfo Mips=Off MASKED=1

//-----------------------------------------------------------------------------
// Zone properties.

var skyzoneinfo SkyZone; // Optional sky zone containing this zone's sky.
var() name ZoneTag;
var() localized String LocationName; 

var() float KillZ;		// any actor falling below this level gets destroyed
var() eKillZType KillZType;	// passed by FellOutOfWorldEvent(), to allow different KillZ effects
var() bool bSoftKillZ;	// 2000 units of grace unless land

//-----------------------------------------------------------------------------
// Zone flags.

var() const bool   bFogZone;			// Zone is fog-filled.
var()		bool   bTerrainZone;		// There is terrain in this zone.
var()		bool   bDistanceFog;		// There is distance fog in this zone.
var()		bool   bClearToFogColor;	// Clear to fog color if distance fog is enabled.

var const array<TerrainInfo> Terrains;

//-----------------------------------------------------------------------------
// Zone light.
var            vector AmbientVector;
var(ZoneLight) byte AmbientBrightness, AmbientHue, AmbientSaturation;

var(ZoneLight) color DistanceFogColor;
var(ZoneLight) float DistanceFogStart;
var(ZoneLight) float DistanceFogEnd;
var(ZoneLight) float DistanceFogBlendTime;

var(ZoneLight) const texture EnvironmentMap;
var(ZoneLight) float TexUPanSpeed, TexVPanSpeed;
var(ZoneLight) float SkeletalDiffuse;
var(ZoneLight) float SkeletalBrightness;

var(ZoneSound) editinline I3DL2Listener ZoneEffect;
var(ZoneSound) Sound StereoAmbience;				//a stereo or 5.1 ambient loop
var(ZoneSound) ESoundZone SoundZone;				//describes the type on zone we are in.

//------------------------------------------------------------------------------

var(ZoneVisibility) bool bLonelyZone;								// This zone is the only one to see or never seen
var(ZoneVisibility) editinline array<ZoneInfo> ManualExcludes;		// No Idea.. just sounded cool

// <kris>
var(DynamicGamma) float Bias;
var(DynamicGamma) float DarkClamp;
var(DynamicGamma) float LightClamp;
var(DynamicGamma) float LightDT;
var(DynamicGamma) float DarkDT;
var(DynamicGamma) float ContrastDT;
var(DynamicGamma) float LightThreshold;
var(DynamicGamma) float DarkThreshold;
var bool NoLoadScreen; // see below
var bool DoneLoading;  // should really go in LevelInfo but messing with that is scary
// </kris>

//=============================================================================
// Iterator functions.

// Iterate through all actors in this zone.
native(308) final iterator function ZoneActors( class<actor> BaseClass, out actor Actor );

simulated function LinkToSkybox()
{
	local skyzoneinfo TempSkyZone;

	// SkyZone.
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
		SkyZone = TempSkyZone;
	if(Level.DetailMode == DM_Low)
	{
		foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
			if( !TempSkyZone.bHighDetail && !TempSkyZone.bSuperHighDetail )
				SkyZone = TempSkyZone;
	}
	else if(Level.DetailMode == DM_High)
	{
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
			if( !TempSkyZone.bSuperHighDetail )
				SkyZone = TempSkyZone;
	}
	else if(Level.DetailMode == DM_SuperHigh)
	{
		foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
			SkyZone = TempSkyZone;
	}
}

//=============================================================================
// Engine notification functions.

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	// call overridable function to link this ZoneInfo actor to a skybox
	LinkToSkybox();
}

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	Other.OnActorEnteredZone();
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	Other.OnActorLeavingZone();
}

// Set sound properties.
function SetProps( I3DL2Listener Effect, Sound Ambience, ESoundZone Zone )
{
  if( Effect != None )
    ZoneEffect = Effect;
  
  if( Ambience != None )
  {
    StereoAmbience = Ambience;
    PlaySound(StereoAmbience,SLOT_AmbientStereo);
   }
    
  SoundZone = Zone;
}


// Decompiled with UE Explorer.
defaultproperties
{
    KillZ=-10000.0000000
    AmbientSaturation=255
    DistanceFogColor=(R=128,G=128,B=128,A=0)
    DistanceFogStart=3000.0000000
    DistanceFogEnd=8000.0000000
    DistanceFogBlendTime=1.0000000
    TexUPanSpeed=1.0000000
    TexVPanSpeed=1.0000000
    SkeletalDiffuse=0.1000000
    SkeletalBrightness=2.5000000
    Bias=0.4000000
    DarkClamp=0.4000000
    LightClamp=0.2000000
    LightDT=0.1500000
    DarkDT=0.1500000
    ContrastDT=0.5000000
    LightThreshold=0.1000000
    DarkThreshold=0.0100000
    bStatic=true
    bNoDelete=true
    Texture=Texture'S_ZoneInfo'
}