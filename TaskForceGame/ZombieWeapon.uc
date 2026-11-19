/*
	TODO: 
		DropFrom() overload
		TravelPostAccept() ???

*/
class ZombieWeapon extends Weapon
	abstract
	native;

const MP_DIFFICULTY_HACK = 1;
const SP_BOT_DIFFICULTY = 2;

var byte NMF;

var float AdjustStep;	// Used for aligning effects
var int AdjustPerson;	// Used for aligning effects

var string PVMeshName;   // Name of first person (playerview) weapon mesh

// Weapon firing/state information
var   float ReticleRangeFactor;  // How far away from enemy the reticle will still turn red, as a fraction of TraceDist
var(Accuracy) float WeaponSpread[4];		// Holds trace accuracies for 4 game difficulty levels
var(Accuracy) float ScatterKick;        // Scatter caused by single shot, as a fraction of trace accuracy.
var           float ScatterFactor; 		// Scatter caused by jolting of previous shot.  Multiplied by TraceAccuracy. 0 means no scatter
var(Accuracy) float ScatterFullRestoreTime; // Time in seconds to go from 100% scatter to 0 scatter
var(Accuracy) float MinScatterFactor;   // ScatterFactor when firing first of a series of shots (and waited long enough before to allow scatter to settle down)
var(Accuracy) float MinScatterFactorZoomed;   // MinScatterFactor when zoomed
var(Accuracy) float MaxScatterFactorZoomed;   // Max ScatterFactor when zoomed (non-zoomed equivalent is 1.0)
var           float TimeOfLastShot;     
var   bool bCanFireAgainPostReload;  // MAT 2/15/05
var   bool bUseCanFireAgainPostReload;  // MAT 2/15/05
var   bool bReleasedFireSinceLastShot;
var	  bool bJustSelected;   // Gets set to true when weapon is brought up, set false after reaching idle.  Used to allow player
							//  to start holding trigger when switching to weapon (and have weapon fire when ready) but to
var   bool bUseMPDiffHack;
var	  int  BurstCounter;
var() int  BurstLength;

var bool  bCanCheckForHoldingFire;
var bool  bBrassTinklePending;
var bool  bJustPlayedDryFire;
var bool  bEjectedbrass;
var float BrassSoundLevelTime;
var float DelayBeforeBrassSound;
var sound BrassSound[EMATERIALTYPE_SIZE];  // The sound of spent shell casings hitting the ground
var sound DryFireSound;

var float TimeBetweenNonSubtleIdles; 
var float TimeOfNextNonSubtleIdle; 
var float TimeOfIdleStart;

// zoom
var byte    forceZoomFinishCounter;  // Used to buffer additional zoom click requests.
var(Zoom) bool	bCanZoom;
var(Zoom) bool	bHasScope;
var bool	bZoomed;		// Weapon is zoomed in
var bool	bDoingZoom;		// Weapon is starting zoomn, zoomed in, or ending zoom
var bool	bZoomOnNextIdle;
var bool	abortScopeRaise;
var(Zoom) bool	bKeepLastZoomSetting;	// If false, then zoom magnification will revert to the default value of fFOVChange
var bool	IsAdjustingZoom;
var(Zoom) float   fScopeRaiseDuration;
var(Zoom) float	fZoomInDuration, fZoomOutDuration; 
var(Zoom) float	fFOVChange, fCurFOVChange; 
var(Zoom) float	fFOVChangeMax, fFOVChangeMin;
var float	fZoomStartTime;
var float	fDefaultPVWeaponFOV; 
var float	fFOVAdjustStart, fFOVAdjustTarget;
var float	ZoomAdjustStartTime;
var float	ZoomDelta;
var(Zoom) vector	ZoomPlayerViewOffset; // For weapons with no scope
var(Zoom) rotator	ZoomRotationOffset;   // For weapons with no scope
var(Zoom) float   ZoomLeanPVYCorr;   // For iron-sight zoom: used to correct PV weapon position when leaning and zoomed
var(Zoom) float   ZoomLeanPVZCorr;   // For iron-sight zoom: used to correct PV weapon position when leaning and zoomed
var(Zoom) float   ZoomLeanPitchCorr; // For iron-sight zoom: used to correct PV weapon pitch when leaning and zoomed
var(Zoom) float   LeanPVYCorr;   // For iron-sight zoom: used to correct PV weapon position when leaning 
var(Zoom) float   LeanPVZCorr;   // For iron-sight zoom: used to correct PV weapon position when leaning
var(Zoom) float   LeanPitchCorr; // For iron-sight zoom: used to correct PV weapon pitch when leaning
var(Zoom) vector	LeanPlayerViewOffset;
var(Zoom) rotator	LeanRotationOffset;
var(Zoom) vector	ZoomLeanPlayerViewOffset;
var(Zoom) rotator	ZoomLeanRotationOffset;
var(Zoom) sound		ZoomInSound;
var(Zoom) sound		ZoomOutSound;
var(Zoom) sound		ZoomMagnificationInSound;
var(Zoom) vector	ScopeFinalSegment;  // Path of final segment of no-anim scope raising
var		  float		TimeOfLastZoomSound;

//Cheat help
var bool	bHidden; 

var bool AutoAimOnZoom;

// AI
var(BotFireRate)	float	BotFireRate;
var(BotFireRate)	float	BotBulletInterval;
var(BotFireRate)	float	MuzzleFlashInterval;

var() float BotGhostBulletPercent;

var EWeaponAnimType WeaponAnims;

// tracer
var(MiscSFRMProps) bool	bFireTracer;	// weapon should fire triacer
var(MiscSFRMProps) int  ShotsPerTracer;		// 1 = Tracer every shot, 6 = Tracer every 6th shot
var				   int  ShotsUntilNextTracer;

// muzzle flash
var(SFRMMuzzleFlash) vector vMuzzleFlashLocalOffset;	// you can use unrealed to place an effect notify on the weapon, 
														// and estimate a position of the muzzle flash on the weapon model

// brass
var(PVBrass)		class<Emitter>		BrassEjectingEmitterClass; 
var(PVBrass)		name				BrassEjectBone;
var(PVBrass)		rangevector			BrassStartVelocityRange;
var(PVBrass)		vector				BrassRight;   // Used to compensate for lateral motion (so if it ejects to the right, brass won't appear to eject to the left when player is running right)
var					float				LastShotDist;
var(PVBrass)		float				MinShotDistBrass;
var(PVBrass)		Emitter				BrassEmitter;

// scope glass
var()				InventoryAttachment scopeGlass;
var()				staticmesh			scopeGlassMesh;
var(ScopeGlass)		string				scopeGlassMeshName;
var(ScopeGlass)		name				ScopeGlassBone;
var(ScopeGlass)		vector				scopeGlassRelLoc;
var(ScopeGlass)		rotator				scopeGlassRelRot;
var(ScopeGlass)		float				scopeGlassScale;

var()				InventoryAttachment scopeGlass2;
var()				staticmesh			scopeGlassMesh2;
var(ScopeGlass)		string				scopeGlassMeshName2;
var(ScopeGlass)		name				ScopeGlassBone2;
var(ScopeGlass)		vector				scopeGlassRelLoc2;
var(ScopeGlass)		rotator				scopeGlassRelRot2;
var(ScopeGlass)		float				scopeGlassScale2;


// if the owner of the weapon is targetting a player pawn, we should play
// flyby sound when missed
var bool bPlayFlyBySound; 

// Per weapon ViewKick variables
var(ViewKick) vector	ViewKickRate, ViewKickMax;
var(ViewKick) float	fViewRestoreTime;
var(ViewKick) float fZoomViewKickFactor;
var	       int      KickDirX;
var	       int      KickDirY;

var int WeaponIconNum;


// New AI bools
var bool bIsSingleShot;
var bool bIsSingleUse;
var int BotClips;
var bool bIsSilenced;
var bool bSetBurstWeapon;
var int		BotBurstSize;
var float	BotTimeBetweenBursts;

var EWeaponSpeedClass	SpeedClass;

var Sound UnderWaterFire;

var int HandsSkinIndex;					// because art can't be consistant....
var bool bOverwriteBulletImpact; 

//These numbers are computed as follows
// H = 480;	// 24 feet
// A = COS(Angle) * H;
// AutoTargetRadiusSquared = (H*H) - (A*A);
// So an angle of 15 gives 5.176380902 FT range in which we autotarget.6
var(AutoTargeting)	float AutoTargetRadiusSquared[4];

// Pawn Animations - Index 0 is Idle Mode - Index 1 is Aim Mode
var name		TakeOutAnim[2];		
var name		PutAwayAnim[2];
var name		PoseAnim[2];
var name		PawnFireAnim;
var name		PawnReloadAnim;

// Water weapon switch
//var ZombieWeapon		nextWeapWater;
//var ZombieWeapon		inputNextWeapWater;
//var bool			bDoingWaterTransition;
//var bool			bTransDestinationWater;

// Weapon sway while moving
var(MovementSway) vector  NeutralPlayerViewOffset;  // The current neutral (no-sway) position for PV weapon movement sway
var(MovementSway) rotator NeutralPlayerViewRotationOffset;  // The current neutral (no-sway) position for PV weapon movement sway
var               float   PVOTransitionTime;
var               float   PVRotOffTransitionTime;
var               vector  TargetPlayerViewOffset;
var               rotator  TargetPlayerViewRotationOffset;

var(MovementSway) float YawSwayFactor, PitchSwayFactor;
var(MovementSway) vector TransSwayFactors;  // Scaling factors on translation sway (due to player translation)
var(MovementSway) vector YawTransSwayFactors;    // Scaling factors on translation sway (due to player yaw)
var(MovementSway) vector PitchTransSwayFactors;  // Scaling factors on translation sway (due to player pitch)
var(MovementSway) vector MinSwayClamp, MaxSwayClamp;
var(MovementSway) rotator MinSwayRotClamp, MaxSwayRotClamp;


var(WeapHandAnimations) name xSubtleIdle;
var(WeapHandAnimations) name xNonSubtleIdle;
var(WeapHandAnimations) name xSingleFire;
var(WeapHandAnimations) name xReloadAnim;
var(WeapHandAnimations) name xHolsterAnim;
var(WeapHandAnimations) name xSelectAnim;
var(WeapHandAnimations) name xScopeOnAnim;
var(WeapHandAnimations) name xScopeOffAnim;

var string MPHandTexName;
var string MPHandTexNameTerr;

// ---------------------------------------------------------

var	float	fNoiseFactor;		// how much noise is this weapon making < 0.0 - 1.0> (Used to see if AI should notice this weapon firing)

// ---------------------------------------------------------

var					bool				DEBUG_WeapAttachment;
var					bool				UseWeapAttachment;
var					InventoryAttachment WeapAttachment;
var					mesh				WeapAttachmentMesh;
var(WeapAttachment)	string				WeapAttachmentMeshName;
var(WeapAttachment)	name				WeapAttachmentBone;
var(WeapAttachment)	vector				WeapAttachmentRelLoc;
var(WeapAttachment)	rotator				WeapAttachmentRelRot;
var(WeapAttachment)	float				WeapAttachmentScale;
var(WeapAttachment) name				WAPVMuzzleFlashBone;
var(WeapAttachment) name				WABrassBone;

var (AttachAnims)	bool				UseAttachAnims;
var (AttachAnims)	name				AttachFireAnim;
var (AttachAnims)	name				AttachReloadAnim;
var (AttachAnims)	name				AttachSelectAnim;

var					string				WeapAnimSet;
var					string				WeapAttachAnimSet;

var					string				WeapAttTexName;
var					Texture				WeapAttTex;

// ---------------------------------------------------------

//
// Hud
//
var class<LocalMessage> MessageClass;

const CROSSHAIR_None = -1;
const CROSSHAIR_ASSAULTRIFLE = 3;
const CROSSHAIR_PISTOL = 4;
const CROSSHAIR_SHOTGUN = 5;
const CROSSHAIR_SNIPER = 6;
const CROSSHAIR_SUBMACHINEGUN = 7;
const CROSSHAIR_HVYMACHINEGUN = 30;
const CROSSHAIR_GRENADELAUNCHER = 40;

var int CrosshairIndex;

var int WeaponIconIndex;

struct native export HUDDisplayProps
{
	var byte WeaponIconIdx;
	var byte AmmoIconIdx;
	var int ItemsPerTex;
};
var HUDDisplayProps hudProps;

// -------------------

//
// Sounds
//
var() sound FireSounds[ESOUNDZONE_SIZE];
var() sound ReloadSound;

//
// Rumble
//
var() RumbleDescription			RumbleDes;

//
// Playerview  muzzle flash
//
var(PVMuzzleFlash)	class<StaticMeshActor>		PVMuzzleStaticMeshClass; 
var			StaticMeshActor			PVMuzzleStaticMesh;
var(PVMuzzleFlash)	vector			PVMuzzleLocation;			// muzzle location in model coord
var(PVMuzzleFlash)	float			PVMuzzleFlashScale; 
var(PVMuzzleFlash)	Material		PVMuzzleFlashSkin; 
var(PVMuzzleFlash)	bool			bUse2DMuzzleFlash;	//Wether or not to use the 2D MuzzleFlash (MFTexture)
var(PVMuzzleFlash)	vector			PVMuzzleLocationZoomed;		// muzzle location in model coord when zoomed
var(PVMuzzleFlash)	vector			PVMuzzleLocationLean;		// muzzle location in model coord when leaning
var(PVMuzzleFlash)	vector			PVMuzzleLocationZoomLean;		// muzzle location in model coord when zoomed and leaning

// Overal muzzleflash property
var(PVMuzzleFlash)	bool			bWeapHasMuzzleFlash;

var					byte			AmbientGlowDelta;
var					byte			WAAmbientGlowDelta;

// ---------------------------------------------------------

replication
{
	// Functions client can call.
	reliable if( Role<ROLE_Authority )
		ServerGotoState,ServerSetDoingZoom,ServerSetZoomed;
	
	reliable if( ROLE==ROLE_Authority)
		TimeBetweenNonSubtleIdles, playHolsterAnim,UnZoom, // BurstCounter,
		ClientPlayerViewWeapon, ClientInit, ClientCanFireAgainPostReload;
}

static simulated function PreCacheWeapAssets();

function ServerGotoState(name newState)
{
	//log ("SERVER SETTING STATE"@newState);
	GotoState(newState);
}

simulated static function PrecacheAssets(LevelInfo xLevel)
{
	PrecacheSecondaryStaticMeshes(xLevel);

	if( default.UseWeapAttachment )
		PrecacheWeapAttachmentTextures(xLevel);
}

simulated static function PrecacheWeapAttachmentTextures(LevelInfo xLevel)
{
	xLevel.AddPrecacheMaterial( texture(DynamicLoadObject(default.WeapAttTexName,class'texture')) );
}

/////////////////////////////
//Attachment Stuff

simulated function MakeWeapAttachment()
{
	local bool AttachSuccess;
	local MeshAnimation anim;

	if (!UseWeapAttachment)
	{
		return;
	}

	// Debug only: update relative location, relative rotations and drawscale.
	// This allows use of editactor in-game to find the correct position for the
	// silencer.
	//if( WeapAttachment != None )
	//{
	//	WeapAttachment.SetRelativeLocation(WeapAttachmentRelLoc);
	//	WeapAttachment.SetRelativeRotation(WeapAttachmentRelRot);
	//	WeapAttachment.SetDrawScale( WeapAttachmentScale );
	//}

	if( WeapAttachment != None )  // if WeapAttachment exists already, no need to spawn it
		return;

	if( WeapAttachmentBone == 'none' || WeapAttachmentBone == '' )  // if no attach bone specified, return
		return;


	// Create fist-person weapon attachment (this is *not* third-person WeaponAttachment)
	WeapAttachmentMesh = Mesh(DynamicLoadObject(WeapAttachmentMeshName,class'Mesh'));

	WeapAttachment = Spawn( class'Engine.InventoryAttachment', self,,GetBoneCoords(WeapAttachmentBone).Origin );
	WeapAttachment.LinkMesh( WeapAttachmentMesh );
	if( WeapAttachment != None && WeapAttachAnimSet != "" )
	{
		anim = MeshAnimation( DynamicLoadObject(WeapAttachAnimSet, class'MeshAnimation') );
		WeapAttachment.LinkSkelAnim( anim );
	}
	WeapAttachment.SetDrawType(DT_Mesh);
	WeapAttachment.SetDrawScale( WeapAttachmentScale );

	AttachSuccess = AttachToBone( WeapAttachment, WeapAttachmentBone );
	if( AttachSuccess )
	{
		WeapAttachment.SetRelativeLocation(WeapAttachmentRelLoc);
		WeapAttachment.SetRelativeRotation(WeapAttachmentRelRot);
	}

	WeapAttachment.RemoteRole = ROLE_None;
}

