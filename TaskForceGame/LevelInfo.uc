//=============================================================================
// LevelInfo contains information about the current level. There should 
// be one per level and it should be actor 0. UnrealEd creates each level's 
// LevelInfo automatically so you should never have to place one
// manually.
//
// The ZoneInfo properties in the LevelInfo are used to define
// the properties of all zones which don't themselves have ZoneInfo.
//=============================================================================
class LevelInfo extends ZoneInfo
	native
	nativereplication;

// Textures.
#exec Texture Import File=Textures\WireframeTexture.dds
#exec Texture Import File=Textures\WhiteSquareTexture.tga
#exec Texture Import File=Textures\S_Vertex.dds Name=LargeVertex

//-----------------------------------------------------------------------------
// Level time.

// Time passage.
var() float TimeDilation;          // Normally 1 - scales real time passage.

// Current time.
var           float	TimeSeconds;   // Time in seconds since level began play.
var transient int   Year;          // Year.
var transient int   Month;         // Month.
var transient int   Day;           // Day of month.
var transient int   DayOfWeek;     // Day of week.
var transient int   Hour;          // Hour.
var transient int   Minute;        // Minute.
var transient int   Second;        // Second.
var transient int   Millisecond;   // Millisecond.
var			  float	PauseDelay;		// time at which to start pause
var config float	DecalStayScale;		// 0 to 2 - affects decal stay time

var() config enum EPhysicsDetailLevel
{
	PDL_Low,
	PDL_Medium,
	PDL_High
} PhysicsDetailLevel;

var array<PathNode> PathNodes;

// list of active AI
var array<Controller> Bots;

// Karma - jag
var(Karma) float KarmaTimeScale;		// Karma physics timestep scaling.
var(Karma) float RagdollTimeScale;		// Ragdoll physics timestep scaling. This is applied on top of KarmaTimeScale.
var(Karma) int   MaxRagdolls;			// Maximum number of simultaneous rag-dolls.
var(Karma) float KarmaGravScale;		// Allows you to make ragdolls use lower friction than normal.
var(Karma) bool  bKStaticFriction;		// Better rag-doll/ground friction model, but more CPU.

var(DynamicGamma) bool ForceDynamicGammaOff;


var()	   bool bKNoInit;				// Start _NO_ Karma for this level. Only really for the Entry level.
// jag

//-----------------------------------------------------------------------------
// Text info about level.

var() localized string Title;
var()           string Author;		    // Who built it.
var() localized string LevelEnterText;  // Message to tell players when they enter.
var()           string LocalizedPkg;    // Package to look in for localizations.
var             PlayerReplicationInfo Pauser;          // If paused, name of person pausing the game.
var				int	PauserCount;
var()		int RecommendedNumPlayers;
var		LevelSummary Summary;
var           string VisibleGroups;			// List of the group names which were checked when the level was last saved
var transient string SelectedGroups;		// A list of selected groups in the group browser (only used in editor)
//-----------------------------------------------------------------------------
// Flags affecting the level.

var() bool           bLonePlayer;     // No multiplayer coordination, i.e. for entranceways.
var bool             bBegunPlay;      // Whether gameplay has begun.
var bool             bPlayersOnly;    // Only update players.
var const EDetailMode	DetailMode;      // Client detail mode.
var bool			 bDropDetail;	  // frame rate is below DesiredFrameRate, so drop high detail actors
var bool			 bAggressiveLOD;  // frame rate is well below DesiredFrameRate, so make LOD more aggressive
var bool             bStartup;        // Starting gameplay.
var	bool			 bPathsRebuilt;	  // True if path network is valid
var bool			 bHasPathNodes;
var globalconfig bool bCapFramerate;		// frame rate capped in net play if true (else limit number of servermove updates)

//-----------------------------------------------------------------------------
// Renderer Management.
var config bool bNeverPrecache;

//-----------------------------------------------------------------------------
// Legend - used for saving the viewport camera positions
var() vector  CameraLocationDynamic;
var() vector  CameraLocationTop;
var() vector  CameraLocationFront;
var() vector  CameraLocationSide;
var() rotator CameraRotationDynamic;

