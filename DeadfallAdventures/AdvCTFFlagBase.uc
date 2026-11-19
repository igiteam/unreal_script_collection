class AdvCTFFlagBase extends EvilCarriedObject
    hidecategories(Navigation);

var SoundCue TeamFlagTakenSound;
var SoundCue TeamFlagDroppedSound;
var string TeamFlagTakenStringKey;
var string TeamFlagDroppedStringKey;
var SoundCue EnemyFlagTakenSound;
var SoundCue EnemyFlagDroppedSound;
var string EnemyFlagTakenStringKey;
var string EnemyFlagDroppedStringKey;
var array<SoundCue> PlayerTakesFlagSound;
var array<string> PlayerTakesFlagMessageKeys;
var ParticleSystem RespawnEffect;
var bool bBringUpBright;
var bool bBringDownFromBright;
var repnotify bool bFadingOut;
var repnotify bool bRespawning;
var repnotify bool bActivateFlash;
var bool bWasClothEnabled;
var repnotify bool bPlayIdleAnim;
var array<MaterialInstanceConstant> MICArray;
var Vector RunningClothVelClamp;
var Vector HoverboardingClothVelClamp;
var export editinline ParticleSystemComponent SuccessfulCaptureSystem;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var float LastLocationPingTime;
var AnimNodeSequence AnimNode;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        bFadingOut, bRespawning;

    // Pos:0x011
    if(bNetDirty
        bActivateFlash, bPlayIdleAnim;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'bFadingOut')
    {
        // End:0x2E
        if(bFadingOut)
        {
            CustomFadeOutEffects();
        }        
    }
    else
    {
        // End:0x62
        if(VarName == 'bRespawning')
        {
            // End:0x5F
            if(bRespawning)
            {
                CustomRespawnEffects();
            }            
        }
        else
        {
            // End:0x93
            if(VarName == 'bActivateFlash')
            {
                // End:0x90
                if(bActivateFlash)
                {
                    FlashEffect();
                }                
            }
            else
            {
                // End:0xC1
                if(VarName == 'bPlayIdleAnim')
                {
                    PlayAnimation(bPlayIdleAnim);                    
                }
                else
                {
                    super.ReplicatedEvent(VarName);
                }
            }
        }
    }
    //return;    
}

simulated function PlayAnimation(bool bPlay)
{
    // End:0x40
    if(AnimNode == none)
    {
        AnimNode = AnimNodeSequence(SkelMesh.Animations);
    }
    // End:0x166
    if(AnimNode != none)
    {
        // End:0xCA
        if(!bPlay)
        {
            AnimNode.StopAnim();
            AnimNode.SetRootBoneAxisOption(2, 2, 2);
            AnimNode.SetRootBoneRotationOption(2, 2, 2);            
        }
        else
        {
            AnimNode.SetAnim('Idle');
            AnimNode.SetRootBoneAxisOption(0, 0, 0);
            AnimNode.SetRootBoneRotationOption(0, 0, 0);
            AnimNode.PlayAnim(true, 1.0000000, 0.0000000);
        }
    }
    //return;    
}

