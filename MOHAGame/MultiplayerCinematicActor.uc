class MultiplayerCinematicActor extends Actor
    native
    config(Game)
    notplaceable
    hidecategories(Navigation);

const MAX_PLAYERS_PER_PLANE = 8;

enum EMultiplayerITPActivity
{
    PLAYER_MITP_SIT_IDLE,           // 0
    PLAYER_MITP_STAND_UP,           // 1
    PLAYER_MITP_STAND_IDLE,         // 2
    PLAYER_MITP_JUMP_OUT,           // 3
    PLAYER_MITP_STOPPED,            // 4
    PLAYER_MITP_MAX                 // 5
};

enum EMultiplayerJumpMasterITPActivity
{
    JUMPMASTER_MITP_IDLE,           // 0
    JUMPMASTER_MITP_STAND_UP,       // 1
    JUMPMASTER_MITP_GET_READY,      // 2
    JUMPMASTER_MITP_GO_GO,          // 3
    JUMPMASTER_MITP_LOOK_UP,        // 4
    JUMPMASTER_MITP_STOPPED,        // 5
    JUMPMASTER_MITP_MAX             // 6
};

struct native JumpMasterActivityAnimList
{
    var(ITP) name CinematicAnimName;
    var(ITP) const MultiplayerCinematicActor.EMultiplayerJumpMasterITPActivity ITPActivity;

    structdefaultproperties
    {
        CinematicAnimName="None"
        ITPActivity=0
    }
};

struct native ActivityAnimList
{
    var(ITP) name CinematicAnimNames[8];
    var(ITP) const MultiplayerCinematicActor.EMultiplayerITPActivity ITPActivity;

    structdefaultproperties
    {
        CinematicAnimNames[0]="None"
        CinematicAnimNames[1]="None"
        CinematicAnimNames[2]="None"
        CinematicAnimNames[3]="None"
        CinematicAnimNames[4]="None"
        CinematicAnimNames[5]="None"
        CinematicAnimNames[6]="None"
        CinematicAnimNames[7]="None"
        ITPActivity=0
    }
};

var export editinline array<export editinline MOHASkeletalMeshComponent> Meshes;
var export editinline array<export editinline MOHASkeletalMeshComponent> HeadMeshes;
var export editinline MOHASkeletalMeshComponent FPMesh;
var int FPMeshIndex;
var export editinline MOHASkeletalMeshComponent JumpMasterMesh;
var(ITP) export editinline MOHASkeletalMeshComponent JumpMasterHeadMesh;
var(ITP) name JumpMasterSocketName;
var MultiplayerCinematicActor.EMultiplayerJumpMasterITPActivity JumpMasterActivity;
var MultiplayerCinematicActor.EMultiplayerJumpMasterITPActivity JumpMasterActivityCurrent;
var MultiplayerCinematicActor.EMultiplayerITPActivity MeshActivities[8];
var MultiplayerCinematicActor.EMultiplayerITPActivity CurrentMeshActivities[8];
var(ITP) JumpMasterActivityAnimList ActivityJumpMasterAnims[EMultiplayerJumpMasterITPActivity];
var bool bIsJumpMasterPlaying;
var(Debug) config bool bDebugAnims;
var array<bool> bIsPlayingArray;
var(ITP) int iCinematicActorNumber;
var(ITP) SkeletalMeshActor PlaneSkelMeshActor;
var(ITP) name PlaneSeatSocketNames[8];
var(ITP) name PlaneStandSocketNames[8];
var(ITP) config float fJumpEndTimes[8];
var(ITP) config float fExitPlaneTimes[8];
var(ITP) ActivityAnimList ActivityPlayerAnims[EMultiplayerITPActivity];
var(ITP) ActivityAnimList FP_ActivityPlayerAnims[EMultiplayerITPActivity];
var int MeshSlotOccupied[8];
var transient int m_iGRIIndex;

simulated event PostBeginPlay()
{
    local int I;
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    super.PostBeginPlay();
    I = 0;
    J0x33:

    // End:0x79 [Loop If]
    if(I < Meshes.Length)
    {
        Meshes[I].AttachComponent(HeadMeshes[I], 'Root');
        ++I;
        // [Loop Continue]
        goto J0x33;
    }
    JumpMasterMesh.AttachComponent(JumpMasterHeadMesh, 'Root');
    amgri.AddCinActor(self);
    //return;    
}

simulated function Destroyed()
{
    local AirborneModeGameReplicationInfo amgri;

    super.Destroyed();
    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x2C
    if(amgri == none)
    {
        return;
    }
    amgri.RemoveCinActor(self);
    m_iGRIIndex = -1;
    //return;    
}

simulated function OnMultiplayerITPChangeJumpMasterActivity(SeqAct_MultiplayerITPChangeJumpMasterActivity Action)
{
    JumpMasterActivity = Action.NewActivity;
    AttachAndPlayJumpMasterMeshAnimation();
    //return;    
}

simulated function OnMultiplayerITPChangeSingleActivity(SeqAct_MultiplayerITPChangeSingleActivity Action)
{
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    // End:0xB2
    if((Action.MeshNumber >= 0) && Action.MeshNumber < Meshes.Length)
    {
        MeshActivities[Action.MeshNumber] = Action.NewActivity;
        PlayAnimation(Action.MeshNumber, Action.NewActivity);
        amgri.UpdateCinActor(self);
    }
    //return;    
}

