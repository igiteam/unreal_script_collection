class OirInstance extends LocationRotationObject
    native;

const OIRENTRY_NONE = 0x0000;
const OIRENTRY_NOLOCO = 0x0001;
const OIRENTRY_LOCO = 0x0002;

enum EOIRState
{
    OIRSTATE_LOCOMOTION,            // 0
    OIRSTATE_STEERING,              // 1
    OIRSTATE_ENTRY,                 // 2
    OIRSTATE_ACTIVITY,              // 3
    OIRSTATE_EXIT,                  // 4
    OIRSTATE_MAX                    // 5
};

struct native OIRCustomAttachData
{
    var Actor AttachToActor;
    var export editinline SkeletalMeshComponent AttachToMesh;
    var name AttachNameSocketBone;

    structdefaultproperties
    {
        AttachToActor=none
        AttachToMesh=none
        AttachNameSocketBone="None"
    }
};

var Pawn LockedBy;
var name m_CurrentActivityName;
var name m_CurrentActivityPose;
var float m_TransitionRateScale;
var transient bool m_bCurrentActivityIsSet;
var transient bool bForceUseOIR;
var transient bool bUseVaultExit;
var transient bool bVaultExitUsed;
var transient bool bOIRInExit;
var MOHAAnimBlendByActivity m_ActivityNode;
var MOHAAnimOIRManager m_OIRManagerNode;
var bool m_bPawnIsAttached;
var transient OirInstance.EOIRState m_eOIRState;
var transient float m_fEntryLength;
var transient int DesiredOIREntry;
var transient Vector vAlternateExitFinalPosition;
var transient OIRCustomAttachData customAttach;
var OIROwnerInterface OIRParent;
var AnimTree OIRAnimTree;
var AnimSet OIRAnimSet;
var float OIRCollideWorldRadius;
//var delegate<OnActivityDone> __OnActivityDone__Delegate;
//var delegate<OnActivityFailed> __OnActivityFailed__Delegate;
//var delegate<OnActivityStarted> __OnActivityStarted__Delegate;

delegate OnActivityDone(name activity, name activityPose)
{
    //return;    
}

delegate OnActivityFailed(name activity, name activityPose)
{
    //return;    
}

delegate OnActivityStarted(name activity, name activityPose)
{
    //return;    
}

// Export UOirInstance::execGetActivityNode(FFrame&, void* const)
native function MOHAAnimBlendByActivity GetActivityNode();

// Export UOirInstance::execSetActivityNode(FFrame&, void* const)
native function SetActivityNode(MOHAAnimBlendByActivity Node);

// Export UOirInstance::execSetOIRManagerNode(FFrame&, void* const)
native function SetOIRManagerNode(MOHAAnimOIRManager Node);

// Export UOirInstance::execAddAvailableOIREntry(FFrame&, void* const)
native function AddAvailableOIREntry(int availableEntry);

// Export UOirInstance::execGetAvailableOIREntries(FFrame&, void* const)
native function int GetAvailableOIREntries();

// Export UOirInstance::execGetCurrentActivityName(FFrame&, void* const)
native function name GetCurrentActivityName();

// Export UOirInstance::execGetCurrentActivityPose(FFrame&, void* const)
native function name GetCurrentActivityPose();

// Export UOirInstance::execSetCurrentActivity(FFrame&, void* const)
native function SetCurrentActivity(name activity, name activityPose, float TransitionRateScale);

// Export UOirInstance::execGetObjFromInterface(FFrame&, void* const)
native function Object GetObjFromInterface(OIROwnerInterface oirOwner);

function PrintActivityNames()
{
    local array<name> names;
    local int I;

    // End:0x0D
    if(OIRAnimTree == none)
    {
        return;
    }
    names = GetActivityNames();
    I = 0;
    J0x24:

    // End:0x3E [Loop If]
    if(I < names.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x24;
    }
    //return;    
}

