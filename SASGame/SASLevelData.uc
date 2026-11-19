//=============================================================================
// SASLevelData.uc
//=============================================================================

class SASLevelData extends Info
	native
	placeable
	hidecategories(Actor,Advanced,Collision,Events,Force,Karma,LightColor,Lighting,Sound,Display,Object);

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

struct native SASMaterialList
{
	var() edfindable editinline class<SASBulletHit>			mEmitter;
	var() edfindable editinline class<SASProjectedDecal>	mDecalClass;
};

var() Array<SASBoneDamage>										mBoneDamages;

var (Decals) Array<SASMaterialList>								mDecalList;
//var(Decals) Array<Material>									mBloodTextureList;

var Class<SASProjectedDecal>									mBlastDecalsClass;

var() edfindable class<SASBulletHit>							mHitFleshEffect;
var() edfindable editinline Array<class>						mExitWoundSpurtEffects;
var() edfindable editinline Array<class>						mExitWoundCloudEffects;
var() edfindable editinline Array<class>						mBloodPoolEffects;

var(Scoring) int mWhichTimerIsOverallTimer;
var(Scoring) float mInitialScore;
var(Scoring) float mScorePerShotMissed;
var(Scoring) float mScorePerShotHit;
var(Scoring) float mDeathScoreSAS;
var(Scoring) float mDeathScoreHostage;
var(Scoring) float mDeathScoreTerrorist;
var(Scoring) float mDeathScoreTerroristSurrendered;
var(Scoring) float mCaptureScoreTerrorist;
var(Scoring) float mTimeIdeal;
var(Scoring) float mTimeIdealCoop;
var(Scoring) float mTimeDifferenceScorePerSecond;

var(Scoring) float mMaxPossibleScore;				// maximum possible score for this level
var(Scoring) float mMinPossibleScore;				// minimum possible score for this level

var(Scoring) float mGradeCaptain_PC;				// score above this for Captain grade
var(Scoring) float mGradeSergeant_PC;				// score above this for Sergeant grade
var(Scoring) float mGradeCorporal_PC;				// score above this for Corporal grade
var(Scoring) float mGradeTrooper_PC;				// score above this for Trooper grade
													// below this: Cashiered

// Script counters
var(Scripting) export editinline Array<SASScriptCounter>	mScriptCounters;

//var(Messages) Localized Array<String>	mShoutedMessages;	// SHOUT_MaxStrings


var(sound)	Array<Sound>								mWhizzSoundsList;
var(sound)	float	mWhizzRadius;
var(sound)	float	mWhizzVolume;
var(sound)	float	mWhizzMinPitch;
var(sound)	float	mWhizzMaxPitch;

//-----------------------------------------------------------------------------
// Functions

replication
{
	reliable if ( bNetInitial && Role == ROLE_Authority )
		mInitialScore,
		mScorePerShotMissed,
		mScorePerShotHit,
		mDeathScoreSAS,
		mDeathScoreHostage,
		mDeathScoreTerrorist,
		mDeathScoreTerroristSurrendered,
		mCaptureScoreTerrorist,
		mTimeDifferenceScorePerSecond,
		mMaxPossibleScore,
		mMinPossibleScore,
		mGradeCaptain_PC,			
		mGradeSergeant_PC,			
		mGradeCorporal_PC,			
		mGradeTrooper_PC;	
}
										


///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
event PreBeginPlay()
{
	InitScriptCounters();
}