simulated function OnMultiplayerITPChangeAllActivities(SeqAct_MultiplayerITPChangeAllActivities Action)
{
    local int I;
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    I = 0;
    J0x2D:

    // End:0x81 [Loop If]
    if(I < Meshes.Length)
    {
        MeshActivities[I] = Action.NewActivities[I];
        PlayAnimation(I, MeshActivities[I]);
        ++I;
        // [Loop Continue]
        goto J0x2D;
    }
    amgri.UpdateCinActor(self);
    //return;    
}

simulated function ResetMultiplayerCinematicActor()
{
    local int I;
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    I = 0;
    J0x2D:

    // End:0x66 [Loop If]
    if(I < Meshes.Length)
    {
        MeshActivities[I] = 4;
        PlayAnimation(I, 4);
        ++I;
        // [Loop Continue]
        goto J0x2D;
    }
    JumpMasterActivity = 5;
    AttachAndPlayJumpMasterMeshAnimation();
    amgri.UpdateCinActor(self);
    //return;    
}

simulated event float GetAnimationNormalizedPosition(int MeshIndex)
{
    // End:0x4E
    if(Meshes[MeshIndex] != none)
    {
        return Meshes[MeshIndex].GetAnimNormalizedPosition(ActivityPlayerAnims[int(CurrentMeshActivities[MeshIndex])].CinematicAnimNames[MeshIndex]);
    }
    return -1.0000000;
    //return ReturnValue;    
}

simulated event float GetAnimationCurrentTime(int MeshIndex)
{
    // End:0x4E
    if(Meshes[MeshIndex] != none)
    {
        return Meshes[MeshIndex].GetAnimCurrentTime(ActivityPlayerAnims[int(CurrentMeshActivities[MeshIndex])].CinematicAnimNames[MeshIndex]);
    }
    return -1.0000000;
    //return ReturnValue;    
}

simulated event float FP_GetAnimationCurrentTime(int MeshIndex)
{
    // End:0x4E
    if(Meshes[MeshIndex] != none)
    {
        return Meshes[MeshIndex].GetAnimCurrentTime(FP_ActivityPlayerAnims[int(CurrentMeshActivities[MeshIndex])].CinematicAnimNames[MeshIndex]);
    }
    return -1.0000000;
    //return ReturnValue;    
}

simulated function SetMeshActivity(int MeshIndex, MultiplayerCinematicActor.EMultiplayerITPActivity MeshActivity)
{
    CurrentMeshActivities[MeshIndex] = MeshActivity;
    // End:0x32
    if(int(MeshActivity) == int(4))
    {
        DetachMesh(MeshIndex);
        return;
    }
    // End:0x60
    if((MeshSlotOccupied[MeshIndex] == 1) || bDebugAnims == true)
    {
        AttachAndPlayMeshAnimation(MeshIndex);
    }
    //return;    
}

simulated function DetachMesh(int MeshIndex)
{
    PlaneSkelMeshActor.SkeletalMeshComponent.DetachComponent(Meshes[MeshIndex]);
    SetMeshVisibility(MeshIndex, false);
    // End:0x6A
    if(MeshIndex == FPMeshIndex)
    {
        PlaneSkelMeshActor.SkeletalMeshComponent.DetachComponent(FPMesh);
        SetFPMeshVisibility(false);
    }
    MeshSlotOccupied[MeshIndex] = 0;
    //return;    
}

simulated function DetachJumpMasterMesh()
{
    PlaneSkelMeshActor.SkeletalMeshComponent.DetachComponent(JumpMasterMesh);
    SetJumpMasterMeshVisibility(false);
    //return;    
}

simulated function AttachAndPlayJumpMasterMeshAnimation()
{
    local Rotator rootBoneRot, origRot;
    local Vector rootBoneTrans, origTrans, origScale, meshOrigin;
    local name origBoneName;
    local SkeletalMeshSocket origSkelMeshSocket;
    local int I;
    local bool bFound, bLoop, bRestartIfAlreadyPlaying;
    local MultiplayerCinematicActor.EMultiplayerJumpMasterITPActivity MeshActivity;
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    MeshActivity = JumpMasterActivity;
    JumpMasterActivityCurrent = MeshActivity;
    // End:0x6B
    if(int(MeshActivity) == int(5))
    {
        JumpMasterMesh.StopAnim();
        DetachJumpMasterMesh();
        return;
    }
    bFound = false;
    // End:0xA7
    if((int(MeshActivity) != int(0)) && FPMeshIndex == -1)
    {
        MeshActivity = 0;
        JumpMasterActivityCurrent = MeshActivity;
    }
    // End:0x23F
    if(int(MeshActivity) != int(0))
    {
        I = 0;
        J0xBE:

        // End:0x23F [Loop If]
        if(I < PlaneSkelMeshActor.SkeletalMeshComponent.Attachments.Length)
        {
            // End:0x235
            if(PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].Component == JumpMasterMesh)
            {
                origRot = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeRotation;
                origTrans = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeLocation;
                origBoneName = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].BoneName;
                origScale = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeScale;
                bFound = true;
                rootBoneRot = QuatToRotator(JumpMasterMesh.GetBoneQuaternion('Root', 1));
                rootBoneTrans = GetAdjustedRootTranslation(JumpMasterMesh, 'Root', origRot);
                meshOrigin = JumpMasterMesh.SkeletalMesh.Origin;
                // [Explicit Break]
                goto J0x23F;
            }
            ++I;
            // [Loop Continue]
            goto J0xBE;
        }
    }
    J0x23F:

    // End:0x2CB
    if(!bFound)
    {
        origSkelMeshSocket = PlaneSkelMeshActor.SkeletalMeshComponent.GetSocketByName(JumpMasterSocketName);
        // End:0x2CB
        if(origSkelMeshSocket != none)
        {
            origRot = origSkelMeshSocket.RelativeRotation;
            origTrans = origSkelMeshSocket.RelativeLocation;
            origBoneName = origSkelMeshSocket.BoneName;
            origScale = origSkelMeshSocket.RelativeScale;            
        }
    }
    PlaneSkelMeshActor.SkeletalMeshComponent.AttachComponent(JumpMasterMesh, origBoneName, (origTrans + rootBoneTrans) - meshOrigin, Normalize(origRot + rootBoneRot), origScale);
    bIsJumpMasterPlaying = true;
    bLoop = (int(MeshActivity) == int(0)) || int(MeshActivity) == int(3);
    bRestartIfAlreadyPlaying = int(MeshActivity) != int(5);
    JumpMasterMesh.PlayAnimAtRate(ActivityJumpMasterAnims[int(MeshActivity)].CinematicAnimName, 1.0000000, 0.0000000, bLoop, bRestartIfAlreadyPlaying);
    SetJumpMasterMeshVisibility(true);
    amgri.UpdateCinActor(self);
    //return;    
}