function array<name> GetActivityNames()
{
    local int I;
    local array<name> names;
    local MOHAAnimBlendByActivity Node;

    // End:0x11
    if(OIRAnimTree == none)
    {
        return names;
    }
    Node = GetActivityNode();
    // End:0x96
    if(Node != none)
    {
        names.Length = Node.Children.Length;
        I = 0;
        J0x49:

        // End:0x96 [Loop If]
        if(I < Node.Children.Length)
        {
            names[I] = Node.Children[I].Name;
            I++;
            // [Loop Continue]
            goto J0x49;
        }
    }
    return names;
    //return ReturnValue;    
}

function Update(OIRData od, OIROwnerInterface Owner)
{
    OIRAnimSet = od.OIRAnimSet;
    OIRAnimTree = od.OIRAnimTree;
    Location = od.OIRPosition;
    Rotation = od.OIRRotation;
    OIRCollideWorldRadius = od.OIRCollideWorldRadius;
    OIRParent = Owner;
    //return;    
}

function bool IsLocked()
{
    return LockedBy != none;
    //return ReturnValue;    
}

function Pawn GetLockedBy()
{
    return LockedBy;
    //return ReturnValue;    
}

function SetActivityDone(delegate<OnActivityDone> cb)
{
    __OnActivityDone__Delegate = cb;
    //return;    
}

event SetActivityFailed(delegate<OnActivityFailed> cb)
{
    __OnActivityFailed__Delegate = cb;
    //return;    
}

function SetActivityStarted(delegate<OnActivityStarted> cb)
{
    __OnActivityStarted__Delegate = cb;
    //return;    
}

function CurrentActivityStarted()
{
    OnActivityStarted(GetCurrentActivityName(), GetCurrentActivityPose());
    //return;    
}

event float GetArrivedAtRadius()
{
    // End:0x2C
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        return OIRParent.GetArrivedAtRadius();        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

event bool ShouldAttach()
{
    local OIRAttachmentPolicy oirAttach;

    // End:0x57
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        oirAttach = OIRAttachmentPolicy(GetObjFromInterface(OIRParent));
        // End:0x57
        if(NotEqual_InterfaceInterface(oirAttach, OIRAttachmentPolicy(none)))
        {
            return oirAttach.ShouldAttach();
        }
    }
    return true;
    //return ReturnValue;    
}

event bool ShouldCollideWorld()
{
    local OIRAttachmentPolicy oirAttach;

    // End:0x57
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        oirAttach = OIRAttachmentPolicy(GetObjFromInterface(OIRParent));
        // End:0x57
        if(NotEqual_InterfaceInterface(oirAttach, OIRAttachmentPolicy(none)))
        {
            return oirAttach.ShouldCollideWorld();
        }
    }
    return true;
    //return ReturnValue;    
}

event SkeletalMeshComponent.ERootMotionMode GetRootMotionMode()
{
    local OIRAttachmentPolicy oirAttach;

    // End:0x57
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        oirAttach = OIRAttachmentPolicy(GetObjFromInterface(OIRParent));
        // End:0x57
        if(NotEqual_InterfaceInterface(oirAttach, OIRAttachmentPolicy(none)))
        {
            return oirAttach.GetRootMotionMode();
        }
    }
    return 0;
    //return ReturnValue;    
}

event bool UseOIRPhysics()
{
    local OIRAttachmentPolicy oirAttach;

    // End:0x57
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        oirAttach = OIRAttachmentPolicy(GetObjFromInterface(OIRParent));
        // End:0x57
        if(NotEqual_InterfaceInterface(oirAttach, OIRAttachmentPolicy(none)))
        {
            return oirAttach.UseOIRPhysics();
        }
    }
    return true;
    //return ReturnValue;    
}

event GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    local OIRAttachmentPolicy oirAttach;

    // End:0x67
    if(NotEqual_InterfaceInterface(OIRParent, OIROwnerInterface(none)))
    {
        oirAttach = OIRAttachmentPolicy(GetObjFromInterface(OIRParent));
        // End:0x67
        if(NotEqual_InterfaceInterface(oirAttach, OIRAttachmentPolicy(none)))
        {
            oirAttach.GetAttachData(out_Actor, out_SkelMesh, out_AttachName);
        }
    }
    //return;    
}

defaultproperties
{
    m_TransitionRateScale=1.0000000
}