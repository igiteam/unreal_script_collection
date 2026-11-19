class ZombieBipedPawn extends ZombiePawn
	notplaceable
	native;

const	WEAPON_ATTACH_BONE           = 'r_wrist';

const	HEADSHOT_DAMAGE_MODIFIER     = 3.0;
const	LEGSHOT_DAMAGE_MODIFIER      = 0.5;

const	CHANNEL_Turning            = 1;
const	CHANNEL_Injured            = 2;
const	CHANNEL_HitReact           = 3;
const	CHANNEL_LeaningA           = 4;
const	CHANNEL_LeaningB           = 5;
const	CHANNEL_WeaponPose         = 6;
const	CHANNEL_WeaponHandling     = 7;
const	CHANNEL_Blink              = 8;

const	WEAPSLOT_Primary             = 0;
const	WEAPSLOT_Pistol              = 1;
const	WEAPSLOT_Grenade             = 2;
const	WEAPSLOT_Knife               = 3;

const	GRENADE_ROTATION_MULTIPLIER  = 0;
const	SHOT_ROTATION_MULTIPLIER     = 100000;
const	HEADSHOT_PUSH_MULTIPLIER     = 1.5;

const NUM_SOUND_SET                = 3;
const NUM_SOUND_CAT                = 8;
const SOUND_ARRAY_SIZE             = 24;        //NUM_SOUND_SET * NUM_SOUND_CAT;

var float LODDamageFactor[4];

// sound category 
enum ESoundCat
{
	SC_Alert,
	SC_Attack,
	SC_Die,
	SC_Grenade,
	SC_Hit,
	SC_Incoming,
	SC_Response,
	SC_Retreat
};

var const byte ViewPitch;				// replicate for procedural aiming
var const byte ViewYaw;					// replicate for procedural aiming ( will always be 0 for player controlled pawns - unless someone changes it in the future )

var bool		bUseMPLocationalDamage;

//	Physics based animation
var bool		bIsIdle;					// true when standing still on the ground, Physics can be used for determining other states
var bool		bWasIdle;					
var bool		bDoTorsoTwist;
var bool		RotateFeetWhileStanding;
var const bool	FootTurning;
var const bool	FootStill;
var bool		bIsRunning;					// Pawn is running and not walking
var bool		bIsPedestrian;				// Pawn is walking or running
var bool		bInjured;
var bool		bWasAimMode;
var bool		bExplicitAnimationsOnly;	// Set this to true if you don't want the pawn to do any animation updates
var bool		HasLinkedAnims;
var const bool	HeadLookAt;
var const bool	TorsoLookAt;
var bool		beenSearched;				// After I died I got robbed of ammo
var bool		bIsAI;
var bool		bPullingNade;
var bool		bReleasingNade;

// net "working"
var bool		bAimMode;
var bool		bLeaning;
var bool		bIsReloading;
var bool		bHoldingNade;		// True when pawn has grenade selected and has started throwing but has not released the button ( for cook-off )
var const bool	bReloadCanceled;
var const bool	bFirstNetReceive;
var bool		bPullNade;
var bool		bReleaseNade;
var bool		bReload;
var bool		bWeaponChanged;
var bool		bPlayHitReact;

var bool		bBlendDone;

var bool		bPlayKick;

var bool		bCivilianShouldSit;

var EHitLocation  ClientHumanHitLocation;
var Vector        ClientHitLocation;

var int			IdleAnimIndex;		// The current idle animation index;
var int			lastDamage;
var int			PendingWeaponSlot;	// SlotID of weapon we're changing to

//	Torso twisting/looking
var const int	FootRot;
var const int	OldFootRot;
var const int	TurnDir;
var float		IdleTime;
var float		RemainingLandingTime;
var float		AbsImpactVelocity;
var float		TimeKilled;
var const float HeadLookAtAlpha;
var const float TorsoLookAtAlpha;
var const float LeanAlphaX, LeanAlphaY;
var const float HeadTurnRate;
var const float TorsoTurnRate;
var const float CurrLeanAlpha;			// actual applied lean alpha
var const float DesiredLeanAlpha;		// lean alpha that we're interpolating to
var const float LookAtAlphaFadeRate;	
var const float LeanFadeRate;			// rate of interpolation
var float       LookTimeLeft;
var float       MyUpdateTime;
var const float MaxCrouchSpeed;
var const float MaxWalkSpeed;
var const float NextBlinkTime;
var const Vector OldVelocity;
var const Vector EyesLookAtPoint;
var const Vector HeadLookAtPoint;
var const Vector TorsoLookAtPoint;
var Vector TakeHitMomentum;

// updated in UpdateLookDir - based on current interpolated information
var const Vector AimingDirection;

var const Rotator HeadCurRotation;
var const Rotator TorsoCurRotation;

var const actor LookAtActor;

// procedural weapon kick data
var float LerpParam;
var float LastLerpParam;

var float StopReloadTimer;
// last place the pawn was damaged
var EHitLocation LastHitLoc;

// SpecForcePawn Carryover
var vector  ViewKickAdjustment;
var rotator OldViewRotation;

var InventoryTrigger TouchingThisInvetoryHack; 

// sound for enemies
var int       MySoundSet;
var Sound     MySoundCat[SOUND_ARRAY_SIZE];

//////////////////////////////////////////////
//	Anim Names
//////////////////////////////////////////////

// idle movement anims
var name WalkAnims[4];					// 0=forward, 1=backwards, 2=left, 3=right
var name CrouchAnims[4];
var name RunAnims[4];
// attack/alert movement anims
var name WalkAimAnims[4];
var name CrouchAimAnims[4];
var name RunAimAnims[4];

// turning anims
var name TurnRightAnim[2];				// 0 = standing, 1 = crouched
var name TurnLeftAnim[2];				
var name BaseIdleAnim[2];
var name BaseAimAnim[2];
var name CurrentIdleAnim;
var name IdleAnims[5];					// random idles

// Air movement anims ( still )
var name TakeoffStillAnim;				// initial jump
var name AirStillAnim;					// while in air
var name LandStillAnim;					// when landed

// Other
var name TPoseAnim;
var name BlinkAnim;

var const transient int SkMeshPtr;		// Mesh instance

// Leaning animations - 0 : stand - 1 : crouch
var name LeanLeftAnim[2];
var name LeanRightAnim[2];

// Current lean amount
var float	CurLeanX,
			CurLeanY;

//	Bone names
var name RootBone;
var name HeadBone;
var name HeadBone2;
var name PelvBone;
var name SpineBone1;
var name SpineBone2;
var name SpineBone3;
var name LookDirBone;

// impact effect class
var class<Emitter>	BloodImpactEffect;

////////////////////////////////////////////
// Weapon Information
////////////////////////////////////////////