simulated function SetAnimPlay(bool bPlay)
{
    bPlayIdleAnim = bPlay;
    bForceNetUpdate = true;
    // End:0x49
    if(int(Role) == int(ROLE_Authority))
    {
        PlayAnimation(bPlay);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetAnimPlay(true);
    //return;    
}

simulated event OnBaseChainChanged()
{
    local AdvPawn UTP;

    UTP = AdvPawn(Base);
    // End:0xD6
    if(UTP != none)
    {
        UTP.Mesh.bForceUpdateAttachmentsInTick = true;
        SkelMesh.SetShadowParent(UTP.Mesh);
        ClearTimer('SetFlagDynamicLightToNotBeDynamic');
        LightEnvironment.bDynamic = true;        
    }
    else
    {
        SkelMesh.bClothBaseVelClamp = false;
        SkelMesh.SetAttachClothVertsToBaseBody(false);
        SkelMesh.SetShadowParent(none);
        LightEnvironment.bDynamic = true;
        SetTimer(5.0000000, false, 'SetFlagDynamicLightToNotBeDynamic');
        // End:0x1C2
        if(AdvPawn(OldBase) != none)
        {
            AdvPawn(OldBase).Mesh.bForceUpdateAttachmentsInTick = false;
        }
    }
    //return;    
}

simulated function FlashEffect()
{
    SuccessfulCaptureSystem.ActivateSystem();
    //return;    
}

simulated function bool ShouldMinimapRenderFor(PlayerController PC)
{
    return (bHome || PC.PlayerReplicationInfo.Team != Team) || (WorldInfo.TimeSeconds - LastLocationPingTime) < 5.0000000;
    //return ReturnValue;    
}

simulated function ClientReturnedHome()
{
    super.ClientReturnedHome();
    // End:0x28
    if(HomeBase != none)
    {
        SetBase(HomeBase);
    }
    //return;    
}

function SetHolder(Controller C)
{
    local int I;
    local AdvPawn UTP;
    local AdvPlayerControllerMP PC;

    SetAnimPlay(false);
    SkelMesh.SetTranslation(vect(0.0000000, 0.0000000, 0.0000000));
    UTP = AdvPawn(C.Pawn);
    LightEnvironment.bDynamic = true;
    SkelMesh.SetShadowParent(UTP.Mesh);
    ClearTimer('SetFlagDynamicLightToNotBeDynamic');
    // End:0x2F0
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        I = Rand(PlayerTakesFlagSound.Length);
        // End:0x1CB
        if(AdvPlayerControllerMP(C) == PC)
        {
            PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", PlayerTakesFlagMessageKeys[I], "AdvGame"), PlayerTakesFlagSound[I]);
            // End:0x2EF
            continue;
        }
        // End:0x27F
        if(Team == PC.PlayerReplicationInfo.Team)
        {
            PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", TeamFlagTakenStringKey, "AdvGame"), TeamFlagTakenSound);
            // End:0x2EF
            continue;
        }
        PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", EnemyFlagTakenStringKey, "AdvGame"), EnemyFlagTakenSound);        
    }    
    super.SetHolder(C);
    //return;    
}

function bool ValidHolder(Actor Other)
{
    local Controller C;

    // End:0x1A
    if(!super.ValidHolder(Other))
    {
        return false;
    }
    C = Pawn(Other).Controller;
    // End:0xA1
    if(WorldInfo.GRI.OnSameTeam(self, C))
    {
        SameTeamTouch(C);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SameTeamTouch(Controller C)
{
    //return;    
}

simulated function CustomRespawnEffects()
{
    local int I;

    bRespawning = true;
    bFadingOut = false;
    ClearTimer('CustomFadeOutEffects');
    SetTimer(1.0000000, false, 'bringUpBrightOff');
    // End:0x15D
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0xCA
        if(RespawnEffect != none)
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(RespawnEffect, Location, Rotation, self);
        }
        bBringUpBright = true;
        bBringDownFromBright = false;
        I = 0;
        J0xED:

        // End:0x113 [Loop If]
        if(I < MICArray.Length)
        {
            I++;
            // [Loop Continue]
            goto J0xED;
        }
        bWasClothEnabled = SkelMesh.bEnableClothSimulation;
        SkelMesh.SetEnableClothSimulation(false);
    }
    //return;    
}

simulated function bringUpBrightOff()
{
    local int I;

    // End:0x8F
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        bBringUpBright = false;
        I = 0;
        J0x40:

        // End:0x66 [Loop If]
        if(I < MICArray.Length)
        {
            ++I;
            // [Loop Continue]
            goto J0x40;
        }
        SkelMesh.SetEnableClothSimulation(bWasClothEnabled);
    }
    bRespawning = false;
    //return;    
}