//end Attachment Stuff
/////////////////////////////////

simulated function LoadPVMesh()
{
	if( Mesh != None )
		return;
	else
		LinkMesh( skeletalmesh(DynamicLoadObject( PVMeshName,class'skeletalmesh')), false );
}

//
// call to reskin player view weapon 
//
native simulated function ReskinWeapon(Material Skin0, Material Skin1);

// Function that returns string name for campaign-specific weapon skin (if any)
function string GetCampaignWeapSkin(int index)
{
	return "";
}

function PostNetBeginPlay()
{
	local MeshAnimation anims;
	local bool bInstigatorNotPlayer;

//	log(self$"::PostNetBeginPlay()");
	if( instigator != none && ZombiePlayerPawn(instigator) == none )
		bInstigatorNotPlayer = true;

	if( bInstigatorNotPlayer )
		UseWeapAttachment = false;

	if (UseWeapAttachment)
	{
		MakeWeapAttachment();
	}

	if (WeapAnimSet != "")
	{
		anims = MeshAnimation(DynamicLoadObject(WeapAnimSet, class'MeshAnimation'));
		LinkSkelAnim(anims);
	}

	// Hack: ensure that in net game the client gets a hands texture
	if( !bInstigatorNotPlayer )
		ClientPlayerViewWeapon();

	if (Level.NetMode != NM_Standalone || Level == None 
	 || Level.Game == None || SFRMMultiPlayer(Level.Game) != None )
		bUseMPDiffHack = true;
	else
		bUseMPDiffHack = false;

	NeutralPlayerViewOffset = PlayerViewOffset;

	if( bUseMPDiffHack && MPDamageAmount > 0 )
		DamageAmount = MPDamageAmount;

	if( Level.NetMode != NM_Standalone )
		ClientInit();

	// For fake dynamic light on weapon (where ambient glow is used
	// to simulate dynamic light on weapon), pre-compute nominal
	// variation in ambient glow.
	if( bIsSilenced )
	{
		AmbientGlowDelta=30;
		WAAmbientGlowDelta=50;
	}
	else
	{
		AmbientGlowDelta=60;
		WAAmbientGlowDelta=100;
	}
}

simulated function ClientInit()
{
	local MeshAnimation anims;

//	Log("ZombieWeapon.ClientInit #####################################################");

	LoadPVMesh();

	if( instigator != none && ZombiePlayerPawn(instigator) == none )
		UseWeapAttachment = false;
	if (UseWeapAttachment)
	{
		MakeWeapAttachment();
	}

	if (WeapAnimSet != "")
	{
		anims = MeshAnimation(DynamicLoadObject(WeapAnimSet, class'MeshAnimation'));
		LinkSkelAnim(anims);
	}

	if (Level.NetMode != NM_Standalone || Level == None 
	 || Level.Game == None || SFRMMultiPlayer(Level.Game) != None )
		bUseMPDiffHack = true;
	else
		bUseMPDiffHack = false;

	if( bUseMPDiffHack && MPDamageAmount > 0 )
		DamageAmount = MPDamageAmount;

	NeutralPlayerViewOffset = PlayerViewOffset;


	// For fake dynamic light on weapon (where ambient glow is used
	// to simulate dynamic light on weapon), pre-compute nominal
	// variation in ambient glow.
	if( bIsSilenced )
	{
		AmbientGlowDelta=30;
		WAAmbientGlowDelta=50;
	}
	else
	{
		AmbientGlowDelta=60;
		WAAmbientGlowDelta=100;
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay(); 

	// If a player is using this weapon, then load the PV mesh
	if( mesh == None )//&& (SpecForcePlayerPawn(Instigator) != None || SpecForcePlayerPawn(Owner) != None) )
		LoadPVMesh();
	
	//
	// Notify Map Info Actor about a new PlayerView object
	// coming it (just in case we need to do some post processing on the object)
	//
	if (Level.DefaultMapInfo != None)
		Level.DefaultMapInfo.PlayerViewWeapon(self); 

	MakeScopeGlass();

	fDefaultPVWeaponFOV	= DisplayFOV;  // MAT 3/13/04: Fix crashing bug caused when user mashed L trigger, B btn and black btn (showhelp)

	ScatterFactor = MinScatterFactor;
}

simulated function ClientPlayerViewWeapon()
{
//	Log("ZombieWeapon.ClientPlayerViewWeapon -------- "$ self.class );
//	Log("   ----  Level : "$Level );
//	Log("   ----  Level.HandsTexture:"$Level.HandsTexture );
//	Log("   ----  Level.NetMode != NM_Standalone : "$Level.NetMode != NM_Standalone);
//	Log("   ----  Level.DefaultMapInfo: "$Level.DefaultMapInfo );
//	Log("   ----  Level.DefaultMapInfo.HandsTexture:"$Level.DefaultMapInfo.HandsTexture );
	if( Level != None && SinglePlayerMI(Level.DefaultMapInfo) != None )
	{
		// Single Player
	//	Log("     Level.HandsTexture is none");
		// If the Level.HandsTexture is null, see if we can get it from either the MapInfo 
		// or if not then DLO and assign directly to Level.HandsTexture
		if( SinglePlayerMI(Level.DefaultMapInfo) != None )
		{
			SinglePlayerMI(Level.DefaultMapInfo).SetLevelHandsTexture();
		}	
		else
		{
			// As a fallback, load Special Forces MP hand texture
			Level.HandsTexture = texture( DynamicLoadObject(MPHandTexName,class'texture') );
		}

		// If we have successfully set HandsTexture to something, then use it
		if( Level.HandsTexture != None )
		{
		//	Log("     Level.HandsTexture is now not none, so we'll use it to reskin.");
			Reskin( Level.HandsTexture, None );
		}
	}
	else
	{
		// Multiplayer
		// These textures should have already been pre-loaded, so
		// the folowing DLO shouldn't cause a hitch.
		if( instigator != None && instigator.controller != None && instigator.controller.PlayerReplicationInfo != None
		 && instigator.controller.PlayerReplicationInfo.bTerrorist )
			Skins[0] = texture(DynamicLoadObject(MPHandTexNameTerr,class'texture'));
		else
			Skins[0] = texture(DynamicLoadObject(MPHandTexName,class'texture'));
	}

//	Log("   UseWeapAttachment:"$ UseWeapAttachment $"  WeapAttachment:"$ WeapAttachment $"  WeapAttTex:"$ WeapAttTex );
	if (UseWeapAttachment && WeapAttachment != None )
	{
	//	Log("     If WeapAttTex is not none, will try to reskin WeapAttachment");
		WeapAttTex = texture(DynamicLoadObject(default.WeapAttTexName,class'texture'));
		if( WeapAttTex != None )
			WeapAttachment.Reskin( WeapAttTex, None );
	}	

}

//
// Cleanup 
//
simulated function Destroyed()
{
	if( scopeGlass != None )
	{
		scopeGlass.bHidden=true;
		scopeGlass.Destroyed();
	}
	if( scopeGlass2 != None )
	{
		scopeGlass2.bHidden=true;
		scopeGlass2.Destroyed();
	}

	if( WeapAttachment != None )
	{
		WeapAttachment.bHidden=true;
		WeapAttachment.Destroy();
	}

	Super.Destroyed(); 

}

// If this is single player, and owner is a human player, returns true (MAT 9/28/04)
function bool isSPHumanPlayer(Pawn Other)
{
	if( PlayerController(Other.controller) != None || ZombiePlayerPawn(Other) != None )  // is human player
	{
		if( Level.NetMode != NM_Standalone || Level == None 
		 || Level.Game == None || SFRMMultiPlayer(Level.Game) != None )
			return false; // is multiplayer
		else
			return true;  // is single player
	}
	else
		return false;
}

function bool ShouldSpawnCamProjectile()
{
	return false;
}

native simulated function rotator GetSkelMeshRotationOffset(SkeletalMesh weapMesh, ZombieWeapon weap );
native simulated function SetSkelMeshRotationOffset(SkeletalMesh weapMesh, ZombieWeapon weap, rotator NewRotationOffset);

function InitializeWeapon()
{
	// no need to switch weapon mode if we only have one.
//	log(self$"::InitializeWeapon");

	if( AmmoName != None )
	{
		AmmoType = Ammunition(Pawn(Owner).FindInventoryType(AmmoName));
		if ( AmmoType == None )  // Temp hack (scaffolding during removal of weapon modes)
		{
			GiveAmmo(Pawn(Owner));
		}
	}

	// update hud
	if( SFRMPlayerController(Pawn(Owner).Controller) != none && Pawn(Owner).Weapon == self )
	{
		SFRMPlayerController(Pawn(Owner).Controller).SetCHIndex(GetCrosshairIndex(), WeaponIconIndex);
	}

	SpawnMuzzleFlashStaticMesh();
}

simulated function Tick(float TimeDelta)
{
	Super.Tick( TimeDelta );
	if( bBrassTinklePending && Level.TimeSeconds >= BrassSoundLevelTime )
	{
		PlayBrassSound();
	}
	
	///DEBUG!!!!
	//if (DEBUG_WeapAttachment && UseWeapAttachment)
	//{
	//	MakeWeapAttachment();
	//}

	if( PVOTransitionTime > 0.0 )
	{
		InterpolatePVO( TimeDelta );
	//	if( PVOTransitionTime != 0 )
	//		Log( Level.TimeSeconds $"  "$ PVOTransitionTime $"  T:"$ TargetPlayerViewOffset $"  N:"$ NeutralPlayerViewOffset );
	}

	if( PVRotOffTransitionTime > 0.0 )
	{
		InterpolatePVRotOff( TimeDelta );
	}
}

simulated function StartPVOInterpolation( float Duration, vector TargetPVO )
{
	PVOTransitionTime = Duration;
	TargetPlayerViewOffset = TargetPVO;
}

simulated function CancelPVOInterpolation( vector NewNeutralPVO )
{
	PVOTransitionTime = 0.0;
	TargetPlayerViewOffset = NewNeutralPVO;
	NeutralPlayerViewOffset = NewNeutralPVO;
}

native simulated function InterpolatePVO( float TimeDelta );

simulated function StartPVRotOffInterpolation( float Duration, rotator TargetPVRotOff )
{
	PVRotOffTransitionTime = Duration;
	TargetPlayerViewRotationOffset = TargetPVRotOff;
}

simulated function CancelPVRotOffInterpolation( rotator NewNeutralPVRotOff )
{
	PVRotOffTransitionTime = -1;
	TargetPlayerViewRotationOffset = NewNeutralPVRotOff;
	NeutralPlayerViewRotationOffset = NewNeutralPVRotOff;
}

native simulated function InterpolatePVRotOff( float TimeDelta );

// Gives how far away enemy can be and still have reticle turn red.  Result is in Unreal length units.
simulated function float GetRedReticleRange()
{
	return ReticleRangeFactor*TraceDist;
}

// MAT 2/15/05
simulated function ClientCanFireAgainPostReload()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  ClientCanFireAgainPostReload!!!");
	bCanFireAgainPostReload = true;
}

simulated function ReleaseFire( optional float F )
{
//	log(self$" "$GetStateName()$"::ReleaseFire");
	bReleasedFireSinceLastShot=true;
	if( !bJustPlayedDryFire )
	{
	//	log("   Brass tinkle");
		RequestBrassSound();
	}
	BurstCounter = 0;
	Super.ReleaseFire();
}

function ServerReleaseFire()
{
//	Log(Level.Hour $":"$ Level.Minute $":"$ Level.Second $"."$ Level.Millisecond $"  ZombieWeapon.ServerReleaseFire  self:"$self.class $"   BurstCounter:"$ BurstCounter );

	bReleasedFireSinceLastShot=true;
	BurstCounter=0;
	Super.ServerReleaseFire();
//	Log("          ZombieWeapon.ServerReleaseFire    BurstCounter:"$BurstCounter );
}

simulated event ForceStopFiring()
{
//	Log(Level.Hour $":"$ Level.Minute $":"$ Level.Second $"."$ Level.Millisecond $"  ZombieWeapon.ForceStopFiring  self:"$self.class $"   instigator:"$instigator.class );
	Pawn(Owner).Controller.bFire=0;
	Pawn(Owner).Controller.bAltFire=0;
	ReleaseFire();
	GotoState('Idle');
}


simulated function AttachToPawn(Pawn P)
{
	local name BoneName;
	
	if ( ThirdPersonActor == None )
	{
		ThirdPersonActor = Spawn(AttachmentClass,Owner);
		InventoryAttachment(ThirdPersonActor).InitFor(self);
	}
	BoneName = P.GetWeaponBoneFor(self);
	if ( BoneName == '' )
	{
		ThirdPersonActor.SetLocation(P.Location);
		ThirdPersonActor.SetBase(P);
	}
	else
		P.AttachToBone(ThirdPersonActor,BoneName);
		
	ThirdPersonActor.SetRelativeLocation(ThirdPersonRelativeLocation);
	ThirdPersonActor.SetRelativeRotation(ThirdPersonRelativeRotation);
}


//
// give incoming pawn the ammo for this weapon
//
static function bool StaticGiveAmmo( Pawn Other )
{
	local Ammunition A; 
	local bool ret;
	
//	Log("ZombieWeapon.StaticGiveAmmo ###################################### ");
	ret=false;

	if( default.AmmoName != None )
	{
		A = Ammunition(Other.FindInventoryType(default.AmmoName));

		if ( A != None )
		{
		//	Log("     A != None   so give ammo ");
			ret = A.AddAmmo(default.ReloadCount*3);
		}		
	}

	return ret;
}

function GiveWeaponSomeClipsOfAmmo(int numClips)
{
	local Ammunition A;

//	Log("ZombieWeapon.GiveWeaponSomeClipsOfAmmo ###################################### "$self.class);
	if( AmmoName != None )
	{
		A = Ammunition(Pawn(Owner).FindInventoryType(AmmoName));
		if ( A != None && default.ReloadCount>0)
		{
			A.AmmoAmount = Min( A.MaxAmmo - (A.MaxAmmo%Default.ReloadCount), A.AmmoAmount+2*Default.ReloadCount);
			if (A.AmmoAmount <=0) A.AmmoAmount = 0;
		}
	}
}
function GiveWeaponAmmo(optional int AmmoCount)
{
	local Ammunition A; 

//	Log("ZombieWeapon.GiveWeaponAmmo ###################################### "$self.class);
	if( AmmoName != None )
	{
		A = Ammunition(Pawn(Owner).FindInventoryType(AmmoName));
		if ( A != None )
		{
			if (AmmoCount == 0)
			{
				if( Level.Game != None && (Level.Game.IsA('SFRMSinglePlayer')) || ABSTRACT_WeapGrenade(self) != None )
					A.AmmoAmount = default.ReloadCount*3; // A.MaxAmmo - (A.MaxAmmo%default.ReloadCount);  // give as many clips as we can, short of MaxAmmo
				else
					A.AmmoAmount = Min( default.ReloadCount*4, 180);  // non-CoOp multiplayer, non-grenade weap: 4 clips but no more than 180 rounds
		//		Log("  SFRMW.GWA      happy happy   ");
			}
			else 
				A.AmmoAmount += AmmoCount;

		}
	}
}