enum EZombiePawnClass
{
	ZPC_Civilian,		// no weapons
	ZPC_Solider,		// m4,				pistol	knife	m203
	ZPC_Heavy,			// m249,			pistol	knife	he grenade
	ZPC_Scout,			// shotgun			pistol	knife	explosive camera???
	ZPC_Sniper,			// sniper rifle		pistol	knife	phosphorous nade
	ZPC_Medic			// bandages			pistol	knife	med kit
};

var EZombiePawnClass PawnClass;

//-----------------------------------------------------------------
// Fixed Inventory - Moved from ZombiePlayerPawn

var()      class<ZombieWeapon>   BotWeaponClass[4];
var        class<ZombieWeapon>   CurrentWeaponClass;    // for replication
var        ZombieWeapon          Weapons[4];
var        ZombieWeapon          MyWeapon;
var        float                 TimeOfLastWeaponEquip;
var        int                   StartingWeapSlot;

var        ZombieWeapon          RocketWeapon;  // Dedicated slot for rocket weapon.  Kept seperate to ensure it doesn't hose carryover.

//-----------------------------------------------------------------

//	Replication
replication
{
	// variables to replicated from the server to the client
	reliable if ( ROLE == ROLE_Authority )
		bAimMode, ViewPitch, ViewYaw, Weapons, LerpParam;

	// function calls to be replicated on the server from the client
	reliable if( ROLE < ROLE_Authority )
		ServerWeaponChanged;

	// variables to be replicated on client machines
	unreliable if ( ROLE == ROLE_Authority )
		CurLeanX, CurLeanY, bLeaning, CurrentWeaponClass,
		bPullNade, bReleaseNade, bReload, bWeaponChanged, bPlayHitReact, ClientHumanHitLocation, ClientHitLocation;

	// function calls to be replicated from the server on the client
	unreliable if ( ROLE == ROLE_Authority )
		ClientSetLean;

	// function calls to be replicated on the server from the client
	unreliable if ( ROLE < ROLE_Authority )
		SetLean;
}

function ServerWeaponChanged( )
{
	if( ROLE == ROLE_Authority )
	{
		bWeaponChanged = true;
		SetDirty();
	}
}
event AnimBlendPoseParams( int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName, optional bool bGlobalPose)
{
	AnimBlendParams( Stage, BlendAlpha, InTime, OutTime, BoneName, bGlobalPose );
}

simulated event LinkUpAnims ( )
{
	local AnimationManager AniMan;

	//log("LinkUpAnims");

	if ( HasLinkedAnims ) return;
	
	//return if we don't have a mesh...
	if ( Mesh == none ) return;

	// see if it's stored in the level
	if ( Level.GameAnimationManager != None )
	{
		// link up anims
		//log("LinkUpAnims HaveAnimMgr");
		AnimationManager ( Level.GameAnimationManager ).PawnLinkupAnimations ( Self );
		HasLinkedAnims = true;
	}
	else
	{
		// otherwise try to find one
		foreach AllActors ( class'AnimationManager', AniMan )
			break;

		// linkup anims if found
		if ( AniMan != None )
		{
			//log("LinkUpAnims Found AnimMgr");

			AniMan.PawnLinkupAnimations ( Self );
			HasLinkedAnims = true;
		}
	}
}

static simulated event SetUpPawn ( EZombiePawnType PawnType, ZombieBipedPawn newPawn)
{
	local Mesh      NewMesh;
	local Texture   tex,
					NewBodySkin,
	                NewHeadSkin;
	local string    Selection;
	local int		skinSelection;
	local int		i;
	local int		numSkinVariants;
	local string    HeadBaseName;
	local string    BodyBaseName;

	// figure out the mesh
	switch ( PawnType )
	{
		case ZPT_JungleEnemyA:
			HeadBaseName = "CBT_DYN_Characters.Enemy.enemy_head";
			BodyBaseName = "CBT_DYN_Characters.Enemy.enemy_body";
			numSkinVariants = 3;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_enemy", class'Mesh' ) );
			break;
		case ZPT_JungleEnemyB:
			HeadBaseName = "CBT_DYN_Characters.Enemy.enemy_b_head";
			BodyBaseName = "CBT_DYN_Characters.Enemy.enemy_b_body";
			numSkinVariants = 3;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_enemy_b", class'Mesh' ) );
			break;
		case ZPT_JungleEnemyC:
			HeadBaseName = "CBT_DYN_Characters.Enemy.enemy_c_head";
			BodyBaseName = "CBT_DYN_Characters.Enemy.enemy_c_body";
			numSkinVariants = 3;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_enemy_c", class'Mesh' ) );
			break;
		case ZPT_CivilianA:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.civilian_a", class'Mesh' ) );
			break;
		case ZPT_CivilianB:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.civilian_b", class'Mesh' ) );
			break;
		case ZPT_OilRigEnemyA:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_enemy_b", class'Mesh' ) );
			break;
		
		case ZPT_OilRigEnemyB:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_enemy_c", class'Mesh' ) );
			break;
		case ZPT_TeamMateA:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_soldier", class'Mesh' ) );
			break;
		default:
			numSkinVariants = 0;
			NewMesh = Mesh ( DynamicLoadObject ( "CBA_Characters.combat_soldier", class'Mesh' ) );
			break;
	}

	numSkinVariants = 1;

	skinSelection = Rand( numSkinVariants );

	for (i=0; i<numSkinVariants; ++i)
	{
		switch( i )
		{
			case 0:
				Selection = "";
				break;
			case 1:
				Selection = "_b";
				break;
			case 2:
				Selection = "_c";
				break;
			default:
				Selection = "";
				break;
		}
		tex = Texture ( DynamicLoadObject ( HeadBaseName$Selection, class'Texture' ) );
		if (i == skinSelection)
		{
			NewHeadSkin = tex;
		}
		
		tex = Texture ( DynamicLoadObject ( BodyBaseName$Selection, class'Texture' ) );
		if (i == skinSelection)
		{
			NewBodySkin = tex;
		}
	}

	if (newPawn == none)
	{
		return;
	}

	// get one?
	if ( NewMesh != None )
	{
		// link the mesh
		newPawn.LinkMesh ( NewMesh );
		// make sure he has his animations
		newPawn.HasLinkedAnims = false;
		newPawn.LinkUpAnims ( );
	}
	// link up new head
	if ( NewHeadSkin != None )
	{
		newPawn.Skins[0] = NewHeadSkin;
	}
	// link up new body
	if ( NewBodySkin != None )
	{
		newPawn.Skins[1] = NewBodySkin;
	}

	// TODO - hook up some attachments
}

