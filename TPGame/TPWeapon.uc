/* TPWeapon */

class TPWeapon extends Weapon
	native
	abstract;

enum ERecoil {RE_None, RE_Fire, RE_Recover};

struct native TPRecoilParams
{
    var config float FireTime;
    var config float RecoverTime;
    var config float RecoilAngle;
    var config float RecoilJitter;
    var config float Spread;
    var config float Spread_AI;
};


var config TPRecoilParams StandingRecoil;
var config TPRecoilParams StandingAimRecoil;
var config TPRecoilParams CrouchingRecoil;
var config TPRecoilParams CrouchingAimRecoil;


struct native RecoilData
{
    var ERecoil State;
    var float   Time;
    var float   PrevAngle;
    var float   PrevJitter;
    var float   PrevPercent;
    var float   TotalFireAngle;
    var float   TotalFireJitter;
    var float   TotalRecoverAngle;
    var float   TotalRecoverJitter;

    structdefaultproperties
    {
        State             = RE_None;
        Time              = 0;
        PrevAngle         = 0;
        PrevJitter        = 0;
        PrevPercent       = 0;
        TotalFireAngle    = 0;
        TotalRecoverAngle = 0;
    }
};

var Array<SoundCue>		Sound_FireStart;
var Array<SoundCue>		Sound_FireStart_NPC;

var Array<SoundCue>		Sound_Fire;
var Array<SoundCue>		Sound_Fire_NPC;

var Array<SoundCue>		Sound_FireEnd;
var Array<SoundCue>		Sound_FireEnd_NPC;

var Array<SoundCue>		Sound_Shell;
var Array<SoundCue>		Sound_Shell_NPC;

var Array<SoundCue>     Sound_WeaponEmpty;
var Array<SoundCue>     Sound_WeaponEmpty_NPC;

var	AudioComponent		Sound_Looping;
var	AudioComponent		Sound_Looping_NPC;

var (AI_AudioEvents)	config float	m_FiringLoudness;
var (AI_AudioEvents)	config float	m_ProjectileImpactLoudness;
var (AI_AudioEvents)	config float	m_ProjectileExplodingLoudness;
var (AI_AudioEvents)	config float	m_ReloadingLoudness;
var (AI_AudioEvents)	config float	m_DroppingLoudness;
var (AI_AudioEvents)	config float	m_PickingUpLoudness;

var bool                bAltFire;
var bool                bLoopReload;
var bool                bAlternateReload;
var bool				bAllowInterruptReload;
var bool                bToggleAimDownSight;
var bool                bLockAimDownSight;
var bool                bWeaponEquipped;
var bool                bWeaponIsHolstered;
var bool                bSemiAuto;
var bool                bADSTurnLookModEnabled;

var float               m_BlimpDmgPlus;
var () float            m_HeroDmgPlus;

var bool                bToSprint;
var bool                bToWalk;
var bool                bToADS;
var bool                bToIdle;
var float               ToSprintAccu;
var float               ToWalkAccu;
var float               ToAdsAccu;
var float               ToIdleAccu;
var float               TransitionStartTime;

var bool                bToStand;
var bool                bToCrouch;

var bool				bInfiniteAmmo;

var config byte         DroppedAmmoMin;
var config byte         DroppedAmmoMax;

var config float		m_MaxReloadTime;

var config bool			m_bAllowedToMeleeWith;
var config bool			m_bCanBlindFireWithWith;
var config bool			m_bShouldUseSnapShotInsteadOfBlindFire;
var config bool			m_bBurstingWeapon;
var config float		m_RadiusForLOSCheck;

var float				m_LockInTime;
var float				m_PullOffTime;

enum WeaponCategory
{
	WeaponCategory_SMG,
	WeaponCategory_Pistol,
	WeaponCategory_Rifle,
	WeaponCategory_Panzer,
	WeaponCategory_Grenade,
	WeaponCategory_Unarmed,
	WeaponCategory_SniperRifle,
	WeaponCategory_Unclassified
};

// ID is what's used to identifiy names, name is the "display" name
var name				WeapID;
var localized string	WeapName;
var WeaponCategory		WeapCategory;
var Texture2D			HUDIcon;

var	TPPhysicalMaterial	DefaultPhysMaterial;
var class<DamageType>	WeaponDamageType;

var int timesReloaded;
var int shotsFired;
var int shotsCompleted;
var int debugCounter;

var() config Array<float>           InstantHitDamage_AI;
var() config Array<float>           InstantHitMomentum_AI;

var config repnotify int           	AmmoInMagazine;
var config int           	        AmmoInMagazine_AI;
var	config int			   			MagazineSize;
var	config int			   			MagazineSize_AI;
var	config repnotify int			AmmoCount;
var config int                      MaxAmmo;
var config float                    AimDownFOV;
var        float                    DefaultSpread;

var config float                    SprintSpread;
var config float                    SprintSpread_AI;

var config float					PlayerSpeedMod; //affects the speed the player moves at when carrying this weapon

var config Float					AI_AccCone_Min;
var config Float					AI_AccCone_Max;

/** How long does it take to Reload this weapon */
// var()			float	ReloadTime;

/////////////////////////////////////////////////

/** Holds the name of the socket to attach a muzzle flash too */
var name					MuzzleFlashSocket;

/** Muzzle flash PSC and Templates*/
var ParticleSystemComponent	MuzzleFlashPSC;

/** Normal Fire and Alt Fire Templates */
var ParticleSystem			MuzzleFlashPSCTemplate;

/** UTWeapon looks to set the color via a color parameter in the emitter */
var color					MuzzleFlashColor;

/** Set this to true if you want the flash to loop (for a rapid fire weapon like a minigun) */
var bool					bMuzzleFlashPSCLoops;

/** dynamic light */
var	const PointLightComponent		MuzzleFlashLight;

/** dynamic light class */
var class<PointLightComponent> MuzzleFlashLightClass;

/** How long the Muzzle Flash should be there */
var() float					MuzzleFlashDuration;

var config RecoilData Recoil;

/* are we percieved as hostile when holding this weapon? */
var bool					bHostile;

/* is this a fake weapon? */
var bool					bPlaceholder;

/* Bullet shell stuff */
var ParticleSystem	        ShellCaseTemplate;
var Emitter                 ShellEmitter;


// Is this a large weapon?
// Used to determine if we should drop any large weapon out of our inventory if we have one before picking this one up
var bool bLargeWeapon;

/** Bullet Tracer Count Variables for ProjectileFire Weapons */
var config int TracerRoundID;    // What bullet interval does tracer round go off at
var repnotify int BulletFireCount;         // Counter for the bullets

/** burst fire variables */
var const config int BulletsPerBurst; // number of bullets per burst of fire
var const config float BurstDelayMin; // minimum delay between bursts of fire
var const config float BurstDelayMax; // minimum delay between bursts of fire

var const config float PlayerRenderWeaponFOV; // the FOV that is used to render the player's arms & weapon

var config bool bInstantKillOnHeadShot;

var config float ProjectileSpeed;

/** Melee variables */
var const config float MeleeDistance; // What is the Melee Range of this weapon
var const config int MeleeDamage; // What is the Melee Damage of this weapon
var const config float MeleeHitForce; // How much liner energy does this weapon transver to who ever get melee attacked with it
var const config float PercentOfMagToBlowThroughBeforeMeleeCharge; // How much of the mag to empty out before melee charging fast fire weapons should be high and single fire low

var const config float ChanceOfRunShot; // What is the Melee Range of this weapon
var const config float TimeBetweenChecksForRunShot; // What is the Melee Range of this weapon
var float LastTimeCheckedForRunShot; // What is the Melee Range of this weapon

// Weapon SubFireTypes
enum EFireType
{
	FT_SingleShot,
	FT_BurstShot,
	FT_RapidShot,
};
var config EFireType SubFireTypes[2];    // We only can do swap between 2 fire types.  IE - Single/Rapid , Burst/Rapid , Single/Burst
var config int SubFireBulletsPerBurst;
var int CurrentSubFireType;				 // What fire type are we using
var int CurrentShot;

var() const editconst LightEnvironmentComponent LightEnvironment;

//force feedback waveforms
var ForceFeedbackWaveform PlayerFireWaveform;

var config float      AimDownFocusInnerRadius;
var config float      AimDownFalloffExponent;
var config float      AimDownBlurKernelSize;
var config bool       bEnableAimDownDof;

var config float      AimDownSightLookMod;
var config float      AimDownSightTurnMod;

// For Weapons on Clients
var class<TPWeaponAttachment> 	AttachmentClass;

var Texture2D CrosshairTextures[4];
var Texture2D CrosshairDotTexture;
var bool bUsingCustomCrosshair;
var config float CrosshairScale;


//PawnAnimSets is the array of animsets that the owner Pawn needs to operate this weapon.  The animsets will be added
//to the pawn in GivenTo and removed in ItemRemovedFromInvManager.
//Currently NPCs and player share the same animsets.  If they didn't we would need to have two arrays.
var array<AnimSet>	PawnAnimSets;







//// start of adhesion friction vars

/** When the weapon is zoomed in then the turn speed is reduced by this much **/
var() config float ZoomedTurnSpeedScalePct;

/** Target friction enabled? */
var() config bool bTargetFrictionEnabled;

/** Min distance for friction */
var() config float TargetFrictionDistanceMin;

/** Peak distance for friction */
var() config float TargetFrictionDistancePeak;

/** Max distance allow for friction */
var() config float TargetFrictionDistanceMax;

/** Interp curve that allows for piece wise functions for the TargetFrictionDistance amount at different ranges **/
var() config InterpCurveFloat TargetFrictionDistanceCurve;

/** Min/Max friction multiplier applied when target acquired */
var() config Vector2d TargetFrictionMultiplierRange;

/** Amount of additional radius/height given to target cylinder when at peak distance */
var() config float TargetFrictionPeakRadiusScale;
var() config float TargetFrictionPeakHeightScale;

//TP - radius height/scale at min distance
var() config float TargetFrictionMinRadiusScale;
var() config float TargetFrictionMinHeightScale;


/** Offset to apply to friction target location (aim for the chest, etc) */
var() config vector TargetFrictionOffset;

/** Boost the Target Friction by this much when zoomed in **/
var() config float TargetFrictionZoomedBoostValue;

var() config bool bTargetAdhesionEnabled;

/** Max time to attempt adhesion to the friction target */
var() config float TargetAdhesionTimeMax;

/** Max distance to allow adhesion to still kick in */
var() config float TargetAdhesionDistanceMax;