simulated function CustomFadeOutEffects()
{
    local int I;

    // End:0xF0
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x82
        if(bBringUpBright)
        {
            bBringUpBright = false;
            bBringDownFromBright = true;
            I = 0;
            J0x59:

            // End:0x7F [Loop If]
            if(I < MICArray.Length)
            {
                ++I;
                // [Loop Continue]
                goto J0x59;
            }            
        }
        else
        {
            // End:0xD1
            if(bBringDownFromBright)
            {
                I = 0;
                J0x9A:

                // End:0xC0 [Loop If]
                if(I < MICArray.Length)
                {
                    ++I;
                    // [Loop Continue]
                    goto J0x9A;
                }
                bBringDownFromBright = false;
                return;                
            }
            else
            {
                bBringUpBright = true;
            }
        }
        SetTimer(0.5000000, false, 'CustomFadeOutEffects');
    }
    //return;    
}

function SendHome(Controller Returner)
{
    super.SendHome(Returner);
    //return;    
}

function ClearCaptureFlag()
{
    bActivateFlash = false;
    //return;    
}

function Drop(optional Controller Killer)
{
    local AdvPlayerControllerMP PC;

    SetFlagPropertiesToStationaryFlagState();
    SetAnimPlay(true);
    // End:0x16F
    foreach WorldInfo.AllControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0xFE
        if(Team == PC.PlayerReplicationInfo.Team)
        {
            PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", TeamFlagDroppedStringKey, "AdvGame"), TeamFlagDroppedSound);
            // End:0x16E
            continue;
        }
        PC.SetAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", EnemyFlagDroppedStringKey, "AdvGame"), EnemyFlagDroppedSound);        
    }    
    super.Drop(Killer);
    //return;    
}

function SetFlagPropertiesToStationaryFlagState()
{
    SkelMesh.SetTranslation(vect(0.0000000, 0.0000000, 0.0000000));
    LightEnvironment.bDynamic = true;
    SkelMesh.SetShadowParent(none);
    SetTimer(5.0000000, false, 'SetFlagDynamicLightToNotBeDynamic');
    //return;    
}

function SetFlagDynamicLightToNotBeDynamic()
{
    ClearTimer('SetFlagDynamicLightToNotBeDynamic');
    LightEnvironment.bDynamic = false;
    //return;    
}

auto state Home
{
    ignores SendHome, Score, Drop;

    function BeginState(name PreviousStateName)
    {
        SetFlagPropertiesToStationaryFlagState();
        CustomRespawnEffects();
        SetAnimPlay(true);
        super.BeginState(PreviousStateName);
        // End:0x9C
        if(Team != none)
        {
            AdvGRI(WorldInfo.GRI).SetFlagHome(Team.TeamIndex);
        }
        EvilGameObjective(HomeBase).SetAlarm(false);
        HomeBase.bForceNetUpdate = true;
        bForceNetUpdate = true;
        bActivateFlash = false;
        SetBase(HomeBase);
        HomeBase.ObjectiveChanged();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        EvilGameObjective(HomeBase).SetAlarm(true);
        HomeBase.bForceNetUpdate = true;
        //return;        
    }

    function SameTeamTouch(Controller C)
    {
        local AdvCTFFlagBase Flag;

        // End:0x13E
        if(AdvPRI(C.PlayerReplicationInfo).bHasFlag)
        {
            Flag = AdvCTFFlagBase(AdvPRI(C.PlayerReplicationInfo).GetFlag());
            AdvGameCTFBase(WorldInfo.Game).ScoreFlag(C, Flag);
            SuccessfulCaptureSystem.SetActive(true);
            bActivateFlash = true;
            SetTimer(0.5000000, false, 'ClearCaptureFlag');
            Flag.Score();
        }
        //return;        
    }
    stop;    
}

