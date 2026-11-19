class TurokPawnHumanNpcNative extends TurokPawnHuman
    abstract
    native
    nativereplication
    config(Pawn)
    hidecategories(Navigation);

enum EHumanNPCType
{
    EHNPCT_HumanMg,                 // 0
    EHNPCT_HumanWc,                 // 1
    EHNPCT_Lil,                     // 2
    EHNPCT_MPBot,                   // 3
    EHNPCT_Scientist,               // 4
    EHNPCT_SpiderTank,              // 5
    EHNPCT_NUM,                     // 6
    EHNPCT_MAX                      // 7
};

enum EHumanNPCEye
{
    EHEYE_Idle,                     // 0
    EHEYE_Investigate,              // 1
    EHEYE_Attack,                   // 2
    EHEYE_Dead,                     // 3
    EHEYE_MAX                       // 4
};

struct native HumanSpeech
{
    var @NULL mSoundCue;
    var int mPriority;
    var float mCoolDown;
    var float mGracePeriod;
    var name mBBName;

    structdefaultproperties
    {
        mSoundCue=none
        mPriority=0
        mCoolDown=0.0000000
        mGracePeriod=0.0000000
        mBBName="None"
    }
};

var const byte mNPCType;
var protected byte mReplicatedTeamIndex;
var protected byte mSpatialTargetBoneIndex;
var protected repnotify byte mSpeechSoundCueIndex;
var protected repnotify byte mHumanEye;
var const string mNPCName;
var(Accuracy) config float mAccuracySpreadMinAngle;
var(Accuracy) config float mAccuracySpreadMaxAngle;
var(Accuracy) config float mAccuracyAdaptiveSpreadAngle[3];
var(Accuracy) config float mAccuracyLockTime;
var float mAccuracyLockStartTime;
var bool mForcePerfectAccuracy;
var bool mCanUseCover;
var array mHumanSpeechList;
var int mCanAttackOverride;
var float mAimRate;
var config float mIdleAimRate;
var config float mAttackAimRate;
var(Senses) config @NULL mSensesIdle;
var(Senses) config @NULL mSensesInvestigateLow;
var(Senses) config @NULL mSensesInvestigateMedium;
var(Senses) config @NULL mSensesInvestigateScripted;
var(Senses) config @NULL mSensesInvestigateHigh;
var(Senses) config @NULL mSensesAttack;
var(grenade) config float mMinGrenadeDist;
var(grenade) config float mMaxGrenadeDist;
var(grenade) config float mGrenadeBufferDist;
var(GrenadeReaction) config float mGrenadeReactionTimeMin;
var(GrenadeReaction) config float mGrenadeReactionTimeMax;
var(Speech) config float mEnemySpottedDist;
var(Grass) config float mAccuracyPenalty;
var int mSpeechSndChannel;
var(Arrow) config float mNoticeArrowDist;
var(Target) config float mAcquireBaseTime;
var(Target) config float mAcquireDistScale;
var(Target) config float mAcquireDistMinTime;
var(Target) config float mAcquireDistMaxTime;
var @NULL mEyeMI;
var config float mRefireDistance;
var config float mRefireScale;
var config float mInvestigateAcquireTime;
var private transient @NULL mCurrentViewRotation;
var @NULL mCoverGraphSet;
var @NULL mStunnedGraphSet;
var int mUpdateHumanNpcIndex;