simulated function AttachAndPlayMeshAnimation(int MeshIndex)
{
    local Rotator rootBoneRot, origRot;
    local Vector rootBoneTrans, origTrans, origScale, meshOrigin;
    local name origBoneName;
    local SkeletalMeshSocket origSkelMeshSocket;
    local int I;
    local bool bFound, bLoop, bRestartIfAlreadyPlaying;
    local MultiplayerCinematicActor.EMultiplayerITPActivity MeshActivity;
    local AirborneModeGameReplicationInfo amgri;

    amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
    // End:0x26
    if(amgri == none)
    {
        return;
    }
    MeshSlotOccupied[MeshIndex] = 1;
    MeshActivity = CurrentMeshActivities[MeshIndex];
    // End:0x65
    if(int(MeshActivity) == int(4))
    {
        DetachMesh(MeshIndex);
        return;
    }
    bFound = false;
    I = 0;
    J0x74:

    // End:0x20D [Loop If]
    if(I < PlaneSkelMeshActor.SkeletalMeshComponent.Attachments.Length)
    {
        // End:0x203
        if(PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].Component == Meshes[MeshIndex])
        {
            origRot = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeRotation;
            origTrans = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeLocation;
            origBoneName = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].BoneName;
            origScale = PlaneSkelMeshActor.SkeletalMeshComponent.Attachments[I].RelativeScale;
            bFound = true;
            rootBoneRot = QuatToRotator(Meshes[MeshIndex].GetBoneQuaternion('Root', 1));
            rootBoneTrans = GetAdjustedRootTranslation(Meshes[MeshIndex], 'Root', origRot);
            meshOrigin = Meshes[MeshIndex].SkeletalMesh.Origin;
            // [Explicit Break]
            goto J0x20D;
        }
        ++I;
        // [Loop Continue]
        goto J0x74;
    }
    J0x20D:

    // End:0x308
    if(!bFound)
    {
        // End:0x254
        if(int(MeshActivity) == int(0))
        {
            origSkelMeshSocket = PlaneSkelMeshActor.SkeletalMeshComponent.GetSocketByName(PlaneSeatSocketNames[MeshIndex]);            
        }
        else
        {
            // End:0x2AA
            if((int(MeshActivity) == int(2)) || int(MeshActivity) == int(1))
            {
                MeshActivity = 2;
                origSkelMeshSocket = PlaneSkelMeshActor.SkeletalMeshComponent.GetSocketByName(PlaneStandSocketNames[MeshIndex]);                
            }
        }
        // End:0x308
        if(origSkelMeshSocket != none)
        {
            origRot = origSkelMeshSocket.RelativeRotation;
            origTrans = origSkelMeshSocket.RelativeLocation;
            origBoneName = origSkelMeshSocket.BoneName;
            origScale = origSkelMeshSocket.RelativeScale;            
        }
    }
    PlaneSkelMeshActor.SkeletalMeshComponent.AttachComponent(Meshes[MeshIndex], origBoneName, (origTrans + rootBoneTrans) - meshOrigin, Normalize(origRot + rootBoneRot), origScale);
    // End:0x3B7
    if(FPMeshIndex == MeshIndex)
    {
        PlaneSkelMeshActor.SkeletalMeshComponent.AttachComponent(FPMesh, origBoneName, (origTrans + rootBoneTrans) - meshOrigin, Normalize(origRot + rootBoneRot), origScale);
    }
    bIsPlayingArray[MeshIndex] = true;
    bLoop = (int(MeshActivity) != int(1)) && int(MeshActivity) != int(3);
    bRestartIfAlreadyPlaying = (int(MeshActivity) == int(1)) || int(MeshActivity) == int(3);
    // End:0x48D
    if(FPMeshIndex == MeshIndex)
    {
        FPMesh.PlayAnimAtRate(FP_ActivityPlayerAnims[int(MeshActivity)].CinematicAnimNames[MeshIndex], 1.0000000, 0.0000000, bLoop, bRestartIfAlreadyPlaying);
        // End:0x48D
        if(int(MeshActivity) == int(2))
        {
            FPMesh.ForceTick(0.0000000);
        }
    }
    Meshes[MeshIndex].PlayAnimAtRate(ActivityPlayerAnims[int(MeshActivity)].CinematicAnimNames[MeshIndex], 1.0000000, 0.0000000, bLoop, bRestartIfAlreadyPlaying);
    // End:0x507
    if(int(MeshActivity) == int(2))
    {
        Meshes[MeshIndex].ForceTick(0.0000000);
    }
    // End:0x524
    if(MeshIndex == FPMeshIndex)
    {
        SetFPMeshVisibility(true);        
    }
    else
    {
        SetMeshVisibility(MeshIndex, true);
    }
    amgri.UpdateCinActor(self);
    //return;    
}

