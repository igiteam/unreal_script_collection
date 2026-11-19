class TurokHackTerminal extends Actor
    native
    nativereplication
    config(Game)
    notplaceable
    hidecategories(Navigation)
    autoexpandcategories(Multiplayer,Hacking);

const HACK_ACTION_NUM_TEAMS = 2;

enum eHackType
{
    HACKTYPE_Team,                  // 0
    HACKTYPE_Nonteam,               // 1
    HACKTYPE_Duel,                  // 2
    HACKTYPE_MAX                    // 3
};

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Hacking) const byte mHackType;
var byte mTeamForNonTeamHackType;
var(Hacking) private bool mbEnabled;
var(Hacking) const bool mEnableResetForDuelTerminal;
var private bool mbCurrentEnabled;
var bool mbTeamIsValid;
var bool mDuelHackFinishTimeValid;
var bool mLastStatusTeam0;
var bool mLastStatusTeam1;
var bool mLastEnabledStatus;
var(Hacking) int mTeamForTeamHackType;
var(Hacking) const float mRequiredTime;
var(Hacking) const int mResetTimeForDuelTerminal;
var(Hacking) const string mInstructionStringId;
var(Hacking) const string mInstructionStringId2;
var(Hacking) const string mOnCompletedMessageStringId;
var(Hacking) editconst int mInstructionHash;
var(Hacking) editconst int mInstructionHash2;
var(Hacking) editconst int mOnCompletedMessageHash;
var private int mCurrentTeamForTeamHackType;
var private float mProgress[2];
var int mDuelHackFinishTime;
var float mLastHackFinishTime;
var private config float HackCooldownTime;
var(ConsoleMesh) export editinline @NULL mConsoleMesh;
var(ConsoleMesh) @NULL mDestroyedMesh;
var(ActionVolume) @NULL mHackActionVolume;
var(ParticleEffects) export editinline @NULL mParticleSystem;
var @NULL mHackCompleteSoundCue;
var() int mHealth;

replication
{
    // Pos:0x000
    if(bNetDirty
        mProgress, mTeamForNonTeamHackType, 
        mbCurrentEnabled, mbTeamIsValid;
}

// Export UTurokHackTerminal::execUpdateProgress(FFrame&, void* const)
native function UpdateProgress(int Team, float DeltaTime);

// Export UTurokHackTerminal::execGetProgress(FFrame&, void* const)
native function float GetProgress(int Team);

// Export UTurokHackTerminal::execGetRequiredTime(FFrame&, void* const)
native function float GetRequiredTime();

event ResetProgress(int Team)
{
    SetProgress(Team, 0.0000000);
    //return;    
}

// Export UTurokHackTerminal::execSetOwningTeam(FFrame&, void* const)
native function SetOwningTeam(int Team);

// Export UTurokHackTerminal::execCanWeUseThisTerminal(FFrame&, void* const)
native function bool CanWeUseThisTerminal(int Team);

simulated function @NULL GetHackGraphSet(@NULL hacker)
{
    return none;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    mCurrentTeamForTeamHackType = mTeamForTeamHackType;
    mbCurrentEnabled = mbEnabled;
    mDuelHackFinishTimeValid = false;
    CheckHackableStatus();
    //return;    
}

function Reset()
{
    local int I;

    super.Reset();
    I = 0;
    J0x0D:

    // End:0x37 [Loop If]
    if(I < 2)
    {
        SetProgress(I, 0.0000000);
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    mbTeamIsValid = false;
    mCurrentTeamForTeamHackType = mTeamForTeamHackType;
    mLastHackFinishTime = 0.0000000;
    SetEnabled(mbEnabled);
    //return;    
}

event CheckHackableStatus()
{
    local bool edgeCaseTeam0, edgeCaseTeam1;

    edgeCaseTeam0 = false;
    edgeCaseTeam1 = false;
    // End:0x47
    if(!mbCurrentEnabled && mLastEnabledStatus != mbCurrentEnabled)
    {
        TriggerEventClass(Class'TurokSeqEvent_HackStatus', self, 2 + 1);        
    }
    else
    {
        edgeCaseTeam0 = (CanWeUseThisTerminal(0)) != mLastStatusTeam0;
        edgeCaseTeam1 = (CanWeUseThisTerminal(1)) != mLastStatusTeam1;
        // End:0xC5
        if(((edgeCaseTeam0 || edgeCaseTeam1) && CanWeUseThisTerminal(0)) && CanWeUseThisTerminal(1))
        {
            TriggerEventClass(Class'TurokSeqEvent_HackStatus', self, 2);            
        }
        else
        {
            // End:0xF3
            if(edgeCaseTeam0 && CanWeUseThisTerminal(0))
            {
                TriggerEventClass(Class'TurokSeqEvent_HackStatus', self, 0);                
            }
            else
            {
                // End:0x11E
                if(edgeCaseTeam1 && CanWeUseThisTerminal(1))
                {
                    TriggerEventClass(Class'TurokSeqEvent_HackStatus', self, 1);
                }
            }
        }
    }
    mLastEnabledStatus = mbCurrentEnabled;
    mLastStatusTeam0 = CanWeUseThisTerminal(0);
    mLastStatusTeam1 = CanWeUseThisTerminal(1);
    //return;    
}

event SetProgress(int Team, float Value)
{
    mProgress[Team] = Value;
    CheckHackableStatus();
    //return;    
}

event SetEnabled(bool Enabled)
{
    mbCurrentEnabled = Enabled;
    CheckHackableStatus();
    //return;    
}

event DisplayCompleteMessage()
{
    //return;    
}

event DuelHackComplete(int Time)
{
    mDuelHackFinishTime = Time;
    mDuelHackFinishTimeValid = true;
    SetTimerForDuelHackReset();
    //return;    
}

function SetTimerForDuelHackReset()
{
    // End:0x1C
    if(mEnableResetForDuelTerminal)
    {
        SetTimer(1.0000000, true, 'UpdateForDuelHackReset');
    }
    //return;    
}

function UpdateForDuelHackReset()
{
    // End:0x4F
    if(WorldInfo.TimeSeconds > float(mDuelHackFinishTime + mResetTimeForDuelTerminal))
    {
        ResetProgress(0);
        ResetProgress(1);
        ClearTimer('UpdateForDuelHackReset');
        mDuelHackFinishTimeValid = false;
    }
    //return;    
}

function OnToggle(@NULL Action)
{
    // End:0x2C
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetEnabled(true);        
    }
    else
    {
        // End:0x58
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetEnabled(false);            
        }
        else
        {
            // End:0x89
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetEnabled(!mbCurrentEnabled);
            }
        }
    }
    CheckHackableStatus();
    //return;    
}