//-----------------------------------------------------------------------------
// Audio properties.

//var(Audio) string	Song;			// Filename of the streaming song.
var(Audio) IMusicDesc Song;
var(Audio) float	PlayerDoppler;	// Player doppler shift, 0=none, 1=full.
var(Audio) float	MusicVolumeOverride;

var 	transient	int			SongHandle;



//-----------------------------------------------------------------------------
// Miscellaneous information.

var() float Brightness;
var() texture Screenshot;
var texture DefaultTexture;
var texture WireframeTexture;
var texture WhiteSquareTexture;
var texture LargeVertex;
var int HubStackLevel;
var transient enum ELevelAction
{
	LEVACT_None,
	LEVACT_Loading,
	LEVACT_Saving,
	LEVACT_Connecting,
	LEVACT_Precaching
} LevelAction;

var transient GameReplicationInfo GRI;
var Actor GameAnimationManager;


//-----------------------------------------------------------------------------
// Networking.

var enum ENetMode
{
	NM_Standalone,        // Standalone game.
	NM_DedicatedServer,   // Dedicated server, no local client.
	NM_ListenServer,      // Listen server.
	NM_Client             // Client only, no local server.
} NetMode;
var string ComputerName;  // Machine's name according to the OS.
var string EngineVersion; // Engine version.
var string MinNetVersion; // Min engine version that is net compatible.

//-----------------------------------------------------------------------------
// Gameplay rules

var() string DefaultGameType;
var() string PreCacheGame;
var GameInfo Game;
var float DefaultGravity;

//-----------------------------------------------------------------------------
// Navigation point and Pawn lists (chained using nextNavigationPoint and nextPawn).

var const NavigationPoint NavigationPointList;
var const Controller ControllerList;
var private PlayerController LocalPlayerController;		// player who is client here

//-----------------------------------------------------------------------------
// Server related.

var string NextURL;
var bool bNextItems;
var float NextSwitchCountdown;

//-----------------------------------------------------------------------------
// Global object recycling pool.

var transient ObjectPool	ObjectPool;

//-----------------------------------------------------------------------------
// Additional resources to precache (e.g. Playerskins).

var transient array<material>	PrecacheMaterials;
var transient array<staticmesh> PrecacheStaticMeshes;
var transient array<skeletalmesh> PrecacheSkeletalMeshes;

var(Mission) MapInfo DefaultMapInfo; 
var Texture HandsTexture;  // Will get set by DefaultMapInfo at start of multiplayer game

var(AI) float AI_SkillLevel;

//-----------------------------------------------------------------------------
// Bullet hole manager

var byte NumBulletHoles;
var transient Effects BulletHoles[64];
var transient byte BHoleQueueHead;
var transient byte BHoleQueueTail;

var byte CurrentImpactEffects;


// debug
var bool bMPWeapLogs;


//-----------------------------------------------------------------------------
// Functions.

native simulated function DetailChange(EDetailMode NewDetailMode);
native simulated function bool IsEntry();

simulated function PostBeginPlay()
{
	local PathNode Node;

	Super.PostBeginPlay();
	DecalStayScale = FClamp(DecalStayScale,0,2);
	AI_SkillLevel = FClamp( AI_SkillLevel, -1.0, 1.0 );

	if ( Event != 'None' )
	{
		TriggerEvent ( Event, Self, None );
	}

	foreach AllActors ( class'PathNode', Node )
	{
		PathNodes [ PathNodes.Length ] = Node;
	}

	if( DefaultMapInfo != None )
		InitBulletHoles();

	//so clients can get at GRI 
	log ("SETTING LEVELINFO GRI TO"@Game.GameReplicationInfo);
	GRI = Game.GameReplicationInfo;
}

simulated function InitBulletHoles()
{
	local byte bnx;
	local class<Effects> BulletHoleClass; 

	BulletHoleClass = class<Effects>(DynamicLoadObject("ZombieGame.BulletHole",class'Class'));
	for( bnx = 0 ; bnx < NumBulletHoles ; bnx++ )
	{
		BulletHoles[bnx] = Spawn( BulletHoleClass );
		BulletHoles[bnx].bHidden = true;
	//	Log("LevelInfo.PostBeginPlay  BulletHoles["$ bnx $"] "$ BulletHoles[bnx] );
	}
}