simulated function PlayAnimation(int MeshIndex, MultiplayerCinematicActor.EMultiplayerITPActivity MeshActivity)
{
    // End:0x40
    if(((int(MeshActivity) != int(4)) && int(CurrentMeshActivities[MeshIndex]) == int(MeshActivity)) && MeshSlotOccupied[MeshIndex] == 1)
    {
        return;
    }
    // End:0x13D
    if(((MeshIndex >= 0) && MeshIndex < Meshes.Length) && Meshes[MeshIndex] != none)
    {
        switch(MeshActivity)
        {
            // End:0x7C
            case 0:
            // End:0x81
            case 2:
            // End:0x86
            case 1:
            // End:0xBB
            case 3:
                bIsPlayingArray[MeshIndex] = true;
                // End:0xB8
                if(!IsInState('PlayingCinematic'))
                {
                    GotoState('PlayingCinematic');
                }
                // End:0x129
                break;
            // End:0x126
            case 4:
                Meshes[MeshIndex].StopAnim();
                // End:0x106
                if(FPMeshIndex == MeshIndex)
                {
                    FPMesh.StopAnim();
                    SetFPMeshVisibility(false);
                }
                bIsPlayingArray[MeshIndex] = false;
                SetMeshVisibility(MeshIndex, false);
                // End:0x129
                break;
            // End:0xFFFF
            default:
                break;
        }
        SetMeshActivity(MeshIndex, MeshActivity);
    }
    //return;    
}

// Export UMultiplayerCinematicActor::execGetAdjustedRootTranslation(FFrame&, void* const)
native function Vector GetAdjustedRootTranslation(SkeletalMeshComponent MeshComp, name RootBoneName, Rotator PreviousOrientation);