function OnToggleTeam(@NULL Action)
{
    local bool doSetTeam;
    local @NULL InstigatorInfo;

    // End:0x12
    if(int(mHackType) != int(0))
    {
        return;
    }
    // End:0x3B
    if(Action.InputLinks[0].bHasImpulse)
    {
        doSetTeam = true;        
    }
    else
    {
        // End:0x64
        if(Action.InputLinks[1].bHasImpulse)
        {
            doSetTeam = false;            
        }
        else
        {
            // End:0x96
            if(Action.InputLinks[2].bHasImpulse)
            {
                doSetTeam = mCurrentTeamForTeamHackType == 255;                
            }
            else
            {
                return;
            }
        }
    }
    // End:0xE7
    if(doSetTeam)
    {
        Action.GetInstigatorTeamInfo(InstigatorInfo);
        // End:0xE4
        if(InstigatorInfo.mTeamIndex != 255)
        {
            mCurrentTeamForTeamHackType = InstigatorInfo.mTeamIndex;
        }        
    }
    else
    {
        mCurrentTeamForTeamHackType = 255;
    }
    CheckHackableStatus();
    //return;    
}

event TakeDamage(int DamageAmount, @NULL EventInstigator, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x1C
    if((mHealth <= 0) || DamageType == none)
    {
        return;
    }
    super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    mHealth -= DamageAmount;
    // End:0xA0
    if(mHealth <= 0)
    {
        // End:0x7B
        if(mDestroyedMesh != none)
        {
            mConsoleMesh.SetStaticMesh(mDestroyedMesh);
        }
        mParticleSystem.ActivateSystem();
        TriggerEventClass(Class'TurokSeqEvent_DestroyableActorDestroyed', EventInstigator);
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokHackTerminal.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    mbEnabled=true
    mRequiredTime=2.5000000
    // Reference: StaticMeshComponent'Default__TurokHackTerminal.ConsoleMesh'
    begin object name=ConsoleMesh class=Class'Engine.StaticMeshComponent'
    end object
    mConsoleMesh=ConsoleMesh
    // Reference: ParticleSystemComponent'Default__TurokHackTerminal.ParticleSystemComponent'
    begin object name=ParticleSystemComponent class=Class'Engine.ParticleSystemComponent'
        bAutoActivate=false
    end object
    mParticleSystem=ParticleSystemComponent
    mHealth=500
    bNoDelete=true
    bIgnoreEncroachers=true
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
    bMovable=false
    bCanBeDamaged=true
    bCollideWhenPlacing=true
    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    Components[0]=ParticleSystemComponent
    Components[1]=ConsoleMesh
    RemoteRole=1
    NetPriority=1.6000000
    SupportedEvents=/* Array type was not detected. */
}