/** Max distance from edge of cylinder for adhesion to be valid */
var() config float TargetAdhesionAimDistY;
var() config float TargetAdhesionAimDistZ;

// TP -Scale of target's cylinder for adhesion
var() config float TargetAdhesionCylinderRadiusScale;
var() config float TargetAdhesionCylinderHeightScale;

/** Min/Max amount to scale for adhesive purposes */
var() config Vector2d TargetAdhesionScaleRange;
var() config Vector2d TargetSuperAdhesionScaleRange;

/** Min amount to scale for adhesive purposes */
var() config float TargetAdhesionScaleAmountMin;

/** Require the target to be moving for adhesion to kick in? */
var() config float TargetAdhesionTargetVelocityMin;

/** Require the player to be moving for adhesion to kick in? */
var() config float TargetAdhesionPlayerVelocityMin;

/** Boost the Target Adhesion by this much when zoomed in **/
var() config float TargetAdhesionZoomedBoostValue;

//// end of adhesion friction vars

var localized string WeaponPickupMessage;

var bool clientFireOverRide;

// This is the weapon image that the character selection is using.
var Texture2D WeaponImage;





/////////////////////////////////////////////////

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native final function TP_GotoState( name NewState, optional name Label, optional bool bForceEvents, optional bool bKeepStack );

//native final static function WorldInfo GetWorldInfo();
native function                        SpawnBulletShells();

simulated function ChangePosture(bool bStand);

native noexport function DrawTracer();
simulated function MaterialInstanceConstant GetScopeView();
simulated function MaterialInstanceConstant GetScopeViewWide();

replication
{
	if (Role == ROLE_Authority && bNetDirty && bNetOwner)
		bLockAimDownSight, AmmoCount, AmmoInMagazine;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'AmmoCount' && !HasAnyAmmo() )
	{
		WeaponEmpty();
	}
	else if ( VarName == 'AmmoInMagazine' && !HasAmmo(CurrentFireMode))
	{
		// This should now be done reliably [ OutofAmmo() ] due to its determinitic behavior.
		// PlayReload();
	}

	Super.ReplicatedEvent(VarName);

}

simulated function ChangePostureDone()
{
    bToStand  = false;
    bToCrouch = false;
}

simulated function bool ShouldRefire()
{
	local bool bSuperRetVal;
	local TPPlayerController myTPC;
	// if doesn't have ammo to keep on firing, then stop
	if( bSemiAuto )
	{
		return false;
	}

	// refire if owner is still willing to fire
	bSuperRetVal = Super.ShouldRefire();

	if (bSuperRetVal)
	{
		myTPC = TPPlayerController(Pawn(Owner).Controller);
		if (myTPC != None)
		{
			myTPC.FadeInHUD();
		}
	}

	return bSuperRetVal;
}

simulated function StartFire(byte FireModeNum)
{
	//`log(" ChadAI - Weapon: " @ Self @ " StartFire fn FireModeNum: " @ FireModeNum  @ " --------------------------------------------------------------------------------------------------------------------------");

	Super.StartFire(FireModeNum);
}

simulated function float GetAmmoInMagazine()
{
    return bIsNPCWeapon ? AmmoInMagazine_AI : AmmoInMagazine;
}

simulated function float GetMagazineSize()
{
    return bIsNPCWeapon ? MagazineSize_AI : MagazineSize;
}


function AddToAmmoInMagazine(float Ammo)
{
    if (bIsNPCWeapon)
	{
        AmmoInMagazine_AI += Ammo;
		//`log(" ChadAI - Weapon: " @ Self @ " AddToAmmoInMagazine-AmmoToAdd: " @ Ammo @ " AmmoCount: " @ AmmoCount @ " AmmoInMagazine: " @ AmmoInMagazine_AI  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	}
    else
        AmmoInMagazine    += Ammo;
}

function SetAmmoInMagazine(float Ammo)
{
    if (bIsNPCWeapon)
	{
        AmmoInMagazine_AI = Ammo;
		//`log(" ChadAI - Weapon: " @ Self @ " SetAmmoInMagazine-AmmoToSet2: " @ Ammo @ " AmmoCount: " @ AmmoCount @ " AmmoInMagazine: " @ AmmoInMagazine_AI  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
	}
    else
        AmmoInMagazine    = Ammo;
}

function float GetInstantHitDamage()
{
    return bIsNPCWeapon ? (InstantHitDamage_AI[CurrentFireMode] + m_BlimpDmgPlus + m_HeroDmgPlus ) : InstantHitDamage[CurrentFireMode];
}

function float GetInstantHitMomentum()
{
    return bIsNPCWeapon ? InstantHitMomentum_AI[CurrentFireMode] : InstantHitMomentum[CurrentFireMode];
}

simulated function WeaponEmpty()
{	
	// If we were firing, stop
	if ( IsFiring() )
	{
		GotoState('Active');
	}

	if ( Instigator != none && Instigator.IsLocallyControlled() )
	{
		Instigator.InvManager.SwitchToBestWeapon( true );
	}
}

/**
 * returns true if this weapon has any ammo
 */
simulated function bool HasAnyAmmo()
{
	return ( AmmoCount > 0 ) || HasAmmo( CurrentFireMode );
}

// TPAnimNotify_WeaponFire calls this
simulated event PlayWeaponFire(optional bool AccurateFire = false)
{
    local WehrmachtPawn Wehr;

    if (AccurateFire)
    {
        Wehr = WehrmachtPawn(Instigator);
        if (Wehr != None)
            Wehr.bAccuratePerformanceFire = AccurateFire;
    }

	SendToFiringState( 0 );
}

// TPAnimNotify_WeaponReload calls this
simulated event PlayReload(optional bool bFinished = false)
{
	if (!bFinished)
	{
		//`log(" ChadAI - Wepaon: " @ Self @ " Reloading State Starting due to PlayReload and bFinished: " @ bFinished @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		GotoState('Reloading');
	}
	else
	{
		GotoState('Active');
	}
}

// TPAnimNotify_WeaponReloaded calls this
simulated event PlayReloadFinished()
{
	//`log(" ChadAI - Wepaon: " @ Self @ " PlayReloadFinished() called -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

}

reliable server function ReloadComplete()
{
	GotoState('Active');	
}

simulated function WeaponIsDown();


/////////////////////////////////////////////////

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();

	if (Spread.Length > 0)
	{
		DefaultSpread = Spread[0];
		Spread[0]     = 0;
	}

	// If the role is authority
	if ( Role == ROLE_AUTHORITY )
		// And we are not locally controlled
		if (Instigator == None || Instigator.IsLocallyControlled() == false ) 
		{
			// Then this weapon should be in Worldspace and not in the foreground like most "true" weapons are.  This case only happens for when:
			// You ARE a listen server
			Mesh.SetDepthPriorityGroup(SDPG_World);		
		}


	if (ShellCaseTemplate != none && Role == ROLE_AUTHORITY && Instigator == None || Instigator.IsLocallyControlled())
	{
		ShellEmitter = spawn(class'EmitterSpawnable');
		ShellEmitter.ParticleSystemComponent.bAutoActivate = false;
		ShellEmitter.bDestroyOnSystemFinish = false;
		if (SkeletalMeshComponent(Mesh) != none)
		{
			SkeletalMeshComponent(Mesh).AttachComponentToSocket(ShellEmitter.ParticleSystemComponent,'shellexit');
		}

		ShellEmitter.SetTemplate(ShellCaseTemplate, false);
	}
}

simulated function bool IsAGrenade()
{
	if ( IsA('Grenade_Persistent') || IsA('Grenade') )
		return true;
	
	return false;
}

simulated function MakeWeaponUnlimited()
{
	// If not grenade.
	if ( !IsAGrenade() )
	{
		bInfiniteAmmo = true;
		AmmoCount = 999;
		;
	}
	
}

simulated function MakeWeaponStandard()
{
	if ( !IsAGrenade() )
		bInfiniteAmmo = false;
}

simulated function MakeGrenadeUnlimited()
{
	// If not grenade.
	if ( IsAGrenade() )
	{
		bInfiniteAmmo = true;
		AmmoCount = 998;	// Grenades are +1 on Give events.

		TPPlayerController(TPPawn(Owner).Controller).bUnlimitedGrenadeMode = true;

		;
	}
	
}

simulated function MakeGrenadeStandard()
{
	if ( IsAGrenade() )
		bInfiniteAmmo = false;
}

simulated function HandleWeaponCheatCodes()
{
	local TPPlayerController tPC;

	// Check if we are in always have ammo mode
	if ( WorldInfo.NetMode == NM_Standalone )
	{
		tPC = GetPlayerController();

		// If we are a grenade
		if ( IsAGrenade() )
		{
			// and if we have the unlimited grenades code
			if ( tPC != None && tPC.IsBonusActive(BONUS_ALWAYS_HAVE_GRENADES) )	
			{
				// This weapon must be set to unlimited
				MakeGrenadeUnlimited();
			}
			else
			{
				// Otherwise set it to normal
				MakeGrenadeStandard();
			}
		}
		// Else we are a weapon
		else
		{
			// but do we have unlimited ammo?
			if ( tPC != None && tPC.IsBonusActive(BONUS_ALWAYS_HAVE_AMMO) )	
			{
				// If so, make this weapon unlimited
				MakeWeaponUnlimited();
			}
			else
			{
				// Otherwise set it to normal
				MakeWeaponStandard();
			}
		}
	}
}

// Toggles Fire Types
simulated function ChangeFireTypes()
{
	CurrentSubFireType++;
	if (CurrentSubFireType >= 2)
		CurrentSubFireType = 0;

	CurrentShot = 0;
}

// Overriden from parent.  If there is a better place to save the post process effect
// info then this functionality should go there.  Saving DOF info NOT available till
// after PlayerPawn's postbeginplay!
function GivenTo(Pawn ThisPawn, optional bool bDoNotActivate)
{
    local PlayerPawn			Player;
	local TPPlayerController	tPC;

    Player = PlayerPawn(ThisPawn);

	if ( Player != None )
		tPC = TPPlayerController(Player.Controller);

    if (Player != None && !Player.Controller.IsInState('PlayerShielding') && !Player.Controller.IsInState('PlayerGrappling_v2'))
    {
        if (!bDoNotActivate)
        {
            // for anim hand positions...
            tPC.ClientSetDPG(true);
            tPC.SetDesiredFOV (class'TPPlayerController'.default.DefaultFOV);
            tPC.SetGunAndArmsFOVs();
        }
    }

	//Add this weapon's animsets to the pawn
	if( TPPawn(ThisPawn) != None )
	{
		TPPawn(ThisPawn).AddAnimSetsNotUnique(PawnAnimSets);
	}

    // Don't allow any switching if shielding since we don't want to switch
    // away from the pistol
    if (Player != None && Player.Controller.IsInState('PlayerShielding'))
        bDoNotActivate = true;

	HandleWeaponCheatCodes();

    Super.GivenTo(ThisPawn, bDoNotActivate);
}