// RAF 10/21/2004 - Moved to support bots as well as Players
simulated event UpdateMPPawnClass()
{
	//local class<ZombieBipedPawn> MPPawnClass;
	local bool isTerr;
	local int ClassIdx;
	local mesh classMesh;
	
	isTerr = false;
	ClassIdx = 1;

	if ((Level.NetMode != NM_Standalone) || (Level.Game == none) ||  ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer'))
	{
		if (PlayerReplicationInfo != none)
		{
			isTerr = PlayerReplicationInfo.bTerrorist;
			ClassIdx = PlayerReplicationInfo.ClassIdx;
		}

		log( PlayerReplicationInfo.PlayerName @ PlayerReplicationInfo.bWasTerrorist @ PlayerReplicationInfo.bTerrorist @ PlayerReplicationInfo.OldClassIdx @ PlayerReplicationInfo.ClassIdx );

//		MPPawnClass = class'ZombieGame.MPClass'.static.GetPawnClassFromIdx(ClassIdx, isTerr);
//		log (self@"_____________UMPPC!"@	MPPawnClass @ PlayerReplicationInfo.bTerrorist@PlayerReplicationInfo.ClassIdx);
		
		classMesh = class'ZombieGame.MPClass'.static.GetMeshFromIdx(ClassIdx, isTerr);
		LinkMesh ( classMesh, true );
		Skins[0] = class'ZombieGame.MPClass'.static.GetSkinFromIdx(ClassIdx, isTerr, 0);
		Skins[1] = class'ZombieGame.MPClass'.static.GetSkinFromIdx(ClassIdx, isTerr, 1);

		GroundSpeed = class'ZombieGame.MPClass'.static.GetSpeedFromIdx(ClassIdx);
		LinkUpAnims ( );
	}
}

// toss out a weapon: overridden here to not toss any pickups
function TossWeapon(Vector TossVel)
{
}

simulated event PostBeginPlay ( )
{
	Super.PostBeginPlay ( );

	LinkUpAnims ( );

	if ( Level.bStartup )
	{
		// add weapons based on class
		AddWeaponLoadout ( );
	}
	MySoundSet = Rand( 3 );

	if( SFRMSinglePlayer(Level.Game) == None )
	{
		bUseMPLocationalDamage = true;
		DestroyTimer = 2;
	}
	else
	{
		bUseMPLocationalDamage = false;
		DestroyTimer = 30;
	}
}

simulated event PostNetBeginPlay ( )
{
	Super.PostNetBeginPlay ( );

	LinkUpAnims ( );
}

function name GetWeaponBoneFor ( Inventory I )
{
	return WEAPON_ATTACH_BONE;
}

// play the sound passed in from this AI's current sound category
function PlaySoundCategory( ESoundCat sound )
{
	PlaySound( MySoundCat[sound + MySoundSet * NUM_SOUND_CAT],, 255,,1000,,true );
}

function int GetCurrentWeaponIndex ( )
{
	local int Index;

	// current weapon is invalid?
	if ( MyWeapon == None )
	{
		// set as invalid
		Index = -1;
	}
	// otherwise..
	else
	{
		// loop over all weapons in inventory
		for ( Index = 0; Index < 4; Index++ )
		{
			// if we find a match...
			if ( MyWeapon == Weapons[Index] )
			{
				// fall out of loop
				break;
			}
		}
	}
	// return index of weapon
	return Index;
}

function AddWeaponLoadout ( )
{
	local int Index;

	// initialize us!
	MyWeapon = None;
	PendingWeaponSlot = 0;

	// add weapons to inventory
	for ( Index = 0; Index < 4; Index++ )
	{
		// create the weapon if valid
		if ( BotWeaponClass[Index] != None )
		{
			Weapons[Index] = Spawn ( BotWeaponClass[Index], Self );
		}
		// give to pawn if valid
		if ( Weapons[Index] != None )
		{
			Weapons[Index].GiveTo ( Self );
		}
	}
}

// select a weapon ( function signature is like this to match ZombiePlayerPawn )
exec function EquipWeapon ( optional int SlotID, optional bool bIgnorePause  )
{
	//log ( "Equipping weapon"@SlotID@"- Weapon[SlotID] is"@Weapons[SlotID] );
	if ( SlotID > -1 && SlotID < 4 && Weapons[SlotID] != None && Weapons[SlotID] != MyWeapon )
	{
		PendingWeaponSlot = SlotID;
		//log ( "PendingWeaponSlot is"@PendingWeaponSlot@"- Going to state ChangingWeapon" );
		GotoState ( 'ChangingWeapon' );
	}
}

function ShowWeaponAttachment ( bool bShow )
{
	if ( Weapon != None && Weapon.ThirdPersonActor != None )
	{
		Weapon.ThirdPersonActor.bHidden = !bShow;
	}
}

// net "working"
event SetLean ( bool bLeaningFlag, float LeanValX, float LeanValY )
{
//	log ( "*** Server Set Lean ***" );
	bLeaning = bLeaningFlag;
	CurLeanX = LeanValX;
	CurLeanY = LeanValY;
	ClientSetLean ( bLeaningFlag, LeanValX, LeanValY );
}

simulated function ClientSetLean ( bool bLeaningFlag, float LeanValX, float LeanValY )
{
	//log ( "*** Client Set Lean ***" );
	bLeaning = bLeaningFlag;
	CurLeanX = LeanValX;
	CurLeanY = LeanValY;
}

//	Native Functions
native function SetDirty( );
native function bool IsMP( );
native function int Get4WayDirection( );
native function int Get4WayDirectionVel ( Vector InVelocity );
native function SetLookAtPoint ( Vector point, optional bool Eyes, optional bool Head, optional bool Torso );
native function StopLookAt ( optional bool Eyes, optional bool Head, optional bool Torso );
native function SetLookAtActor ( Actor Target, optional bool Eyes, optional bool Head, optional bool Torso );
native function AnimStopLooping ( EAnimationChannels Channel );
native function BlendOutAnims ( optional int StartChan, optional int EndChan, optional float BlendOutTime );
native function RestoreDefaultBonePositions ( );
native function DumpAnims ( Canvas MyCanvas );

simulated function DisplayDebug ( Canvas Canvas, out float YL, out float YPos )
{
	local string T;
	//Super.DisplayDebug ( Canvas, YL, YPos );
	
	T = "Look At Actor "$LookAtActor@"- CurrentState:"@GetStateName();
	Canvas.TextHeight = 12*Canvas.ScaleY;
	Canvas.TextWidth  = 12*0.8*Canvas.ScaleX;
	Canvas.DrawText ( T );
	Canvas.CurY += Canvas.TextHeight;
	DumpAnims ( Canvas );
	T = "Me "$self;
	Canvas.TextHeight = 12*Canvas.ScaleY;
	Canvas.TextWidth  = 12*0.8*Canvas.ScaleX;
	Canvas.DrawText ( T );
	Canvas.CurY += Canvas.TextHeight;
	if ( Controller != None )
	{
		Controller.DisplayDebug ( Canvas, YL, YPos );
	}
}

function PlayLanded ( float ImpactVel )
{
	AbsImpactVelocity = Abs ( ImpactVel );
}

function int GetLocationalDamage ( int Damage, vector HitLocation )
{
	local EHitLocation		HumanHitLoc;
	local int				NewDamage;

	NewDamage = Damage;
	HumanHitLoc = EHitLocation ( GetHumanHitLocation ( HitLocation ) );
	LastHitLoc = HumanHitLoc;

	switch ( HumanHitLoc )
	{
		// head
		case HITLOC_Head:
			NewDamage *= HEADSHOT_DAMAGE_MODIFIER;
			break;
		// legs
		case HITLOC_UpperRightLeg:
		case HITLOC_LowerRightLeg:
		case HITLOC_UpperLeftLeg:
		case HITLOC_LowerLeftLeg:
			NewDamage *= LEGSHOT_DAMAGE_MODIFIER;
			break;
	}
	// return locational damage
	return NewDamage;
}

function int GetMPLocationalDamage ( int Damage, vector HitLocation, class<DamageType> damageType )
{
	local EHitLocation		HumanHitLoc;
	local int				NewDamage;

	NewDamage = Damage;
	HumanHitLoc = EHitLocation ( GetHumanHitLocation ( HitLocation ) );
	LastHitLoc = HumanHitLoc;

	//PlayHitReaction ( HumanHitLoc );
	NewDamage *= damageType.static.GetMPHitLocDamageModifier( HumanHitLoc );

	// return locational damage
	return NewDamage;
}

function TakeDamage ( int Damage, Pawn instigatedBy, Vector hitLocation, Vector momentum, class<DamageType> damageType, optional Controller KillerController )
{
	local int		actualDamage;
	local Emitter	ImpactEffect;
	local bool		bIsSPBot;

//	if( !ClassIsChildOf( damageType, Class'ZombieGame.DamageTypeGrenade' ) )
	if( !damageType.default.bNoSpecificLocation )
	{
		if( bUseMPLocationalDamage )
			actualDamage = GetMPLocationalDamage ( Damage, hitLocation, damageType );
		else
			actualDamage = GetLocationalDamage ( Damage, hitLocation );
	//	Log("ZBP:  after getting locational damage:   hitLocation:"$ hitLocation $"  actualDamage:"$ actualDamage $"  damage:"$ damage );
	}
	else
	{
		actualDamage = Damage;
	}

	// Single-player bot?
	if ( !IsHumanControlled ( ) && !IsMP ( ) )
	{
		bIsSPBot = true;
		// startup the limping anims
		if ( actualDamage > 0 && Health == 100 )
		{
			bInjured = true;

			// ALERT! hardcoded badness
			if ( LastHitLoc == HITLOC_UpperLeftLeg || LastHitLoc == HITLOC_LowerLeftLeg )			// always do left leg if hit left leg
				LoopAnim ( 'aim_wounded_walk_l', 1.0, 0.2, CHANNEL_Injured );
			else if ( LastHitLoc == HITLOC_UpperRightLeg || LastHitLoc == HITLOC_LowerRightLeg )	// always do right leg if hit right leg
				LoopAnim ( 'aim_wounded_walk_r', 1.0, 0.2, CHANNEL_Injured );
			else if ( frand ( ) > 0.5 )																// otherwise 50/50
				LoopAnim ( 'aim_wounded_walk_l', 1.0, 0.2, CHANNEL_Injured );
			else
				LoopAnim ( 'aim_wounded_walk_r', 1.0, 0.2, CHANNEL_Injured );			
		}
	}

	// Nerf damage in SinglePlayer, as a function of difficulty.
	// - RAF 10/1/04 (Moved from SFRMDamageType and changed a few of the checks)
	// - MAT 11/12/04 Moved from ZombiePlayerPawn to ZombieBipedPawn, changed hard-coded factor to an
	//       array.  Now no longer just for nerfing bot damage on player.
	if ( !IsMP() )
	{
		actualDamage *= LODDamageFactor[Level.Game.GameDifficulty];
	//	Log("(LODDamageFactor["$ Level.Game.GameDifficulty $"]:"$ LODDamageFactor[Level.Game.GameDifficulty] $"   actualDamage:"$ actualDamage );
	}

	// make blood effect
	if ( BloodImpactEffect != None )
	{
		// spawn
		ImpactEffect = Spawn ( BloodImpactEffect, instigatedBy,,hitLocation,,false );
		// make noise (for AI)
		ImpactEffect.MakeNoise ( 0.6 );
		// play sound for player
		if( bIsSPBot )
		{
			ImpactEffect.PlaySound ( class'ZombieGame.SFRMAmmunition'.default.RandomBulletImpactSounds[EMaterialTypes.MATERIAL_Flesh],,1,,30,,true );
		}
		else if( !Level.GRI.bGameEnded )
		{
			// Multiplayer: only let instigator hear the whack loudly
			// (the sound serves as feedback that they hit this pawn)
			if( InstigatedBy != None )
				InstigatedBy.HearBulletImpactVictim();

			// For nearby players, let them hear a fainter whack
		//	PlaySound(damageType.Static.GetPawnDamageSound(self),SLOT_Misc,0.8,,10);
		}
	}

	if( Level.bMPWeapLogs && IsHumanControlled() )
	{
		if( instigatedBy != None )
			Log( Level.TimeSeconds $" MPLog:   ** Took damage.  victim:"$ PlayerReplicationInfo.Playername $"   actualDamage:"$ actualDamage $"  damage type:"$ damageType $"  instigator:"$ instigator.PlayerReplicationInfo.Playername );
		else if( KillerController != None )
			Log( Level.TimeSeconds $" MPLog:   ** Took damage.  victim:"$ PlayerReplicationInfo.Playername $"   actualDamage:"$ actualDamage $"  damage type:"$ damageType $"  instigator:"$ KillerController.PlayerReplicationInfo.Playername );
		else
			Log( Level.TimeSeconds $" MPLog:   ** Took damage.  victim:"$ PlayerReplicationInfo.Playername $"   actualDamage:"$ actualDamage $"  damage type:"$ damageType $"  couldn't figure out instigator (instigatedBy and KillerController both null).");

		Log( Level.TimeSeconds $" MPLog:         (hitLoc-Location):"$ HitLocation-Location $" ("$ VSize(HitLocation-Location) $")" );
	}

	Health -= actualDamage;
	// reincarnatioN!?
	if ( Controller.bReincarnate && Health <= 0 )
	{
		Health = 100;
	}

	// Single-player bot?
	if ( bIsSPBot )
	{
		// nerf the ground speed
		GroundSpeed = 150.0 + ( 2.0 * FClamp ( Health, 0, 100 ) );
		
		// don't divide by 0
		if ( Health > 0 )
			WalkingPct = 0.29 + ( 1.0 / FClamp ( Health, 0, 100 ) );
	}

	// notify controller?
	if ( Controller != None )
	{
		Controller.NotifyTakeHit ( instigatedBy, HitLocation, actualDamage, DamageType, Momentum );
	}

	// died?
	if ( Health <= 0 )
	{
		TakeHitMomentum = Normal(momentum);

		if( instigatedBy != none )
			KillerController = instigatedBy.GetKillerController();

		Died( KillerController, damageType, hitLocation );
	}
	else
	{
		ClientHumanHitLocation = EHitLocation ( GetHumanHitLocation ( hitLocation ) );
		ClientHitLocation = hitLocation;
		SetDirty();
		PlayHitReaction ( EHitLocation ( GetHumanHitLocation ( hitLocation ) ), hitLocation );
	}
}

event Died ( Controller Killer, class<DamageType> damageType, vector HitLocation )
{
	local int Index;
	if ( IsMP ( ) )
	{
		for ( Index = 0; Index < 4; Index++ )
		{
			if ( Weapons[Index] != None )
			{
				Weapons[Index].Destroy ( );
				Weapons[Index] = None;
			}
		}
	}
	else
	{
		// If not in multiplayer, drop weapon attachment
		if( Weapon != None && ZombieWeaponAttachment(Weapon.ThirdPersonActor) != None )
		{
			ZombieWeaponAttachment(Weapon.ThirdPersonActor).DetachFrom ( Self );
			Weapon.ThirdPersonActor = None;
		}
	}

	// in the Pawn, this will trigger our event if it's set...
	Super.Died ( Killer, DamageType, HitLocation );

	// don't allow for multi trigger
	Event = '';

	// make sure we have no weapon
	Weapon = None;
	CurrentWeaponClass = None;
}

simulated event PlayDying ( class<DamageType> DamageType, vector HitLoc )
{	
	local vector HitDir;
	local vector HitVel;

	AnimBlendToAlpha ( CHANNEL_Turning, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_Injured, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_HitReact, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_LeaningA, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_LeaningB, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_WeaponPose, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_WeaponHandling, 0.0, 0.01 );
	AnimBlendToAlpha ( CHANNEL_Blink, 0.0, 0.01 );

	// fix our bones
	StopLookAt ( true, true, true );
	RestoreDefaultBonePositions ( );

	//kkm--DON'T call the super (nasty)
	AmbientSound = None;
	GotoState('Dying');
	bReplicateMovement = false;
	bTearOff = true;
	Velocity += TearOffMomentum;

	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	TimeKilled = Level.TimeSeconds;

	// set up ragdoll stuff
	HitDir = HitLoc - KillerLocation;
	HitDir = Normal ( HitDir );

	KarmaParamsSkel ( KParams ).KShotStrength = 0;

	//if( LastHitLoc == HITLOC_Head )
	//{
	//	KarmaParamsSkel ( KParams ).KShotStart = Location - ( 2 * HitDir );
	//	KarmaParamsSkel ( KParams ).KShotEnd = Location + ( HitDir * 100 );
	//}
	//else
	//{
	KarmaParamsSkel ( KParams ).KShotStart = HitLoc - ( 2 * HitDir );
	KarmaParamsSkel ( KParams ).KShotEnd = HitLoc + ( HitDir * 100 );
	//}

	// launch him
	SetPhysics ( PHYS_KarmaRagDoll );
	//HitDir.Z += 0.5;
	
	HitVel = vect( 0, 0, 0 );
	// check for grenade type damage to send the body flying
	if( ClassIsChildOf( damageType, Class'ZombieGame.DamageTypeGrenade' ) )
	{
		HitDir = Location - HitLoc;
		HitDir.Z = 0;
		HitDir = Normal ( HitDir );
		HitDir.Z = 0.5;
		HitVel.x = (FRand() - 0.5) * GRENADE_ROTATION_MULTIPLIER;
		HitVel.y = (FRand() - 0.5) * GRENADE_ROTATION_MULTIPLIER;
		HitVel.z = (FRand() - 0.5) * GRENADE_ROTATION_MULTIPLIER;
		KSetSkelVel ( HitDir * 475, HitVel );
	}
	else
	{
		KSetSkelVel ( HitDir * 0, HitVel );
	}
	bPlayedDeath = true;
}

simulated function PlayFiring ( float Rate, name FiringMode )
{
	local Class<ZombieWeapon> curWeapon;
	
	if( MyWeapon != None )
		curWeapon = MyWeapon.Class;
	else
		curWeapon = CurrentWeaponClass;

	if ( curWeapon != None && curWeapon.Default.PawnFireAnim != 'None' )
	{
		AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.15, 0.15, SpineBone1, false );
		PlayAnim ( curWeapon.Default.PawnFireAnim, 1.0, 0.0, CHANNEL_WeaponHandling );
	}
}

