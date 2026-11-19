class SASTerroristVoice extends SASPawnVoice
	native
	abstract;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

// Terrorist specific speech.

var array<Sound>	mCallBackupSounds;
var array<Sound>	mSurprisedSounds;
var array<Sound>	mFeignDeathSounds;
var float			mFeignDeathChance;		
var array<Sound>	mAlertSounds;
var array<Sound>	mBattlecrySounds;
var array<Sound>	mDirectionSounds;
var array<Sound>	mEnemyRetreatSounds;
var array<Sound>	mExecutionSounds;
var array<Sound>	mFriendLossSounds;
var array<Sound>	mGrenadeSounds;
var array<Sound>	mWeaponJamSounds;
var array<Sound>	mTauntSounds;
var array<Sound>	mWarningSounds;
var array<Sound>	mHostageStandoffSounds;

var array<Sound>	mAlertAggressiveSeenThreatSounds;
var Range			mAlertAggressiveSeenThreatDelay;
var float			mAlertAggressiveSeenThreatChance;
var array<Sound>	mAlertAggressiveNoThreatSounds;
var Range			mAlertAggressiveNoThreatDelay;
var float			mAlertAggressiveNoThreatChance;
var array<Sound>	mAlertCoverSeenThreatSounds;
var Range			mAlertCoverSeenThreatDelay;
var float			mAlertCoverSeenThreatChance;
var array<Sound>	mAlertCoverNoThreatSounds;
var Range			mAlertCoverNoThreatDelay;
var float			mAlertCoverNoThreatChance;
var array<Sound>	mRetreatSounds;
var Range			mRetreatDelay;
var float			mRetreatChance;
var array<Sound>	mSurrenderSounds;
var Range			mSurrenderDelay;
var float			mSurrenderChance;



// Decompiled with UE Explorer.
defaultproperties
{
    mFeignDeathChance=1.0000000
    mAlertAggressiveSeenThreatDelay=(Min=0.2500000,Max=3.0000000)
    mAlertAggressiveSeenThreatChance=1.0000000
    mAlertAggressiveNoThreatDelay=(Min=0.5000000,Max=10.0000000)
    mAlertAggressiveNoThreatChance=1.0000000
    mAlertCoverSeenThreatDelay=(Min=0.2500000,Max=3.0000000)
    mAlertCoverSeenThreatChance=1.0000000
    mAlertCoverNoThreatDelay=(Min=0.5000000,Max=10.0000000)
    mAlertCoverNoThreatChance=1.0000000
    mRetreatDelay=(Min=0.5000000,Max=3.0000000)
    mRetreatChance=1.0000000
    mSurrenderDelay=(Min=0.0000000,Max=1.0000000)
    mSurrenderChance=1.0000000
    mHitSounds[0]=Sound'DefHurt.Base.Hit01'
    mHitSounds[1]=Sound'DefHurt.Base.Hit02'
    mHitSounds[2]=Sound'DefHurt.Base.Hit03'
    mHitSounds[3]=Sound'DefHurt.Base.Hit04'
    mHitSounds[4]=Sound'DefHurt.Base.Hit05'
    mHitSounds[5]=Sound'DefHurt.Base.Hit06'
    mHitSounds[6]=Sound'DefHurt.Base.Hit07'
    mHitSounds[7]=Sound'DefHurt.Base.Hit08'
    mHitSounds[8]=Sound'DefHurt.Base.Hit09'
    mHitSounds[9]=Sound'DefHurt.Base.Hit10'
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
    mCoughSounds[0]=Sound'Coughs.WD_gas_reaction_1'
    mCoughSounds[1]=Sound'Coughs.WD_gas_reaction_2'
    mCoughSounds[2]=Sound'Coughs.WD_gas_reaction_3'
    mCoughSounds[3]=Sound'Coughs.WD_gas_reaction_4'
    mCoughSounds[4]=Sound'Coughs.WD_gas_reaction_5'
    mCoughSounds[5]=Sound'Coughs.WD_gas_reaction_6'
    mCoughSounds[6]=Sound'Coughs.WD_gas_reaction_7'
    mCoughSounds[7]=Sound'Coughs.WD_gas_reaction_8'
    mCoughSounds[8]=Sound'Coughs.WD_gas_reaction_9'
    mCoughSounds[9]=Sound'Coughs.WD_gas_reaction_10'
    mCoughSounds[10]=Sound'Coughs.WD_gas_reaction_11'
    mCoughSounds[11]=Sound'Coughs.WD_gas_reaction_12'
    mCoughSounds[12]=Sound'Coughs.WD_gas_reaction_13'
    mCoughSounds[13]=Sound'Coughs.WD_gas_reaction_14'
    mCoughSounds[14]=Sound'Coughs.WD_gas_reaction_15'
    mCoughSounds[15]=Sound'Coughs.WD_gas_reaction_16'
    mCoughSounds[16]=Sound'Coughs.WD_gas_reaction_17'
    mCoughSounds[17]=Sound'Coughs.WD_gas_reaction_18'
    mCoughSounds[18]=Sound'Coughs.WD_gas_reaction_19'
    mCoughSounds[19]=Sound'Coughs.WD_gas_reaction_20'
    mCoughSounds[20]=Sound'Coughs.WD_gas_reaction_21'
    mCoughSounds[21]=Sound'Coughs.WD_gas_reaction_22'
    mCoughSounds[22]=Sound'Coughs.WD_gas_reaction_23'
    mCoughSounds[23]=Sound'Coughs.WD_gas_reaction_24'
    mCoughSounds[24]=Sound'Coughs.WD_gas_reaction_25'
    mCoughSounds[25]=Sound'Coughs.WD_gas_reaction_26'
    mCoughSounds[26]=Sound'Coughs.WD_gas_reaction_27'
    mCoughSounds[27]=Sound'Coughs.WD_gas_reaction_28'
    mCoughSounds[28]=Sound'Coughs.WD_gas_reaction_29'
}