reliable client function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
	if (WorldInfo.NetMode != NM_Standalone)
		TPPawn(NewOwner).AddAnimSetsNotUnique(PawnAnimSets);

	super.ClientGivenTo(NewOwner, bDoNotActivate);
}

function ItemRemovedFromInvManager()
{
	//Remove this weapon's animsets from the pawn
	if( TPPawn(Owner) != None )
	{
        TPPawn(Owner).RemoveAnimSetFirstOccurrence(PawnAnimSets);
	}

	super.ItemRemovedFromInvManager();
}

/**
// Copied function from Base Weapon so we can add decal effects on instant fire weapons

 * Performs an 'Instant Hit' shot.
 * Also, sets up replication for remote clients,
 * and processes all the impacts to deal proper damage and play effects.
 *
 * Network: Local Player and Server
 */

simulated function InstantFire()
{
	local vector			StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local int				Idx;
	local ImpactInfo		RealImpact;

	//`log("Weapon::InstantFire");

	// define range to use for CalcWeaponFire()
	StartTrace = Instigator.GetWeaponStartTraceLocation();
	EndTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();

	//DrawDebugLine( StartTrace, EndTrace, 255,255,0); //SPARK - for visualizing instant fire direction

	// Perform shot
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

	// Added for Decals on Instant Fire Shots
	SpawnDecalEffect(RealImpact);

	if (Role == ROLE_Authority)
	{
		// Set flash location to trigger client side effects.
		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
		// would probably have to run a full simulation on remote clients.
		SetFlashLocation(RealImpact.HitLocation);
	}

	// Process all Instant Hits on local player and server (gives damage, spawns any effects).
	for (Idx = 0; Idx < ImpactList.Length; Idx++)
	{
		ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
	}
	
	Instigator.MakeNoise(m_FiringLoudness, AudioEventType_SMALL_ARMS_FIRING );
}

/**
// Copied function from Base Weapon so we can use tracers beam effects

 * Fires a projectile.
 * Spawns the projectile, but also increment the flash count for remote client effects.
 * Network: Local Player and Server
 */
simulated function Projectile ProjectileFire()
{
	local vector		StartTrace, EndTrace, RealStartLoc, AimDir;
	local ImpactInfo	TestImpact;
	local Projectile	SpawnedProjectile;
	local float DistanceCheck;
	local TPPhysicalMaterial tpphysmat;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();
	if( Role == ROLE_Authority )
	{
		// This is where we would start an instant trace. (what CalcWeaponFire uses)
		StartTrace = Instigator.GetWeaponStartTraceLocation(self);

		// this is the location where the projectile is spawned.
		RealStartLoc = GetPhysicalFireStartLoc();

		if( StartTrace != RealStartLoc && !self.IsA('PanzerStrike'))
		{
			//`log("RECOMPULATING!");
			// if projectile is spawned at different location of crosshair,
			// then simulate an instant trace where crosshair is aiming at, Get hit info.
			EndTrace = StartTrace + Vector(GetAdjustedAim( StartTrace )) * GetTraceRange();
			TestImpact = CalcWeaponFire( StartTrace, EndTrace );

			// Then we realign projectile aim direction to match where the crosshair did hit.
			AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
		}
		else
		{
			// otherwise just compute aim direction directly
			AimDir = Vector(GetAdjustedAim( RealStartLoc ));
		}

		if (WorldInfo.NetMode != NM_Standalone)
		{
			EndTrace = StartTrace + Vector(GetAdjustedAim( StartTrace )) * GetTraceRange();
			TestImpact = CalcWeaponFire( StartTrace, EndTrace );
			SetFlashLocation(TestImpact.HitLocation);
		}
		

		// Spawn projectile
		SpawnedProjectile = Spawn(GetProjectileClass(), Self,, RealStartLoc,,, false);
		
		// bDeleteMe will get set in the case of it spawning right on someone else (point blank range)
		// but we still need to set the damage type etc...
		if( SpawnedProjectile != None /*&& !SpawnedProjectile.bDeleteMe*/ )
		{
			if (!self.IsA('PanzerStrike'))
			{
				SpawnedProjectile.Speed = ProjectileSpeed;
			}
			else
			{
				SpawnedProjectile.Speed = 10;
			}
			SpawnedProjectile.MaxSpeed = ProjectileSpeed;
			SpawnedProjectile.Damage = GetInstantHitDamage();

			if( SpawnedProjectile.Damage < 0.0 )
			{
				SpawnedProjectile.Damage = 0.0;
			}

			SpawnedProjectile.MomentumTransfer = GetInstantHitMomentum();

			if (TPProjectile(SpawnedProjectile) != none)
			{
				TPProjectile(SpawnedProjectile).bInstantKillOnHeadShot = bInstantKillOnHeadShot;

				//if ( WorldInfo.NetMode != NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
				//{
					if (TPProjectile(SpawnedProjectile).bUseTracer)
					{
						if (!bIsNPCWeapon)
						{
							if (BulletFireCount++ >= TracerRoundID)
							{
								BulletFireCount = 0;
								TPProjectile(SpawnedProjectile).SpawnTracer();
							}
							else
							{
								TPProjectile(SpawnedProjectile).StaticMeshComponent.SetHidden(true);
							}
						}
						else
						{
							if (BulletFireCount == 0)
							{
								TPProjectile(SpawnedProjectile).SpawnTracer();
							}
							else
							{
								TPProjectile(SpawnedProjectile).StaticMeshComponent.SetHidden(true);
							}
							if (++BulletFireCount >= BulletsPerBurst)
								BulletFireCount = 0;
						}
					}
				//}
			}
			SpawnedProjectile.Init( AimDir );

			if (Owner != none)
			{
				//Rumble the controller for the projectile fire.
				if (Pawn(Owner).Controller.IsA('TPPlayerController'))
				{
					TPPlayerController(Pawn(Owner).Controller).ClientPlayForceFeedbackWaveform(PlayerFireWaveform);
					//else
					//{
					//	//`log("ForceFeedbackManager is NONE!");
					//}
				}
			}
			
			

			// Return it up the line
			//return SpawnedProjectile;
		}
	}

	if (WorldInfo.NetMode == NM_Client)
	{
    	//StartTrace = Instigator.GetWeaponStartTraceLocation(self);
		StartTrace = GetPhysicalFireStartLoc();
		EndTrace = StartTrace + Vector(GetAdjustedAim( StartTrace )) * GetTraceRange();
		TestImpact = CalcWeaponFire( StartTrace, EndTrace );
		DistanceCheck = VSize(Owner.Location - TestImpact.HitLocation);

		;	

		if (DistanceCheck > 700)
		{
			return SpawnedProjectile;
		}

		if (TestImpact.HitActor != none)
		{
			if (!TestImpact.HitActor.IsA('Pawn') || (TestImpact.HitActor.IsA('SVehicle') && !TestImpact.HitActor.IsA('Turret')))
			{	
				tpphysmat = TPPhysicalMaterial(TestImpact.HitInfo.PhysMaterial);
				HandleImpactParticles( tpphysmat, WeaponDamageType, TestImpact);
			}
		}
	}
		
	return SpawnedProjectile;
}

simulated function SpawnDecalEffect(ImpactInfo Info)
{
	//local DecalLifetimeDataAge LifetimeData;
	local Material DecalMat, ExitDecalMat;
	local TPPhysicalMaterial BulletMaterial;
	local TPPhysicalMaterialProperty BulletMatProperty;
	local vector WallThickness;
	local int PickedDecal;	
	local float DecalSize;

	local DecalComponent Decal;
		
		
		
	if (Info.HitActor != none)
	{
		if (!Info.HitActor.IsA('Pawn'))
		{
			if (Info.HitInfo.PhysMaterial == none)
			{
				Info.HitInfo.PhysMaterial = DefaultPhysMaterial;
			}
			BulletMaterial = TPPhysicalMaterial(Info.HitInfo.PhysMaterial);
			BulletMatProperty = TPPhysicalMaterialProperty(BulletMaterial.PhysicalMaterialProperty);
			
			PickedDecal = Rand(BulletMatProperty.BulletDecals.Length);
			DecalMat = BulletMatProperty.BulletDecals[PickedDecal].DecalMaterial;
			ExitDecalMat = BulletMatProperty.BulletDecals[PickedDecal].ExitDecalInfo.DecalMaterial;

			if (DecalMat != none)
			{
				//LifetimeData = new(Owner) class'DecalLifetimeDataAge';
				//LifetimeData.LifeSpan = 99999.0;
						
				DecalSize = (FRand() * (BulletMatProperty.BulletDecals[PickedDecal].MaxSize - BulletMatProperty.BulletDecals[PickedDecal].MinSize)) + BulletMatProperty.BulletDecals[PickedDecal].MinSize;
				//Decal = Owner.AddDecal(DecalMat,Info.HitLocation,rotator(-Info.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,Info.HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, Info.HitInfo.BoneName/*HitBone*/, Info.HitInfo.Item/*HitNodeIndex*/, Info.HitInfo.LevelIndex/*HitLevelIndex*/);
				Decal = WorldInfo.MyDecalManager.SpawnDecal(DecalMat,Info.HitLocation,rotator(-Info.HitNormal),DecalSize,DecalSize,20,false,Rand(40)-20,Info.HitInfo.HitComponent,true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, Info.HitInfo.BoneName/*HitBone*/, Info.HitInfo.Item/*HitNodeIndex*/, Info.HitInfo.LevelIndex/*HitLevelIndex*/);
				if (Decal != none)
				{
					Info.HitActor.AttachComponent(Decal);
					TPGameReplicationInfo(WorldInfo.GRI).BulletDecalManager.Add(Decal);
				}

				if (BulletMatProperty.BulletDecals[PickedDecal].UseExitDecalInfo && ExitDecalMat != none)
				{
					DecalSize = (FRand() * (BulletMatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MaxSize - BulletMatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MinSize)) + BulletMatProperty.BulletDecals[PickedDecal].ExitDecalInfo.MinSize;
				
					WallThickness.X = BulletMatProperty.BulletDecals[PickedDecal].ExitDecalInfo.WallThickness;
					//Decal = Owner.AddDecal(ExitDecalMat,Info.HitLocation + (WallThickness >> rotator(-Info.HitNormal) ),rotator(Info.HitNormal),Rand(40)-20, DecalSize,DecalSize,20,false,Info.HitInfo.HitComponent,/*LifetimeData*/None, true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, Info.HitInfo.BoneName/*HitBone*/, Info.HitInfo.Item/*HitNodeIndex*/, Info.HitInfo.LevelIndex/*HitLevelIndex*/);
					Decal = WorldInfo.MyDecalManager.SpawnDecal(ExitDecalMat,Info.HitLocation + (WallThickness >> rotator(-Info.HitNormal) ),rotator(Info.HitNormal),DecalSize,DecalSize,20,false,Rand(40)-20,Info.HitInfo.HitComponent,true/*bProjectOnTerrain*/, false/*bProjectOnSkeletalMeshes*/, Info.HitInfo.BoneName/*HitBone*/, Info.HitInfo.Item/*HitNodeIndex*/, Info.HitInfo.LevelIndex/*HitLevelIndex*/);
					
					if (Decal != none)
					{
						Info.HitActor.AttachComponent(Decal);
						TPGameReplicationInfo(WorldInfo.GRI).BulletDecalManager.Add(Decal);
					}

					Info.HitLocation += (WallThickness >> rotator(-Info.HitNormal) );
					Info.HitNormal *= -1; 
					BulletMaterial.SpawnImpactParticles( None, Info );
				}
			}
			
		}
	}
}