state Dropped
{
    ignores Drop, CheckFit;

    function SameTeamTouch(Controller C)
    {
        AdvGameCTFBase(WorldInfo.Game).ScoreFlag(C, self);
        SendHome(C);
        //return;        
    }

    function Timer()
    {
        // End:0x26
        if(bFadingOut)
        {
            super.Timer();
            bFadingOut = false;            
        }
        else
        {
            bFadingOut = true;
            CustomFadeOutEffects();
            SetTimer(1.0000000);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x27
        if(DroppedSound != none)
        {
            PlaySound(DroppedSound);
        }
        EvilGameReplicationInfo(WorldInfo.GRI).SetFlagDown(int(GetTeamNum()));
        WorldInfo.GRI.bForceNetUpdate = true;
        SetTimer(MaxDropTime, false);
        bCollideWorld = false;
        SetCollisionSize(0.7500000 * DefaultRadius, DefaultHeight);
        SetCollision(true, false);
        CheckFit();
        CheckPain();
        //return;        
    }
    stop;    
}

defaultproperties
{
    TeamFlagTakenSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_ETHA_001'
    TeamFlagDroppedSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_ETDA_001'
    TeamFlagTakenStringKey="ANNO_CTF_ETHA_001"
    TeamFlagDroppedStringKey="ANNO_CTF_ETDA_001"
    EnemyFlagTakenSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PTHA_001'
    EnemyFlagDroppedSound=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PTDA_001'
    EnemyFlagTakenStringKey="ANNO_CTF_PTHA_001"
    EnemyFlagDroppedStringKey="ANNO_CTF_PTDA_001"
    PlayerTakesFlagSound[0]=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PHA_001'
    PlayerTakesFlagSound[1]=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PHA_002'
    PlayerTakesFlagSound[2]=SoundCue'a_anno_ctf01_cue.ANNO_CTF_PHA_003'
    PlayerTakesFlagMessageKeys[0]="ANNO_CTF_PHA_001"
    PlayerTakesFlagMessageKeys[1]="ANNO_CTF_PHA_002"
    PlayerTakesFlagMessageKeys[2]="ANNO_CTF_PHA_003"
    RunningClothVelClamp=(X=500.0000000,Y=500.0000000,Z=200.0000000)
    HoverboardingClothVelClamp=(X=300.0000000,Y=300.0000000,Z=200.0000000)
    // Reference: DynamicLightEnvironmentComponent'Default__AdvCTFFlagBase.FlagLightEnvironment'
    begin object name=FlagLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=FlagLightEnvironment
    LastLocationPingTime=-100.0000000
    bUseTeamColorForIcon=true
    MapSize=0.4000000
    IconCoords=(U=843.0000000,V=86.0000000,UL=46.0000000,VL=44.0000000)
    GameObjBone3P="Spine"
    GameObjOffset3P=(X=-30.0000000,Y=0.0000000,Z=16.0000000)
    GameObjRot3P=(Pitch=-16384,Yaw=0,Roll=0)
    GameObjOffset1P=(X=-30.0000000,Y=0.0000000,Z=0.0000000)
    // Reference: PointLightComponent'Default__AdvCTFFlagBase.FlagLightComponent'
    begin object name=FlagLightComponent class=Class'Engine.PointLightComponent'
        Radius=250.0000000
        Brightness=5.0000000
        CastShadows=false
        LightingChannels=(Dynamic=false,CompositeDynamic=false)
    end object
    FlagLight=FlagLightComponent
    // Reference: ForceFeedbackWaveform'Default__AdvCTFFlagBase.ForceFeedbackWaveformPickUp'
    begin object name=ForceFeedbackWaveformPickUp
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: SkeletalMeshComponent'Default__AdvCTFFlagBase.TheFlagSkelMesh'
    begin object name=TheFlagSkelMesh class=Class'Engine.SkeletalMeshComponent'
        Animations=AnimNodeSequence'Default__AdvCTFFlagBase.AnimNodeSeq0'
        AnimSets[0]=AnimSet'wp_urn_01.Anim.as_wp_artifact_01'
        bUpdateSkelWhenNotRendered=false
        bPerBoneMotionBlur=true
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvCTFFlagBase.FlagLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Nothing
        BlockRigidBody=true
        LightingChannels=(Unnamed_6=true)
    end object
    SkelMesh=TheFlagSkelMesh
    bHome=true
    // Reference: CylinderComponent'Default__AdvCTFFlagBase.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=85.0000000
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=FlagLightEnvironment
    Components[2]=FlagLightComponent
    Components[3]=TheFlagSkelMesh
    bHardAttach=true
    bCollideActors=true
    NetPriority=3.0000000
    CollisionComponent=CollisionCylinder
}