event bool BotFire(bool bFinished, optional float BotAccuracy, optional name FiringMode)
{
	local ZombiePlayerPawn PlayerPawn; 
	local bool retVal; 

	retVal = Super.BotFire(bFinished, BotAccuracy, FiringMode); 

	if ( retVal )
	{
		if( Owner == None || Pawn(Owner).Controller == None || Pawn(Owner).Controller.Target == None )
			return retVal;

		PlayerPawn = ZombiePlayerPawn(Pawn(Owner).Controller.Target); 

		if ( PlayerPawn != None)
		{
			bPlayFlyBySound=True; 
			return retVal; 
		}
	}

	bPlayFlyBySound=False;

	return retVal;
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	// MAT 2/22/05: Pre-condition: Instigator must not be none.  (But it can be some other kind of pawn).

	if( (ZombieBipedPawn(Instigator) == None) || !(ZombieBipedPawn(Instigator).bLeaning) )
	{
		// If in MP, and client player is crouched, then ensure that on
		// server we get the right eye height
		if( Role == ROLE_Authority && !Instigator.IsLocallyControlled() && Instigator.bIsCrouched )
		{
			return (Instigator.Location + Instigator.EyePosition() 
				+ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z); 
			// MAT 2/22/05: Removed hack that added +25 height.
		}
		else
		{
			//HACK!
			if( !Instigator.IsHumanControlled() )
			{
				Instigator.EyeHeight = Instigator.default.EyeHeight;
			}
			return (Instigator.Location + Instigator.EyePosition() 
				+ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z); 
		}
	}
	else
		return (PlayerController(Instigator.Controller).LeanFirePosition 
				+ FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z);
}


// TrackPlayer - This function is linked to the hud and used to display any special
// player tracking or targetting info.  X/Y is the screen coordinates of the player.  
// returns FALSE if it doesn't process the player.

simulated function bool TrackPlayer(canvas Canvas, float X, float Y, pawn P);

function bool HandlePickupQuery( Pickup Item )
{
/*
	local int OldAmmo, i; // NewAmmo
	local Pawn P;

	if (Item.InventoryType == Class)
	{
		if ( WeaponPickup(item).bWeaponStay && ((item.inventory == None) || item.inventory.bTossedOut) )
			return true;
		
		P = Pawn(Owner);
		OldAmmo=Ammunition(Pawn(Owner).FindInventoryType(AmmoName)).AmmoAmount;
		
		// add default amount of ammo
		GiveWeaponAmmo();

		if ( OldAmmo == 0 && (P.Weapon.class != item.InventoryType) )
				ClientWeaponSet(true);

		Item.AnnouncePickup(Pawn(Owner));
		return true;
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
*/
	return false;
}

function float AmmoStatus()
{
	local Ammunition Ammo;
	Ammo = Ammunition(Pawn(Owner).FindInventoryType(AmmoName)); 
	return float(Ammo.AmmoAmount)/Ammo.MaxAmmo;
}

//
// Pipe through current weapon mode
//
simulated function bool HasAmmo()
{
//SysLinkSPAM	log("HasAmmo: " $ AmmoType @ Owner @ Pawn(Owner).FindInventoryType(AmmoType.Class));
	return ( ( Ammunition(Pawn(Owner).FindInventoryType(default.AmmoName)).HasAmmo() )  
			|| ( GetReloadCount() != 0 ) );
}

simulated function PlayFiring()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond$"  ZombieWeapon.PlayFiring");
	if (HasAnim(xSingleFire))
	{
		PlayAnim(xSingleFire, 1.0f, 0.02f);
	}

	if ((RumbleDes != none) && (PlayerController(Instigator.Controller) != none))
	{
		PlayerController(Instigator.Controller).PlayRumble(RumbleDes);
	}

	IncrementFlashCount();
	
	if (UseAttachAnims && UseWeapAttachment && (AttachFireAnim != ''))
	{
		WeapAttachment.PlayAnim(AttachFireAnim, 1.0f, 0.02f);
	}
	
	if( bDoingZoom && (bHasScope || HasAnim(xScopeOnAnim)) )  // Until scopes are implemented, also checking for anim
	{
		bMuzzleFlash = false; 
		bDrawMuzzleFlash = false; 
	}
	else
	{
		bMuzzleFlash = true; 
		bDrawMuzzleFlash = true; 
	}
}

simulated native function float AdjustShotScatter(float Accuracy);

simulated function CalcTimeOfNextNonSubtle()
{
	TimeOfNextNonSubtleIdle = Level.TimeSeconds + TimeBetweenNonSubtleIdles + (FRand() * TimeBetweenNonSubtleIdles);
}

simulated function PlayIdleAnim(optional bool bForceSubtle)  // RedMerc (optional bool param added, but code using it not ported)
{
	local name IdleAni;
	local bool bPlayNonSubtle;

	bPlayNonSubtle = (Level.TimeSeconds > TimeOfNextNonSubtleIdle);

	if(bPlayNonSubtle )
	{
		IdleAni = xNonSubtleIdle;
		
		CalcTimeOfNextNonSubtle();
	}
	else
	{
		IdleAni = xSubtleIdle;
	}

	if(HasAnim(IdleAni))
		PlayAnim(IdleAni, 1.0, 0.05);

	// For zoom (especially iron-sight zoom), keep weapon from bobbing up and down too much
	if( bZoomed )
	{
		SetAnimFrame( 20.0 );
	}
}

simulated function TweenDown()
{
	local name Anim;
	local float frame,rate;

	if ( IsAnimating() && AnimIsInGroup(0,'Select') )
	{
		GetAnimParams(0,Anim,frame,rate);
		TweenAnim( Anim, frame * 0.4 );
	}
	else
	{
		if (HasAnim(xHolsterAnim))
			PlayAnim(xHolsterAnim, 1.0f, 0.02f);
	}
}

simulated function BringUp()
{
	Super.BringUp();

	MakeScopeGlass();
}

simulated function MakeScopeGlass()
{
	local bool AttachSuccess;

	// Debug only: update relative locations, relative rotations and drawscales.
	// This allows use of editactor in-game to find the correct position for the
	// scope glass piece(s).
/*	if( ScopeGlass != None )
	{
		ScopeGlass.SetRelativeLocation(scopeGlassRelLoc);
		ScopeGlass.SetRelativeRotation(scopeGlassRelRot);
		ScopeGlass.SetDrawScale( scopeGlassScale );
	}
	if( ScopeGlass2 != None )
	{
		ScopeGlass2.SetRelativeLocation(scopeGlassRelLoc2);
		ScopeGlass2.SetRelativeRotation(scopeGlassRelRot2);
		ScopeGlass2.SetDrawScale( scopeGlassScale2 );
	}
*/
	if( ScopeGlass != None )  // if scope doesn't exists already, no need to spawn it
		return;

	if( scopeGlassBone == 'none' || scopeGlassBone == '' )  // if no scope glass bone specified, return
		return;


	// Create main scope glass
	scopeGlassMesh = StaticMesh(DynamicLoadObject(ScopeGlassMeshName,class'StaticMesh'));

	ScopeGlass = Spawn( class'Engine.InventoryAttachment', self,,GetBoneCoords(ScopeGlassBone).Origin );
	ScopeGlass.SetStaticMesh( scopeGlassMesh );
	ScopeGlass.SetDrawType(DT_StaticMesh);
	ScopeGlass.SetDrawScale( scopeGlassScale );

	AttachSuccess = AttachToBone( ScopeGlass, ScopeGlassBone );
	if( AttachSuccess )
	{
		ScopeGlass.SetRelativeLocation(scopeGlassRelLoc);
		ScopeGlass.SetRelativeRotation(scopeGlassRelRot);
	}


	// Create secondary scope glass (if any)
	if( scopeGlassBone2 == 'none' || scopeGlassBone2 == '' )  // if no scope glass bone specified, return
		return;

	scopeGlassMesh2 = StaticMesh(DynamicLoadObject(ScopeGlassMeshName2,class'StaticMesh'));

	ScopeGlass2 = Spawn( class'Engine.InventoryAttachment', self,,GetBoneCoords(ScopeGlassBone2).Origin );
	ScopeGlass2.SetStaticMesh( scopeGlassMesh2 );
	ScopeGlass2.SetDrawType(DT_StaticMesh);
	ScopeGlass2.SetDrawScale( scopeGlassScale2 );

	AttachSuccess = AttachToBone( ScopeGlass2, ScopeGlassBone2 );
	if( AttachSuccess )
	{
		ScopeGlass2.SetRelativeLocation(scopeGlassRelLoc2);
		ScopeGlass2.SetRelativeRotation(scopeGlassRelRot2);
	}
}

simulated function CheckForHoldFire()
{
//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  ZombieWeapon.CheckForHoldFire   BC:"$ BurstCounter );
	if( !NeedsToReload() )
	{
		if( ShouldRespondToPressingFire() && !Level.GRI.bGameEnded )
		{
			bJustSelected=false;
		//	Log("    Instigator.PressingFire():"$ Instigator.PressingFire() );
			if ( Instigator.PressingFire() )
				Fire(0.0);
			if ( Instigator.PressingAltFire() )
				AltFire(0.0);
		}
		else
		{
			bJustSelected=false;
		}
	}
}

state Idle
{
	simulated function Tick(float TimeDelta)
	{
		if( bCanCheckForHoldingFire )
		{
			if( instigator.Weapon == self && instigator.IsLocallyControlled() )
				CheckForHoldFire();
		}
		else
		{
			if( instigator.Weapon == self && (!bJustSelected || Level.TimeSeconds > TimeOfIdleStart + 0.04) )
				bCanCheckForHoldingFire = true;
		//	if( instigator.Weapon == self && Level.TimeSeconds > TimeOfIdleStart + 0.04 )
		//		Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"   setting bCanCheckForHoldingFire to true based on time (dt:"$ Level.TimeSeconds-Level.TimeSeconds $") ###");
		}

		Global.Tick( TimeDelta );
	}

	simulated function BeginState()
	{
	//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  ZombieWeapon.Idle.BeginState   bJustSelected:"$ bJustSelected );
		TimeOfIdleStart = Level.TimeSeconds;
		if( !IsAnimating()
		 && !( ShouldRespondToPressingFire() && (Instigator.PressingFire() || Instigator.PressingAltFire()) ) )
			PlayIdleAnim();
		Super.BeginState();
	}

	simulated function EndState()
	{
	//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  ZombieWeapon.Idle.EndState ");
		bCanCheckForHoldingFire=false;
		Super.EndState();
	}

	simulated function ForceReload()
	{
		// Check that there is reserve ammo before doing the reload animation
		if( Ammunition(Pawn(Owner).FindInventoryType(default.AmmoName)).HasAmmo() )
			Super.ForceReload();
	}

Begin:
//	Log( FormatTime(Level.Minute*60+Level.Second) $" "$ Level.Millisecond $"  ZombieWeapon.Idle Begin: label   ShouldRespondToPressingFire():"$ ShouldRespondToPressingFire() );
	bPointing=False;
	if ( NeedsToReload() && HasAmmo() )
		GotoState('Reloading');
	if (SwitchOnEmpty)
	{
		if ( !HasAmmo() ) 
		{
			Instigator.Controller.SwitchToBestWeapon();  //Goto Weapon that has Ammo
		}
	}
}

simulated function bool ShouldRespondToPressingFire()
{
//	Log(">ZombieWeapon.ShouldRespondToPressingFire   bJustSelected:"$bJustSelected $"   IsSingleShot():"$IsSingleShot() $"  BurstDone():"$BurstDone() $"   BC:"$BurstCounter $"  BL:"$BurstLength );
//	Log(">ZombieWeapon.ShouldRespondToPressingFire     bReleasedFireSinceLastShot:"$bReleasedFireSinceLastShot );
	if( IsSingleShot() )
	{
		if( bJustSelected )
			return true;
		else if( bReleasedFireSinceLastShot )
			return true;
		else
			return false;
	}
	else
	{
		if( bJustSelected )
			return true;
		else if( !BurstDone() )
			return true;
		else
			return false;
	}
}

simulated function bool IsSingleShot()
{
	return (BurstLength == 1 );
}

simulated function bool BurstDone()
{
	if( BurstLength == 0 )
		return false;
	else if( BurstCounter >= BurstLength )
		return true;
	else
		return false;
}

simulated function PlayReloading()
{
	if (HasAnim(xReloadAnim))
	{
		PlayAnim(xReloadAnim, 1.0f, 0.02f);
	}
	else
	{
		log("!!!No reload anim ("$xReloadAnim$")for " $ self);
	}

	if (UseAttachAnims && UseWeapAttachment && (AttachReloadAnim != ''))
	{
		WeapAttachment.PlayAnim(AttachReloadAnim, 1.0f, 0.02f);
	}

	CalcTimeOfNextNonSubtle();
}

simulated function PlaySelect()
{
	bForceFire = false;
	bForceAltFire = false;

	if ( Mesh != None && HasAnim ( xSelectAnim ) )
	{
		PlayAnim(xSelectAnim, 1.0f, 0.0f);
	//	Log("  Playing select anim");
	}
	if (UseAttachAnims && UseWeapAttachment && (AttachSelectAnim != ''))
	{
		WeapAttachment.PlayAnim(AttachSelectAnim, 1.0f, 0.0f);
	}

	CalcTimeOfNextNonSubtle();
}

function ProjectileFire()
{
	local Vector Start, X,Y,Z;
	
	if( Pawn(Owner) != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
	{
		SFRMPlayerController(Pawn(Owner).Controller).StatMgr.ShotFired();
	}

	Owner.MakeNoise(fNoiseFactor);
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	Start = GetFireStart(X,Y,Z); 
	AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError, true);	
	AmmoType.SpawnProjectile(Start,AdjustedAim);	

	if( Level.bMPWeapLogs )
		Log( Level.TimeSeconds $" MPLog: #### Projectile shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  weap:"$ self.class );
}

//
// TraceFire - Overload TraceFire so we can spawn tracers if we need to 
// but don't have to redo the math for direction and such.
//
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Material HitMaterial; 
	local vector TracerStart; 
	local rotator TraceRotation, Rot; 
	local bool OverrideAutoAim;
	local SFRMPlayerController SFRMPC;

	Accuracy = AdjustShotScatter(Accuracy) + BotTraceAccuracy;

	OverrideAutoAim = false;

	if (!AutoAimOnZoom && bZoomed)
	{
		OverrideAutoAim = true;
//		log("No auto aim");
	}