simulated event PlayHitReaction( EHitLocation InHumanHitLocation, Vector HitLocation )
{
	local Name animToPlay;
	local float toPlayAlpha;

	if( ROLE == ROLE_Authority )
	{
		bPlayHitReact = true;
		SetDirty();
	}

	toPlayAlpha = 0.5;
	if( InHumanHitLocation == HITLOC_Torso )
	{
		if( Normal( HitLocation - Location ) dot Normal( Vector( Rotation ) ) >= 0 )
			animToPlay = 'hit_c_pose';
		else
			animToPlay = 'hit_b_pose';
	}
	else if( InHumanHitLocation == HITLOC_Head )
	{
		if( Normal( HitLocation - Location ) dot Normal( Vector( Rotation ) ) >= 0 )
			animToPlay = 'hit_c_head_pose';
		else
			animToPlay = 'hit_b_head_pose';
	}
	else if( InHumanHitLocation == HITLOC_UpperRightArm || InHumanHitLocation == HITLOC_LowerRightArm )
	{
		toPlayAlpha = 0.2;
		if( Normal( HitLocation - Location ) dot Normal( Vector( Rotation ) ) >= 0 )
			animToPlay = 'hit_r_pose';
		else
			animToPlay = 'hit_l_pose';
	}
	else if( InHumanHitLocation == HITLOC_UpperRightLeg || InHumanHitLocation == HITLOC_LowerRightLeg ||
	         InHumanHitLocation == HITLOC_UpperLeftLeg || InHumanHitLocation == HITLOC_LowerLeftLeg )
	{
		animToPlay = 'hit_c_pose';
	}
	else
	{
		toPlayAlpha = 0.2;
		if( Normal( HitLocation - Location ) dot Normal( Vector( Rotation ) ) >= 0 )
			animToPlay = 'hit_l_pose';
		else
			animToPlay = 'hit_r_pose';
	}

	AnimBlendParams ( CHANNEL_WeaponHandling, toPlayAlpha, 0.0, 0.3, SpineBone2, false );
	PlayAnim ( animToPlay, 1.0, 0.0, CHANNEL_WeaponHandling );
}

