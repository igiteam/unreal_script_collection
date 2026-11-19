
class SASSquadVoice extends SASPawnVoice
	native
	abstract;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


// Soldier specific speech
var array<Sound>	mThrowGrenadeSounds;
var array<Sound>	mHattonRoundSounds;
var array<Sound>	mBlueOnBlueSounds;
var array<Sound>	mBombFoundSounds;
var array<Sound>	mDefusingBombSounds;
var array<Sound>	mManDownSounds;
var float			mManDownChance;
var array<Sound>	mTerroristDownSounds;
var float			mTerroristDownChance;
var array<Sound>	mHostageKilledSounds;
var array<Sound>	mHostageStandoffSounds;
var array<Sound>	mHostageGetDownSounds;
var array<Sound>	mShootHostageSounds;
var array<Sound>	mMagChangeSounds;
var array<Sound>	mClearSounds;
var array<Sound>	mLargeVolumeClearSounds;
var Range			mClearDelay;
var array<Sound>	mAvoidSounds;
var array<Sound>	mContactSounds;
var array<Sound>	mContactFrontSounds;
var array<Sound>	mContactRearSounds;
var array<Sound>	mContactLeftSounds;
var array<Sound>	mContactRightSounds;
var array<Sound>	mCheckDeadSounds;
var Range			mCheckDeadDelay;
var float			mCheckDeadChance;
var array<Sound>	mCallBackupSounds;
var Range			mCallBackupDelay;
var array<Sound>	mChargeWarnSounds;
var array<Sound>	mGoSounds;
var array<Sound>	mHoldPositionSounds;
var array<Sound>	mIdentTerroristSounds;
var array<Sound>	mMoveLeftSounds;
var array<Sound>	mMoveRightSounds;
var array<Sound>	mMovingSounds;
var float			mMovingChance;
var array<Sound>	mOrderWingmanSounds;
var float			mOrderWingmanChance;
var array<Sound>	mRadioCheckSounds;
var array<Sound>	mRoomSearchSounds;
var array<Sound>	mStoppageSounds;
var array<Sound>	mAcknowledgeYesSounds;
var Range			mSquadAcknowledgeYesDelay;
var array<Sound>	mAcknowledgeNoSounds;
var array<Sound>	mOutOfBoundsSounds;



// Decompiled with UE Explorer.
defaultproperties
{
    mManDownChance=1.0000000
    mTerroristDownChance=0.5000000
    mClearDelay=(Min=1.0000000,Max=2.5000000)
    mCheckDeadDelay=(Min=1.0000000,Max=2.0000000)
    mCheckDeadChance=0.2500000
    mCallBackupDelay=(Min=1.2000000,Max=1.2000000)
    mMovingChance=0.3000000
    mOrderWingmanChance=0.3000000
    mSquadAcknowledgeYesDelay=(Min=0.0000000,Max=1.0000000)
    mIncapacitatedSounds[0]=Sound'Screams.X_incap_01'
    mIncapacitatedSounds[1]=Sound'Screams.X_incap_02'
    mIncapacitatedSounds[2]=Sound'Screams.X_incap_03'
    mIncapacitatedSounds[3]=Sound'Screams.X_incap_04'
    mIncapacitatedSounds[4]=Sound'Screams.X_incap_05'
    mIncapacitatedSounds[5]=Sound'Screams.X_incap_06'
    mIncapacitatedSounds[6]=Sound'Screams.X_incap_07'
    mIncapacitatedSounds[7]=Sound'Screams.X_incap_08'
    mIncapacitatedSounds[8]=Sound'Screams.X_incap_09'
    mIncapacitatedSounds[9]=Sound'Screams.X_incap_10'
    mIncapacitatedSounds[10]=Sound'Screams.X_incap_11'
    mIncapacitatedSounds[11]=Sound'Screams.X_incap_12'
    mIncapacitatedSounds[12]=Sound'Screams.X_incap_13'
    mIncapacitatedSounds[13]=Sound'Screams.X_incap_14'
    mIncapacitatedSounds[14]=Sound'Screams.X_incap_15'
    mIncapacitatedSounds[15]=Sound'Screams.X_incap_16'
    mIncapacitatedSounds[16]=Sound'Screams.X_incap_17'
    mIncapacitatedSounds[17]=Sound'Screams.X_incap_18'
    mIncapacitatedSounds[18]=Sound'Screams.X_incap_19'
    mIncapacitatedSounds[19]=Sound'Screams.X_incap_20'
    mIncapacitatedSounds[20]=Sound'Screams.X_incap_21'
    mIncapacitatedSounds[21]=Sound'Screams.X_incap_22'
    mIncapacitatedSounds[22]=Sound'Screams.X_incap_23'
    mIncapacitatedSounds[23]=Sound'Screams.X_incap_24'
    mDeathSounds[0]=Sound'DefHurt.Base.Die01'
    mDeathSounds[1]=Sound'DefHurt.Base.Die02'
    mDeathSounds[2]=Sound'DefHurt.Base.Die03'
    mDeathSounds[3]=Sound'DefHurt.Base.Die04'
    mDeathSounds[4]=Sound'DefHurt.Base.Die05'
    mDeathSounds[5]=Sound'DefHurt.Base.Die06'
    mDeathSounds[6]=Sound'DefHurt.Base.Die07'
    mDeathSounds[7]=Sound'DefHurt.Base.Die08'
    mDeathSounds[8]=Sound'DefHurt.Base.Die09'
    mDeathSounds[9]=Sound'DefHurt.Base.die10'
}