//	else
//	{
//		log("Auto aim");
//	}

	if( Pawn(Owner) != None )
	{
		SFRMPC = SFRMPlayerController(Pawn(Owner).Controller);
		if( SFRMPC != None && SFRMPC.StatMgr != None )
			SFRMPC.StatMgr.ShotFired();
	}

	Owner.MakeNoise(fNoiseFactor);

	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	if( Pawn( Owner ).IsHumanControlled( ) )
		StartTrace = GetFireStart( X, Y, Z );
	else
		ZombieWeaponAttachment(ThirdPersonActor).GetEffectStart( StartTrace, Rot );

	// Adjust endpoint of trace (for horizontal and vertical offset and inaccuracy).
	// Essentially, if the YOffset and ZOffset are 0, then converting from Accuracy 
	// factor to a max scatter angle (i.e. weapon could be betweeen +0.5*angle and 
	// -0.5*angle) is as folows:
	//
	//    Max scatter angle = 2 * arctangent( accuracy * 0.5 * 1000 / TraceDistance ) 
	//        where: TraceDist's default is often 10,000 (or 100,000 for sniper rifles).
	//
	// If you don't feel like doing trig (i.e. if you're a normal person):
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.573 deg (or: +/-0.286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 5.72 deg (or: +/-2.86 deg about aim point)
	//	For TraceDist = 10,000 (and no YOffset or ZOffset):	
	//		Accuracy=0.1 means shot will be within 0.0573 deg (or: +/-0.0286 deg about aim point)
	//		Accuracy=1.0 means shot will be within 0.573 deg (or: +/-2.86 deg about aim point)
	//
	// Other notes / more details:
	// * (FRand() - 0.5) returns something between -0.5 and +0.5
	// * The scaling factor of 1000 on each component is not the TraceDist, but usually
	//   more like 1/10th or 1/100th of the TraceDist.  It appears to be a magic number 
	//   chosen because it made things look ok.
	// * If using YOffset or ZOffset, remember that they will be scaled up by 1000.	
	EndTrace = StartTrace + (YOffset + Accuracy * (FRand() - 0.5 ) ) * Y * 1000
		+ (ZOffset + Accuracy * (FRand() - 0.5 )) * Z * 1000;

	AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError, OverrideAutoAim);

	X = vector(AdjustedAim);
	EndTrace += (TraceDist * X);
	
	if( Instigator != None && Instigator.Controller != None )
	{
		Instigator.Controller.ShowStartFire = StartTrace;
		Instigator.Controller.ShowEndFire = EndTrace;
	}

	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial,true);
	LastShotDist = VSize(HitLocation - Location);

	if( Level.bMPWeapLogs )
	{
		if( Pawn(Other) != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  hit player named "$ Pawn(other).PlayerReplicationInfo.PlayerName $"  class idx:"$ Pawn(other).PlayerReplicationInfo.ClassIdx $"  terr:"$ Pawn(other).PlayerReplicationInfo.bTerrorist $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else if( Other != None )
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  hit a(n) "$ other.class $"  dist:"$ VSize(HitLocation-StartTrace) $" ("$ VSize(HitLocation-StartTrace)/24 $"ft)" );
		}
		else
		{
			Log( Level.TimeSeconds $" MPLog: #### Shot fired by "$ instigator.PlayerReplicationInfo.PlayerName $"  weap:"$ self.class $"  hit nothing." );
		}
	}

	if ( bFireTracer != False && PlayerController(Instigator.Controller) == None)
	{
		if( ShotsUntilNextTracer <= 1 )
		{
			ZombieWeaponAttachment(ThirdPersonActor).GetEffectStart(TracerStart,TraceRotation);
			Spawn(class'Tracer', self, ,TracerStart, AdjustedAim); 
			ShotsUntilNextTracer=ShotsPerTracer;
		}
		else
		{
			ShotsUntilNextTracer--;
		}	
	}

	AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z, HitMaterial);
}



// FakeTrace - Performs the same logic as a TraceHit, but doesn't actually pass it
// to the ammo.  It's used for spawning beam effects and such in first/person
simulated function FakeTrace()
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;

	Owner.MakeNoise(fNoiseFactor);
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 
	EndTrace = StartTrace + TraceDist * X; 
	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True);
	if (Other==None)
		HitLocation = EndTrace;

	if (ThirdPersonActor!=None)
	{
		ZombieWeaponAttachment(ThirdPersonActor).HitLoc=HitLocation;
		ZombieWeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
	}
}

simulated function RequestBrassSound()
{
	if( BrassEjectBone != 'none' && bEjectedbrass )
	{
		BrassSoundLevelTime = Level.TimeSeconds + DelayBeforeBrassSound;
		bBrassTinklePending = true;
		bEjectedbrass = false;
	}
}

simulated function PlayBrassSound()
{
	local Pawn			P;
	local PlayerController PC;
	local vector		HitLocation, HitNormal, TraceEnd;
	local material		mStandingOn;
	local byte			byteType; 
	local bool			bFoundMat;
	local actor			Other;

	bBrassTinklePending = false;

	P = Pawn(Owner);
	if(P != None)
	{
		PC = SFRMPlayerController(P.Controller);
	}

	// Find what material the brass would likely fall on
	TraceEnd = Location + vect( 0, 0, -260 );
	Other = Trace( HitLocation, HitNormal, TraceEnd,,,, mStandingOn );
	if( mStandingOn != None )
	{
		byteType = mStandingOn.MaterialType;
		if( byteType != EMATERIALTYPE_SKY )
			bFoundMat = true;
	}
//	Log("ZombieWeapon.PlayBrassSound  byteType:"$byteType );

	// Play brass tinkle sound
	if( bFoundMat )
	{
		if(PC == None)
			PlaySound(BrassSound[byteType],SLOT_Misc,,,240.0);  // arg 2: slot, arg 5: radius
		else
			PlaySound(BrassSound[byteType],SLOT_Interface,,,240.0);  // arg 2: slot, arg 5: radius
	}
}

state NormalFire
{
	ignores ForceReload, Zoom;

	function ServerFire()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  NormalFire.ServerFire  BC:"$ BurstCounter $"  L.TS:"$ Level.TimeSeconds $"  TOLS:"$ TimeOfLastShot $"  dt:"$ (Level.TimeSeconds-TimeOfLastShot) );
		if( BurstCounter < 3 )
			Global.ServerFire();
	}

	function AnimEnd(int Channel)
	{
		if ( NeedsToReload() )
		{
		//	log("   Brass tinkle");
			RequestBrassSound();
		}

		Super.AnimEnd(Channel);
	}

	function Finish()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"    ZombieWeapon.NormalFire.Finish   RC:"$ ReloadCount ); 

		if( NeedsToReload() || !HasAmmo() || !bWantToFire || !ShouldRespondToPressingFire() )
		{
			Global.Finish();
		}
		else if( BurstCounter < 3 )
		{
			// For a low number of shots in a burst, force server to wait for client before
			// going on to next shot.
			// This will help keep number of shots fired by server in sync with number of
			// of fire anims played by client for small bursts.  Only really concerned about
			// small bursts because it's harder for someone to notice an extra shot in a
			// large burst (e.g. 2 shots where 1 was expected is much more obvious than 7
			// shots where 6 were expected).
		//	Log("    Kickme!!!!  BC:"$ BurstCounter $"  RC:"$ ReloadCount );
			bWantToFire=false;
			GotoState('Idle');
		}
		else if( Level.GRI.bGameEnded )
		{
			bWantToFire=false;
			GotoState('Idle');
		}
		else
		{
			Global.ServerFire();
		}
	}

	simulated function Tick(float TimeDelta)
	{
		if( Instigator.IsLocallyControlled() && Level.TimeSeconds > TimeOfLastShot + 0.06 )
		{
			AmbientGlow = default.AmbientGlow;  // MAT: ambient glow self-flash
			if( WeapAttachment != None )
				WeapAttachment.AmbientGlow = WeapAttachment.default.AmbientGlow;
		}
		Global.Tick( TimeDelta );
	}

	function EndState()
	{
	//	Log(Level.Hour $":"$ Level.Minute $":"$ Level.Second $"."$ Level.Millisecond $"  ZombieWeapon.NormalFire.EndState    ");
		if( Instigator.IsLocallyControlled() )
		{
			AmbientGlow = default.AmbientGlow;  // MAT: ambient glow self-flash
			if( WeapAttachment != None )
				WeapAttachment.AmbientGlow = WeapAttachment.default.AmbientGlow;
		}
		RequestBrassSound();
		CalcTimeOfNextNonSubtle();
		Super.EndState();
	}
}

//
// Zooming/unzooming states and functions
//

simulated function RestorePVSkelMeshRotOffset()
{
	local rotator SkelMeshRotOffset;

	SkelMeshRotOffset.Pitch=0;
	SkelMeshRotOffset.Roll=0;
	SkelMeshRotOffset.Yaw=0;
//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, SkelMeshRotOffset );
	NeutralPlayerViewRotationOffset = SkelMeshRotOffset;
}

simulated event bool IsFullyZoomed()
{
	return bZoomed;
}

simulated event bool IsZooming()
{
	return bDoingZoom;
}

simulated function ChangePVMuzzleLocZoom( bool newZoom )
{
	local PlayerController pc;
	pc = PlayerController(instigator.controller);
	if( pc == None )
		return;
	else
		ChangePVMuzzleLocZoomLean( newZoom, pc.bLeanView );
}

simulated function ChangePVMuzzleLocLean( bool newLean )
{
	ChangePVMuzzleLocZoomLean( bZoomed, newLean );
}

simulated function ChangePVMuzzleLocZoomLean( bool newZoom, bool newLean )
{
	local PlayerController pc;
	pc = PlayerController(instigator.controller);
	if( pc == None )
		return;

//ZOOMLEANSPAM	Log("ChangePVMuzzleLoc   zoom:"$ bZoomed $"  lean:"$ newLean );
	if( newZoom )
	{
		if( newLean )
			PVMuzzleLocation = PVMuzzleLocationZoomLean;
		else
			PVMuzzleLocation = PVMuzzleLocationZoomed;
	}
	else
	{
		if( newLean )
			PVMuzzleLocation = PVMuzzleLocationLean;
		else
			PVMuzzleLocation = default.PVMuzzleLocation;
	}

}

simulated function MoveToZoomPV( float time, bool newZoom )
{
	// If player is currently leaning and weapon does not have a scope,
	// then "pre-position" zoom

	if( PlayerController(instigator.controller) != None && PlayerController(instigator.controller).bLeanView )
		MoveToZoomLeanPV( time, newZoom, true, !(HasAnim(xScopeOffAnim) || bHasScope) );
	else
		MoveToZoomLeanPV( time, newZoom, false, false );
}

simulated function MoveToLeanPV( float time, bool newLean )
{
	MoveToZoomLeanPV( time, bZoomed, newLean );
	ChangePVMuzzleLocLean( newLean );
}

// Moves to a new playerview offset and playerview rotation offset for a new
// zoom or lean state.
// -If optional bool zoomPrePosition is set true and player is leaning, then the
//  playerview offset will be pre-positioned to a good starting value before 
//  starting interpolation.  (It's a hack that makes sideways snapping of weapon
//  not quite as bad looking).
// -For scoped weapons with no scope on anim, this function will move the weapon 
//  to a PV offset forward of the final target.  Moving back towards the final
//  target will be taken care of in state RaisingScope.
simulated function MoveToZoomLeanPV( float time, bool newZoom, bool newLean, optional bool zoomPrePosition )
{
//ZOOMLEANSPAM	Log("MoveToLeanPV  newLean:"$ newLean $"  bZoomed:"$ bZoomed );
	if( newLean )
	{
		if( newZoom )
		{
		//ZOOMLEANSPAM	Log("     [x]zoom [x]lean");
		//	NeutralPlayerViewRotationOffset = ZoomLeanRotationOffset;
		//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, NeutralPlayerViewRotationOffset );
			StartPVRotOffInterpolation( time*0.8, ZoomLeanRotationOffset );
			if( zoomPrePosition && ZoomLeanPlayerViewOffset.Y != 0 )
			{
			//ZOOMLEANSPAM		Log("   zl zoomPrePosition ");
				PlayerViewOffset.Y = ZoomLeanPlayerViewOffset.Y;
				NeutralPlayerViewOffset.Y = PlayerViewOffset.Y;
			}
			if( bHasScope && !HasAnim( xScopeOnAnim ) )
				StartPVOInterpolation( time, ZoomLeanPlayerViewOffset-ScopeFinalSegment );
			else
				StartPVOInterpolation( time, ZoomLeanPlayerViewOffset );
		}
		else 
		{
		//ZOOMLEANSPAM		Log("     [ ]zoom [x]lean");
		//	NeutralPlayerViewRotationOffset = LeanRotationOffset;
		//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, NeutralPlayerViewRotationOffset );
			StartPVRotOffInterpolation( time*0.8, LeanRotationOffset );
			if( zoomPrePosition && LeanPlayerViewOffset.Y != 0 )
			{
			//ZOOMLEANSPAM		Log("   _l zoomPrePosition ");
				PlayerViewOffset.Y = LeanPlayerViewOffset.Y;
				NeutralPlayerViewOffset.Y = PlayerViewOffset.Y;
			}
			StartPVOInterpolation( time, LeanPlayerViewOffset );
		}

	}
	else
	{
		if( newZoom )
		{
		//ZOOMLEANSPAM	Log("     [x]zoom [ ]lean");
		//	NeutralPlayerViewRotationOffset = ZoomRotationOffset;
		//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, NeutralPlayerViewRotationOffset );
			StartPVRotOffInterpolation( time*0.8, ZoomRotationOffset );
			if( bHasScope && !HasAnim( xScopeOnAnim ) )
				StartPVOInterpolation( time, ZoomPlayerViewOffset-ScopeFinalSegment );
			else
				StartPVOInterpolation( time, ZoomPlayerViewOffset );
		}
		else 
		{
		//ZOOMLEANSPAM	Log("     [ ]zoom [ ]lean");
		//	NeutralPlayerViewRotationOffset.Pitch = 0;
		//	NeutralPlayerViewRotationOffset.Roll  = 0;
		//	NeutralPlayerViewRotationOffset.Yaw   = 0;
		//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, NeutralPlayerViewRotationOffset );
			TargetPlayerViewRotationOffset.Pitch = 0;
			TargetPlayerViewRotationOffset.Roll  = 0;
			TargetPlayerViewRotationOffset.Yaw   = 0;
			StartPVRotOffInterpolation( time*0.8, TargetPlayerViewRotationOffset );
			StartPVOInterpolation( time, default.PlayerViewOffset );
		}
	}
//ZOOMLEANSPAM	Log("     NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );
}

simulated function Zoom()
{
	Instigator.Acceleration = vect(0, 0, 0);
//	Log("ZombieWeapon.Zoom           t (ms):"$Level.TimeSeconds*1000 $"  bDoingZoom:"$bDoingZoom );

	if( !bCanZoom )
		return;

	if( !bZoomed )
	{
		if( Level.TimeSeconds > TimeOfLastZoomSound + 0.20 
		 && Level.TimeSeconds > TimeOfLastShot + 0.20 )
		{
			PlayerController(Pawn(Owner).Controller).ClientPlaySound(ZoomInSound, , ,SLOT_Interface);
			TimeOfLastZoomSound = Level.TimeSeconds;
		}

		bDoingZoom=true;
		ServerSetDoingZoom( bDoingZoom );
		GotoState('RaisingScope');  // This will go to Zooming when it's done
	}
	else
	{
		if( Level.TimeSeconds > TimeOfLastZoomSound + 0.30 
		 && Level.TimeSeconds > TimeOfLastShot + 0.20 )
		{
			PlayerController(Pawn(Owner).Controller).ClientPlaySound(ZoomOutSound, , ,SLOT_Interface);
			TimeOfLastZoomSound = Level.TimeSeconds;
		}

		GotoState('Zooming');  // This will go to lowering scope when it's done
	}
}

simulated function UnZoom()
{
	//if we're tossing a quick grenade forward unzoom requests to the new grenade
	if (IsInState('DownWeapon') && Pawn(Owner).pendingWeapon.IsA('ABSTRACT_WeapGrenade'))
	{
		ZombieWeapon(Pawn(Owner).pendingWeapon).UnZoom();
		return;
	}
	
	//	Log("ZombieWeapon.UnZoom         t (ms):"$Level.TimeSeconds*1000 );
	if( bZoomed && bHasScope )
	{
		GotoState('Zooming');  // This will go to lowering scope when it's done
		BeginState();  // If it's already in state zooming, still need Zooming.BeginState to be called.
	}
	else
	{
		// Otherwise, it's not fully zoomed (still doing scope-on/off) 
		// or it doesn't have a scope on/off animation.
		// So it's ok to take a more direct route.
		UnZoomFaster();
	}
}