replication
{
    // Pos:0x000
    if(bNetDirty
        mAimRate, mHumanEye, 
        mReplicatedTeamIndex, mSpatialTargetBoneIndex, 
        mSpeechSoundCueIndex;
}

// Export UTurokPawnHumanNpcNative::execGetViewRotation(FFrame&, void* const)
native simulated function @NULL GetViewRotation();

// Export UTurokPawnHumanNpcNative::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export UTurokPawnHumanNpcNative::execGetMaxSpeedModifier(FFrame&, void* const)
native function float GetMaxSpeedModifier();

simulated function PostBeginPlay()
{
    local int Index;

    super.PostBeginPlay();
    // End:0xC2
    if(Mesh != none)
    {
        Index = 0;
        J0x18:

        // End:0xC2 [Loop If]
        if(Index < Mesh.SkeletalMesh.Materials.Length)
        {
            // End:0xB8
            if(Mesh.GetMaterial(Index).Name == 'EyesMat00')
            {
                mEyeMI = new (none) Class'Engine.MaterialInstanceConstant';
                mEyeMI.SetParent(Mesh.GetMaterial(1));
                Mesh.SetMaterial(1, mEyeMI);
            }
            Index++;
            // [Loop Continue]
            goto J0x18;
        }
    }
    mCurrentViewRotation = Rotation;
    mSpatialTarget = Location + (Vector(Rotation) * float(100));
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    // End:0x32
    if(VarName == 'mSpeechSoundCueIndex')
    {
        ReplicatedSpeechEvent(int(mSpeechSoundCueIndex));        
    }
    else
    {
        // End:0x54
        if(VarName == 'mHumanEye')
        {
            ReplicatedEyeEvent(mHumanEye);
        }
    }
    //return;    
}

function byte ChooseFireMode()
{
    return GetFiringMode();
    //return ReturnValue;    
}

function SetFireMode(byte mode)
{
    GetPrimaryWeapon().SetCurrentFireMode(mode);
    //return;    
}

simulated function OnAIFireMode(@NULL Action)
{
    local @NULL primaryWeapon;

    primaryWeapon = GetPrimaryWeapon();
    // End:0x58
    if(int(primaryWeapon.CurrentFireMode) != int(Action.mFireMode))
    {
        primaryWeapon.ClearPendingFire(int(primaryWeapon.CurrentFireMode));
    }
    primaryWeapon.SetCurrentFireMode(Action.mFireMode);
    //return;    
}

// Export UTurokPawnHumanNpcNative::execGetWeaponStartTraceLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponStartTraceLocation(optional @NULL CurrentWeapon);

event PostSaveGameRestore()
{
    WorldInfo.Game.ChangeTeam(Controller, int(mReplicatedTeamIndex), true);
    //return;    
}

function SetReplicatedTeamNum(int TeamIndex)
{
    mReplicatedTeamIndex = byte(TeamIndex);
    //return;    
}

simulated function string GetHumanReadableName()
{
    return mNPCName;
    //return ReturnValue;    
}

function bool CanAttack(@NULL Other)
{
    // End:0x0D
    if(mCanAttackOverride < 1)
    {
        return false;
    }
    return super.CanAttack(Other);
    //return ReturnValue;    
}

simulated function PlaySpeechSound(@NULL sc, int soundCueIndex)
{
    // End:0x69
    if(sc != none)
    {
        // End:0x3D
        if(mSpeechSndChannel == -1)
        {
            mSpeechSndChannel = mSoundController.CreateAudioChannel(sc, true, true);            
        }
        else
        {
            mSoundController.ChangeAudioChannel(mSpeechSndChannel, sc, true, true);
        }
        mSpeechSoundCueIndex = byte(soundCueIndex);
    }
    //return;    
}

simulated event StopSpeechSound()
{
    // End:0x35
    if(mSpeechSndChannel != -1)
    {
        mSoundController.StopAudioChannel(mSpeechSndChannel);
        mSpeechSoundCueIndex = byte(-1);
    }
    //return;    
}

simulated function ReplicatedSpeechEvent(int soundCueIndex)
{
    // End:0x7F
    if(soundCueIndex >= 0)
    {
        // End:0x4D
        if(mSpeechSndChannel == -1)
        {
            mSpeechSndChannel = mSoundController.CreateAudioChannel(mHumanSpeechList[soundCueIndex].mSoundCue, true, true);            
        }
        else
        {
            mSoundController.ChangeAudioChannel(mSpeechSndChannel, mHumanSpeechList[soundCueIndex].mSoundCue, true, true);
        }        
    }
    else
    {
        // End:0xA7
        if(mSpeechSndChannel != -1)
        {
            mSoundController.StopAudioChannel(mSpeechSndChannel);
        }
    }
    //return;    
}

simulated function SetEye(float Red, float Green, float Blue, float Alpha)
{
    // End:0x3D
    if(mEyeMI != none)
    {
        mEyeMI.SetVectorParameterValue('VEmssHue', MakeLinearColor(Red, Green, Blue, Alpha));
    }
    //return;    
}

simulated function ReplicatedEyeEvent(byte eye)
{
    // End:0x31
    if(int(eye) == int(0))
    {
        SetEye(0.1000000, 0.8000000, 1.0000000, 0.0000000);        
    }
    else
    {
        // End:0x62
        if(int(eye) == int(1))
        {
            SetEye(1.0000000, 0.5000000, 0.0000000, 0.0000000);            
        }
        else
        {
            // End:0x93
            if(int(eye) == int(2))
            {
                SetEye(1.0000000, 0.0300000, 0.0000000, 0.0000000);                
            }
            else
            {
                // End:0xC1
                if(int(eye) == int(3))
                {
                    SetEye(0.0000000, 0.0000000, 0.0000000, 0.0000000);
                }
            }
        }
    }
    //return;    
}

simulated function SetIdleEye()
{
    SetEye(0.1000000, 0.8000000, 1.0000000, 0.0000000);
    mHumanEye = 0;
    //return;    
}

simulated function SetInvestigateEye()
{
    SetEye(1.0000000, 0.5000000, 0.0000000, 0.0000000);
    mHumanEye = 1;
    //return;    
}

simulated function SetAttackEye()
{
    SetEye(1.0000000, 0.0300000, 0.0000000, 0.0000000);
    mHumanEye = 2;
    //return;    
}

simulated function SetDeadEye()
{
    SetEye(0.0000000, 0.0000000, 0.0000000, 0.0000000);
    mHumanEye = 3;
    //return;    
}

defaultproperties
{
    mReplicatedTeamIndex=255
    mNPCName="TurokPawnHumanNpcNative"
    mCanUseCover=true
    mCanAttackOverride=1
    mSpeechSndChannel=-1
    // Reference: TurokWeaponMediator'Default__TurokPawnHumanNpcNative.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnHumanNpcNative.MeterComponent'
    begin object name=MeterComponent
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnHumanNpcNative.KnockdownComponent'
    begin object name=KnockdownComponent
    end object
    mKnockdownController=KnockdownComponent
    // Reference: TurokAISteer'Default__TurokPawnHumanNpcNative.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnHumanNpcNative.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnHumanNpcNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: TurokPathController'Default__TurokPawnHumanNpcNative.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnHumanNpcNative.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    // Reference: TurokSoundController'Default__TurokPawnHumanNpcNative.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokAnimLadderController'Default__TurokPawnHumanNpcNative.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    // Reference: SkeletalMeshComponent'Default__TurokPawnHumanNpcNative.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHumanNpcNative.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnHumanNpcNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnHumanNpcNative.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    Components[10]=TurokWeaponMediatorComponent
    // Reference: SkeletalMeshComponent'Default__TurokPawnHumanNpcNative.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnHumanNpcNative.TurokSkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHumanNpcNative.MyLightEnvironment'
    end object
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    CollisionComponent=CollisionCylinder
}