simulated event PlayReloading ( )
{
	local Class<ZombieWeapon> curWeapon;

	if( ROLE == ROLE_Authority )
	{
		bReload = true;
		SetDirty();
	}

	if( MyWeapon != None )
		curWeapon = MyWeapon.Class;
	else
		curWeapon = CurrentWeaponClass;

	if( curWeapon != None && curWeapon.Default.PawnReloadAnim != 'None' )
	{
		AnimBlendParams( CHANNEL_WeaponHandling, 1.0, 0.25, 0.25, SpineBone1, true );
		PlayAnim( curWeapon.Default.PawnReloadAnim, 1.0, 0.0, CHANNEL_WeaponHandling );
		bIsReloading = true;
	}
	if( ZombieBot( Controller ) != None )
	{
		ZombieBot( Controller ).NotifyReloading ( );
	}
}

simulated event PlayPullNadeMP( )
{
	AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.25, 0, SpineBone1, false );
	PlayAnim ( 'aim_grenade_shoot_pull', 1.0, 0.0, CHANNEL_WeaponHandling );
	bPullingNade = true;
}

simulated event PlayReleaseNadeMP( )
{
	AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0, 0.25, SpineBone1, false );
	PlayAnim ( 'aim_grenade_shoot_throw', 1.0, 0.0, CHANNEL_WeaponHandling );
	bReleasingNade = true;
}

