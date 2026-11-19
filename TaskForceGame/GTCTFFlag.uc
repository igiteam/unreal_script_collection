class GTCTFFlag extends Actor
native
;

//#exec MESH IMPORT MESH=usflag ANIVFILE=MODELS\usflag_a.3d DATAFILE=MODELS\usflag_d.3d X=0 Y=0 Z=0 ZEROTEX=1
//#exec MESH ORIGIN MESH=usflag X=0 Y=0 Z=0

//#exec MESH SEQUENCE MESH=usflag SEQ=All  STARTFRAME=0 NUMFRAMES=50
//#exec MESH SEQUENCE MESH=usflag SEQ=flagwave STARTFRAME=0 NUMFRAMES=50

//#exec TEXTURE IMPORT NAME=JusflagB FILE=MODELS\flag_blue.dds GROUP=Skins MASKED=1 // twosided
//#exec TEXTURE IMPORT NAME=JusflagR FILE=MODELS\flag_red.dds GROUP=Skins MASKED=1 // twosided

//#exec MESHMAP NEW   MESHMAP=usflag MESH=usflag
//#exec MESHMAP SCALE MESHMAP=usflag X=0.1 Y=0.1 Z=0.2

var bool bOldHolderRelevantFlag;
var int TeamIndex;
var GTCTFBase myBase;

var Pawn Holder;
var name FlagWaveAnimName;

var sound FlagCapSound;
var sound FlagTakenSound;
var sound FlagReturnedSound;
var sound FlagDroppedSound;
var sound FlagCapSoundWin;
var sound FlagCapSoundLose;
var sound FlagTakenSoundYourTeam;
var sound FlagTakenSoundOtherTeam;
var sound FlagDropSoundTheirs;
var sound FlagDropSoundYours;
var sound FlagRetSoundTheirs;
var sound FlagRetSoundYours;
var GameReplicationInfo GRI;

var string Tf121SkinName;
var string OpForSkinName;

var rotator myRotation; //replicate this seperately since Rotation doesnt' seem to be replicated on flags

const DROP_RESET_TIME = 25;

replication
{
	reliable if (ROLE<ROLE_Authority)
		SetFlagSkin,GoHome,GoCarried,SetFlagBase,Drop,NativeTouch;
	
	reliable if (bNetDirty && ROLE == ROLE_Authority)
		TeamIndex,Holder,myBase,GRI,myRotation;
	
	//server calls this on client
	reliable if (Role==ROLE_Authority)
		ClientSetFlagSkin;
	
}

function BaseChange();
function Bump( actor Other );
event FellOutOfWorld(eKillZType KillType)
{
	GoHome();
}

//these all run on the server
native event SetFlagBase(GTCTFBase base);
native event Drop(vector newVel);
native event GoCarried(Pawn other);
native event GoHome();
native event NativeTouch( Actor Other );

//runs on server
event SetFlagSkin()
{
	ClientSetFlagSkin(TeamIndex);
	if (TeamIndex == 0)
	{
		Skins[0]= Texture ( DynamicLoadObject ( Tf121SkinName, class'Texture' ) );
	}
	else 
	{
		Skins[0]= Texture ( DynamicLoadObject ( OpForSkinName, class'Texture' ) );
	}
}

//runs on client, called from server version
simulated event ClientSetFlagSkin(int myTeamIndex)
{
	TeamIndex=myTeamIndex;
	if (TeamIndex == 0)
	{
		Skins[0]= Texture ( DynamicLoadObject ( Tf121SkinName, class'Texture' ) );
	}
	else
	{
		Skins[0]= Texture ( DynamicLoadObject ( OpForSkinName, class'Texture' ) );
	}

}

//NativeTouch runs on server
event Touch( Actor Other ){NativeTouch(Other);}

auto state Home
{
	function BeginState()
	{
//		log("Flag setting Home: " $ TeamIndex @ GRI);
		GRI.SetCarriedObjectState(TeamIndex, 'Home');
	}

	function Timer()
	{
		SetCollision(default.bCollideActors,false,false);
	}
}

state Carried
{
	function BeginState()
	{
//		log("Flag setting HeldEnemy: " $ TeamIndex @ GRI);
		GRI.SetCarriedObjectState(TeamIndex, 'HeldEnemy');
	}
}

state Dropped
{
	function BeginState()
	{
//		log("Flag setting Down: " $ TeamIndex @ GRI);
		GRI.SetCarriedObjectState(TeamIndex, 'Down');
		SetTimer(DROP_RESET_TIME, false);
	}

	function Timer()
	{
		GoHome();
	}
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    FlagWaveAnimName="flagwave"
    FlagTakenSound=Sound'CBW_DYN_interface.mp.MP_flag_taken'
    FlagReturnedSound=Sound'CBW_DYN_interface.mp.MP_flag_returned'
    FlagDroppedSound=Sound'CBW_DYN_interface.mp.MP_flag_dropped'
    FlagCapSoundWin=Sound'CBW_DYN_interface.mp.mp_win'
    FlagCapSoundLose=Sound'CBW_DYN_interface.mp.mp_lose'
    FlagTakenSoundYourTeam=Sound'CBW_DYN_interface.mp.mp_flag_take_yourteam'
    FlagTakenSoundOtherTeam=Sound'CBW_DYN_interface.mp.mp_flag_take_otherteam'
    FlagDropSoundTheirs=Sound'CBW_DYN_interface.mp.mp_flag_drop_otherteam'
    FlagDropSoundYours=Sound'CBW_DYN_interface.mp.mp_flag_drop_yourteam'
    FlagRetSoundTheirs=Sound'CBW_DYN_interface.mp.mp_flag_return_otherteam'
    FlagRetSoundYours=Sound'CBW_DYN_interface.mp.mp_flag_return_yourteam'
    Tf121SkinName="CBT_DYN.flags.flag_tf121"
    OpForSkinName="CBT_DYN.flags.flag_opfor"
    DrawType=2
    bAlwaysRelevant=true
    Mesh=SkeletalMesh'CBA_Props.flag'
    Texture=none
    DrawScale=0.7500000
    CollisionRadius=48.0000000
    CollisionHeight=50.0000000
    bCollideActors=true
    bCollideWorld=true
    bUseCylinderCollision=true
}