function DropFrom(vector StartLocation, vector StartVelocity)
{
	if (WeapID != 'Hands')
		super.DropFrom(StartLocation, StartVelocity);
}

simulated event bool IsReloading()
{
	return IsInState('Reloading');
}

simulated event bool IsSprinting()
{
	return IsInState('ActiveSprinting');
}


simulated event bool IsAimDownSight()
{
	return bToggleAimDownSight;
}

simulated event bool IsAimDownSightLocked()
{
	return bLockAimDownSight;
}

//simulated event bool IsWeaponHolstering()
//{
//    return IsInState('WeaponHolstering');
//}

simulated event bool IsWeaponEquipped()
{
    return bWeaponEquipped;
}

simulated event bool IsEquipping()
{
	local TPPawn P;
	local bool bResult;

	bResult = IsInState('WeaponEquipping');
	P = TPPawn(Owner);

	if (P != none)
	{
		P.bIsEquipping = bResult;
	}
	return bResult;
}

simulated event bool IsPuttingDown()
{
	local TPPawn P;
	local bool bResult;

	bResult = (IsInState('WeaponPuttingDown') || IsInState('WeaponHolstering') );
	P = TPPawn(Owner);

	if (P != none)
	{
		P.bIsPuttingDown = bResult;
	}
    return bResult;
}

// Returns the total ammo we have including what we have in our magazine
simulated function int GetTotalAmmo()
{
	return GetAmmoInMagazine() + AmmoCount;
}

// Returns true if there is ammo left in the other weapon, false otherwise
function bool TakeAmmo (TPWeapon Other)
{
    local int AmmoNeeded;

    AmmoNeeded = MaxAmmo - AmmoCount;

	if ( !bInfiniteAmmo )
	{
		if (Other.AmmoCount >= AmmoNeeded)
		{
			//`log(self @ "taking ammo needed" @ AmmoNeeded);
	    
			AmmoCount += AmmoNeeded;
			Other.AmmoCount -= AmmoNeeded;
			AmmoNeeded = 0;
		}
		else
		{
			//`log(self @ "taking other's ammo count" @ Other.AmmoCount);

			AmmoCount += Other.AmmoCount;
			AmmoNeeded -= Other.AmmoCount;
			Other.AmmoCount = 0;
		}

		if (Other.GetAmmoInMagazine() >= AmmoNeeded)
		{
			//`log(self @ "taking ammo needed in magazine" @ AmmoNeeded);
	    
			AmmoCount += AmmoNeeded;
			Other.AddToAmmoInMagazine(-AmmoNeeded);

			AmmoNeeded = 0;
		}
		else
		{
			//`log(self @ "taking other's ammo in magazine" @ Other.AmmoInMagazine);

			AmmoCount += Other.GetAmmoInMagazine();
			AmmoNeeded -= Other.GetAmmoInMagazine();
			Other.SetAmmoInMagazine(0);
		}
	}
    
    return (Other.AmmoCount+Other.GetAmmoInMagazine() > 0);
}

//Override from Weapon class
simulated state Active
{
    simulated function BeginState( Name PreviousStateName )
	{
        local int i;

		//`log(" ChadAI - TPWep: " @ Self @ " Time: " @ WorldInfo.TimeSeconds @ " Active state - BeginState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");
		m_AI_WeaponState = WeaponState_Active;

        if(bWeaponEquipped)
            PlayIdleAnimationAnimation();

		// Check to see if we need to go down
   		if( bWeaponPutDown )
		{
			PutDownWeapon();
		}
		else
		{
	        // if either of the fire modes are pending, perform them
			for( i=0; i<InvManager.PendingFire.Length; i++ )
			{
				if( PendingFire(i) )
				{
					// Kking - Keep an eye out for how we treat pending fire.  Deviations in Weapon and TPWeapon may cause this functionality to be incorrect.
					BeginFire(i);	
					break;
				}
			}
		}
	}

	/** Override BeginFire so that it will enter the firing state right away. */
	simulated function BeginFire(byte FireModeNum)
	{
		//`log(" ChadAI - Wepaon: " @ Self @ " In Active State and BeginFire fn called-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		// Kking - Handle Single Shot and Auto fire the same for now.  This is most likely incorrect for single shot and will need testing to see what's wrong.
	    if( !bDeleteMe && Instigator != none )
		{
            WalkSprintTransitionDone();
			Global.BeginFire(FireModeNum);

			if(!bWeaponEquipped)
	        {
                GotoState( 'WeaponEquipping' );
	        }
            else if(!HasAmmo( FireModeNum ))
			{
				//`log(" ChadAI - Wepaon: " @ Self @ " In Active State Reloading State and !HasAmmo - CanReload(): " @ CanReload()  @ " MagazineFull: " @ MagazineFull() @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			   if( CanReload() && !MagazineFull() )
			   {
				   // Kking - This shouldn't be possible as reload happens outside this.  Investigate.
				  // `log("Kking - _<TPWeapon>_Active::BeginFire() - Called while should be in reload.");

                   if (WorldInfo.NetMode == NM_Standalone)
				   {
						//`log(" ChadAI - Wepaon: " @ Self @ " In Active State Reloading State Starting due !HasAmmo && CanReload && !MagazineFull && WorldInfo.NetMode == NM_Standalone -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
						GoToState('Reloading');
				   }

                   return;
               }
               else
			   {
				   // the weapon is empty and there arePlay Sound_WeaponEmpty
					//if (WorldInfo.NetMode != NM_Standalone)
					//	PlayerPawn(Instigator).DoMeleeAttack();
					//else
				    PlaySoundWeaponEmpty();
			   }
			}
			else if( PendingFire( FireModeNum ) && HasAmmo(FireModeNum))
			{
                // in the active state, fire right away if we have the ammunition
				//`log(" ChadAI - Weapon: " @ Self @ " state Active BeginFirefn SendToFiringState in TP WEAPON &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

				SendToFiringState( FireModeNum );
			}
		}
	}

    simulated event Tick(float DeltaTime)
    {
        //local PlayerPawn player;

        if (bToIdle)
            ToIdleAccu += DeltaTime;
        if (bToADS)
            ToADSAccu  += DeltaTime;
        if (bToWalk)
            ToWalkAccu += DeltaTime;

        //if (bToggleAimDownSight && bEnableAimDownDof)
        //{
        //    player = PlayerPawn(Instigator);
        //    player.WeaponDOFTick(DeltaTime);
        //}
    }

    simulated function ChangePosture(bool bStand)
    {
        bToStand  = bStand;
        bToCrouch = !bStand;
    }
}

simulated event WalkSprintTransitionDone()
{
    bToSprint           = false;
    bToWalk             = false;
    ToWalkAccu          = 0;
    ToSprintAccu        = 0;
    TransitionStartTime = 0;
}

simulated state ActiveSprinting extends Active
{
	simulated function BeginState(Name PreviousStateName)
	{
		m_AI_WeaponState = WeaponState_ActiveSprinting;

		super.BeginState(PreviousStateName);

        if (bToWalk)
        {
            ToSprintAccu = class'TPAnimNodeBlendByWeaponState'.default.sprintBlendTime - ToWalkAccu;
            TransitionStartTime = ToSprintAccu;
        }

        bToSprint = true;
        bToWalk   = false;

		//TPPawn(Owner).bIsSprinting = true;
		//TPPlayerController(TPPawn(Owner).Controller).SetSprinting(true);
	}
	simulated function EndState(Name NextStateName)
	{
		super.EndState(NextStateName);

        if (bToSprint)
        {
            ToWalkAccu = class'TPAnimNodeBlendByWeaponState'.default.sprintBlendTime - ToSprintAccu;
            TransitionStartTime = ToWalkAccu;
        }

        bToSprint = false;
        bToWalk   = true;

		//TPPlayerController(TPPawn(Owner).Controller).SetSprinting(false);
	}


    simulated event Tick(float DeltaTime)
    {
        if (bToSprint)
            ToSprintAccu += DeltaTime;

        Super.Tick(DeltaTime);
    }
}

// Each weapon should override this for it's recoil model.
// 
// Percent - The amount of time that has passed since the weapon was fired in percentage.
//           i.e. If weapon fire time is 0.75 and 0.375 seconds has passed, this value is .5
//           
// Angle - The change in angle (in degrees) that will be applied this   (following the default
//         model of changing the angle linearly as a function of time).
//
simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    return FireAngle;
}


simulated function GetRecoilParams(out float FireTime, out float RecoverTime, out float RecoilAngle, out float RecoilJitter)
{
    if (IsAimDownSight())
    {
        if (Instigator.bIsCrouched)
        {
            FireTime     = CrouchingAimRecoil.FireTime;
            RecoverTime  = CrouchingAimRecoil.RecoverTime;
            RecoilAngle  = CrouchingAimRecoil.RecoilAngle;
            RecoilJitter = CrouchingAimRecoil.RecoilJitter;
        }
        else
        {
            FireTime     = StandingAimRecoil.FireTime;
            RecoverTime  = StandingAimRecoil.RecoverTime;
            RecoilAngle  = StandingAimRecoil.RecoilAngle;
            RecoilJitter = StandingAimRecoil.RecoilJitter;
        }
    }
    else
    {
        if (Instigator.bIsCrouched)
        {
            FireTime     = CrouchingRecoil.FireTime;
            RecoverTime  = CrouchingRecoil.RecoverTime;
            RecoilAngle  = CrouchingRecoil.RecoilAngle;
            RecoilJitter = CrouchingRecoil.RecoilJitter;
        }
        else
        {
            FireTime     = StandingRecoil.FireTime;
            RecoverTime  = StandingRecoil.RecoverTime;
            RecoilAngle  = StandingRecoil.RecoilAngle;
            RecoilJitter = StandingRecoil.RecoilJitter;
        }
    }
}