// This function is for situations where a fast unzoom is needed, so it's
// ok if the scope-off animation is interrupted or not played at all.
simulated function UnZoomFaster()
{
//	Log("ZombieWeapon.UnZoomFaster   t (ms):"$Level.TimeSeconds*1000 );
	bDoingZoom=false;
	ServerSetDoingZoom( bDoingZoom );
	EndZoom();
	if( HasAnim(xScopeOffAnim) )
		PlayAnim(xScopeOffAnim,1.00 );
	else
	{
		//StartPVOInterpolation( 0.2, default.PlayerViewOffset );
		MoveToZoomPV( 0.1, false );
	//ZOOMLEANSPAM	Log("UnZoomFaster  NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );
	}
	GotoState('Idle');
}

function ServerSetDoingZoom( bool newbDoingZoom )
{
//	Log("ZombieWeapon.ServerSetDoingZoom  newbDoingZoom:"$ newbDoingZoom );
	bDoingZoom = newbDoingZoom;
}

function ServerSetZoomed( bool newbZoomed )
{
//	Log("ZombieWeapon.ServerSetZoomed  newbZoomed:"$ newbZoomed );
	bZoomed = newbZoomed;
}

// Used to buffer additional zoom click requests.
//  Returning true means it can accept things in the buffer.
//  Returning false means it can't accept things in the buffer (usually
//  because it can handle the input right away).
simulated function bool ForceNextZoomPhase()
{
	return false;
}

simulated state RaisingScope
{
	ignores Fire, AltFire, ForceReload;

	simulated function UnZoomFaster()
	{
	//	NeutralPlayerViewOffset = default.PlayerViewOffset;
		if( PlayerController(instigator.controller) != None && PlayerController(instigator.controller).bLeanView )
			CancelPVOInterpolation( default.LeanPlayerViewOffset );
		else
			CancelPVOInterpolation( default.PlayerViewOffset );
	//	Log("RaisingScope  UnZoomFaster  NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );

		bDoingZoom=false;
		ServerSetDoingZoom( bDoingZoom );
		abortScopeRaise=true;
	}

	simulated function MoveToLeanPV( float time, bool newLean )
	{
		if( HasAnim( xScopeOnAnim ) )
		{
			return;
		}
		else if( bHasScope )
		{
			return;
		}
		else
		{
			MoveToZoomLeanPV( time, true, newLean );
			ChangePVMuzzleLocLean( newLean );
		}
	}

	// Used to buffer additional zoom click requests.
	//  Returning true means it can accept things in the buffer.
	//  Returning false means it can't accept things in the buffer (usually
	//  because it can handle the input right away).
	simulated function bool ForceNextZoomPhase()
	{
		// Force weapon to go to next zooming phase
		if( fFOVChangeMax > 0 && fFOVChangeMax > fFOVChangeMin )
		{
			forceZoomFinishCounter++;
			GotoState('Zooming');
		}
		else
		{
			// If this weapon has no zoom adjustment, abort scope raise
			forceZoomFinishCounter=0;
		//	abortScopeRaise = true;
			CancelScopeRaise();
		}
		return true;
	}

Begin:
//	Log("ZombieWeapon RaisingScope Begin:   t (ms):"$Level.TimeSeconds*1000 $"  bDoingZoom:"$bDoingZoom $"  abortScopeRaise:"$abortScopeRaise );
	abortScopeRaise=false;

	// Play scope-raising anim, if any.
	if( HasAnim( xScopeOnAnim ) )
	{
		if( Instigator!= None && Instigator.bIsCrouched )
			PlayAnim(xScopeOnAnim,1.25);
		else
			PlayAnim(xScopeOnAnim,1.00);

		// As scope-raising anim plays, move the PVOffset back towards
		// the default (no lean, no zoom) so that the anim will end in
		// the right place
	//	StartPVOInterpolation( 0.08, default.PlayerViewOffset );
	//	StartPVOInterpolation( fScopeRaiseDuration, default.PlayerViewOffset );
		MoveToZoomLeanPV( fScopeRaiseDuration, false, false );

		Sleep(fScopeRaiseDuration);

		//if( !abortScopeRaise )
		//	FinishAnim();
	}
	else
	{
		// If no scope-raising anim, raise the weapon iron-sight zoom style

		// Set a fixed frame
		SetAnimFrame( 0.0 );

		// Raise weapon
		MoveToZoomPV( FMax(0.05,fScopeRaiseDuration-0.15), true );
	//ZOOMLEANSPAM	Log("RaisingScope  Begin:  NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );

		if( bHasScope )
		{
			Sleep(fScopeRaiseDuration-0.15);

			// Force it to reach the right position
			CancelPVOInterpolation( TargetPlayerViewOffset );

			// Move towards player
			StartPVOInterpolation( 0.15, TargetPlayerViewOffset+ScopeFinalSegment );
			Sleep( 0.15 );
		}
	}

	if( !abortScopeRaise )
	{
		GotoState('Zooming');
	}
	else
	{
		CancelScopeRaise();
	}
}

simulated function CancelScopeRaise()
{
	bDoingZoom			= false;
	bZoomed				= false;
	ServerSetDoingZoom( bDoingZoom );
	ServerSetZoomed( bZoomed );
	if (Instigator.Controller.bIsPlayer)
	{
		PlayerController(Instigator.Controller).ResetFOV();
	//	PlayerController(Instigator.Controller).setLean(false);

		if( PlayerController(Instigator.Controller).bLeanView )
			CancelPVOInterpolation( default.LeanPlayerViewOffset );
		else
			CancelPVOInterpolation( default.PlayerViewOffset );
	}
	abortScopeRaise=false;

	GotoState('Idle');
}

simulated state LoweringScope
{
	ignores Fire, AltFire, ForceReload;

Begin:
//	Log("ZombieWeapon LoweringScope  t (ms):"$Level.TimeSeconds*1000 $"  bDoingZoom:"$bDoingZoom );
	EndZoom();
	if( HasAnim(xScopeOffAnim) )
	{
		// Have the scope-lowering anim start from the default
		// position (so that the anim will start at the right plice
		CancelPVOInterpolation( default.PlayerViewOffset );

		if( Instigator != None && Instigator.bIsCrouched )
			PlayAnim(xScopeOffAnim,1.25);
		else
			PlayAnim(xScopeOffAnim,1.00);

		// As scope-lowering anim plays, move the PVOffset towards
		// the current appropriate target value so that the
		// anim will end in the right place
		MoveToZoomPV( fZoomOutDuration*1.3, false );

		//FinishAnim();
		Sleep( FMin(fZoomOutDuration*0.5,0.08) );
	}
	else //if( bHasScope )
	{
		// If no scope-lowering anim, lower the weapon iron-sight (un)zoom style

		if( bHasScope )
		{
			StartPVOInterpolation( 0.09, PlayerViewOffset-ScopeFinalSegment );
			Sleep( 0.09 );
		}

		MoveToZoomPV( fZoomOutDuration, false );
	//ZOOMLEANSPAM	Log("LoweringScope Begin:   NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );

		Sleep( FMin(fZoomOutDuration*0.5,0.08) );
	}

	bDoingZoom=false;
	ServerSetDoingZoom( bDoingZoom );
	GotoState('Idle');
}

simulated state Zooming
{
	ignores Finish, ClientFinish;  // Fixes bug where zoom will sometimes snap in

	simulated function Fire(optional float F);
	simulated function AltFire(optional float F); 
	simulated function ForceReload(); 
	simulated function NextWeaponFunction();
	simulated function PrevWeaponFunction(); 

	simulated function AdjustZoomIn() {}
	simulated function AdjustZoomOut() {}

	simulated function StepZoomIn() {}
	simulated function StepZoomOut() {}

	simulated function bool IsZoomed()
	{
		return false;
	}

	simulated function bool PutDown()
	{
		bChangeWeapon = true;
		return True;
	}

	simulated function AnimEnd(int Channel)
	{
		if ( Role == ROLE_Authority )
		{
			Finish();
		}
		else
		{
			ClientFinish();
		}
	}

	// Used to buffer additional zoom click requests.
	//  Returning true means it can accept things in the buffer.
	//  Returning false means it can't accept things in the buffer (usually
	//  because it can handle the input right away).
	simulated function bool ForceNextZoomPhase()
	{
		forceZoomFinishCounter++;
		return true;
	}

	simulated function Tick(float TimeDelta)
	{
		local float CurFOV;

		Super.Tick(TimeDelta); 		

		fCurFOVChange += TimeDelta;
		CurFOV = FClamp(90.0 - (((1 / fZoomInDuration) * fCurFOVChange) * fFOVChange), 90 - fFOVChange, 170);	
	
		PlayerController(Instigator.Controller).SetFOV(CurFOV);

		DisplayFOV = FClamp(CurFOV / 2, 30.0, default.DisplayFOV); 

		if( PVOTransitionTime > 0.0 )
		{
			InterpolatePVO( TimeDelta );
		}
		if( PVRotOffTransitionTime > 0.0 )
		{
			InterpolatePVRotOff( TimeDelta );
		}

		if( !bHasScope )
		{
			//if( VSize(PlayerViewOffset - ZoomPlayerViewOffset) > 2.0 )
			//	NeutralPlayerViewOffset = (ZoomPlayerViewOffset-default.PlayerViewOffset)*TimeDelta/0.22 + PlayerViewOffset;
			//else
			//	NeutralPlayerViewOffset = (PlayerViewOffset + ZoomPlayerViewOffset)*0.5;

		//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, ZoomRotationOffset );
			NeutralPlayerViewRotationOffset = ZoomRotationOffset;
		}
		
		if ( Level.TimeSeconds - fZoomStartTime > abs(fZoomInDuration) )
		{
			if (!bZoomed)
			{
				PlayerController(Instigator.Controller).ResetFOV();
				DisplayFOV = default.DisplayFOV;
			}

			GotoState('Idle'); 
			return; 
		}
	}

	simulated function BeginState()
	{

		local PlayerController PC;
		local Vector X,Y,Z;
		local Vector Start;

		PC = PlayerController(Instigator.Controller);
		
		if(!bZoomed)
		{	
			GetAxes(Instigator.GetViewRotation(),X,Y,Z);
			Start = GetFireStart(X,Y,Z);
			
			PC.SetRotation(FindTarget(Start, AimError));
		}
		
		if ( PC == None ) 
			return; 

		if ( bZoomed )
		{
			EndZoom();
			GotoState('LoweringScope');	// play lower anim and reset weapon
		}
		else
		{
			StartZoom();
			if( forceZoomFinishCounter == 0 && Instigator != None && ZoomMagnificationInSound != None )
			{
				Instigator.PlaySound(ZoomMagnificationInSound,SLOT_Interface);
			}
		}
	}
	
	simulated function EndState()
	{
		// If zoom-in didn't have a chance to finish by now, then force the zoom all the way in.
		if( bZoomed && PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChange) )
		{
		//	Log("ZombieWeapon  state Zooming:  EndState  Forced zoom-in to finish.  Desired CurFOV:"$90.0 - fFOVChange );
			PlayerController(Instigator.Controller).SetFOV(90 - fFOVChange);
			DisplayFOV = FClamp((90 - fFOVChange) / 2, 30.0, default.DisplayFOV);
		}

		if( bHasScope || HasAnim(xScopeOnAnim) )
		{
			if( bZoomed && Owner != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
			{
				//SFRMPlayerController(Pawn(Owner).Controller).SetCHIndex(GetCrosshairIndexForNone(), WeaponIconIndex);
				BasicHUD(PlayerController(Pawn(Owner).Controller).myhud).SetScopeMode(true, true);
			}
		}
		else if( bZoomed )
		{
			if( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bLeanView )
			{
				NeutralPlayerViewOffset = ZoomLeanPlayerViewOffset;
				NeutralPlayerViewRotationOffset = ZoomLeanRotationOffset;
			}
			else
			{
				NeutralPlayerViewOffset = ZoomPlayerViewOffset;
				NeutralPlayerViewRotationOffset = ZoomRotationOffset;
			}
			SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, NeutralPlayerViewRotationOffset );
		}

	//	if( bZoomed )
	//		PVMuzzleLocation = PVMuzzleLocationZoomed;
		ChangePVMuzzleLocZoom( bZoomed );

		// Handle buffered zoom clicks
		while( forceZoomFinishCounter > 0 )
		{
			// Keep stepping in zoom while we can
			if( InstantStepZoomIn() )
			{
				forceZoomFinishCounter--;
			}
			else
			{
				// If we couldn't step zoom in anymore, then unzoom
				forceZoomFinishCounter = 0;
				UnZoomFaster();
			}
		}
	}

	simulated function rotator FindTarget(vector projStart, int aimerror)
	{
		local vector FireDir, AimSpot, HitNormal, HitLocation;
		local actor BestTarget;
		local float bestFOV, curFOV;
		local float Adjacent,Opposite,Hypotenuse;
		local bool ZAdjust;
		
		local Controller P;
		local PlayerController PC;
		
		PC = PlayerController(Instigator.Controller);
		
		if ((Level.Game != None && Level.Game.GameDifficulty > 4) || bUseMPDiffHack )
		{
			if (PC.bBehindView)
				return PC.Pawn.Rotation;
			else
				return PC.Rotation;
		}
		
		if( Level.Game != None && Level.Game.GameDifficulty == 0 )
		{
			ZAdjust = true;
		}

		FireDir = vector(PC.Rotation);
		
		
		//If we were already aiming at a pawn early out.
		BestTarget = Trace(HitLocation, HitNormal, projStart + 100000 * FireDir, projStart, true);	
		if ( (BestTarget != None) && BestTarget.bProjTarget )
		{
			if (PC.bBehindView)
				return PC.Pawn.Rotation;
			else
				return PC.Rotation;
		}

		BestTarget = None;
		for(P=Level.ControllerList; P!=None; P=P.NextController)
		{
			// Note: 
			// 1. The following if-statement depends on short-circuiting of the logic, 
			//    and therefore
			// 2. It requires the check for ZombiePawn(P.Pawn) != None to come 
			//    before any use of ZombiePawn(P.Pawn).Faction.
			if( (P != PC) && (ZombiePawn(P.Pawn) != None ) &&
				(ZombiePawn(P.Pawn).GetFaction ( ) != ZombiePawn(PC.Pawn).GetFaction ( )) &&
				(FastTrace(projStart,P.Pawn.Location)) )
			{	
				AimSpot = (P.Pawn.Location - ProjStart);
				curFOV = Normal(FireDir) Dot Normal(AimSpot);
				Hypotenuse = VSize(AimSpot);
				Adjacent = curFOV * Hypotenuse;
				Opposite = (Hypotenuse * Hypotenuse) - (Adjacent * Adjacent);
				
				//Log(P.Pawn@"H:"@Hypotenuse@"A:"@Adjacent@"O:"@Opposite@"Radius:"@AutoTargetRadiusSquared[Level.Game.GameDifficulty]);
				
				if(Opposite <= AutoTargetRadiusSquared[Level.Game.GameDifficulty])
				{											
									
					//Log(P.Pawn@"Current FOV:"@curFOV@"Best FOV"@bestFOV);
					if(curFOV > bestFOV)
					{
						bestFOV = curFOV;
						BestTarget = P.Pawn;
					}
				}
			}
		}
			
		if(BestTarget != None)
		{
			//Log("Returning:"@BestTarget@BestTarget.Location@BestTarget.Location - projStart);
			AimSpot = (BestTarget.Location - ProjStart);
			if(ZAdjust)
			{
				AimSpot.Z += Pawn(BestTarget).EyeHeight;
			}
			else
			{
				AimSpot.Z += Pawn(BestTarget).EyeHeight/2;
			}
			return rotator(AimSpot); 
		}
				
		//Fall Thru no suitable target.
		if (PC.bBehindView)
			return PC.Pawn.Rotation;
		else
			return PC.Rotation;
	}
}

//
// Functions and state that are used to vary the zoom (typically with D-pad)
// Zoom will vary when control is held down.
//