function EndReloadAnim ( )
{
	AnimBlendToAlpha ( CHANNEL_WeaponHandling, 0.0, 0.25 );
}

simulated event AnimEnd ( int Channel )
{
	if( IsMP( ) && Channel == CHANNEL_WeaponHandling )
	{
		if( bPullingNade )
		{
			bPullingNade = false;
			if( ROLE == ROLE_Authority )
			{
				bPullNade = false;
			}
		}
		else if( bReleasingNade )
		{
			bReleasingNade = false;
			if( ROLE == ROLE_Authority )
			{
				bReleaseNade = false;
			}
		}
		if( bIsReloading )
		{
			bIsReloading = false;
			if( ROLE == ROLE_Authority )
			{
				bReload = false;
			}
		}
		if( bPlayHitReact )
		{
			if( ROLE == ROLE_Authority )
			{
				bPlayHitReact = false;
			}
		}
	}

	//NOTE: Intentionally not calling super.
}

function TimedLookAtPoint ( vector Point, float Seconds, optional bool Eyes, optional bool Head, optional bool Torso )
{
	if ( Seconds > 0.0 )
	{
		SetLookAtPoint ( Point, Eyes, Head, Torso );
		LookTimeLeft = Seconds;
	}
}

function TimedLookAtActor ( Actor Target, float Seconds, optional bool Eyes, optional bool Head, optional bool Torso )
{
	if ( Seconds > 0.0 )
	{
		SetLookAtActor ( Target, Eyes, Head, Torso );
		LookTimeLeft = Seconds;
	}
}

function SetAimMode ( bool bUseAimMode )
{
	bAimMode = bUseAimMode;
}

// Called to play grenade throwing animation
function ThrowGrenade ( )
{
	GotoState ( 'ThrowingGrenade' );
}

// Animation notify functions
function ANIM_ThrowGrenade ( )
{
	if ( ZombieBot ( Controller ) != None )
	{
		ZombieBot ( Controller ).ThrowGrenadeAt ( );
	}
}

function ANIM_KickGrenade( )
{
	if( ZombieBot( Controller ) != None )
	{
		ZombieBot( Controller ).KickGrenade( );
	}
}

simulated function ClientKickView(vector Kick)
{
	local vector DeltaKick;
	local vector OldKick;
	local rotator VR;

	OldKick = ViewKickAdjustment;
	
	// let weapon adjust camera kick 
	ZombieWeapon(Weapon).CalcWeaponKick(ViewKickAdjustment, Kick); 

	// If pointing past straight up (>95 deg), scale down kick
	if( Controller.Rotation.Pitch > 17453 && Controller.Rotation.Pitch < 32767)
	{
		ViewKickAdjustment.x *= 0.0;
		ViewKickAdjustment.y *= 0.0;
		ViewKickAdjustment.z *= 0.55;
	}

	DeltaKick = ViewKickAdjustment - OldKick;
	// Handle pitch wraparound (e.g. ViewKickAdjustment pitch is 2 deg, OldKick pitch is 358 deg)
	if( ViewKickAdjustment.z < OldKick.z )
		DeltaKick.z = ViewKickAdjustment.z + 65535 - OldKick.z;

	if ( Controller.bIsPlayer )
	{
		vr = Controller.Rotation;
		vr.yaw += DeltaKick.x;
		vr.roll += DeltaKick.y;
		vr.pitch += DeltaKick.z;
		if( vr.pitch > 65535 )	// If pitch goes past 360 degrees,
			vr.pitch -= 65535;  // wrap around (e.g. 362 becomes 2 deg)
		if(vr.pitch >= 18000 && vr.pitch < 32767 ) // if pitch is close to max of 98 deg
			vr.pitch = 17998; // kick pitch down
		Controller.SetRotation(vr);
		OldViewRotation = vr;
	}
}

simulated function RestoreViews(float Delta)
{
	local vector OldKick, DeltaKick;
//	local vector NewVecDown; 
	local rotator VR;
	local int PreRestorePitchChange;

	if ( ViewKickAdjustment == vect(0,0,0) )
		return;

	OldKick = ViewKickAdjustment;

	// let weapon restore camera
	ZombieWeapon(Weapon).RestoreWeaponKick(Delta, ViewKickAdjustment); 
	
	DeltaKick = OldKick - ViewKickAdjustment;
	DeltaKick.Z += 0.5;  // Extra +0.5 compensates for truncation error in going from vector to rotator (MAT 07/28/04)

	if (PlayerController(Controller)!=None)
	{
		vr = Controller.Rotation;
		vr.yaw -= DeltaKick.x;
		vr.roll -= DeltaKick.y;
		vr.pitch -= DeltaKick.z;
		if( vr.pitch < 0 )	// If pitch goes below 0 degrees,
			vr.pitch += 65535;  // wrap around (e.g. -2 becomes 358 deg)

		// Determine if pitch moved outside of the kick restore logic
		PreRestorePitchChange = (Controller.Rotation.Pitch - OldViewRotation.Pitch);
		if( PreRestorePitchChange < -32767 )   // Take care of 0/360 deg wrap-around 
			PreRestorePitchChange += 65535;    // (e.g. new is 1000, old is 65435, want ans +2000)
		else if( PreRestorePitchChange > 32767 ) // Take care of 0/360 deg wrap-around  
			PreRestorePitchChange -= 65535;      // (e.g. new is 64353, old is 1000, want ans -2000)

		// If it did move, then reduce the vertical restoration amount
		if( PreRestorePitchChange < -40 && ViewKickAdjustment.z > 182 ) // || PreRestorePitchChange > 200 )
		{
		//	Log("ZBPawn restore view: pitch change logic TRIPPED!  change: "$PreRestorePitchChange  $"  action:"$ViewKickAdjustment.z $"->"$ViewKickAdjustment.z*0.85);
			ViewKickAdjustment.z *= 0.85;
		}
		else if( PreRestorePitchChange > 80 && ViewKickAdjustment.z > 364 )
		{
		//	Log("ZBPawn restore view: pitch change logic TRIPPED!  change: "$PreRestorePitchChange  $"  action:"$ViewKickAdjustment.z $"->"$ViewKickAdjustment.z*0.99);
			ViewKickAdjustment.z *= 0.98;
		}


		Controller.SetRotation(vr);
		OldViewRotation = vr;
	}
}