simulated function float GetSpread()
{
    local float  MySpread, Percent;
		
    if (IsAimDownSight())
    {
        if (Instigator.bIsCrouched)
            MySpread = bIsNPCWeapon? CrouchingAimRecoil.Spread_AI : CrouchingAimRecoil.Spread;
        else
            MySpread = bIsNPCWeapon? StandingAimRecoil.Spread_AI  : StandingAimRecoil.Spread;
    }
    else
    {
        if (Instigator.bIsCrouched)
            MySpread = bIsNPCWeapon? CrouchingRecoil.Spread_AI : CrouchingRecoil.Spread;
        else
            MySpread = bIsNPCWeapon? StandingRecoil.Spread_AI  : StandingRecoil.Spread;
    }

    Percent = VSize(Owner.Velocity)/class'PlayerPawn'.default.SprintGroundSpeed;
    fclamp(Percent, 0.0, 1.0f);

    MySpread += ((bIsNPCWeapon? SprintSpread_AI : SprintSpread) - MySpread) * Percent;

    return MySpread;
}

simulated function UpdateRecoil (float DeltaTime)
{
    local float Percent;
    local float Angle;
    local float PrevPercent;
    local float Jitter;
    local float PrevJitter;

    local float FireTime;
    local float RecoverTime;
    local float RecoilAngle;
    local float RecoilJitter; 

    local float Temp;

    local int i;
    local int j;

    GetRecoilParams(FireTime, RecoverTime, RecoilAngle, RecoilJitter);

    if (Recoil.State == RE_Fire)
    {
        Recoil.Time     -= DeltaTime;
        Percent          = fclamp(1 - (Recoil.Time / FireTime), 0.f, 1.f);

        PrevPercent = Recoil.PrevPercent;
        Recoil.PrevPercent = Percent;

        i = int(PrevPercent*100);
        j = int(Percent*100);

        Temp = 0;        
        while (i < j)
        {
            if (i > 0 && (i % 10 == 0))
            {
                Angle = RecoilAngle/10.f; // redundant...
                Temp += FireRecoilProcess (float(i)/100.f, Angle);
            }

            i++;
        }

        Recoil.TotalFireAngle += Temp;

		//`log("Base angle is"@Angle@"base jitter is"@RecoilJitter*AccuracyMod);
        Jitter = RecoilJitter * FRand();
        if (Rand (2) % 2 == 1)
            Jitter *= -1;

        Recoil.TotalFireJitter += Jitter;

        TPPlayerController(Pawn(Owner).Controller).PlayerInput.aLookUp += Temp * 0xFFFF / 360.f;
        TPPlayerController(Pawn(Owner).Controller).PlayerInput.aTurn   += Jitter * 0xFFFF / 360.f;

        if (Recoil.Time < 0)
        {
            Recoil.Time       = RecoverTime;
            Recoil.PrevAngle  = 0;
            Recoil.PrevJitter = 0;
            Recoil.State      = RE_Recover;
        }
    }
    else if (Recoil.State == RE_Recover)
    {
        Recoil.Time -= DeltaTime;
        Percent      = 1 - (Recoil.Time / RecoverTime);
        PrevPercent  = Recoil.PrevAngle;
        PrevJitter   = Recoil.PrevJitter;
        Angle        = Percent*Recoil.TotalFireAngle;
        Jitter       = Percent*Recoil.TotalFireJitter;

        Recoil.PrevAngle  = Angle;
        Recoil.PrevJitter = Jitter;

        Angle = Angle - PrevPercent;
        Jitter = Jitter - PrevJitter;
        
        Recoil.TotalRecoverAngle  += Angle;
        Recoil.TotalRecoverJitter += Jitter;

        if (Recoil.TotalRecoverAngle >= Recoil.TotalFireAngle)
        {
            Angle -= Recoil.TotalRecoverAngle - Recoil.TotalFireAngle;
            Recoil.TotalRecoverAngle -= Recoil.TotalRecoverAngle - Recoil.TotalFireAngle;

            Jitter -= Recoil.TotalRecoverJitter - Recoil.TotalFireJitter;
            Recoil.TotalRecoverJitter -= Recoil.TotalRecoverJitter - Recoil.TotalFireJitter;
        }

        TPPlayerController(Pawn(Owner).Controller).PlayerInput.aLookUp -= Angle  * 0xFFFF/360.0f;
        TPPlayerController(Pawn(Owner).Controller).PlayerInput.aTurn   -= Jitter * 0xFFFF/360.0f;

        if (Recoil.Time < 0)
        {
            //TPPlayerController(Pawn(Owner).Controller).ClientMessage
            //    ("Total reco angle    : " @ (Recoil.TotalRecoverAngle));
            Recoil.State = RE_None;
            Spread[CurrentFireMode] = 0;
        }
    }
}


simulated function FireAmmunition()
{
	local float Dummy;

    if (SubFireTypes[CurrentSubFireType] == FT_RapidShot && Recoil.State == RE_None && PlayerPawn(Owner) != None)
        Spread[CurrentFireMode] = 0;
    else
        Spread[CurrentFireMode] = GetSpread();

    if (PlayerPawn(Owner) != None)
    {
        if (Recoil.State == RE_None)
        {
            Recoil.TotalFireAngle = 0;
            Recoil.TotalRecoverAngle = 0;
            Recoil.TotalFireJitter = 0;
        }
        else
        {
            Recoil.TotalFireJitter -= Recoil.TotalRecoverJitter;
            Recoil.TotalFireAngle  -= Recoil.TotalRecoverAngle;
        }

        Recoil.TotalRecoverAngle = 0;
        Recoil.TotalRecoverJitter = 0;

        GetRecoilParams(Recoil.Time, Dummy, Dummy, Dummy);

        Recoil.PrevAngle   = 0;
        Recoil.PrevPercent = 0;
        Recoil.State       = RE_Fire;

		if (!IsA('Grenade_Persistent') && !IsA('Panzerstrike'))
		{
			if (WorldInfo.NetMode == NM_Standalone && PlayerPawn(Owner) != None && PlayerPawn(Owner).Controller != None && TPPlayerController(PlayerPawn(Owner).Controller) != None )
			{
				TPPlayerController(PlayerPawn(Owner).Controller).Achievements.ClientIncrementBulletsFired(1);
			}
			else if (Role == ROLE_Authority && PlayerPawn(Owner) != None && PlayerPawn(Owner).Controller != None && TPPlayerController(PlayerPawn(Owner).Controller) != None )
			{
				TPPlayerReplicationInfo(TPPlayerController(PlayerPawn(Owner).Controller).PlayerReplicationInfo).IncrementBulletsFiredThisRound();
			}
		}

		shotsFired++;
    }

	if (Owner != none)
	{
		//Rumble the controller for the projectile fire.
		if (Pawn(Owner).Controller.IsA('TPPlayerController'))
		{
			TPPlayerController(Pawn(Owner).Controller).ClientPlayForceFeedbackWaveform(PlayerFireWaveform);
		}
	}

	//`log(" ChadAI - Weapon: " @ Self @ " FireAmmunition in TP WEAPON -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

    Super.FireAmmunition ( );
}

simulated function RefireCheckTimer()
{
}

simulated function DetermineTransition()
{
	;
	//TPPlayerController(Pawn(Owner).Controller).Say("Check Log - DetermineTransition()"); 
}

simulated function DetermineFireMode()
{
	// For Different Fire Types
	CurrentShot++;
	bSemiAuto = false;
	switch(SubFireTypes[CurrentSubFireType])
	{
		case FT_SingleShot:
			bSemiAuto=true;
			break;
		case FT_BurstShot:
			if (CurrentShot >= SubFireBulletsPerBurst)
			{
				bSemiAuto = true;
				CurrentShot = 0;
			}
			break;
		case FT_RapidShot:
			bSemiAuto = false;
			break;
	}

}

//Override from Weapon class
simulated state WeaponFiring
{

	/** Override BeginFire so that it will enter the firing state right away. */
	simulated function BeginFire(byte FireModeNum)
	{
		clientFireOverRide = false;

		if ( bSemiAuto )
		{
			ReloadCheck();
			
			if ( WorldInfo.NetMode == NM_ListenServer && !Pawn(Owner).IsLocallyControlled() && HasAmmo(CurrentFireMode) )
			{
				;

				// then flag it so StartFire knows to grant the shot
				clientFireOverRide = true;

				
				// Kking: This fixes the semi-auto sync issue when clients fire in active and server is still in WeaponFiring.
				PlayFiringAnimation();
				FireAmmunition();

				Super.BeginFire(FireModeNum);
				
			}

			return;
		}
			
		
		Super.BeginFire(FireModeNum);
	}
	simulated function bool ReloadCheck()
	{
		if (Role == ROLE_Authority && !HasAmmo(CurrentFireMode))
		{
			ClearTimer('RefireCheckTimer');
			OutofAmmo();
			// Calling PlayReload as listen server will result in duplicate call as OutofAmmo is a client call that is called on clients/ListenServer, but NOT Dedicated Server
			if ( WorldInfo.NetMode == NM_ListenServer )
			{
				//`log("ChadAI - WeaponFiring - ReloadCheck - PlayReload");
				PlayReload();
			}

			return true;
		}

		return false;
	}


	simulated function StartFire(byte FireModeNum)
	{

		// If we are a listen server and the client is requesting to start fire, due to latency we should simply grant this request
		// and assume that the client waited an appropriate amount of time before refiring a semi-auto
			
		if ( bSemiAuto && clientFireOverRide == false )
			return;  

		clientFireOverRide = false;
		Super.StartFire(FireModeNum);

	}
	simulated event ReplicatedEvent(name VarName)
	{
		if ( VarName == 'AmmoCount' && !HasAnyAmmo() )
		{
			return;
		}

		Super.ReplicatedEvent(VarName);

	}

    simulated function BeginState( Name PreviousStateName )
	{
		m_AI_WeaponState = WeaponState_WeaponFiring;
		//`log(self @ "Begin: Weapon Firing," @ PreviousStateName);
		super.BeginState( PreviousStateName );
        PlayFiringAnimation();
    }

	// Kking - This whole function needs to be rewritten
	simulated function RefireCheckTimer()
	{
		if (!bIsNPCWeapon)
		{
			DetermineFireMode();
		}

		DetermineTransition();
	}
	
    simulated function EndState( Name NextStateName )
	{
		// Set weapon as not firing
		ClearFlashCount();
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
		shotsCompleted++;

		if (Instigator != none && AIController(Instigator.Controller) != None)
		{
			AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self,CurrentFireMode);
		}
    }

	simulated function DetermineTransition()
	{
		if ( bSemiAuto )
			ClearTimer('RefireCheckTimer');

		if ( bSemiAuto && HasAmmo(CurrentFireMode) )
		{
			StopFire(CurrentFireMode);
			GotoState('Active');
		}
		else if (Role == ROLE_Authority && !HasAmmo(CurrentFireMode))
		{
			ReloadCheck();
		}
		else if ( ShouldRefire() )
		{
			//`log(" ChadAI - Weapon: " @ Self @ " state WeaponFiring in TP WEAPON says I should FireAmmunition -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

			PlayFiringAnimation();
			FireAmmunition();
		}
		else
		{
			StopFire(CurrentFireMode);
			GotoState('Active');
		}
	}
	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		if (SeqNode != None && SeqNode.NodeName == 'WeaponFiringAnimations')
		{
			//`log( SeqNode @ SeqNode.NodeName);
			DetermineTransition();
		}
	}

}