simulated function PlayAllAnimation(MultiplayerCinematicActor.EMultiplayerITPActivity MeshActivity)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x35 [Loop If]
    if(I < Meshes.Length)
    {
        PlayAnimation(I, MeshActivity);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function StopAllAnimation()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(I < Meshes.Length)
    {
        PlayAnimation(I, 4);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local int I;
    local bool bDonePlaying;

    // End:0xAE
    if(VarName == 'MeshActivities')
    {
        I = 0;
        J0x1A:

        // End:0x4A [Loop If]
        if(I < 8)
        {
            PlayAnimation(I, MeshActivities[I]);
            ++I;
            // [Loop Continue]
            goto J0x1A;
        }
        bDonePlaying = true;
        I = 0;
        J0x59:

        // End:0x94 [Loop If]
        if(I < Meshes.Length)
        {
            // End:0x8A
            if(int(MeshActivities[I]) != int(4))
            {
                bDonePlaying = false;
                // [Explicit Break]
                goto J0x94;
            }
            ++I;
            // [Loop Continue]
            goto J0x59;
        }
        J0x94:

        // End:0xAB
        if(bDonePlaying)
        {
            GotoState('EndCinematic');
        }        
    }
    else
    {
        // End:0xCE
        if(VarName == 'JumpMasterActivities')
        {
            AttachAndPlayJumpMasterMeshAnimation();            
        }
        else
        {
            super.ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function SetMeshVisibility(int MeshNum, bool bVisible)
{
    // End:0x7F
    if(((MeshNum >= 0) && MeshNum < Meshes.Length) && Meshes[MeshNum] != none)
    {
        Meshes[MeshNum].SetHidden(!bVisible);
        HeadMeshes[MeshNum].SetHidden(!bVisible);
        SetMeshIssueNotifies(MeshNum, bVisible);
    }
    //return;    
}

simulated function SetFPMeshVisibility(bool bVisible)
{
    FPMesh.SetHidden(!bVisible);
    SetFPMeshIssueNotifies(bVisible);
    //return;    
}

simulated function SetJumpMasterMeshVisibility(bool bVisible)
{
    JumpMasterMesh.SetHidden(!bVisible);
    JumpMasterHeadMesh.SetHidden(!bVisible);
    SetJumpMasterMeshIssueNotifies(bVisible);
    //return;    
}

simulated function SetOtherMeshSeat(int iSeatNum)
{
    local MultiplayerCinematicActor.EMultiplayerITPActivity currActivity;

    // End:0x8D
    if((iSeatNum >= 0) && iSeatNum < Meshes.Length)
    {
        currActivity = CurrentMeshActivities[iSeatNum];
        // End:0x60
        if(int(currActivity) != int(4))
        {
            AttachAndPlayMeshAnimation(iSeatNum);
            SetMeshVisibility(iSeatNum, true);            
        }
        else
        {
            CurrentMeshActivities[FPMeshIndex] = 0;
            AttachAndPlayMeshAnimation(iSeatNum);
            SetMeshVisibility(iSeatNum, true);
        }
    }
    //return;    
}

simulated function SetFPMeshSeat(int iSeatNum)
{
    local MultiplayerCinematicActor.EMultiplayerITPActivity currActivity;

    // End:0xBB
    if((iSeatNum >= 0) && iSeatNum < Meshes.Length)
    {
        FPMeshIndex = iSeatNum;
        currActivity = CurrentMeshActivities[FPMeshIndex];
        // End:0x76
        if(int(currActivity) != int(4))
        {
            AttachAndPlayMeshAnimation(FPMeshIndex);
            SetFPMeshVisibility(true);
            SetMeshVisibility(FPMeshIndex, false);            
        }
        else
        {
            CurrentMeshActivities[FPMeshIndex] = 0;
            AttachAndPlayMeshAnimation(FPMeshIndex);
            SetFPMeshVisibility(true);
            SetMeshVisibility(FPMeshIndex, false);
        }
        AttachAndPlayJumpMasterMeshAnimation();        
    }
    else
    {
        FPMeshIndex = -1;
    }
    //return;    
}

simulated function SetAllMeshVisibility(bool bVisible)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(I < Meshes.Length)
    {
        SetMeshVisibility(I, bVisible);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SetMeshIssueNotifies(int MeshNum, bool bIssueNotifies)
{
    // End:0x52
    if(Meshes[MeshNum].Animations.IsA('AnimNodeSequence'))
    {
        AnimNodeSequence(Meshes[MeshNum].Animations).bNoNotifies = !bIssueNotifies;
    }
    //return;    
}

simulated function SetFPMeshIssueNotifies(bool bIssueNotifies)
{
    // End:0x46
    if(FPMesh.Animations.IsA('AnimNodeSequence'))
    {
        AnimNodeSequence(FPMesh.Animations).bNoNotifies = !bIssueNotifies;
    }
    //return;    
}

simulated function SetJumpMasterMeshIssueNotifies(bool bIssueNotifies)
{
    // End:0x46
    if(JumpMasterMesh.Animations.IsA('AnimNodeSequence'))
    {
        AnimNodeSequence(JumpMasterMesh.Animations).bNoNotifies = !bIssueNotifies;
    }
    //return;    
}

state PlayingCinematic
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        I = 0;
        J0x07:

        // End:0x4F [Loop If]
        if(I < Meshes.Length)
        {
            Meshes[I].bForceNoTick = false;
            HeadMeshes[I].bForceNoTick = false;
            ++I;
            // [Loop Continue]
            goto J0x07;
        }
        JumpMasterMesh.bForceNoTick = false;
        JumpMasterHeadMesh.bForceNoTick = false;
        FPMesh.bForceNoTick = false;
        PlaneSkelMeshActor.SetHidden(false);
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        local int I;
        local bool bStillPlaying, bNeedToUpdateCinActor;
        local AirborneModeGameReplicationInfo amgri;

        amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
        // End:0x34
        if((amgri == none) || bHidden == true)
        {
            return;
        }
        super(Actor).Tick(DeltaTime);
        bNeedToUpdateCinActor = false;
        I = 0;
        J0x4E:

        // End:0x1DB [Loop If]
        if(I < Meshes.Length)
        {
            // End:0xFF
            if(int(CurrentMeshActivities[I]) == int(1))
            {
                // End:0xFC
                if((Meshes[I] != none) && Meshes[I].Animations.IsA('AnimNodeSequence'))
                {
                    // End:0xFC
                    if(!AnimNodeSequence(Meshes[I].Animations).bPlaying)
                    {
                        PlayAnimation(I, 2);
                        MeshActivities[I] = 2;
                        bNeedToUpdateCinActor = true;
                    }
                }
                // [Explicit Continue]
                goto J0x1D1;
            }
            // End:0x1D1
            if(int(CurrentMeshActivities[I]) == int(3))
            {
                // End:0x1D1
                if((Meshes[I] != none) && Meshes[I].Animations.IsA('AnimNodeSequence'))
                {
                    // End:0x1D1
                    if(!AnimNodeSequence(Meshes[I].Animations).bPlaying || AnimNodeSequence(Meshes[I].Animations).CurrentTime >= fJumpEndTimes[I])
                    {
                        PlayAnimation(I, 4);
                        MeshActivities[I] = 4;
                        bNeedToUpdateCinActor = true;
                    }
                }
            }
            J0x1D1:

            ++I;
            // [Loop Continue]
            goto J0x4E;
        }
        // End:0x278
        if(((int(JumpMasterActivity) == int(1)) || int(JumpMasterActivity) == int(2)) || int(JumpMasterActivity) == int(4))
        {
            // End:0x278
            if((JumpMasterMesh != none) && JumpMasterMesh.Animations.IsA('AnimNodeSequence'))
            {
                // End:0x278
                if(!AnimNodeSequence(JumpMasterMesh.Animations).bPlaying)
                {
                    JumpMasterActivity = 0;
                    AttachAndPlayJumpMasterMeshAnimation();
                    bNeedToUpdateCinActor = true;
                }
            }
        }
        // End:0x298
        if(bNeedToUpdateCinActor == true)
        {
            amgri.UpdateCinActor(self);
        }
        bStillPlaying = false;
        I = 0;
        J0x2A7:

        // End:0x2DF [Loop If]
        if(I < bIsPlayingArray.Length)
        {
            bStillPlaying = bIsPlayingArray[I];
            // End:0x2D5
            if(bStillPlaying)
            {
                // [Explicit Break]
                goto J0x2DF;
            }
            ++I;
            // [Loop Continue]
            goto J0x2A7;
        }
        J0x2DF:

        // End:0x2F8
        if(!bStillPlaying)
        {
            GotoState('EndCinematic');
        }
        //return;        
    }
    stop;    
}

auto state EndCinematic
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;
        local AirborneModeGameReplicationInfo amgri;

        amgri = AirborneModeGameReplicationInfo(WorldInfo.GRI);
        // End:0x26
        if(amgri == none)
        {
            return;
        }
        StopAllAnimation();
        SetAllMeshVisibility(false);
        SetFPMeshVisibility(false);
        FPMesh.bForceNoTick = true;
        FPMeshIndex = -1;
        I = 0;
        J0x69:

        // End:0xD8 [Loop If]
        if(I < Meshes.Length)
        {
            MeshActivities[I] = 4;
            Meshes[I].StopAnim();
            Meshes[I].bForceNoTick = true;
            HeadMeshes[I].bForceNoTick = true;
            ++I;
            // [Loop Continue]
            goto J0x69;
        }
        SetJumpMasterMeshVisibility(false);
        JumpMasterActivity = 5;
        JumpMasterMesh.StopAnim();
        JumpMasterMesh.bForceNoTick = true;
        JumpMasterHeadMesh.bForceNoTick = true;
        amgri.UpdateCinActor(self);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent0'
    begin object name=WPawnSkeletalMeshComponent0 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[0]=WPawnSkeletalMeshComponent0
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent1'
    begin object name=WPawnSkeletalMeshComponent1 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[1]=WPawnSkeletalMeshComponent1
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent2'
    begin object name=WPawnSkeletalMeshComponent2 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[2]=WPawnSkeletalMeshComponent2
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent3'
    begin object name=WPawnSkeletalMeshComponent3 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[3]=WPawnSkeletalMeshComponent3
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent4'
    begin object name=WPawnSkeletalMeshComponent4 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[4]=WPawnSkeletalMeshComponent4
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent5'
    begin object name=WPawnSkeletalMeshComponent5 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    Meshes[5]=WPawnSkeletalMeshComponent5
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent6'
    begin object name=WPawnSkeletalMeshComponent6 class=Class'MOHASkeletalMeshComponent'
    end object
    Meshes[6]=WPawnSkeletalMeshComponent6
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.WPawnSkeletalMeshComponent7'
    begin object name=WPawnSkeletalMeshComponent7 class=Class'MOHASkeletalMeshComponent'
    end object
    Meshes[7]=WPawnSkeletalMeshComponent7
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh0'
    begin object name=ParatrooperHeadMesh0 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[0]=ParatrooperHeadMesh0
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh1'
    begin object name=ParatrooperHeadMesh1 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[1]=ParatrooperHeadMesh1
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh2'
    begin object name=ParatrooperHeadMesh2 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[2]=ParatrooperHeadMesh2
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh3'
    begin object name=ParatrooperHeadMesh3 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[3]=ParatrooperHeadMesh3
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh4'
    begin object name=ParatrooperHeadMesh4 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[4]=ParatrooperHeadMesh4
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh5'
    begin object name=ParatrooperHeadMesh5 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    HeadMeshes[5]=ParatrooperHeadMesh5
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh6'
    begin object name=ParatrooperHeadMesh6 class=Class'MOHASkeletalMeshComponent'
    end object
    HeadMeshes[6]=ParatrooperHeadMesh6
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.ParatrooperHeadMesh7'
    begin object name=ParatrooperHeadMesh7 class=Class'MOHASkeletalMeshComponent'
    end object
    HeadMeshes[7]=ParatrooperHeadMesh7
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.FPSkeletalMeshComponent0'
    begin object name=FPSkeletalMeshComponent0 class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    FPMesh=FPSkeletalMeshComponent0
    FPMeshIndex=-1
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.JumpMasterSkeletalMeshComponent'
    begin object name=JumpMasterSkeletalMeshComponent class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    JumpMasterMesh=JumpMasterSkeletalMeshComponent
    // Reference: MOHASkeletalMeshComponent'Default__MultiplayerCinematicActor.JumpMasterHeadSkeletalMeshComponent'
    begin object name=JumpMasterHeadSkeletalMeshComponent class=Class'MOHASkeletalMeshComponent'
        bUpdateSkelWhenNotRendered=true
    end object
    JumpMasterHeadMesh=JumpMasterHeadSkeletalMeshComponent
    JumpMasterSocketName="JumpMaster"
    JumpMasterActivity=5
    JumpMasterActivityCurrent=5
    MeshActivities[0]=4
    MeshActivities[1]=4
    MeshActivities[2]=4
    MeshActivities[3]=4
    MeshActivities[4]=4
    MeshActivities[5]=4
    MeshActivities[6]=4
    MeshActivities[7]=4
    CurrentMeshActivities[0]=4
    CurrentMeshActivities[1]=4
    CurrentMeshActivities[2]=4
    CurrentMeshActivities[3]=4
    CurrentMeshActivities[4]=4
    CurrentMeshActivities[5]=4
    CurrentMeshActivities[6]=4
    CurrentMeshActivities[7]=4
    ActivityJumpMasterAnims[0]=(CinematicAnimName="AD_PlaneJumpMaster_Idle",ITPActivity=0)
    ActivityJumpMasterAnims[1]=(CinematicAnimName="AD_PlaneJumpMaster_StandUp",ITPActivity=1)
    ActivityJumpMasterAnims[2]=(CinematicAnimName="AD_PlaneJumpMaster_GetReady",ITPActivity=2)
    ActivityJumpMasterAnims[3]=(CinematicAnimName="AD_PlaneJumpMaster_GoGo",ITPActivity=3)
    ActivityJumpMasterAnims[4]=(CinematicAnimName="AD_PlaneJumpMaster_lookup",ITPActivity=4)
    bIsPlayingArray[0]=false
    bIsPlayingArray[1]=false
    bIsPlayingArray[2]=false
    bIsPlayingArray[3]=false
    bIsPlayingArray[4]=false
    bIsPlayingArray[5]=false
    bIsPlayingArray[6]=false
    bIsPlayingArray[7]=false
    PlaneSeatSocketNames[0]="Seat0"
    PlaneSeatSocketNames[1]="Seat1"
    PlaneSeatSocketNames[2]="Seat2"
    PlaneSeatSocketNames[3]="Seat3"
    PlaneSeatSocketNames[4]="Seat4"
    PlaneSeatSocketNames[5]="Seat5"
    PlaneSeatSocketNames[6]="Seat6"
    PlaneSeatSocketNames[7]="Seat7"
    PlaneStandSocketNames[0]="Stand0"
    PlaneStandSocketNames[1]="Stand1"
    PlaneStandSocketNames[2]="Stand2"
    PlaneStandSocketNames[3]="Stand3"
    PlaneStandSocketNames[4]="Stand4"
    PlaneStandSocketNames[5]="Stand5"
    PlaneStandSocketNames[6]="Stand6"
    PlaneStandSocketNames[7]="Stand7"
    fJumpEndTimes[0]=1.9500000
    fJumpEndTimes[1]=3.1500000
    fJumpEndTimes[2]=3.6500000
    fJumpEndTimes[3]=4.0800000
    fJumpEndTimes[4]=4.7500000
    fJumpEndTimes[5]=5.4100000
    fJumpEndTimes[6]=6.0800000
    fJumpEndTimes[7]=6.7500000
    fExitPlaneTimes[0]=1.0000000
    fExitPlaneTimes[1]=2.0000000
    fExitPlaneTimes[2]=2.9500000
    fExitPlaneTimes[3]=3.8500000
    fExitPlaneTimes[4]=5.2500000
    fExitPlaneTimes[5]=5.7500000
    fExitPlaneTimes[6]=5.7500000
    fExitPlaneTimes[7]=5.7500000
    ActivityPlayerAnims[0]=(CinematicAnimNames="AD_PlaneSitIdle0",CinematicAnimNames[1]="AD_PlaneSitIdle1",CinematicAnimNames[2]="AD_PlaneSitIdle2",CinematicAnimNames[3]="AD_PlaneSitIdle3",CinematicAnimNames[4]="AD_PlaneSitIdle4",CinematicAnimNames[5]="AD_PlaneSitIdle5",CinematicAnimNames[6]="AD_PlaneSitIdle6",CinematicAnimNames[7]="AD_PlaneSitIdle7",ITPActivity=0)
    ActivityPlayerAnims[1]=(CinematicAnimNames="AD_PlaneGetup0",CinematicAnimNames[1]="AD_PlaneGetup1",CinematicAnimNames[2]="AD_PlaneGetup2",CinematicAnimNames[3]="AD_PlaneGetup3",CinematicAnimNames[4]="AD_PlaneGetup4",CinematicAnimNames[5]="AD_PlaneGetup5",CinematicAnimNames[6]="AD_PlaneGetup6",CinematicAnimNames[7]="AD_PlaneGetup7",ITPActivity=1)
    ActivityPlayerAnims[2]=(CinematicAnimNames="AD_PlaneStandIdle0",CinematicAnimNames[1]="AD_PlaneStandIdle1",CinematicAnimNames[2]="AD_PlaneStandIdle2",CinematicAnimNames[3]="AD_PlaneStandIdle3",CinematicAnimNames[4]="AD_PlaneStandIdle4",CinematicAnimNames[5]="AD_PlaneStandIdle5",CinematicAnimNames[6]="AD_PlaneStandIdle6",CinematicAnimNames[7]="AD_PlaneStandIdle7",ITPActivity=2)
    ActivityPlayerAnims[3]=(CinematicAnimNames="AD_PlaneJump0",CinematicAnimNames[1]="AD_PlaneJump1",CinematicAnimNames[2]="AD_PlaneJump2",CinematicAnimNames[3]="AD_PlaneJump3",CinematicAnimNames[4]="AD_PlaneJump4",CinematicAnimNames[5]="AD_PlaneJump5",CinematicAnimNames[6]="AD_PlaneJump6",CinematicAnimNames[7]="AD_PlaneJump7",ITPActivity=3)
    ActivityPlayerAnims[4]=(CinematicAnimNames="AD_PlaneSitIdle0",CinematicAnimNames[1]="AD_PlaneSitIdle0",CinematicAnimNames[2]="AD_PlaneSitIdle0",CinematicAnimNames[3]="AD_PlaneSitIdle0",CinematicAnimNames[4]="AD_PlaneSitIdle0",CinematicAnimNames[5]="AD_PlaneSitIdle0",CinematicAnimNames[6]="AD_PlaneSitIdle0",CinematicAnimNames[7]="AD_PlaneSitIdle0",ITPActivity=4)
    FP_ActivityPlayerAnims[0]=(CinematicAnimNames="AD_FP_PlaneSitIdle0",CinematicAnimNames[1]="AD_FP_PlaneSitIdle1",CinematicAnimNames[2]="AD_FP_PlaneSitIdle2",CinematicAnimNames[3]="AD_FP_PlaneSitIdle3",CinematicAnimNames[4]="AD_FP_PlaneSitIdle4",CinematicAnimNames[5]="AD_FP_PlaneSitIdle5",CinematicAnimNames[6]="AD_FP_PlaneSitIdle6",CinematicAnimNames[7]="AD_FP_PlaneSitIdle7",ITPActivity=0)
    FP_ActivityPlayerAnims[1]=(CinematicAnimNames="AD_FP_PlaneGetup0",CinematicAnimNames[1]="AD_FP_PlaneGetup1",CinematicAnimNames[2]="AD_FP_PlaneGetup2",CinematicAnimNames[3]="AD_FP_PlaneGetup3",CinematicAnimNames[4]="AD_FP_PlaneGetup4",CinematicAnimNames[5]="AD_FP_PlaneGetup5",CinematicAnimNames[6]="AD_FP_PlaneGetup6",CinematicAnimNames[7]="AD_FP_PlaneGetup7",ITPActivity=1)
    FP_ActivityPlayerAnims[2]=(CinematicAnimNames="AD_FP_PlaneStandIdle0",CinematicAnimNames[1]="AD_FP_PlaneStandIdle1",CinematicAnimNames[2]="AD_FP_PlaneStandIdle2",CinematicAnimNames[3]="AD_FP_PlaneStandIdle3",CinematicAnimNames[4]="AD_FP_PlaneStandIdle4",CinematicAnimNames[5]="AD_FP_PlaneStandIdle5",CinematicAnimNames[6]="AD_FP_PlaneStandIdle6",CinematicAnimNames[7]="AD_FP_PlaneStandIdle7",ITPActivity=2)
    FP_ActivityPlayerAnims[3]=(CinematicAnimNames="AD_FP_PlaneJump0",CinematicAnimNames[1]="AD_FP_PlaneJump1",CinematicAnimNames[2]="AD_FP_PlaneJump2",CinematicAnimNames[3]="AD_FP_PlaneJump3",CinematicAnimNames[4]="AD_FP_PlaneJump4",CinematicAnimNames[5]="AD_FP_PlaneJump5",CinematicAnimNames[6]="AD_FP_PlaneJump6",CinematicAnimNames[7]="AD_FP_PlaneJump7",ITPActivity=3)
    FP_ActivityPlayerAnims[4]=(CinematicAnimNames="AD_FP_PlaneSitIdle0",CinematicAnimNames[1]="AD_FP_PlaneSitIdle1",CinematicAnimNames[2]="AD_FP_PlaneSitIdle2",CinematicAnimNames[3]="AD_FP_PlaneSitIdle3",CinematicAnimNames[4]="AD_FP_PlaneSitIdle4",CinematicAnimNames[5]="AD_FP_PlaneSitIdle5",CinematicAnimNames[6]="AD_FP_PlaneSitIdle6",CinematicAnimNames[7]="AD_FP_PlaneSitIdle7",ITPActivity=4)
    m_iGRIIndex=-1
    Components[0]=WPawnSkeletalMeshComponent0
    Components[1]=ParatrooperHeadMesh0
    Components[2]=WPawnSkeletalMeshComponent1
    Components[3]=ParatrooperHeadMesh1
    Components[4]=WPawnSkeletalMeshComponent2
    Components[5]=ParatrooperHeadMesh2
    Components[6]=WPawnSkeletalMeshComponent3
    Components[7]=ParatrooperHeadMesh3
    Components[8]=WPawnSkeletalMeshComponent4
    Components[9]=ParatrooperHeadMesh4
    Components[10]=WPawnSkeletalMeshComponent5
    Components[11]=ParatrooperHeadMesh5
    Components[12]=WPawnSkeletalMeshComponent6
    Components[13]=ParatrooperHeadMesh6
    Components[14]=WPawnSkeletalMeshComponent7
    Components[15]=ParatrooperHeadMesh7
    Components[16]=FPSkeletalMeshComponent0
    Components[17]=JumpMasterSkeletalMeshComponent
    Components[18]=JumpMasterHeadSkeletalMeshComponent
    bNoDelete=true
}