////////////////////////////////////////////////////////////////////////////////
// InitScriptCounters
//
// Set all counters to their initial values.
function InitScriptCounters ()
{
	local int	i;

	for ( i = 0; i < mScriptCounters.Length; ++i )
	{
		if ( mScriptCounters[i] != None )
		{
			// Set counter to its initial value
			mScriptCounters[i].Reset ();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
// GetBodyPartInfoIndex 
//
//::function int GetBodyPartInfoIndex ( Name aBoneName )
//::{
//::	local int i;
//::	
//::	for ( i = 0; i < mBoneDamages.Length; i++ )
//::	{
//::		if ( mBoneDamages[i].mBoneName == aBoneName )
//::		{
//::			return i;
//::		}
//::	}
//::	
//::	return -1;
//::}

////////////////////////////////////////////////////////////////////////////////
// Default Properties
//	

// Decompiled with UE Explorer.
defaultproperties
{
    mBoneDamages[0]=(mBoneName="Bip01",mKillable=false,mType=1)
    mBoneDamages[1]=(mBoneName="bip01 Pelvis",mKillable=false,mType=1)
    mBoneDamages[2]=(mBoneName="Bip01 Spine",mKillable=false,mType=1)
    mBoneDamages[3]=(mBoneName="Bip01 L Thigh",mKillable=false,mType=4)
    mBoneDamages[4]=(mBoneName="Bip01 L Calf",mKillable=false,mType=4)
    mBoneDamages[5]=(mBoneName="Bip01 L Foot",mKillable=false,mType=4)
    mBoneDamages[6]=(mBoneName="Bip01 L Toe0",mKillable=false,mType=4)
    mBoneDamages[7]=(mBoneName="Bip01 L Toe0Nub",mKillable=false,mType=4)
    mBoneDamages[8]=(mBoneName="Bip01 R Thigh",mKillable=false,mType=5)
    mBoneDamages[9]=(mBoneName="Bip01 R Calf",mKillable=false,mType=5)
    mBoneDamages[10]=(mBoneName="Bip01 R Foot",mKillable=false,mType=5)
    mBoneDamages[11]=(mBoneName="Bip01 R Toe0",mKillable=false,mType=5)
    mBoneDamages[12]=(mBoneName="Bip01 R Toe0Nub",mKillable=false,mType=5)
    mBoneDamages[13]=(mBoneName="bip01 spine1",mKillable=false,mType=1)
    mBoneDamages[14]=(mBoneName="bip01 spine2",mKillable=false,mType=1)
    mBoneDamages[15]=(mBoneName="bip01 neck",mKillable=false,mType=0)
    mBoneDamages[16]=(mBoneName="bip01 head",mKillable=false,mType=0)
    mBoneDamages[17]=(mBoneName="bip01 HeadNub",mKillable=false,mType=0)
    mBoneDamages[18]=(mBoneName="Bip01 L Clavicle",mKillable=false,mType=2)
    mBoneDamages[19]=(mBoneName="Bip01 L UpperArm",mKillable=false,mType=2)
    mBoneDamages[20]=(mBoneName="Bip01 L ForeArm",mKillable=false,mType=2)
    mBoneDamages[21]=(mBoneName="bip01 L Hand",mKillable=false,mType=2)
    mBoneDamages[22]=(mBoneName="Bip01 L Finger0",mKillable=false,mType=2)
    mBoneDamages[23]=(mBoneName="Bip01 L Finger01",mKillable=false,mType=2)
    mBoneDamages[24]=(mBoneName="Bip01 L Finger02",mKillable=false,mType=2)
    mBoneDamages[25]=(mBoneName="Bip01 L Finger0Nub",mKillable=false,mType=2)
    mBoneDamages[26]=(mBoneName="Bip01 L Finger1",mKillable=false,mType=2)
    mBoneDamages[27]=(mBoneName="Bip01 L Finger11",mKillable=false,mType=2)
    mBoneDamages[28]=(mBoneName="Bip01 L Finger12",mKillable=false,mType=2)
    mBoneDamages[29]=(mBoneName="Bip01 L Finger1Nub",mKillable=false,mType=2)
    mBoneDamages[30]=(mBoneName="Bip01 L Finger2",mKillable=false,mType=2)
    mBoneDamages[31]=(mBoneName="Bip01 L Finger21",mKillable=false,mType=2)
    mBoneDamages[32]=(mBoneName="Bip01 L Finger22",mKillable=false,mType=2)
    mBoneDamages[33]=(mBoneName="Bip01 L Finger2Nub",mKillable=false,mType=2)
    mBoneDamages[34]=(mBoneName="Bip01 R Clavicle",mKillable=false,mType=3)
    mBoneDamages[35]=(mBoneName="Bip01 R UpperArm",mKillable=false,mType=3)
    mBoneDamages[36]=(mBoneName="Bip01 R ForeArm",mKillable=false,mType=3)
    mBoneDamages[37]=(mBoneName="Bip01 R Hand",mKillable=false,mType=3)
    mBoneDamages[38]=(mBoneName="Bip01 R Finger0",mKillable=false,mType=3)
    mBoneDamages[39]=(mBoneName="Bip01 R Finger01",mKillable=false,mType=3)
    mBoneDamages[40]=(mBoneName="Bip01 R Finger02",mKillable=false,mType=3)
    mBoneDamages[41]=(mBoneName="Bip01 R Finger0Nub",mKillable=false,mType=3)
    mBoneDamages[42]=(mBoneName="Bip01 R Finger1",mKillable=false,mType=3)
    mBoneDamages[43]=(mBoneName="Bip01 R Finger11",mKillable=false,mType=3)
    mBoneDamages[44]=(mBoneName="Bip01 R Finger12",mKillable=false,mType=3)
    mBoneDamages[45]=(mBoneName="Bip01 R Finger1Nub",mKillable=false,mType=3)
    mBoneDamages[46]=(mBoneName="Bip01 R Finger2",mKillable=false,mType=3)
    mBoneDamages[47]=(mBoneName="Bip01 R Finger21",mKillable=false,mType=3)
    mBoneDamages[48]=(mBoneName="Bip01 R Finger22",mKillable=false,mType=3)
    mBoneDamages[49]=(mBoneName="Bip01 R Finger2Nub",mKillable=false,mType=3)
    mBoneDamages[50]=(mBoneName="GunClipNode",mKillable=false,mType=1)
    mBoneDamages[51]=(mBoneName="GunClipNode01",mKillable=false,mType=5)
    mBoneDamages[52]=(mBoneName="Weapnode",mKillable=false,mType=3)
    mDecalList[0]=(mEmitter=Class'SASWeaponDamage.SASBulletHitGeneric',mDecalClass=Class'SASWeaponDamage.SASBulletDamageGeneric')
    mDecalList[1]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWall',mDecalClass=Class'SASWeaponDamage.SASBulletDamageWall')
    mDecalList[2]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWall',mDecalClass=Class'SASWeaponDamage.SASBulletDamageConcrete')
    mDecalList[3]=(mEmitter=Class'SASWeaponDamage.SASBulletHitMetal',mDecalClass=Class'SASWeaponDamage.SASBulletDamageMetal')
    mDecalList[4]=(mEmitter=Class'SASWeaponDamage.SASBulletHitGlass',mDecalClass=Class'SASWeaponDamage.SASBulletDamageGlass')
    mDecalList[5]=(mEmitter=Class'SASWeaponDamage.SASBulletHitPlastic',mDecalClass=Class'SASWeaponDamage.SASBulletDamagePlastic')
    mDecalList[6]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWood',mDecalClass=Class'SASWeaponDamage.SASBulletDamageWood')
    mDecalList[7]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWaterJet',mDecalClass=Class'SASWeaponDamage.SASBulletDamageWater')
    mDecalList[8]=(mEmitter=Class'SASWeaponDamage.SASBulletHitEarth',mDecalClass=Class'SASWeaponDamage.SASBulletDamageEarth')
    mDecalList[9]=(mEmitter=Class'SASWeaponDamage.SASBulletHitEarth',mDecalClass=Class'SASWeaponDamage.SASBulletDamageGrass')
    mDecalList[10]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWaterJet',mDecalClass=none)
    mDecalList[11]=(mEmitter=none,mDecalClass=Class'SASWeaponDamage.SASBulletDamageBloodSplat')
    mDecalList[12]=(mEmitter=none,mDecalClass=none)
    mDecalList[13]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWire',mDecalClass=Class'SASWeaponDamage.SASBulletDamageWire')
    mDecalList[14]=(mEmitter=none,mDecalClass=Class'SASWeaponDamage.SASBulletDamageBloodDrag')
    mDecalList[15]=(mEmitter=Class'SASWeaponDamage.SASBulletHitUpholstery',mDecalClass=Class'SASWeaponDamage.SASBulletDamageFloor')
    mDecalList[16]=(mEmitter=none,mDecalClass=Class'SASWeaponDamage.SASBulletDamageFloor')
    mDecalList[17]=(mEmitter=Class'SASWeaponDamage.SASBulletHitPaper',mDecalClass=Class'SASWeaponDamage.SASBulletDamagePaper')
    mDecalList[18]=(mEmitter=Class'SASWeaponDamage.SASBulletHitLitter',mDecalClass=Class'SASWeaponDamage.SASBulletDamageLitter')
    mDecalList[19]=(mEmitter=Class'SASWeaponDamage.SASBulletHitSteamJet',mDecalClass=Class'SASWeaponDamage.SASBulletDamageSteamJet')
    mDecalList[20]=(mEmitter=none,mDecalClass=Class'SASWeaponDamage.SASBulletDamageGlassLarge')
    mDecalList[21]=(mEmitter=Class'SASWeaponDamage.SASBulletHitWall',mDecalClass=Class'SASWeaponDamage.SASBulletDamageConcrete')
    mDecalList[22]=(mEmitter=none,mDecalClass=none)
    mDecalList[23]=(mEmitter=Class'SASWeaponDamage.SASBulletHitUpholstery',mDecalClass=Class'SASWeaponDamage.SASBulletDamageUpholstery')
    mDecalList[24]=(mEmitter=Class'SASWeaponDamage.SASBulletHitMetal',mDecalClass=Class'SASWeaponDamage.SASBulletDamageMetalTwo')
    mDecalList[25]=(mEmitter=Class'SASWeaponDamage.SASBulletHitGenericB',mDecalClass=Class'SASWeaponDamage.SASBulletDamageGeneric')
    mDecalList[26]=(mEmitter=Class'SASWeaponDamage.SASBulletHitGenericC',mDecalClass=Class'SASWeaponDamage.SASBulletDamageGenericNoDecal')
    mDecalList[27]=(mEmitter=Class'SASWeaponDamage.SASBulletHitGenericD',mDecalClass=Class'SASWeaponDamage.SASBulletDamageFloor')
    mDecalList[28]=(mEmitter=Class'SASWeaponDamage.SASBulletHitMetal',mDecalClass=Class'SASWeaponDamage.SASBulletDamageMetalThree')
    mDecalList[29]=(mEmitter=Class'SASWeaponDamage.SASBulletHitBush',mDecalClass=none)
    mBlastDecalsClass=Class'SASWeaponDamage.SASBlastDamageDecals'
    mHitFleshEffect=Class'SASWeaponDamage.SASBulletHitFlesh'
    mExitWoundSpurtEffects[0]=Class'SASWeaponDamage.SASBulletHitFleshSpurt'
    mExitWoundSpurtEffects[1]=Class'SASWeaponDamage.SASBulletHitFleshSpurtB'
    mExitWoundSpurtEffects[2]=Class'SASWeaponDamage.SASBulletHitFleshSpurtC'
    mExitWoundSpurtEffects[3]=Class'SASWeaponDamage.SASBulletHitFleshSpurtD'
    mExitWoundCloudEffects[0]=Class'SASWeaponDamage.SASBulletHitFleshExit'
    mExitWoundCloudEffects[1]=Class'SASWeaponDamage.SASBulletHitFleshExitB'
    mExitWoundCloudEffects[2]=Class'SASWeaponDamage.SASBulletHitFleshExitC'
    mExitWoundCloudEffects[3]=Class'SASWeaponDamage.SASBulletHitFleshExitD'
    mBloodPoolEffects[0]=Class'SASBloodPoolA'
    mBloodPoolEffects[1]=Class'SASBloodPoolB'
    mBloodPoolEffects[2]=Class'SASBloodPoolC'
    mBloodPoolEffects[3]=Class'SASBloodPoolD'
    mScorePerShotMissed=-10.0000000
    mScorePerShotHit=10.0000000
    mDeathScoreSAS=-100.0000000
    mDeathScoreHostage=-200.0000000
    mDeathScoreTerrorist=300.0000000
    mDeathScoreTerroristSurrendered=-500.0000000
    mCaptureScoreTerrorist=400.0000000
    mTimeIdeal=300.0000000
    mTimeIdealCoop=300.0000000
    mTimeDifferenceScorePerSecond=5.0000000
    mMaxPossibleScore=5000.0000000
    mGradeCaptain_PC=80.0000000
    mGradeSergeant_PC=60.0000000
    mGradeCorporal_PC=40.0000000
    mGradeTrooper_PC=20.0000000
    mWhizzSoundsList[0]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_01'
    mWhizzSoundsList[1]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_02'
    mWhizzSoundsList[2]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_03'
    mWhizzSoundsList[3]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_04'
    mWhizzSoundsList[4]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_05'
    mWhizzSoundsList[5]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_06'
    mWhizzSoundsList[6]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_07'
    mWhizzSoundsList[7]=Sound'MM_Impacts.Sounds.WD_bullet_flyby_08'
    mWhizzRadius=40.0000000
    mWhizzVolume=0.5000000
    mWhizzMinPitch=0.8000000
    mWhizzMaxPitch=1.2000000
    Texture=Texture'EditorTx.S_LevelData'
    RemoteRole=1
    bAlwaysRelevant=true
}