simulated function class<GameInfo> GetGameClass()
{
	local class<GameInfo> G;

	if(Level.Game != None)
		return Level.Game.Class;

	if (GRI != None && GRI.GameClass != "")
		G = class<GameInfo>(DynamicLoadObject(GRI.GameClass,class'Class'));
	if(G != None)
		return G;

	if ( DefaultGameType != "" )
		G = class<GameInfo>(DynamicLoadObject(DefaultGameType,class'Class'));

	return G;
}

simulated event FillPrecacheMaterialsArray()
{
	local Actor A;
	local class<GameInfo> G;
	
	if ( NetMode == NM_DedicatedServer )
		return;
	if ( Level.Game == None )
	{
		if ( (GRI != None) && (GRI.GameClass != "") )
			G = class<GameInfo>(DynamicLoadObject(GRI.GameClass,class'Class'));
		if ( (G == None) && (DefaultGameType != "") )
			G = class<GameInfo>(DynamicLoadObject(DefaultGameType,class'Class'));
		if ( G == None )
			G = class<GameInfo>(DynamicLoadObject(PreCacheGame,class'Class'));
		if ( G != None )
			G.Static.PreCacheGameTextures(self);
	}
	ForEach AllActors(class'Actor',A)
	{
		A.UpdatePrecacheMaterials();
	}
}

simulated event FillPrecacheStaticMeshesArray()
{
	local Actor A;
	local class<GameInfo> G;
	
	if ( NetMode == NM_DedicatedServer )
		return;
	if ( Level.Game == None )
	{
		if ( (GRI != None) && (GRI.GameClass != "") )
			G = class<GameInfo>(DynamicLoadObject(GRI.GameClass,class'Class'));
		if ( (G == None) && (DefaultGameType != "") )
			G = class<GameInfo>(DynamicLoadObject(DefaultGameType,class'Class'));
		if ( G == None )
			G = class<GameInfo>(DynamicLoadObject(PreCacheGame,class'Class'));
		if ( G != None )
			G.Static.PreCacheGameStaticMeshes(self);
	}
	
	ForEach AllActors(class'Actor',A)
		A.UpdatePrecacheStaticMeshes();
}

simulated function AddPrecacheMaterial(Material mat)
{
    local int Index;

	if ( NetMode == NM_DedicatedServer )
		return;
    if (mat == None)
        return;

    Index = Level.PrecacheMaterials.Length;
    PrecacheMaterials.Insert(Index, 1);
	PrecacheMaterials[Index] = mat;
}

simulated function AddPrecacheStaticMesh(StaticMesh stat)
{
    local int Index;

	if ( NetMode == NM_DedicatedServer )
		return;
    if (stat == None)
        return;

    Index = Level.PrecacheStaticMeshes.Length;
    PrecacheStaticMeshes.Insert(Index, 1);
	PrecacheStaticMeshes[Index] = stat;
}

simulated function AddPrecacheSkeletalMesh(SkeletalMesh skel)
{
    local int Index;

	if ( NetMode == NM_DedicatedServer )
		return;
    if (skel == None)
        return;

    Index = Level.PrecacheSkeletalMeshes.Length;
    PrecacheSkeletalMeshes.Insert(Index, 1);
	PrecacheSkeletalMeshes[Index] = skel;
}

//
// Return the URL of this level on the local machine.
//
native simulated function string GetLocalURL();

//
// Return the URL of this level, which may possibly
// exist on a remote machine.
//
native simulated function string GetAddressURL();

//
// Jump the server to a new level.
//
native event ServerTravel( string URL, bool bItems );

//
// ensure the DefaultPhysicsVolume class is loaded.
//
function ThisIsNeverExecuted()
{
	local DefaultPhysicsVolume P;
	P = None;
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	// perform garbage collection of objects (not done during gameplay)
	ConsoleCommand("OBJ GARBAGE");
	Super.Reset();
}