reliable server function ServerWeaponEquip()
{


}

// Since variable replication is not guarenteed to be received in time
reliable client function OutofAmmo()
{
	AmmoInMagazine = 0;
	ClearFlashCount();
	ClearFlashLocation();
	ClearTimer('RefireCheckTimer');

	// Call the Weapon Weapon Empty Event
	if (Instigator != none && TPPlayerController(Instigator.Controller) != none)
		TPPlayerController(Instigator.Controller).WeaponIsEmpty(self);

	if ( IsA('Grenade_Persistent')  )
		return;

    if (CanReload())
	{
		//`log("ChadAI - OutofAmmo - PlayReload");
	    PlayReload();
	}
    else
	{
		GoToState('Active');
	}
}

simulated function TimeWeaponEquipping()
{
	//`log("TPDemoWeapon::TimeWeaponEquipping().. Instigator="$Instigator);


//
//	// Play the animation
//	if( Instigator.IsFirstPerson() )
//	{
//		PlayWeaponEquip();
//	}

	super.TimeWeaponEquipping();


	// The weapon is equipped, attach it to the mesh.
	//AttachWeaponTo( Instigator.Mesh );

}

simulated state WeaponEquipping
{
	simulated function BeginState(Name PreviousStateName)
	{
		//`log(" ChadAI - Wep: " @ Self @ " Time: " @ WorldInfo.TimeSeconds @ " WeaponEquipping BeginState -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");


		m_AI_WeaponState = WeaponState_WeaponEquipping;

        if (Instigator.IsA('PlayerPawn'))
        {
            Mesh.SetDepthPriorityGroup(SDPG_Foreground);
        }
		

		// If the role is authority
		if ( Role == ROLE_AUTHORITY )
		// And we are not locally controlled
			if ( Instigator.IsLocallyControlled() == false ) //
			{
				Mesh.SetDepthPriorityGroup(SDPG_World);		
			}

        AttachWeaponTo( Instigator.Mesh );
        
        Mesh.SetHidden(false);
         
		super.BeginState( PreviousStateName );

		bLockAimDownSight = true;
    }


    simulated function EndState(name NextState)
    {
        bLockAimDownSight = false;

		TryToRestoreAimDownSight();

        Super.EndState(NextState);
    }

	simulated function WeaponEquipped()
	{   
		//`log(" ChadAI - TPWep: " @ Self @ " Time: " @ WorldInfo.TimeSeconds @ " WeaponEquipping state - WeaponEquipped -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");

		bWeaponEquipped=true;
		
        bWeaponIsHolstered = false; 
		
		
		super.WeaponEquipped();
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)  // kmsk
	{
		if( SeqNode == None )
			return;
			
		if (SeqNode.NodeName == 'WeaponUnequippingAnimations'		||
			SeqNode.NodeName == 'WeaponEquippingAnimations'			||
            SeqNode.NodeName == 'StandWeaponEquippingAnimations'	||
            SeqNode.NodeName == 'CrouchWeaponEquippingAnimations'		)
		{
            WeaponEquipped();
		}
	}
}

simulated state WeaponPuttingDown
{
	simulated function BeginState(Name PreviousStateName)
	{
//        `log(self @ "----------------Im putting down my weapon------");
		super.BeginState( PreviousStateName );      
		//WeaponIsDown();

		m_AI_WeaponState = WeaponState_WeaponPuttingDown;

		TryToStoreAimDownSight();
    }


	simulated function WeaponIsDown()
	{
        bWeaponEquipped=false;
		super.WeaponIsDown();
	}

    simulated function EndState(name NextState)
    {
        Super.EndState(NextState);
    }

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{ 
		if( SeqNode == None )
			return;

		if (SeqNode.NodeName == 'WeaponUnequippingAnimations'		||
			SeqNode.NodeName == 'WeaponEquippingAnimations'			||
            SeqNode.NodeName == 'StandWeaponUnequippingAnimations'	||
            SeqNode.NodeName == 'CrouchWeaponUnequippingAnimations'		)
		{
			WeaponIsDown();
		}
	}

}

simulated function TimeWeaponHolstering()
{
	SetTimer( PutDownTime>0 ? PutDownTime : 0.01 , false, 'WeaponHolstered');
}

simulated state WeaponHolstering
{
    simulated function BeginState( Name PreviousStateName )
	{
//        `log(self @ "----------------Im holstering my weapon------");
		m_AI_WeaponState = WeaponState_WeaponHolstering;

        if( WeapID == 'Pistol')
        {   
            SetHidden(true);
        }
        
		TimeWeaponHolstering();
        
        if(bWeaponIsHolstered)//?
        {
           //return;
           WeaponHolstered();
        }
    }

    simulated function EndState( name NextStateName)
    {
		ClearTimer('WeaponHolstered');

    }

	simulated function WeaponHolstered()
	{
        if(!bWeaponIsHolstered)
            bWeaponIsHolstered = true; 
        GotoState('Active');
	}
	
	

    event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		WeaponHolstered();
	}
}

simulated function TimeWeaponReload()
{
	//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " TimeWeaponReload:  SetTimer - m_MaxReloadTime: " @ m_MaxReloadTime @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	SetTimer( m_MaxReloadTime>0 ? m_MaxReloadTime : 0.01 , false, 'WeaponReloaded');
}

simulated function WeaponReloadedFromTimer()
{
	// If priming the grenade when a reload happens, unprime the grenade.
	//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " WeaponReloadedFromTimer:  Called in the main class -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	WeaponReloaded();
}

simulated function WeaponReloaded()
{
	// If priming the grenade when a reload happens, unprime the grenade.
	//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " WeaponReloaded:  Called in the main class IsInState('Active'): " @ IsInState('Active') @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

	if( Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None && TPPlayerController(Pawn(Owner).Controller) != None )
	{
		TPPlayerController(Pawn(Owner).Controller).bThrowGrenade=false;	
		TPPlayerController(Pawn(Owner).Controller).PrevWeaponOnGrenade=None;
	}

		if ( Instigator != None && Instigator.IsLocallyControlled() && Role == ROLE_SimulatedProxy )
		{
			ReloadComplete();
		}

		if( IsInState('Active') == FALSE )
		{
			GotoState('Active');
		}
}

simulated state Reloading
{
	simulated function BeginState( Name PreviousStateName )
	{
		local int AmountToReload;
        local TPPlayerController tppController;

		m_AI_WeaponState = WeaponState_Reloading;


		//`log(" ChadAI - Weapon: " @ Self@ " Reloading:BeginState just started by goto -AmmoCount: " @ -AmmoCount @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( TPPawn(Owner) != None )
		{
			TPPawn(Owner).bIsReloading = true;

			tppController = TPPlayerController(Pawn(Owner).Controller);

			if( tppController != None )
			{
				tppController.bThrowGrenade=false;	
				tppController.PrevWeaponOnGrenade=None;
			}

			if ( AmmoCount <= 0 && !bInfiniteAmmo )
			{
				//`log(" ChadAI - Weapon: " @ Self @ " Reloading:BeginState  -AmmoCount: " @ -AmmoCount @ " is Zero So Ending -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
				GotoState('Active');
				return;
			}

			// Find how much ammo is needed if there is still ammo in the magazine
			AmountToReload = GetMagazineSize() - GetAmmoInMagazine();

			if (AmountToReload <= AmmoCount)
			{
				AddToAmmoInMagazine(AmountToReload);
				//`log(" ChadAI - Weapon: " @ Self @ " Reloading:  -AmountToReload: " @ -AmountToReload @ " AmmoCount: " @ AmmoCount @ " AmmoInMagazine: " @ GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				if( !bInfiniteAmmo )
				{
					AmmoCount -= AmountToReload;
				}
			}
			else
			{
				//`log(" ChadAI - Weapon: " @ Self @ " Reloading:  AmountToReload > AmmoCount -AmountToReload: " @ -AmountToReload @ " AmmoCount: " @ AmmoCount @ " AmmoInMagazine: " @ GetAmmoInMagazine()  @" -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

				AddToAmmoInMagazine(AmmoCount);

				if( !bInfiniteAmmo )
					AmmoCount = 0;
			}

			TryToStoreAimDownSight();
			bLockAimDownSight = true;

			TimeWeaponReload();
		}
    }

	simulated function EndState(Name NextStateName)
	{
		TPPawn(Owner).bIsReloading = false;

        ClearTimer('WeaponReloaded');
        
		if ( bIsNPCWeapon && Owner != None )
		{
			if ( TPSoldierAIController(Pawn(Owner).Controller) != None )
			{
				TPSoldierAIController(Pawn(Owner).Controller).WeaponReloaded();
			}
		}

        bLockAimDownSight = false;

		TryToRestoreAimDownSight();
	}

	simulated function WeaponReloadedFromTimer()
	{
		//`log(" ChadAI - Time: " @ WorldInfo.TimeSeconds @ " WeaponReloadedFromTimer:  Called in Reload State  -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		WeaponReloaded();
	}

	simulated function WeaponReloaded()
	{
		//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		if( Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None && TPPlayerController(Pawn(Owner).Controller) != None )
		{
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State Owner is a Player -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			// If priming the grenade when a reload happens, unprime the grenade.
			TPPlayerController(Pawn(Owner).Controller).bThrowGrenade=false;	
			TPPlayerController(Pawn(Owner).Controller).PrevWeaponOnGrenade=None;
		}
		else
		{
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State Owner is Not a Player -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
		}

		if ( Instigator != None && Instigator.IsLocallyControlled() && Role == ROLE_SimulatedProxy )
		{
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State - ReloadComplete getting called -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

			ReloadComplete();
		}
		else
		{
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State - ReloadComplete NOT getting called - Instigator: " @ Instigator @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State - ReloadComplete NOT getting called - Instigator.IsLocallyControlled(): " @ Instigator.IsLocallyControlled() @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			//`log(" ChadAI - Weapon: " @ Self @ " WeaponReloaded in Reload State - ReloadComplete NOT getting called - Role: " @ Role @ " -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

		}

		GotoState('Active');

	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		if (SeqNode != None && SeqNode.NodeName == 'WeaponReloadingAnimations')
		{
			//animation has ended
			//`log(" ChadAI - OnAnimEnd:  Calling WeaponReloaded -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");
			WeaponReloaded();
		}
	}
	
}