simulated function AdjustZoomIn()
{
//	Log("AdjustZoomIn ");
	if( fFOVChangeMax > 0 && PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) )
	{
		fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
		ZoomDelta = -((fFOVChangeMax-fFOVChangeMin)/10.0);
		fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
		ZoomAdjustStartTime = Level.TimeSeconds;
		IsAdjustingZoom = true;
		GotoState('AdjustingZoom');
	}
}

simulated function AdjustZoomOut()
{
//	Log("AdjustZoomOut ");
	if( fFOVChangeMax > 0 && PlayerController(Instigator.Controller).FOVAngle < (90 - fFOVChangeMin) )
	{
		fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
		ZoomDelta = ((fFOVChangeMax-fFOVChangeMin)/10.0);
		fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
		ZoomAdjustStartTime = Level.TimeSeconds;
		IsAdjustingZoom = true;
		GotoState('AdjustingZoom');
	}
}

simulated function AdjustZoomStop()
{
//	Log("AdjustZoomStop !!!!!!!");
	IsAdjustingZoom=false;
}

state AdjustingZoom
{
//	ignores AdjustZoomIn, AdjustZoomOut;
	simulated function AdjustZoomIn()
	{
	//	Log("AdjustingZoom.AdjustZoomIn ");
		if( PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) 
		 && fFOVAdjustTarget > (90 - fFOVChangeMax) )
		{
			fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
			ZoomDelta = -((fFOVChangeMax-fFOVChangeMin)/10.0);
			fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
			ZoomAdjustStartTime = Level.TimeSeconds;
			IsAdjustingZoom = true;
		}
	}

	simulated function AdjustZoomOut()
	{
	//	Log("AdjustingZoom.AdjustZoomOut ");
		if( PlayerController(Instigator.Controller).FOVAngle < (90 - fFOVChange) 
		 && fFOVAdjustTarget < (90 - fFOVChange) )
		{
			fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
			ZoomDelta = ((fFOVChangeMax-fFOVChangeMin)/10.0);
			fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
			ZoomAdjustStartTime = Level.TimeSeconds;
			IsAdjustingZoom = true;
		}
	}

	simulated function Tick(float TimeDelta)
	{
		local float totalFOVdelta, FOVdelta, currentFOV;
		
		Super.Tick(TimeDelta); 		

		totalFOVdelta = (fFOVAdjustTarget-fFOVAdjustStart);

		// Find FOV adjustment for this time increment
		FOVdelta = (totalFOVdelta)*TimeDelta/(fZoomInDuration*0.10);
		currentFOV = PlayerController(Instigator.Controller).FOVAngle;
		if( (currentFOV == (90-fFOVChangeMin) && ZoomDelta > 0 )
		 || (currentFOV == (90-fFOVChangeMax) && ZoomDelta < 0 ) )
		{
			IsAdjustingZoom = false;
			GotoState('Idle');
			return;
		}

	//	Log("  OOOOooooo.... t:"$Level.TimeSeconds $"  dt:"$TimeDelta $"     FOV:"$currentFOV $"  delta:"$FOVDelta $"   new FOV:"$currentFOV+FOVdelta );

		// If it hasn't hit the limit, then apply the FOVdelta
		if( abs(FOVdelta) < abs(fFOVAdjustTarget-currentFOV) )
			PlayerController(Instigator.Controller).SetFOV( currentFOV + FOVdelta );
		else
			PlayerController(Instigator.Controller).SetFOV( fFOVAdjustTarget );

		// If we've hit the time limit and player hasn't let up on zoom, go to next zoom step
		if( Level.TimeSeconds >= ZoomAdjustStartTime + 0.10*fZoomInDuration && IsAdjustingZoom )
		{
			SetNextStep();
		}

		if( !IsAdjustingZoom )		
		{
			GotoState('Idle');
		}
	}

	simulated function SetNextStep()
	{
		ZoomAdjustStartTime = Level.TimeSeconds;
		if(PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) 
		&& PlayerController(Instigator.Controller).FOVAngle < (90 - fFOVChangeMin) )
			fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
	}

	simulated function EndState()
	{
		// Force the zoom adjustment to the final desired value 
		if( PlayerController(Instigator.Controller).FOVAngle != fFOVAdjustTarget )
		{
			PlayerController(Instigator.Controller).SetFOV(fFOVAdjustTarget);
		//	Log("OOOOOOooooo     t:"$Level.TimeSeconds $"   FOV:"$fFOVAdjustTarget );
		}

		// If needed, keep last zoom setting
		if( bKeepLastZoomSetting )
			fFOVChange = 90 - PlayerController(Instigator.Controller).FOVAngle;
	}
}


//
// Functions and state that are used to step the zoom (typically with mouse wheel)
// Zoom will increment a (small) step when mouse wheel is turned a notch
//

simulated function float CalcZoomDelta()
{
	return (fFOVChangeMax-fFOVChangeMin);
}

// Steps zoom in instantly, with no transition.
//  Returns true if it was able to adjust zoom, false if it is already at a limit
simulated function bool InstantStepZoomIn()
{
	if( fFOVChangeMax > 0 && PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) )
	{
		// Only play zoom mag adjust sound if this is the last snap adjustment
		if( forceZoomFinishCounter == 1 && Instigator != None && ZoomMagnificationInSound != None )
		{
			Instigator.PlaySound(ZoomMagnificationInSound,SLOT_Interface);
		}

		fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
		ZoomDelta = -CalcZoomDelta();
		fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
		PlayerController(Instigator.Controller).SetFOV( fFOVAdjustTarget );
		return true;
	}
	else
		return false;
}

simulated function StepZoomIn()
{
//	Log("StepZoomIn ");
//	Log("StepZoomIn   FOV:"$ PlayerController(Instigator.Controller).FOVAngle $" gt  (90-fFOVChangeMax):"$ (90-fFOVChangeMax) );
//	Log("    state:"$ GetStateName() );
//	Log("    fFOVChangeMax:"$ fFOVChangeMax $"  fFOVChangeMin:"$ fFOVChangeMin  );
	if( fFOVChangeMax > 0 && PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) )
	{
		if( Instigator != None && ZoomMagnificationInSound != None )
		{
			Instigator.PlaySound(ZoomMagnificationInSound,SLOT_Interface);
		}

		fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
		ZoomDelta = -CalcZoomDelta();
		fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
		ZoomAdjustStartTime = Level.TimeSeconds;
		IsAdjustingZoom = true;
	//	Log("    ZoomDelta:"$ ZoomDelta $"  fFOVAdjustTarget:"$ fFOVAdjustTarget  );
		GotoState('SteppingZoom');
	}
}

simulated function StepZoomOut()
{
//	Log("StepZoomOut ");
	if( fFOVChangeMax > 0 && PlayerController(Instigator.Controller).FOVAngle < (90 - fFOVChangeMin) )
	{
		fFOVAdjustStart = PlayerController(Instigator.Controller).FOVAngle;
		ZoomDelta = CalcZoomDelta();
		fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
		ZoomAdjustStartTime = Level.TimeSeconds;
		IsAdjustingZoom = true;
		GotoState('SteppingZoom');
	}
}

state SteppingZoom
{
	ignores AdjustZoomIn, AdjustZoomOut;
	ignores StepZoomIn, StepZoomOut;
	
	simulated function Tick(float TimeDelta)
	{
		local float totalFOVdelta, FOVdelta, currentFOV;
		
		Super.Tick(TimeDelta); 		

		totalFOVdelta = (fFOVAdjustTarget-fFOVAdjustStart);

		// Find FOV adjustment for this time increment
		FOVdelta = (totalFOVdelta)*TimeDelta/(fZoomInDuration*0.10);
		currentFOV = PlayerController(Instigator.Controller).FOVAngle;
	//	Log("  OOOOooooo.... t:"$Level.TimeSeconds $"  dt:"$TimeDelta $"     FOV:"$currentFOV $"  delta:"$FOVDelta $"   new FOV:"$currentFOV+FOVdelta );

		// If it hasn't hit the limit, then apply the FOVdelta
		if( abs(FOVdelta) < abs(fFOVAdjustTarget-currentFOV) )
			PlayerController(Instigator.Controller).SetFOV( currentFOV + FOVdelta );
		else
			PlayerController(Instigator.Controller).SetFOV( fFOVAdjustTarget );

		if( Level.TimeSeconds >= ZoomAdjustStartTime + 0.10*fZoomInDuration )
		{
			GotoState('Idle');
		}
	}

/*	simulated function SetNextStep()
	{
		ZoomAdjustStartTime = Level.TimeSeconds;
		if(PlayerController(Instigator.Controller).FOVAngle > (90 - fFOVChangeMax) 
		&& PlayerController(Instigator.Controller).FOVAngle < (90 - fFOVChangeMin) )
			fFOVAdjustTarget   = PlayerController(Instigator.Controller).FOVAngle + ZoomDelta;
	}
*/
	simulated function EndState()
	{
		// Force the zoom adjustment to the final desired value 
		if( PlayerController(Instigator.Controller).FOVAngle != fFOVAdjustTarget )
		{
			PlayerController(Instigator.Controller).SetFOV(fFOVAdjustTarget);
		//	Log("OOOOOOooooo     t:"$Level.TimeSeconds $"   FOV:"$fFOVAdjustTarget );
		}

		// If needed, keep last zoom setting
		if( bKeepLastZoomSetting )
			fFOVChange = 90 - PlayerController(Instigator.Controller).FOVAngle;

		IsAdjustingZoom = false;
	}
}


simulated function float GetZoomPower()
{
	local float DefaultFOV;

	if( PlayerController(instigator.controller).FOVAngle <= 0 )
		return 16000.0;
	else
	{
		// Clamp the return values (so even if the actual zoom power is a little past the
		// limits but close enough, the player won't know)
		DefaultFOV = PlayerController(instigator.controller).DefaultFOV;
		return FClamp( DefaultFOV/(instigator.controller.FOVAngle),
					   DefaultFOV/(90-fFOVChangeMin), DefaultFOV/(90-fFOVChangeMax) );
	}
}

// Goes from 0.0 (min zoom) to 1.0 (max zoom)
simulated function float GetZoomFraction()
{
	local float currentFOVChange;

	if( PlayerController(instigator.controller).FOVAngle <= 0 )
		return 16000.0;
	else
	{
		currentFOVChange = 90 - PlayerController(instigator.controller).FOVAngle;
		return FClamp( (currentFOVChange-fFOVChangeMin)/(fFOVChangeMax-fFOVChangeMin), 0.0, 1.0);
	}
}

simulated function float GetZoomSwayFraction();


//
// Reloading state
//

simulated state Reloading
{
	
	simulated function PlayFiring()
	{
		bMuzzleFlash=False;
		bDrawMuzzleFlash=False; 
	}

	simulated function ReleaseFire( optional float F )
	{
	//	log(self$" "$GetStateName()$"::ReleaseFire");
		bReleasedFireSinceLastShot=true;
		//log("   Brass tinkle: NO!!!");
	}

	simulated function BeginState()
	{
		//Log("ZombieWeapon.Reloading.BeginState ");
		BurstCounter = 0;
		bJustPlayedDryFire = false;

		if (bZoomed)		// zoom out if a weapon is zoomed in duing reload
			UnZoomFaster(); 

		if( Ammunition(Pawn(Owner).FindInventoryType(default.AmmoName)).HasAmmo() )
		{
			if( ZombieBipedPawn ( Instigator ) != None )
				ZombieBipedPawn ( Instigator ).PlayReloading ( ); 
			Instigator.PlaySound(ReloadSound,SLOT_Misc,,,200.0);  // arg 2: slot, arg 5: radius
			Super.BeginState(); 
		}
		else
		{
			EndState();
		}
	}

	simulated function EndState()
	{	
		if( ZombiePlayerPawn(Instigator) != None )
		{
			ZombiePlayerPawn(Instigator).EndReloadAnim(); 		
		}

		if( Role == ROLE_Authority )
			ClientCanFireAgainPostReload();  // MAT 2/15/05
	}
	
	simulated function Zoom()
	{
	}

	simulated function UnZoomFaster()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"  ZombieWeapon.UnZoomFaster    RC:" $ ReloadCount $"   bForceReload:"$ bForceReload $"  bZoomed:"$ bZoomed );
		bDoingZoom=false;
		ServerSetDoingZoom( bDoingZoom );
		EndZoom();
		if( HasAnim(xScopeOffAnim) )
			PlayAnim(xScopeOffAnim,1.00 );
		else
		{
			//StartPVOInterpolation( 0.2, default.PlayerViewOffset );
			MoveToZoomPV( 0.15, false );
		//ZOOMLEANSPAM	Log("UnZoomFaster  NeutralPlayerViewRotationOffset:"$ NeutralPlayerViewRotationOffset $"  TargetPlayerViewOffset:"$ TargetPlayerViewOffset );
		}
	}

	simulated function Tick(float TimeDelta)  // MAT 8/31/04: Fixes problem where weapon would get stuck in state reloading
	{
		if( ReloadCount > 0 && !IsAnimating() )
			GotoState('Idle');
		else
			Global.Tick( TimeDelta );
	}
}

//

// Active	
//		When the weapon is selected
//
simulated state Active
{
	simulated function BeginState()
	{
	//	Log("ZombieWeapon.Active.BeginState");
		bCanCheckForHoldingFire=false;
		bJustSelected=true;
		if ( SFRMPlayerController(Pawn(Owner).Controller) != None )
		{
			SFRMPlayerController(Pawn(Owner).Controller).SetCHIndex(GetCrosshairIndex(), WeaponIconIndex);
		}

		// Ensure weapon is at right PV offset and PV rotation offset for the current lean state
		if( PlayerController(instigator.controller) != None && PlayerController(instigator.controller).bLeanView )
			MoveToLeanPV( 0.1, true );
		else
			MoveToLeanPV( 0.1, false );

		Super.BeginState();
	}

	simulated function EndState()
	{
	//	Log("ZombieWeapon.Active.EndState");
		Super.EndState();
		if (bZoomOnNextIdle)
		{
			Zoom();
		}

		bCanFireAgainPostReload=true;  // MAT 2/15/05
	}

Begin: 
//	Log("ZombieWeapon.Active.Begin:");
	ClientPlayerViewWeapon();
//	bJustSelected=true;
	if( ZombiePlayerPawn(Instigator) != None )
	{
		ZombiePlayerPawn(Instigator).ViewKickAdjustment = vect(0,0,0);
		SFRMPlayerController(Pawn(Owner).Controller).SetCHIndex(GetCrosshairIndex(), WeaponIconIndex);
	}
}


//DownWeapon
//	When we're switching weapons...
State DownWeapon
{
	simulated function BeginState()
	{
		// If we don't have a weapon-lowering anim, then do stuff here that
		// would be done in the anim end.
		if( !HasAnim( xHolsterAnim ) )
		{
			if( HasAnim(xSelectAnim))
			{
				PlayAnim(xSelectAnim, 0.0f, 0.02f);
				SetAnimFrame( 0.0 );
			}

			if (bGoInactiveAfterDown)
				GotoState('DownAndInactive');
			else
				Pawn(Owner).ChangedWeapon();
		}
		else
			Super.BeginState();
	}

	simulated function AnimEnd(int Channel)
	{
		// If we don't have a weapon-lowering anim, then this AnimEnd will
		// catch the end of an idle anim instead of a weapon-lowering anim.
		// In that situation, we should do nothing.
		if( HasAnim(xHolsterAnim) )
			Super.AnimEnd( Channel );
	}
}