//---------------------------
// Footstep functions
simulated function FootStepping()
{
	local byte			byteType; 
	local sound			FootstepSound; 

	// hackery!
	if ( bPlayedDeath || Level.GRI.bGameEnded )
		return;

	byteType = GetFloorMaterial ( );
	
	if ( EMaterialTypes ( byteType ) != MATERIAL_None )
	{
		FootstepSound = class'MaterialNoiseInfo'.Static.GetFootstepSound ( byteType );

		if( bIsRunning )
			MakeNoise ( class'MaterialNoiseInfo'.Static.GetNoiseFactor ( byteType ) );

		PlaySound ( FootstepSound, SLOT_Interact, 0.45f, false, 60.0f, 0.5+FRand(), true );
	}
}

event Landed ( vector HitNormal )
{
	local byte			byteType;
	local sound			LandingSound;

	// hackery!
	if ( bPlayedDeath || Level.GRI.bGameEnded )
		return;

	byteType = GetFloorMaterial ( );
	
	if ( EMaterialTypes ( byteType ) != MATERIAL_None )
	{
		LandingSound = class'MaterialNoiseInfo'.Static.GetLandingSound ( byteType );

		PlaySound ( LandingSound, SLOT_Interact, 0.45f, false, 60.0f, 0.5+FRand(), true );
	}

	Move( HitNormal );

	Super.Landed ( HitNormal );
}

state ChangingWeapon
{
Begin:

	//log ( "ChangingWeapon!!" );

	// play put away animation ( don't blend out )
	AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.25, 0.0, SpineBone1, false );
	if ( MyWeapon != None )
	{
		if ( bAimMode )
			PlayAnim ( MyWeapon.PutAwayAnim[1], 1.0, 0.0, CHANNEL_WeaponHandling );
		else
			PlayAnim ( MyWeapon.PutAwayAnim[0], 1.0, 0.0, CHANNEL_WeaponHandling );
	}
	else
	{
		if ( bAimMode )
			PlayAnim ( Weapons[PendingWeaponSlot].PutAwayAnim[1], 1.0, 0.0, CHANNEL_WeaponHandling );
		else
			PlayAnim ( Weapons[PendingWeaponSlot].PutAwayAnim[0], 1.0, 0.0, CHANNEL_WeaponHandling );
	}

	// finish the animation
	FinishAnim ( CHANNEL_WeaponHandling );

	// a little delay
	Sleep ( 0.3 );

	// change to the new weapon
	PendingWeapon = Weapons[PendingWeaponSlot];
	ChangedWeapon ( );
	MyWeapon = Weapons[PendingWeaponSlot];
	//log ( "ChangingWeapon - MyWeapon is"@MyWeapon );

	// play take out animation on new weapon - don't blend in
	AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.0, 0.25, SpineBone1, false );
	if ( bAimMode )
		PlayAnim ( MyWeapon.TakeOutAnim[1], 1.0, 0.0, CHANNEL_WeaponHandling );
	else
		PlayAnim ( MyWeapon.TakeOutAnim[0], 1.0, 0.0, CHANNEL_WeaponHandling );

	// finish the animation
	FinishAnim ( CHANNEL_WeaponHandling );

	GotoState ( '' );
}

// This state is for bots throwing grenades
state ThrowingGrenade
{
Begin:

	// make sure we are holding a grenade
	if ( ABSTRACT_WeapGrenade ( MyWeapon ) != None )
	{	
		// play hold anim
		AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.25, 0.0, SpineBone1, false );
		PlayAnim ( ABSTRACT_WeapGrenade ( MyWeapon ).PawnHoldAnim, 1.0, 0.0, CHANNEL_WeaponHandling );
		FinishAnim ( CHANNEL_WeaponHandling );
		// play throw anim
		AnimBlendParams ( CHANNEL_WeaponHandling, 1.0, 0.0, 0.25, SpineBone1, false );
		PlayAnim ( ABSTRACT_WeapGrenade ( MyWeapon ).PawnFireAnim, 1.0, 0.0, CHANNEL_WeaponHandling );
		FinishAnim ( CHANNEL_WeaponHandling );
	}

	// leave the state
	GotoState ( '' );
}