simulated function TPPlayerController GetPlayerController()
{
	local  PlayerPawn              thePlayerPawn;
	local  TPPlayerController      tpc;

	if ( Owner != None )
	{
		thePlayerPawn = PlayerPawn( Owner );
		if ( thePlayerPawn != None && thePlayerPawn.controller != None )
		{
			tpc = TPPlayerController( thePlayerPawn.controller );
            return tpc;
		}
	}
	return ( none );
}

simulated event ADSTransitionDone()
{
    bToADS              = false;
    bToIdle             = false;
    ToADSAccu           = 0;
    ToIdleAccu          = 0;
    TransitionStartTime = 0;
}

simulated event bool IsADSTransitionDone()
{
    return !bToADS && !bToIdle;
}


simulated function ToggleAimDownSight(TPPlayerController TPController)
{
	local float FOVRate;

    if (IsAimDownSightLocked())
        return;

    bToggleAimDownSight = !bToggleAimDownSight;

    if (bToIdle)
    {
        ToADSAccu = class'TPAnimNodeBlendByWeaponState'.default.ADSBlendTime - ToIdleAccu;
        TransitionStartTime = ToADSAccu;
    }
    if (bToADS)
    {
        ToIdleAccu = class'TPAnimNodeBlendByWeaponState'.default.ADSBlendTime - ToADSAccu;
        TransitionStartTime = ToIdleAccu;
    }

    if (bToggleAimDownSight)
	{
        // Calculate FOV rate based on the a 0.2 second blend time from regular aiming
        // to aim down sight aiming
		FOVRate = (TPController.DefaultFOV - AimDownFOV)/0.2;
		TPController.SetDesiredFOV (AimDownFOV,FOVRate,true);
		TPController.Pawn.GroundSpeed = 200;

        bToADS              = true;
        bToIdle             = false;
	}
    else
	{
		FOVRate = (TPController.DefaultFOV - AimDownFOV)/0.2;
		TPController.SetDesiredFOV (TPController.DefaultFOV,FOVRate,true);
		TPController.Pawn.GroundSpeed = 400;

        bToADS              = false;
        bToIdle             = true;
    }

    //PlayerPawn(TPController.Pawn).SetDOFParameters
    //    (bToggleAimDownSight && bEnableAimDownDof, AimDownFocusInnerRadius, AimDownFalloffExponent, AimDownBlurKernelSize);
}

simulated function PlayWeaponEquipAnimation()
{
    //PlayAnimationOnWeapon( WeaponEquip );
    //`log("bWeaponEquipped at PlayWeaponEquipAnimation is " @bWeaponEquipped);
}

simulated function PlayWeaponUnequipAnimation()
{
    //PlayAnimationOnWeapon( WeaponUnequip );
    //`log("bWeaponEquipped at PlayWeaponUnequipAnimation is " @bWeaponEquipped);
}

simulated function PlayIdleAnimationAnimation()
{

}

simulated function PlayFiringAnimation()
{

}

simulated function PlayAnimationOnWeapon( Name Sequence, bool bLooping = false )
{
	//local SkeletalMeshComponent	SkelMesh;

	return;
	//deprecated below, sinec we use th trees now
//	// do not play on a dedicated server
//	if( WorldInfo.NetMode == NM_DedicatedServer )
//	{
//		//`log(self @ "ret 1");
//		return;
//	}
//
//	SkelMesh = SkeletalMeshComponent(Mesh);
//
//	if (SkelMesh.Animations==None)
//	{
//		//`log(self @ "ret 2");
//		return;
//	}
//
//
//	// Check we have access to mesh and animations
//	if( SkelMesh == None || AnimNodeSequence(SkelMesh.Animations) == None )
//	{
//		`log("Weapon::PlayAnimationOnWeapon - no mesh or no animations :(");
//		return;
//	}
//
//	// Set right animation sequence if needed
////	if( AnimNodeSequence(SkelMesh.Animations).AnimSeq == None ||
////		AnimNodeSequence(SkelMesh.Animations).AnimSeq.SequenceName != Sequence )
////	{
//		AnimNodeSequence(SkelMesh.Animations).SetAnim( Sequence );
//		AnimNodeSequence(SkelMesh.Animations).PlayAnim( bLooping, 1.0 );
////	}
//
//	if( AnimNodeSequence(SkelMesh.Animations).AnimSeq == None )
//	{
//		`log("Weapon::PlayAnimationOnWeapon - AnimNodeSequence(Mesh.Animations).AnimSeq == None");
//		return;
//	}
}

simulated function PlaySoundWeaponEmpty()
{
	// Dont play this in multiplayer games.
	if (WorldInfo.NetMode == NM_Standalone)
	{
		if( bIsNPCWeapon) 
		{
			if( Sound_WeaponEmpty_NPC.Length >= CurrentFireMode + 1 && Sound_WeaponEmpty_NPC[CurrentFireMode] != None )
				Owner.PlaySound(Sound_WeaponEmpty_NPC[CurrentFireMode], true,,,,true);
		}
		else
		{
			if( Sound_WeaponEmpty.Length >= CurrentFireMode + 1 && Sound_WeaponEmpty[CurrentFireMode] != None )
				Owner.PlaySound(Sound_WeaponEmpty[CurrentFireMode], true,,,,true);
		}
	}
}

simulated function PlayFiringSound()
{
	if (Owner != none)
	{
		if( bIsNPCWeapon || (WorldInfo.NetMode != NM_Standalone && ( (Instigator != none && Instigator.Role == ROLE_SimulatedProxy) || (Instigator != none && Instigator.Role == Role_Authority && !Instigator.IsLocallyControlled() ) ) ) )
		{
			if (Sound_Fire_NPC[CurrentFireMode]!=None)
			{
				Owner.PlaySound(Sound_Fire_NPC[CurrentFireMode]);
			}
			
			//Play shell sound at this point too
			if (Sound_Shell_NPC.Length >= CurrentFireMode + 1)
				Owner.PlaySound(Sound_Shell_NPC[CurrentFireMode]);
		}
		else
		{
			if (WorldInfo.NetMode != NM_ListenServer)
			{
				if (Sound_Fire[CurrentFireMode]!=None)
				{
					if (Sound_Fire.Length >= CurrentFireMode + 1)
						Owner.PlaySound(Sound_Fire[CurrentFireMode]);
				}
				
				//Play shell sound at this point too
				if (Sound_Shell.Length >= CurrentFireMode + 1)
					Owner.PlaySound(Sound_Shell[CurrentFireMode]);
			}
			else
			{
				if (Sound_Fire[CurrentFireMode]!=None)
				{
					if (Sound_Fire.Length >= CurrentFireMode + 1)
						Owner.PlaySound(Sound_Fire[CurrentFireMode], true);
				}
				
				//Play shell sound at this point too
				if (Sound_Shell.Length >= CurrentFireMode + 1)
					Owner.PlaySound(Sound_Shell[CurrentFireMode], true);

				if (Sound_Fire_NPC[CurrentFireMode]!=None)
				{
					Owner.PlaySound(Sound_Fire_NPC[CurrentFireMode],,true);
				}
				
				//Play shell sound at this point too
				if (Sound_Shell_NPC.Length >= CurrentFireMode + 1)
					Owner.PlaySound(Sound_Shell_NPC[CurrentFireMode],,true);
			}
		}
	}
}

simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	local TPPlayerController PlayerController;
	
	
	if( Mesh == None )
		;
	
	if( PlayerPawn( Owner ) != None)
	{
		//Weapon is held by a player.
		//Note this may not be the correct way to determine this in multiplayer!
		bIsNPCWeapon = false;
		PlayerController = TPPlayerController(Pawn(Owner).Controller);

		if ( PlayerController != None )
		{
			HandleWeaponCheatCodes();

			if ( !PlayerController.bIsThirdPerson )
				PlayerController.SetGunAndArmsFOVs();

		}
		
	}
	else
	{
		bIsNPCWeapon  = true;
		bInfiniteAmmo = true;
        AmmoCount     = MagazineSize_AI;    // Ensure NPC can reload
	}

	MeshCpnt.AttachComponent(Mesh, 'JO_gun');

	AttachMuzzleFlash();

	if( MeshCpnt != None )
	{
		// Set Shadow parent
		Mesh.SetShadowParent(MeshCpnt);
        Mesh.CastShadow = FALSE;
        Mesh.bCastDynamicShadow = FALSE;
		Mesh.SetLightEnvironment(MeshCpnt.LightEnvironment);
	}

    // Spawn the 3rd Person Attachment
	if (Role==ROLE_Authority && TPPawn(Instigator) != None)
	{
		TPPawn(Instigator).CurrentWeaponAttachmentClass = AttachmentClass;
		if (WorldInfo.NetMode == NM_ListenServer || WorldInfo.NetMode == NM_Standalone || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled()))
		{
			TPPawn(Instigator).WeaponAttachmentChanged();
		}
	}

    GoToState('WeaponEquipping');

}