state ClientFiring
{
	simulated function bool canQuickGrenade()
	{
		if( Level.Game == None || (SFRMMultiPlayer(Level.Game) != None))
			return false;
		else
			return true;
	}

	simulated function Tick(float TimeDelta)
	{
		if( Level.TimeSeconds > TimeOfLastShot + 0.06 )
		{
			AmbientGlow = default.AmbientGlow;  // MAT: ambient glow self-flash
			if( WeapAttachment != None )
				WeapAttachment.AmbientGlow = WeapAttachment.default.AmbientGlow;
		}
		Global.Tick(TimeDelta);
	}

	simulated function ClientFinish()
	{
	//	Log( Level.Hour $":"$ Level.Minute $":"$ Level.Second $" "$ Level.Millisecond $"    ZombieWeapon.ClientFiring.ClientFinish   RC:"$ ReloadCount ); 
		if( NeedsToReload() || !HasAmmo() || !bWantToFire || !ShouldRespondToPressingFire() )
		{
			Global.ClientFinish();
		}
		else if( BurstCounter < 3 )
		{
		//	Log("    Kickme!!!!  BC:"$ BurstCounter $"  RC:"$ ReloadCount );
			ServerFire();
			LocalFire();
		}
		else
		{
			LocalFire();
		}
	}

	simulated function EndState()
	{
		AmbientGlow = default.AmbientGlow;  // MAT: ambient glow self-flash
		if( WeapAttachment != None )
			WeapAttachment.AmbientGlow = WeapAttachment.default.AmbientGlow;

		Super.EndState();
	}
}

function ServerFire()
{
	ZombieBipedPawn( Owner ).bPlayKick = true;
	Super.ServerFire();
}

simulated function LocalFire()
{
//	Log(Level.Hour $":"$ Level.Minute $":"$ Level.Second $"."$ Level.Millisecond $"  ZombieWeapon.LocalFire    self:"$self.class $"  ROLE<Role_Authority ?:"$ (ROLE<Role_Authority) $"  bNetOwner:"$ bNetOwner );
	TimeOfLastShot=Level.TimeSeconds;

	bJustSelected=false;
	BurstCounter++;
//	Log("    SFRMW.LF  incremented burst counter to "$ BurstCounter $" !!!");

	Super.LocalFire();
	ApplyKick();
}

simulated function Fire( float Value )
{
//	Log("ZombieWeapon.Fire   AmmoType:"$AmmoType $"  AmmoType.AmmoAmount"$AmmoType.AmmoAmount $"   ReloadCount:"$ ReloadCount $"  state:"$GetStateName() );
	
	// Update accuracy based on game difficulty
	// (will have update if difficulty was altered since last call to Fire).
	bReleasedFireSinceLastShot=false;

	if (bUseMPDiffHack)
	{
		TraceAccuracy = WeaponSpread[ MP_DIFFICULTY_HACK ];
	}
	else if(bPlayerOwned)
	{
		TraceAccuracy = WeaponSpread[ Level.Game.GameDifficulty ];
	}
	else
	{
		TraceAccuracy = WeaponSpread[ SP_BOT_DIFFICULTY ];
	}

	// If empty, play dry fire sound
	if( ReloadCount == 0 )
	{
		if( instigator.isLocallyControlled() && PlayerController(instigator.controller) != None )
			Instigator.PlaySound(DryFireSound,SLOT_Interface,,,240.0);  // arg 2: slot, arg 5: radius
		else
			Instigator.PlaySound(DryFireSound,SLOT_Misc,,,240.0);  // arg 2: slot, arg 5: radius

		bJustPlayedDryFire=true;

		if (!HasAmmo())
		{
			if( !SwitchOnEmpty )
			{
				return;
			}
			else if( Instigator != None && Instigator.Inventory.PrevWeapon(None, self) != None )
			{
				SwitchToWeaponWithAmmo();
				return;
			}
		}

		return;
	}

	// If this weapon uses the can fire again (post reload) check, then see if the
	// condition is satisfied or if the timeout has expired.
	// This fixes a bug on Combat PC where if a multiplayer client player rapidly clicked fire
	// while the M203 was reloading, sometimes (about 5% of the time according to Groove)
	// the M203 would go through the fire anim, but no projectile would come out.
	// MAT 2/15/05
	if( bUseCanFireAgainPostReload && !bCanFireAgainPostReload && Level.TimeSeconds < TimeOfLastShot + 3.7 )
	{
	//	Log("     ####X Fire... can't launch projectile");
		return;
	}
	else
	{
	//	Log("     ####O Fire... can launch projectile (or isn't using can launch projectile check)");
		bCanFireAgainPostReload = true;
	}

	if( PhysicsVolume != None && PhysicsVolume.bWaterVolume )
	{
		bJustPlayedDryFire=false;
		Owner.PlaySound(UnderWaterFire,, 1,,500, 0.5+FRand(),true);
	}
	else
	{
		bCanFireAgainPostReload = false;  // MAT 2/15/05

		//Log(" calling Super.Fire");
		Super.Fire(Value);
	} 

}

// Tell the Client to add some kick for the weapon
simulated function ApplyKick()
{
	if ( Instigator != None && Instigator.Controller != None && Instigator.Controller.bIsPlayer)
	{
		if (ZombiePlayerPawn(Instigator) != None)
			ZombiePlayerPawn(Instigator).ClientKickView(ViewKickRate);
	}
}


//
// Inventory trigger interface (Hack for now but should be moved to the inventory base class)
//

// let the inventory know that there is some trigger that requires inventory 
// item in the area
function InventoryTriggerTouch(InventoryTrigger Other)
{
	ZombieBipedPawn(Instigator).TouchingThisInvetoryHack = Other; 
}

function InventoryTriggerUnTouch(InventoryTrigger Other)
{
	ZombieBipedPawn(Instigator).TouchingThisInvetoryHack = None; 
}


//
// weapon position helpers
//

// translate from local PlayerView model coords into world space
simulated function vector PVLocalToWorld(vector PVOffset)
{
	local vector X,Y,Z;
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	
	return (Instigator.Location + Instigator.CalcDrawOffset(self) + PVOffset.X * X + PVOffset.Y * Y + PVOffset.Z * Z);
}


//
// animnotify_script events
//

//
// Trigger event for animnotify_script to trigger brass emitter
//
simulated event EjectBrass()
{ 
	local vector  HatchLocation;
	local rotator EffectRotation; 
//	local Emitter BrassEmitter;
	local float   LateralV, LateralVAdj;
	
	local Pawn P;
	local PlayerController PC;

	if( UseWeapAttachment )
	{
		if( WABrassBone == '' || WABrassBone == 'none' )
			return;
	}
	else if( BrassEjectBone == '' || BrassEjectBone == 'none' )
		return;

	P =  Pawn(Owner);
	PC = PlayerController(P.Controller);
	
	if ( (	!P.IsLocallyControlled() ) ||
			(PC == None) || 
			(PC.bBehindView) )
		return;

	HatchLocation = GetBoneCoords(BrassEjectBone).Origin;

	EffectRotation = Instigator.GetViewRotation(); 

	if( BrassEmitter == None );
		BrassEmitter = Spawn(BrassEjectingEmitterClass,self,,HatchLocation,EffectRotation);

	if( BrassStartVelocityRange.X.Max != 0 || BrassStartVelocityRange.Y.Max != 0 || BrassStartVelocityRange.Z.Max != 0 )
		BrassEmitter.Emitters[0].StartVelocityRange = BrassStartVelocityRange;

	if( UseWeapAttachment && WABrassBone != '' && WABrassBone != 'none' )
		WeapAttachment.AttachToBone( BrassEmitter, WABrassBone );
	else
		AttachToBone( BrassEmitter, BrassEjectBone );

	// If facing a wall and too close, shut off collision to avoid artifacts
	// such as shell casings rolling up the wall.
	if( LastShotDist < MinShotDistBrass )
		BrassEmitter.Emitters[0].UseCollision = false;
	else
		BrassEmitter.Emitters[0].UseCollision = true;

	// Compensate for lateral movement so that brass won't come out of the left
	// side of gun when moving right.  Only has an effect if BrassRight is non-zero.
	LateralV = (vect(0,1,0) >> Instigator.GetViewRotation()) dot Instigator.Velocity;

	if(LateralV > 0)
		LateralVAdj = LateralV;
	else
		LateralVAdj = LateralV*0.5;

	if( abs(LateralV) > 24.0 )
	{
		BrassEmitter.Emitters[0].StartVelocityRange.X.Max += BrassRight.X*LateralVAdj*1.2;
		BrassEmitter.Emitters[0].StartVelocityRange.X.Min += BrassRight.X*LateralVAdj*1.2;

		BrassEmitter.Emitters[0].StartVelocityRange.Y.Max += BrassRight.Y*LateralVAdj*1.2;
		BrassEmitter.Emitters[0].StartVelocityRange.Y.Min += BrassRight.Y*LateralVAdj*1.2;

		BrassEmitter.Emitters[0].StartVelocityRange.Z.Max += BrassRight.Z*LateralVAdj*1.2;
		BrassEmitter.Emitters[0].StartVelocityRange.Z.Min += BrassRight.Z*LateralVAdj*1.2;
	}

	bEjectedbrass = true;
}

//
// Trigger event for animnotify_script to play fire sound
//
simulated event PlayFireSound()
{
//	log("PlayFireSound");
//	TimeOfLastShot=Level.TimeSeconds;

	if( Instigator.IsLocallyControlled() )
		PlayFireSoundForZone();

	// Having it eject brass from here so that we can be sure it will not 
	// eject brass before the fire sound.
	EjectBrass();
}

simulated function PlayFireSoundForZone()
{
	local Pawn P;
	local PlayerController PC;

//	log("t="$Level.TimeSeconds $"  ZombieWeapon.PlayFireSoundForZone    self:"$self.class );
	if ( FireSounds[Owner.Region.Zone.SoundZone] != None )
	{
	//	Log("Zone: "$Weapon.Owner.Region.Zone.SoundZone$"  FireSoundForZone: "$FireSounds[Weapon.Owner.Region.Zone.SoundZone] );		
		P = Pawn(Owner);
		if(P != None)
		{
			PC = PlayerController(P.Controller);

			if( PC != None )
				PC.ClientPlaySound( FireSounds[Owner.Region.Zone.SoundZone], , ,SLOT_Interface );
		}
	}

}


//
// Debug / Muzzle flass adjusmant functionality
//

simulated exec function SetMuzzleX(float NewX)
{
    FlashOffsetX=NewX;
}
simulated exec function SetMuzzleY(float NewY)
{
    FlashOffsetY=NewY;
}
simulated exec function ShowMuzzle()
{
	log("#### Muzzle X/Y: "$FlashOffsetX$"/"$FlashOffsetY);
}
simulated function SetAdjustStep(float NewStep)
{
	AdjustStep = NewStep;
	Log("#### Setting Adjustment Step to "$NewStep);
}

simulated function IncAdjustStep()
{
	AdjustStep += 0.25;
	Log("#### Setting Adjustment Step to "$AdjustStep);
}

simulated function DecAdjustStep()
{
	AdjustStep -= 0.25;
	Log("#### Setting Adjustment Step to "$AdjustStep);
}

simulated function SetAdjustPerson(int NewPerson)
{
	AdjustPerson = NewPErson;
	if (AdjustPerson==0)
		Log("#### Adjusting 3rd Person offsets");
	else
		Log("#### Adjusting 1st Person offsets");
}

simulated function AdjustX(int dir)
{

	local ZombieWeaponAttachment W;
	local vector v;

	W = ZombieWeaponAttachment(ThirdPersonActor);
	if (w==none)
		return;

	v.X = AdjustStep *Dir;
	W.Adjust(AdjustPerson,V);		
}		 
	
simulated function AdjustY(int dir)
{

	local ZombieWeaponAttachment W;
	local vector v;
	
	W = ZombieWeaponAttachment(ThirdPersonActor);
	if (w==none)
		return;

	v.Y = AdjustStep *Dir;
	W.Adjust(AdjustPerson,V);		

}		 

simulated function AdjustZ(int dir)
{

	local ZombieWeaponAttachment W;
	local vector v;
	
	W = ZombieWeaponAttachment(ThirdPersonActor);
	if (w==none)
		return;

	v.z = AdjustStep *Dir;
	W.Adjust(AdjustPerson,V);		
		
}		 


simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local ZombieWeaponAttachment W;
	local float inYL;

	inYL = YL;
	if( YL == 0 )
		YL = 12;
	class'ZombieFontDescriptor'.static.SetHUDFont(Canvas, 14);
	Super.DisplayDebug(Canvas, YL, YPos);

	W = ZombieWeaponAttachment(ThirdPersonActor);

	Canvas.SetDrawColor(255,255,0);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	YPos += YL;
	Canvas.SetPos(4,YPos);

	if (AdjustPerson==0)
		Canvas.DrawText("Adjusting 3rd Person View with a step of "$AdjustStep);
	else
		Canvas.DrawText("Adjusting 1st Person View with a step of "$AdjustStep);

	YPos += YL;
	if( W != None )
	{
		Canvas.SetPos(4,YPos);
		Canvas.DrawText("     3rd Person Offset: "$W.EffectLocationOffset[0]);
	}
	YPos += YL;
	if( W != None )
	{
		Canvas.SetPos(4,YPos);
		Canvas.DrawText("     1st Person Offset: "$W.EffectLocationOffset[1]);
	}

	YL = inYL;
}


simulated exec function SetWeapFOV(float newfov)
{
	if ( Pawn(Owner).Weapon != self)
		return;

	DisplayFOV = newFOV;
}

simulated exec function ShowWeapFOV()
{
	if ( Pawn(Owner).Weapon != self)
		return;

	log("#### DisplayFOV = "$DisplayFOV);
}	

simulated exec function SetWeapScale(float ns)
{
	if ( Pawn(Owner).Weapon != self)
		return;

	SetDrawScale(ns);
}

simulated exec function ShowWeapScale()
{
	if ( Pawn(Owner).Weapon != self)
		return;

	log("#### DrawScale= "$DrawScale);
}

simulated exec function SetWeapX(float x)
{
	if ( Pawn(Owner).Weapon != self)
		return;

	PlayerViewOffset.X = x;
	NeutralPlayerViewOffset.X = x;
}

simulated exec function SetWeapY(float Y)
{
	if ( Pawn(Owner).Weapon != self)
		return;

	PlayerViewOffset.Y = Y;
	NeutralPlayerViewOffset.Y = Y;
}
simulated exec function SetWeapZ(float Z)
{
	if ( Pawn(Owner).Weapon != self)
		return;

	PlayerViewOffset.Z = Z;
	NeutralPlayerViewOffset.Z = Z;
}

simulated exec function ShowWeapXYZ()
{
	if ( Pawn(Owner).Weapon != self)
		return;

	log("#### ViewOffset: "$PlayerViewOffset);
}


//Cheat support

//
// Support for Player View effects
//
simulated event RenderOverlays( canvas Canvas )
{

	if(bHidden /*|| ((SFRMPlayerController(Pawn(Owner).Controller) != none) && SFRMPlayerController(Pawn(Owner).Controller).IsNightVisionOn)*/)
	{
		return;
	}
	
	RenderPVEffects(Canvas); 

	Super.RenderOverlays(Canvas);
}

simulated function RenderPVEffects(canvas Canvas) 
{
	// only players should care about PlayerView effects
	if ( !Instigator.Controller.bIsPlayer )
		return; 

	RenderMuzzleFlash(Canvas); 
}

simulated function SpawnMuzzleFlashStaticMesh()
{
	if( PVMuzzleStaticMesh == none && PVMuzzleStaticMeshClass != none )
	{
		PVMuzzleStaticMesh = Spawn(PVMuzzleStaticMeshClass,self); 
		PVMuzzleStaticMesh.Skins[0] = PVMuzzleFlashSkin;
	}
}