//-----------------------------------------------------------------------------
// Network replication.

replication
{
	reliable if( bNetDirty && Role==ROLE_Authority )
		Pauser, TimeDilation, DefaultGravity,GRI;

	reliable if( bNetInitial && Role==ROLE_Authority )
		RagdollTimeScale, KarmaTimeScale, KarmaGravScale;
	
	//client should call this on server
	reliable if (Role < ROLE_Authority)
		PlayInterfaceSoundForAllClients;
}

//
//	PreBeginPlay
//

simulated event PreBeginPlay()
{
	// Create the object pool.

	ObjectPool = new(none) class'ObjectPool';
}

simulated function PlayerController GetLocalPlayerController()
{
	local PlayerController PC;

	if ( Level.NetMode == NM_DedicatedServer )
		return None;
	if ( LocalPlayerController != None )
		return LocalPlayerController;

	ForEach DynamicActors(class'PlayerController', PC)
	{
		if ( Viewport(PC.Player) != None )
		{
			LocalPlayerController = PC;
			break;
		}
	}
	return LocalPlayerController;
}

native function PlayInterfaceSoundForAllClients(Sound s);
native function CommandToAllClients(string s,bool childrenToo);

simulated function NewBulletHole( vector HoleLocation, vector HitNormal )
{
	local rotator BHRot;

//	Log("LevelInfo.NewBulletHole   NumBulletHoles:"$ NumBulletHoles );
	if( NumBulletHoles == 0 )
		return;

	// Move tail to new position
	BHoleQueueTail++;
	if( BHoleQueueTail >= NumBulletHoles )
		BHoleQueueTail = 0;

	// Just in case the array didn't get initialized
	if( BulletHoles[BHoleQueueTail] == None )
	{
		BulletHoles[BHoleQueueTail] = Spawn( class<Effects>(DynamicLoadObject("ZombieGame.BulletHole",class'Class')) );
	}

	// Store new bullet hole info at the queue tail.  Don't care if it overwrites
	// info for an existing hole--if it does, we'll just move the queue head later.
	BulletHoles[BHoleQueueTail].SetLocation( HoleLocation );
	BHRot = rotator(HitNormal);
	BHRot.Roll = FRand()*65535;
	BulletHoles[BHoleQueueTail].SetRotation( BHRot );
	BulletHoles[BHoleQueueTail].bHidden = false;

//	Log("LevelInfo.NewBulletHole  BulletHoles["$ BHoleQueueTail $"] "$ BulletHoles[BHoleQueueTail] $"  bHidden:"$ BulletHoles[BHoleQueueTail].bHidden $" tex:"$ BulletHoles[BHoleQueueTail].texture );

	// If the queue tail (new bullet hole) has met the queue head (oldest bullet hole
	// we still know about), then increment the queue head (i.e. we've already 
	// overwritten the oldest hole's info with the newest hole's info: well, we're ok
	// with it so now we're moving on).
	if( BHoleQueueTail == BHoleQueueHead )
	{
		BHoleQueueHead++;
		if( BHoleQueueHead >= NumBulletHoles )
			BHoleQueueHead = 0;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    TimeDilation=1.0000000
    PhysicsDetailLevel=1
    KarmaTimeScale=0.9000000
    RagdollTimeScale=1.0000000
    MaxRagdolls=3
    KarmaGravScale=1.0000000
    bKStaticFriction=true
    Title="Untitled"
    VisibleGroups="None"
    DetailMode=2
    bCapFramerate=true
    MusicVolumeOverride=1.0000000
    Brightness=1.0000000
    DefaultTexture=Texture'DefaultTexture'
    WireframeTexture=Texture'WireframeTexture'
    WhiteSquareTexture=Texture'WhiteSquareTexture'
    LargeVertex=Texture'LargeVertex'
    PreCacheGame="Engine.GameInfo"
    DefaultGravity=-1500.0000000
    AI_SkillLevel=-1.0000000
    NumBulletHoles=64
    bWorldGeometry=true
    bAlwaysRelevant=true
    bShowBulletHoles=true
    RemoteRole=1
    bHiddenEd=true
}