simulated function DetachWeapon()
{
	local SkeletalMeshComponent ParentMesh;

	if (Instigator != none)
	{
		if ( Instigator.Mesh == None )
			;

        ParentMesh = Instigator.Mesh;
    }

	else
	{
		;
	}

	if (ParentMesh!=None)
	{
		if ( mesh == None )
			;

		ParentMesh.DetachComponent( mesh );
	}

	else
	{
		;
	}


	if ( Mesh != none )
	{
		mesh.SetShadowParent(none);
		mesh.SetLightEnvironment(LightEnvironment);
	}
	
	DetachMuzzleFlash();

	// RB - Added to remove weapons when we pick them up
	if (Role == ROLE_Authority && TPPawn(Instigator) != None)
	{
		if (TPPawn(Instigator).CurrentWeaponAttachmentClass == AttachmentClass)
		{
			TPPawn(Instigator).CurrentWeaponAttachmentClass = None;
			if (Instigator.IsLocallyControlled())
			{
				TPPawn(Instigator).WeaponAttachmentChanged();
			}
		}
	}

	super.DetachWeapon();
}

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	CauseMuzzleFlash();

    if (!bIsNPCWeapon && (WorldInfo.NetMode != NM_Client || (WorldInfo.NetMode == NM_Client && Instigator.IsLocallyControlled())))
	    SpawnBulletShells();
}

simulated function StopFireEffects(byte FireModeNum)
{
	StopMuzzleFlash();
}

simulated function Activate()
{
	super.Activate();
}

simulated function ConsumeAmmo( byte FireModeNum )
{
	AddToAmmoInMagazine(-1);
}

simulated function SetTossAmmo()
{
	//If infinite, randomly pick how much ammo is in our tossed weapon
	if( bInfiniteAmmo )
	{
		// bug 5963 fix, if we dare do this now
		////// begin fix for dropped npc weapons giving player too much ammo
		if (bIsNPCWeapon)
		{	
			// ammom given is AmmoCount + GetAmmoInMagazine()
			// for npc weapons GetAmmoInMagazine() is AmmoInMagazine_AI
			// for non npc weapons GetAmmoInMagazine() is AmmoInMagazine
			// so when we change bIsNPCWeapon false we need to clear AmmoInMagazine
			// also clearing AmmoInMagazine_AI just to be sure
			AmmoInMagazine = 0;
			AmmoInMagazine_AI = 0;
		}
		////// end fix for dropped npc weapons giving player too much ammo

        bIsNPCWeapon = false;

        AmmoCount = rand(DroppedAmmoMax - DroppedAmmoMin) + DroppedAmmoMin;
	}
	
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	return GetAmmoInMagazine() > 0;
}

simulated function bool CanReload()
{
    local TPPlayerController tppController;
//`log(self @ "CanReload?" @ AmmoCount[CurrentFireMode]);

    tppController = TPPlayerController(Pawn(Owner).Controller);

    if (tppController != None && tppController.IsInState('PlayerShielding'))
        return false;

	//`log(" ChadAI - Weapon: " @ Self @ " CanReload: " @ AmmoCount > 0 @ " AmmoCount: " @ AmmoCount @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

    return AmmoCount > 0;
}

simulated function bool MagazineFull()
{
//`log(self @ "MagazineFull?" @  AmmoInMagazine[CurrentFireMode] @ MagazineSize[CurrentFireMode]);
//return true;

	//`log(" ChadAI - Weapon: " @ Self @ " MagazineFullfn GetAmmoInMagazine: " @ GetAmmoInMagazine() @ " GetMagazineSize: " @ GetMagazineSize() @ "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+");

    return (GetAmmoInMagazine() == GetMagazineSize());
}

simulated function bool AmmoCountLow()
{
    return (AmmoCount <= GetMagazineSize());
}

simulated function bool Empty()
{
    return (AmmoCount == 0 && GetAmmoInMagazine() == 0);
}

simulated function bool AmmoCountEmpty ( )
{
    return (AmmoCount == 0);
}

simulated function bool AmmoCountFull ( )
{
    return (AmmoCount == MaxAmmo);
}

simulated function HandleImpactParticles( TPPhysicalMaterial PhysMaterial, class<DamageType> ImpactDamageType, ImpactInfo Impact)
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

	PhysMaterial.SpawnImpactParticles( ImpactDamageType, Impact );
}

simulated function HandleImpactSound( TPPhysicalMaterial	PhysMaterial,
								   class<DamageType>	ImpactDamageType,
								   Actor				dummyActor,
								   Vector				soundPos )
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

	PhysMaterial.PlayImpactSound( ImpactDamageType, dummyActor, soundPos );
}

simulated function ProcessInstantHit( byte FiringMode, ImpactInfo Impact )
{
	local TPPhysicalMaterial tpphysmat;
    local TPPawn tppawn;
	local int DamageAmount;
    
	tpphysmat = TPPhysicalMaterial(Impact.HitInfo.PhysMaterial);

	DamageAmount = GetInstantHitDamage();

	if( DamageAmount < 0.0 )
	{
		DamageAmount = 0.0;
	}

    if (Impact.HitActor != None && Impact.HitInfo.HitComponent != None)
    {
        tppawn = TPPawn(Impact.HitActor);
        if (tppawn != None)
        {
			// Check to see if we instantly kill us on head shots.
			if (tppawn.TeamAssignment == TPTEAM_ENEMY && bInstantKillOnHeadShot && tppawn.GetHitZone(Impact.HitInfo.BoneName) == HZ_Head)
				DamageAmount = tppawn.Health;

            TPPawn(Impact.HitActor).PrePokeActor(Impact.RayDir);
            Impact.HitInfo.HitComponent.AddImpulse (Impact.RayDir * 200, Impact.HitLocation, Impact.HitInfo.BoneName);
        }
    }

		HandleImpactParticles( tpphysmat, WeaponDamageType, Impact);


	// Make impact sound.
//	if ( JustFired == true )
		HandleImpactSound( tpphysmat, WeaponDamageType, self, Impact.HitLocation );


	if (Impact.HitActor != None)
	{
		Impact.HitActor.TakeDamage( DamageAmount, Instigator.Controller,
						Impact.HitLocation, InstantHitMomentum[FiringMode] * Impact.RayDir,
						InstantHitDamageTypes[FiringMode], Impact.HitInfo );
	}
	//Super.ProcessInstantHit( FiringMode, Impact );
}

/////////////////////////////////////////
// Muzzle Flash
/////////////////////////////////////////
simulated function AttachMuzzleFlash()
{
	local TPSkeletalMeshComponent SKMesh;

	// Attach the Muzzle Flash
	SKMesh = TPSkeletalMeshComponent(Mesh);
	if ( SKMesh != none )
	{
		// Muzzle Flash particle system
		if (MuzzleFlashPSCTemplate != none)
		{
			MuzzleFlashPSC  = new(Outer) class'ParticleSystemComponent';
			SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
			MuzzleFlashPSC.SetDepthPriorityGroup(SDPG_World);
			MuzzleFlashPSC.DeactivateSystem();
		}

		//Muzzle Flash light, only for player
		if(MuzzleFlashLight != None && !bIsNPCWeapon)
		{
			SKMesh.AttachComponentToSocket(MuzzleFlashLight, MuzzleFlashSocket);
		}
	}
}

simulated function DetachMuzzleFlash()
{
	local SkeletalMeshComponent SKMesh;
	SKMesh = SkeletalMeshComponent(Mesh);
	if (  SKMesh != none )
	{
		// Muzzle Flash particle system
		if (MuzzleFlashPSC != none)
			SKMesh.DetachComponent( MuzzleFlashPSC );

		// Muzzle Flash light
		if (MuzzleFlashLight != None)
			SkeletalMeshComponent(Mesh).DetachComponent(MuzzleFlashLight);

	}
}

simulated function CauseMuzzleFlash()
{
	//CauseMuzzleFlashLight();

	//`log(" ChadAI - Weapon: " @ Self @ " Time: " @ WorldInfo.TimeSeconds @ " CauseMuzzleFlash -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*");	

	if (MuzzleFlashPSC != none && TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_MUZZLEFLASH))
	{
		MuzzleFlashPSC.DeactivateSystem();

		if ( !bMuzzleFlashPSCLoops || MuzzleFlashPSC.bWasDeactivated )
		{
            if (bIsNPCWeapon || !TPHUD(PlayerController(PlayerPawn(Owner).Controller).myHud).bDrawSniperView)
            {
    		    MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
			    SetMuzzleFlashParams(MuzzleFlashPSC);
			    MuzzleFlashPSC.ActivateSystem();
            }
		}
	}

	if (TPGameReplicationInfo(WorldInfo.GRI).IsWeaponPerfFlagOn(WPF_DYNALIGHT))
	{
		if( MuzzleFlashLight != None)
		{
			MuzzleFlashLight.SetEnabled(true);
		}

		// Set when to turn it off.
		SetTimer(MuzzleFlashDuration,false,'MuzzleFlashTimer');
	}
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
	PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
	PSC.SetVectorParameter('MFlashScale',Vect(0.5,0.5,0.5));
}

simulated function StopMuzzleFlash()
{
	ClearTimer('MuzzleFlashTimer');

	MuzzleFlashTimer();

	if ( MuzzleFlashPSC != none )
	{
		MuzzleFlashPSC.DeactivateSystem();
	}
}

simulated event MuzzleFlashTimer()
{
	if (MuzzleFlashPSC != none && (!bMuzzleFlashPSCLoops) )
	{
		MuzzleFlashPSC.DeactivateSystem();
	}

	if( MuzzleFlashLight != None )
	{
		MuzzleFlashLight.SetEnabled(false);
	}
}

simulated function Vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	local vector loc;

	//`log(MuzzleFlashSocket);
	if( Mesh != none )
	{
		if (!SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(MuzzleFlashSocket, loc))
		{
			//`log("MISSING 'emit' socket on weapon:  " @ Mesh);
		}
		else
		{
			// DO a little bit of fudging to get the projectile to come out of the right place
			if (WorldInfo.NetMode != NM_Standalone)
			{
				loc = Instigator.GetWeaponStartTraceLocation(self);
			}
				
			return loc;
		}
	}

	return Location;
}

native function Vector GetNPCPhysicalFireStartLoc();

//need to place this here because otherwise the g47sniper cache won't work
simulated function ToggleUVLight(bool flag)
{
}

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	local string Message;

	Message = Default.WeaponPickupMessage;
	
	return Repl(Message, "%i", Default.WeapName);
}

simulated function TryToStoreAimDownSight()
{
    local TPPlayerController tppController;

	if ( TPPawn(Owner) == None )
		return;

	tppController = TPPlayerController(Pawn(Owner).Controller);

	if ( tppController == None )
		return;

	tppController.StoreAimDownSight( IsAimDownSight() );
}

simulated function TryToRestoreAimDownSight()
{
    local TPPlayerController tppController;

	if ( TPPawn(Owner) == None )
		return;

	tppController = TPPlayerController(Pawn(Owner).Controller);

	if ( tppController == None )
		return;

	tppController.RestoreAimDownSight();
}