simulated function RenderMuzzleFlash(canvas Canvas)
{		
	local rotator MuzzleRotation;
	local vector MuzzlePos;
	local vector AdjPVMuzzleLoc;
	local float MFDrawScale;
//	local SFRMPlayerController PC;

	if ( bMuzzleFlash && bDrawMuzzleFlash )
	{
		
		if ( !bSetFlashTime )
		{
			bSetFlashTime = true;
			FlashTime = Level.TimeSeconds + FlashLength;
		}
		else if ( FlashTime < Level.TimeSeconds )
		{
			bMuzzleFlash = false;
		}
		
		// If we don't have a muzzle flash static mesh, create one now
		if( PVMuzzleStaticMesh == none && PVMuzzleStaticMeshClass != none )
		{
			SpawnMuzzleFlashStaticMesh();
		}

		// If we have a muzzle flash static mesh, set its properties
		// for the current shot
		if (PVMuzzleStaticMesh != None && bWeapHasMuzzleFlash )
		{		
			MuzzleRotation = Rotation; 
			MuzzleRotation.Roll = (MuzzleRotation.Roll + Rand(65536))%65536;		
			PVMuzzleStaticMesh.SetRotation( MuzzleRotation );

			// Tweak PV muzzle location (to compensate for going up stairs,
			// player rotation and leaning/unleaning)
			AdjPVMuzzleLoc = TweakPVMuzzleLocation(PVMuzzleLocation);

			MuzzlePos = PVLocalToWorld(AdjPVMuzzleLoc);

			FlashLength = default.FlashLength;

			// Set DrawScale.  Make it vary in size from shot to shot, and scale down if zoomed
			if( BurstLength == 1 )
				MFDrawScale = PVMuzzleFlashScale*(1.0-0.22*(ReloadCount%2));  // single-shot weapon
			else
				MFDrawScale = PVMuzzleFlashScale*(1.0-0.22*(BurstCounter%2));
			if( IsFullyZoomed() )
				MFDrawScale *= 0.70;
			PVMuzzleStaticMesh.SetDrawScale( MFDrawScale );

			PVMuzzleStaticMesh.SetLocation(MuzzlePos);

			Canvas.DrawActor(PVMuzzleStaticMesh,false, true, DisplayFOV); 

			if( Instigator.IsLocallyControlled() )
			{
				ZombieWeaponAttachment(ThirdPersonActor).FlashPlayerMuzzleLight(Instigator);

				// MAT: ambient glow self-flash
				// Change ambient glow of weapon to simulate light from muzzle flash
				// lighting up the weapon.
				// Make it vary from shot to shot so that for very fast-firing weapons
				// (where one glow starts before the next has a chance to end) it will
				// look like it's at least flickering (instead of a steady light)
				AmbientGlow = default.AmbientGlow + AmbientGlowDelta + 10*(ReloadCount%2);

				if( WeapAttachment != None )
				{
					WeapAttachment.AmbientGlow = WeapAttachment.default.AmbientGlow + WAAmbientGlowDelta + 20*(ReloadCount%2);
				}
			}
		}

		// reset
		Canvas.SetDrawColor(Canvas.Default.DrawColor.R,Canvas.Default.DrawColor.B,Canvas.Default.DrawColor.G,Canvas.Default.DrawColor.A); 
		Canvas.Style = ERenderStyle.STY_Normal;
	}
	else
	{
		bSetFlashTime = false;
	}
}

simulated native function vector TweakPVMuzzleLocation( vector PVMuzzleLoc );

simulated exec function HideWeapon()
{
    Hide();
}

simulated exec function ShowWeapon()
{
    Show();
}



function Hide()
{
	bHidden = true;
}

function Show()
{
	bHidden = false;
}

// toss out a weapon
function TossWeapon(Vector TossVel)
{
	local Vector X,Y,Z;

	Velocity = TossVel;
	Instigator.GetAxes(Instigator.Rotation,X,Y,Z);
	DropFrom(Instigator.Location + 0.8 * Instigator.CollisionRadius * X - 0.5 * Instigator.CollisionRadius * Y); 
}	

simulated function Reskin(Material Skin0, Material Skin1)
{
	ReskinWeapon(Skin0, Skin1); 
}

simulated function ResetZoomTiltBob( optional bool bCausedByNudge );

simulated function rotator ZoomTiltBob() { return rotator(vect(0.0, 0.0, 0.0)); }

simulated function vector ZoomTiltTranslationBob() { return (vect(0.0, 0.0, 0.0)); }

simulated function StartZoom()
{
	local PlayerController PC;
	PC = PlayerController(Instigator.Controller);

	bZoomed				= true; 
	ServerSetZoomed( bZoomed );
	fZoomStartTime		= Level.TimeSeconds;
	fDefaultPVWeaponFOV	= DisplayFOV; 
	fCurFOVChange		= 0.0;
	fZoomInDuration		= default.fZoomInDuration;

//	if (Instigator.Controller.bIsPlayer)
//		PC.setLean(true);
}

simulated function EndZoom()
{
	local PlayerController PC;
	local rotator SkelMeshRotOffset;

	PC = PlayerController(Instigator.Controller);

	bZoomed				= false;
	ServerSetZoomed( bZoomed );
	fZoomStartTime		= 0.0;
	DisplayFOV			= fDefaultPVWeaponFOV;
	fZoomStartTime		= Level.TimeSeconds;
	fDefaultPVWeaponFOV	= DisplayFOV; 
	fZoomInDuration		= default.fZoomInDuration/3;
	
	if (Instigator.Controller.bIsPlayer)
	{
		// Move PV weapon back so that after FOV snaps out, weapon will still look
		// like it's starting lowering from iron-sights from a point closer to 
		// the player
		if( !HasAnim(xScopeOffAnim) )
			NeutralPlayerViewOffset = NeutralPlayerViewOffset + vect(-12,0,0);

		PC.ResetFOV();
	//	PC.setLean(false);
	}

//	PVMuzzleLocation = default.PVMuzzleLocation;
	ChangePVMuzzleLocZoom( false );

	if( !bHasScope )
	{
	//	NeutralPlayerViewOffset = default.PlayerViewOffset;

		SkelMeshRotOffset.Pitch=0;
		SkelMeshRotOffset.Roll=0;
		SkelMeshRotOffset.Yaw=0;
	//	SetSkelMeshRotationOffset( SkeletalMesh(mesh), self, SkelMeshRotOffset );
		NeutralPlayerViewRotationOffset = SkelMeshRotOffset;
	//	PVMuzzleLocation = default.PVMuzzleLocation;
		ChangePVMuzzleLocZoom( false );
		if( Owner != None && SFRMPlayerController(Pawn(Owner).Controller) != None )
			SFRMPlayerController(Pawn(Owner).Controller).SetCHIndex(GetCrosshairIndex(), GetWeaponIconIndex());
	}
}


//
// View kick functions
//

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated native function CalcWeaponKick(out vector InViewKickAdjustment, vector Kick);

simulated native function RestoreWeaponKick(float Delta, out vector InViewKickAdjustment);


// called when bOverwriteBulletImpact is true
function Actor SpawnImpactEffect(Actor Other, Actor ObjectOwner, vector HitLocation, vector HitNormal, byte MaterialType) { return None; }

// RedMerc
simulated function bool canQuickGrenade()
{
	return true;
}

event CancelQuickGrenade()
{
	if (IsInState('DownWeapon') && Pawn(Owner).pendingWeapon.IsA('ABSTRACT_WeapGrenade'))
	{
		GotoState('Active');
	}
}


simulated function playHolsterAnim()
{
	if( HasAnim(xHolsterAnim) )
		PlayAnim( xHolsterAnim, 1.6 );
}

// For quick grenade: used to give appearance of unzooming (without
// also unleaning) before going from this weapon to grenade.
// This ensures grenade doesn't look zoomed (but ensures we can
// still lean).
simulated function QGViewUnZoom()
{
	if (Instigator.Controller.bIsPlayer)
	{
		PlayerController(Instigator.Controller).ResetFOV();
		DisplayFOV = default.DisplayFOV;
	}
}

// For quick grenade: used to give appearance of rezooming 
// after returning from grenade to this weapon
simulated function QGViewZoom()
{
	if (Instigator.Controller.bIsPlayer)
	{
		PlayerController(Instigator.Controller).SetFOV(90 - fFOVChange);
		DisplayFOV = FClamp((90 - fFOVChange) / 2, 30.0, default.DisplayFOV);
	}
}

//state AfterBurst
//{
//	ignores Fire, AltFire, ServerFire, ServerAltFire;
//
//	simulated function ReleaseFire( optional float F )
//	{
//	//	log(self$GetStateName()$"::ReleaseFire");
//		GotoState('Idle');
//	}
//
//	function EndState()
//	{
//	//	log(self$GetStateName()$"::EndState");
//		BurstCounter = 0;
//	}
//	
//	function BeginState()
//	{
//	//	log(self$GetStateName()$":BeginState");
//	//	log("   Brass tinkle");
//		RequestBrassSound();
//	}
//}

// ----------------------------

simulated function int GetWeaponIconIndex()
{
	return WeaponIconIndex;
}

// Use this instead of accessing the member directly.
simulated function int GetCrosshairIndex()
{
//	log(self.class$"::GetCrossHairIndex   CrosshairIndex:"$ CrosshairIndex );
	if( CrosshairIndex > 2 )
		return CrosshairIndex;
	else
		return GetCrosshairIndexForNone();
}

simulated function int GetCrosshairIndexForNone()
{
	return -1;
}

// ----------------------------

// DEBUG: 
// Call this function from a uc (UnrealScript) function and set a breakpoint
// inside the corresponding native code (ASFRMWeapon::execDebugBPHack).
// Add ((FNameEntry*)(*((DWORD*)(((*(FArray*)(&*(&(FName::Names))))).Data)+this->Name.Index)))->Name
// (or something like that) to the watch window.
// Add ((FNameEntry*)(*((DWORD*)(((*(FArray*)(&*(&(FName::Names))))).Data)+Function->Name.Index)))->Name
// (or something like that) to the watch window.
// Look at the values of these two watches in the CallFunction calls in the native call stack.  This 
// will give the script call stack (albeit not as easy to read as a real uc debugger).
// The first watch will give the name of the class, the second will give the name of the function.
native static function DebugBPHack();

// ----------------------------



// Decompiled with UE Explorer.
defaultproperties
{
    AdjustStep=1.0000000
    AdjustPerson=1
    ReticleRangeFactor=0.6000000
    WeaponSpread[0]=0.1460000
    WeaponSpread[1]=0.1920000
    WeaponSpread[2]=0.2270000
    WeaponSpread[3]=0.2440000
    ScatterKick=1.0000000
    ScatterFullRestoreTime=0.2500000
    MinScatterFactor=0.1000000
    MinScatterFactorZoomed=0.0050000
    MaxScatterFactorZoomed=0.8000000
    DelayBeforeBrassSound=0.6000000
    BrassSound[0]=Sound'CBW_DYN_Foley.brass.Brass_stone1'
    BrassSound[1]=Sound'CBW_DYN_Foley.brass.Brass_gravel1'
    BrassSound[2]=Sound'CBW_DYN_Foley.brass.Brass_gravel1'
    BrassSound[3]=Sound'CBW_DYN_Foley.brass.Brass_metal1'
    BrassSound[4]=Sound'CBW_DYN_Foley.brass.Brass_stone1'
    BrassSound[5]=Sound'CBW_DYN_Foley.brass.Brass_water1'
    BrassSound[6]=Sound'CBW_DYN_Foley.brass.Brass_wood1'
    BrassSound[7]=Sound'CBW_DYN_Foley.brass.Brass_gravel1'
    BrassSound[8]=Sound'CBW_DYN_Foley.brass.Brass_gravel1'
    BrassSound[9]=Sound'CBW_DYN_Foley.brass.Brass_water1'
    BrassSound[10]=Sound'CBW_DYN_Foley.brass.Brass_water1'
    BrassSound[11]=Sound'CBW_DYN_Foley.brass.Brass_gravel1'
    DryFireSound=Sound'CBW_DYN_weapons.USP45.dryfire'
    TimeBetweenNonSubtleIdles=25.0000000
    bCanZoom=true
    bKeepLastZoomSetting=true
    fScopeRaiseDuration=0.2000000
    fZoomInDuration=0.1660000
    fZoomOutDuration=0.1660000
    fFOVChange=35.0000000
    fFOVChangeMin=35.0000000
    ZoomPlayerViewOffset=(X=16.0000000,Y=-1.0000000,Z=-4.0000000)
    ZoomRotationOffset=(Pitch=0,Yaw=850,Roll=910)
    ZoomLeanPVYCorr=0.0500000
    ZoomLeanPVZCorr=0.4400000
    ZoomLeanPitchCorr=0.0900000
    LeanPVYCorr=0.1000000
    LeanPVZCorr=1.0000000
    LeanPitchCorr=0.1000000
    ZoomInSound=Sound'CBW_DYN_interface.HUD.zoom_in_low'
    ZoomOutSound=Sound'CBW_DYN_interface.HUD.zoom_out_low'
    ScopeFinalSegment=(X=-7.0000000,Y=0.0000000,Z=0.0000000)
    AutoAimOnZoom=true
    BotFireRate=0.5000000
    BotBulletInterval=1.0000000
    MuzzleFlashInterval=0.1000000
    BotGhostBulletPercent=0.5000000
    ShotsUntilNextTracer=1
    vMuzzleFlashLocalOffset=(X=100.0000000,Y=-5.0000000,Z=20.0000000)
    BrassEjectingEmitterClass=Class'ZombieEffects.brassEjection'
    BrassEjectBone="bone_bolt"
    ViewKickRate=(X=0.0000000,Y=0.0000000,Z=384.0000000)
    ViewKickMax=(X=0.0000000,Y=0.0000000,Z=10240.0000000)
    fViewRestoreTime=0.2000000
    fZoomViewKickFactor=1.0000000
    KickDirX=-1
    KickDirY=-1
    WeaponIconNum=-1
    BotClips=20
    BotBurstSize=4
    BotTimeBetweenBursts=3.0000000
    SpeedClass=3
    AutoTargetRadiusSquared[0]=15433.8700000
    AutoTargetRadiusSquared[1]=5638.2900000
    AutoTargetRadiusSquared[2]=3421.9320000
    TakeOutAnim[0]="aim_rifle_select"
    TakeOutAnim[1]="aim_rifle_select"
    PutAwayAnim[0]="aim_rifle_deselect"
    PutAwayAnim[1]="aim_rifle_deselect"
    PoseAnim="idle_rifle_pose"
    PawnReloadAnim="aim_rifle_reload"
    YawSwayFactor=0.6000000
    PitchSwayFactor=0.6500000
    TransSwayFactors=(X=0.9000000,Y=0.9000000,Z=0.9000000)
    YawTransSwayFactors=(X=-2.0000000,Y=-2.5000000,Z=0.0000000)
    PitchTransSwayFactors=(X=-2.0000000,Y=0.0000000,Z=-2.5000000)
    MinSwayClamp=(X=-2.2000000,Y=-1.9000000,Z=-2.2000000)
    MaxSwayClamp=(X=2.0000000,Y=1.9000000,Z=2.2000000)
    MinSwayRotClamp=(Pitch=-550,Yaw=-730,Roll=0)
    MaxSwayRotClamp=(Pitch=550,Yaw=730,Roll=0)
    MPHandTexName="CBT_DYN_Weapons.hands.pv_hands"
    MPHandTexNameTerr="CBT_DYN_Weapons.hands.pv_hands_enemy"
    fNoiseFactor=1.0000000
    WAPVMuzzleFlashBone="gun_muzzle"
    CrosshairIndex=3
    hudProps=(WeaponIconIdx=25,AmmoIconIdx=85,ItemsPerTex=5)
    bWeapHasMuzzleFlash=true
    ShakeMag=0.0000000
    shaketime=0.0000000
    ShakeVert=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    ShakeSpeed=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    TraceAccuracy=0.1460000
    DisplayFOV=70.0000000
    MuzzleScale=3.5000000
    PlayerViewOffset=(X=16.5000000,Y=1.2000000,Z=-7.0000000)
    DrawScale=0.1800000
}