State Dying
{
	ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, TakeDamage;

	function ReduceCylinder ( ) { }

	event KVelDropBelow ( )
	{
		if ( Level.TimeSeconds > TimeKilled + 0.5 )
		{
			// bye bye ragdoll physics
			KFreezeRagDoll ( );
		}
	}

	function Landed ( vector HitNormal )
	{
		Super.Landed ( HitNormal );
		SetCollision ( true, true, true );
		SetCollisionSize ( 1.0, 1.0 );
	}

	function BaseChange()
	{
		Super.BaseChange ( );
		SetCollision ( true, true, true );
		SetCollisionSize ( 1.0, 1.0 );
	}

	function LieStill()
	{
		Super.LieStill ( );
		SetCollision ( true, true, true );
		SetCollisionSize ( 1.0, 1.0 );
	}

	function BeginState()
	{
		SetCollision(true,false,false);
		SetCollisionSize ( 1.0, 1.0 );
		if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
			LifeSpan = 1.0;
		else
			SetTimer(DestroyTimer, false);
		SetPhysics(PHYS_Falling);
		bInvulnerableBody = true;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
				Controller.PawnDied(self);
			else
				Controller.Destroy();
		}

		AmbientSound = None;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    LODDamageFactor[0]=5.0000000
    LODDamageFactor[1]=1.0000000
    LODDamageFactor[2]=0.9000000
    LODDamageFactor[3]=0.9000000
    bFirstNetReceive=true
    TorsoTurnRate=0.0150000
    LookAtAlphaFadeRate=4.0000000
    LeanFadeRate=4.0000000
    MyUpdateTime=-1.0000000
    MySoundCat[0]=Sound'CBW_DYN_Dialog.enemy1.fil1_alert00'
    MySoundCat[1]=Sound'CBW_DYN_Dialog.enemy1.fil1_attack00'
    MySoundCat[2]=Sound'CBW_DYN_Dialog.enemy1.fil1_die00'
    MySoundCat[3]=Sound'CBW_DYN_Dialog.enemy1.fil1_grenade00'
    MySoundCat[4]=Sound'CBW_DYN_Dialog.enemy1.fil1_hit00'
    MySoundCat[5]=Sound'CBW_DYN_Dialog.enemy1.fil1_incoming00'
    MySoundCat[6]=Sound'CBW_DYN_Dialog.enemy1.fil1_response00'
    MySoundCat[7]=Sound'CBW_DYN_Dialog.enemy1.fil1_retreat00'
    MySoundCat[8]=Sound'CBW_DYN_Dialog.enemy2.fil2_alert00'
    MySoundCat[9]=Sound'CBW_DYN_Dialog.enemy2.fil2_attack00'
    MySoundCat[10]=Sound'CBW_DYN_Dialog.enemy2.fil2_die00'
    MySoundCat[11]=Sound'CBW_DYN_Dialog.enemy2.fil2_grenade00'
    MySoundCat[12]=Sound'CBW_DYN_Dialog.enemy2.fil2_hit00'
    MySoundCat[13]=Sound'CBW_DYN_Dialog.enemy2.fil2_incoming00'
    MySoundCat[14]=Sound'CBW_DYN_Dialog.enemy2.fil2_response00'
    MySoundCat[15]=Sound'CBW_DYN_Dialog.enemy2.fil2_retreat00'
    MySoundCat[16]=Sound'CBW_DYN_Dialog.enemy3.fil3_alert00'
    MySoundCat[17]=Sound'CBW_DYN_Dialog.enemy3.fil3_attack00'
    MySoundCat[18]=Sound'CBW_DYN_Dialog.enemy3.fil3_die00'
    MySoundCat[19]=Sound'CBW_DYN_Dialog.enemy3.fil3_grenade00'
    MySoundCat[20]=Sound'CBW_DYN_Dialog.enemy3.fil3_hit00'
    MySoundCat[21]=Sound'CBW_DYN_Dialog.enemy3.fil3_incoming00'
    MySoundCat[22]=Sound'CBW_DYN_Dialog.enemy3.fil3_response00'
    MySoundCat[23]=Sound'CBW_DYN_Dialog.enemy3.fil3_retreat00'
    WalkAnims[0]="aim_walk_f_rifle"
    WalkAnims[1]="aim_walk_b_rifle"
    WalkAnims[2]="aim_walk_l_rifle"
    WalkAnims[3]="aim_walk_r_rifle"
    CrouchAnims[0]="aim_crouch_f_rifle"
    CrouchAnims[1]="aim_crouch_b_rifle"
    CrouchAnims[2]="aim_crouch_l_rifle"
    CrouchAnims[3]="aim_crouch_r_rifle"
    RunAnims[0]="aim_run_f_rifle"
    RunAnims[1]="aim_run_b_rifle"
    RunAnims[2]="aim_run_l_rifle"
    RunAnims[3]="aim_run_r_rifle"
    WalkAimAnims[0]="aim_walk_f_rifle"
    WalkAimAnims[1]="aim_walk_b_rifle"
    WalkAimAnims[2]="aim_walk_l_rifle"
    WalkAimAnims[3]="aim_walk_r_rifle"
    CrouchAimAnims[0]="aim_crouch_f_rifle"
    CrouchAimAnims[1]="aim_crouch_b_rifle"
    CrouchAimAnims[2]="aim_crouch_l_rifle"
    CrouchAimAnims[3]="aim_crouch_r_rifle"
    RunAimAnims[0]="aim_run_f_rifle"
    RunAimAnims[1]="aim_run_b_rifle"
    RunAimAnims[2]="aim_run_l_rifle"
    RunAimAnims[3]="aim_run_r_rifle"
    BaseIdleAnim[0]="aim_standing_rifle"
    BaseIdleAnim[1]="aim_crouch_rifle"
    BaseAimAnim[0]="aim_standing_rifle"
    BaseAimAnim[1]="aim_crouch_rifle"
    TakeoffStillAnim="aim_run_jump_rifle"
    AirStillAnim="aim_falling_rifle_pose"
    LandStillAnim="aim_walk_jump_rifle"
    TPoseAnim="tpose"
    BlinkAnim="blink"
    LeanLeftAnim[0]="aim_lean_l_rifle"
    LeanLeftAnim[1]="aim_crouch_lean_l_rifle"
    LeanRightAnim[0]="aim_lean_r_rifle"
    LeanRightAnim[1]="aim_crouch_lean_r_rifle"
    RootBone="char_root"
    HeadBone="neck"
    HeadBone2="Head"
    PelvBone="pelvis"
    SpineBone1="spine_low"
    SpineBone2="spine_mid"
    SpineBone3="spine_high"
    LookDirBone="blink"
    BloodImpactEffect=Class'ZombieEffects.impact_blood'
    Faction=2
    bCanCrouch=true
    bCanWalkOffLedges=true
    bSameZoneHearing=true
    bAdjacentZoneHearing=true
    bPhysicsAnimUpdate=true
    HearingThreshold=4000.0000000
    PeripheralVision=-0.2000000
    GroundSpeed=350.0000000
    WaterSpeed=220.0000000
    AirSpeed=440.0000000
    JumpZ=500.0000000
    WalkingPct=0.3000000
    CrouchedPct=0.2000000
    BaseWalkingPct=0.3000000
    BaseCrouchedPct=0.2000000
    BaseEyeHeight=30.0000000
    EyeHeight=30.0000000
    CrouchHeight=29.0000000
    CrouchRadius=25.0000000
    ControllerClass=Class'ZombieBot'
    Physics=1
    bActorShadows=true
    bStasis=false
    bBlockKarma=true
    bNetNotify=true
    RotationRate=(Pitch=0,Yaw=65535,Roll=2048)
    // Reference: KarmaParamsSkel'ZombieBipedPawn.KCombatSoldierSkel'
    begin object name=KCombatSoldierSkel class=Class'Engine.KarmaParamsSkel'
        KSkeleton="KCombatSoldier"
        KAngularDamping=3.0000000
        KBuoyancy=0.9500000
        KStartEnabled=true
        KVelDropBelowThreshold=0.1000000
        KFriction=0.8000000
        KRestitution=0.2000000
        KImpactThreshold=770.0000000
    end object
    KParams=KCombatSoldierSkel
}