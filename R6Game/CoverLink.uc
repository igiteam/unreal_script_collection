class CoverLink extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

enum ECoverAction
{
    CA_Default,                     // 0
    CA_BlindLeft,                   // 1
    CA_BlindRight,                  // 2
    CA_LeanLeft,                    // 3
    CA_LeanRight,                   // 4
    CA_StepLeft,                    // 5
    CA_StepRight,                   // 6
    CA_PopUp,                       // 7
    CA_BlindUp,                     // 8
    CA_PeekLeft,                    // 9
    CA_PeekRight,                   // 10
    CA_PeekUp,                      // 11
    CA_MAX                          // 12
};

enum ECoverDirection
{
    CD_Default,                     // 0
    CD_Left,                        // 1
    CD_Right,                       // 2
    CD_Up,                          // 3
    CD_MAX                          // 4
};

enum ECoverType
{
    CT_None,                        // 0
    CT_Standing,                    // 1
    CT_MidLevel,                    // 2
    CT_MAX                          // 3
};

struct CoverInfo
{
    var CoverLink Link;
    var int SlotIdx;

    structdefaultproperties
    {
        Link=none
        SlotIdx=0
    }
};

struct FireLink
{
    var array<CoverLink.ECoverAction> CoverActions;
    var const CoverLink TargetLink;
    var const Guid TargetLinkGuid;
    var int TargetSlotIdx;
    var float TargetVisibility;
    var bool bFallbackLink;

    structdefaultproperties
    {
        CoverActions=none
        TargetLink=none
        TargetLinkGuid=(A=94,B=4,C=4,D=0)
        TargetSlotIdx=0
        TargetVisibility=0.0000000
        bFallbackLink=false
    }
};

struct InfluenceLink
{
    var const NavigationPoint NavPoint;
    var const Guid NavPointGuid;
    var array<int> InfluenceMap;

    structdefaultproperties
    {
        NavPoint=none
        NavPointGuid=(A=94,B=4,C=4,D=0)
        InfluenceMap=none
    }
};

struct CoverSlot
{
    var Controller SlotOwner;
    var() CoverLink.ECoverType CoverType;
    var() Vector LocationOffset;
    var() Rotator RotationOffset;
    var() const editinline array<editinline FireLink> FireLinks;
    var() const editinline array<editinline FireLink> ForcedFireLinks;
    var() const editinline array<editinline InfluenceLink> InfluenceLinks;
    var const array<NavigationPoint> ShortCutPaths;
    var CoverInfo MantleTarget;
    var() CoverInfo SwatTurnTarget;
    var() bool bLeanLeft;
    var() bool bLeanRight;
    var() editconst bool bCanMantle;
    var() bool bEnabled;
    var() bool bAllowPopup;
    var() editconst transient bool bSelected;
    var() float LeanTraceDist;

    structdefaultproperties
    {
        SlotOwner=none
        CoverType=0
        LocationOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RotationOffset=(Pitch=0,Yaw=0,Roll=0)
        FireLinks=none
        ForcedFireLinks=none
        InfluenceLinks=none
        ShortCutPaths=none
        MantleTarget=(Link=none,SlotIdx=0)
        SwatTurnTarget=(Link=none,SlotIdx=0)
        bLeanLeft=false
        bLeanRight=false
        bCanMantle=true
        bEnabled=true
        bAllowPopup=true
        bSelected=false
        LeanTraceDist=64.0000000
    }
};

var() editinline array<editinline CoverSlot> Slots;
var array<Controller> Claims;
var() bool bClaimAllSlots;
var() bool bAutoSort;
var() bool bAutoAdjust;
var() bool bCircular;
var() bool bPlayerOnly;
var() float MaxFireLinkDist;
var const Vector CircularOrigin;
var const float CircularRadius;
var const float AlignDist;
var const float StandHeight;
var const float MidHeight;
var const float LeanDist;
var const float PopupDist;
var const transient CoverLink NextCoverLink;
var() float AdhesionScale;

// Export UCoverLink::execGetSlotLocation(FFrame&, void* const)
native final simulated function Vector GetSlotLocation(int SlotIdx);

// Export UCoverLink::execGetSlotRotation(FFrame&, void* const)
native final simulated function Rotator GetSlotRotation(int SlotIdx);

// Export UCoverLink::execGetSlotViewPoint(FFrame&, void* const)
native final simulated function Vector GetSlotViewPoint(int SlotIdx);

// Export UCoverLink::execSpreadInfluence(FFrame&, void* const)
native function SpreadInfluence(int SlotIdx);

// Export UCoverLink::execRemoveInfluence(FFrame&, void* const)
native function RemoveInfluence(int SlotIdx);

final function bool Claim(Controller NewClaim, int SlotIdx, bool bSpreadInfluence)
{
    local int idx;
    local bool bResult;

    logd((((((string(self) @ "Claim Slot") @ string(SlotIdx)) @ "For") @ string(NewClaim)) @ "(All?)") @ string(bClaimAllSlots));
    // End:0x6B
    if(Slots[SlotIdx].SlotOwner == NewClaim)
    {
        bResult = true;        
    }
    else
    {
        // End:0x8C
        if(Slots[SlotIdx].SlotOwner != none)
        {
            bResult = false;            
        }
        else
        {
            idx = Claims.Find(NewClaim);
            // End:0xBE
            if(idx == -1)
            {
                Claims[Claims.Length] = NewClaim;
            }
            // End:0x101
            if(bClaimAllSlots)
            {
                idx = 0;
                J0xCE:

                // End:0xFE [Loop If]
                if(idx < Slots.Length)
                {
                    Slots[idx].SlotOwner = NewClaim;
                    idx++;
                    // [Loop Continue]
                    goto J0xCE;
                }                
            }
            else
            {
                Slots[SlotIdx].SlotOwner = NewClaim;
            }
        }
    }
    // End:0x12C
    if(bSpreadInfluence)
    {
        SpreadInfluence(SlotIdx);
    }
    return bResult;
    return;
}

final function UnClaim(Controller OldClaim, int SlotIdx, bool bRemoveInfluence)
{
    local int idx;

    logd((((string(self) @ "UnClaim - all slots") @ string(OldClaim)) @ string(SlotIdx)) @ string(bRemoveInfluence));
    idx = Claims.Find(OldClaim);
    // End:0x6A
    if(idx != -1)
    {
        Claims.Remove(idx, 1);
    }
    // End:0x7F
    if(bRemoveInfluence)
    {
        RemoveInfluence(SlotIdx);
    }
    idx = 0;
    J0x86:

    // End:0xCC [Loop If]
    if(idx < Slots.Length)
    {
        // End:0xC2
        if(Slots[idx].SlotOwner == OldClaim)
        {
            Slots[idx].SlotOwner = none;
        }
        idx++;
        // [Loop Continue]
        goto J0x86;
    }
    return;
}

final function UnClaimSlot(int SlotIdx)
{
    logd(((string(self) @ "UnClaimSlot") @ string(SlotIdx)) @ string(Slots[SlotIdx].SlotOwner));
    Slots[SlotIdx].SlotOwner = none;
    return;
}

// Export UCoverLink::execIsValidClaim(FFrame&, void* const)
native final function bool IsValidClaim(Controller ChkClaim, int SlotIdx, optional bool bAcceptNone);

final simulated function bool IsStationarySlot(int SlotIdx)
{
    return true;
    return;
}

// Export UCoverLink::execFindSlots(FFrame&, void* const)
native final simulated function bool FindSlots(Vector CheckLocation, float MaxDistance, out int LeftSlotIdx, out int RightSlotIdx);

// Export UCoverLink::execIsEdgeSlot(FFrame&, void* const)
native final simulated function bool IsEdgeSlot(int SlotIdx);

// Export UCoverLink::execIsLeftEdgeSlot(FFrame&, void* const)
native final simulated function bool IsLeftEdgeSlot(int SlotIdx, bool bIgnoreLeans);

// Export UCoverLink::execIsRightEdgeSlot(FFrame&, void* const)
native final simulated function bool IsRightEdgeSlot(int SlotIdx, bool bIgnoreLeans);

final simulated function bool AllowRightTransition(int SlotIdx)
{
    return (SlotIdx < (Slots.Length - 1)) && Slots[SlotIdx + 1].bEnabled;
    return;
}

final simulated function bool AllowLeftTransition(int SlotIdx)
{
    return (SlotIdx > 0) && Slots[SlotIdx - 1].bEnabled;
    return;
}

// Export UCoverLink::execGetFireLinkTo(FFrame&, void* const)
native final function bool GetFireLinkTo(int SlotIdx, CoverInfo ChkCover, out array<CoverLink.ECoverAction> Actions);

// Export UCoverLink::execHasFireLinkTo(FFrame&, void* const)
native final function bool HasFireLinkTo(int SlotIdx, CoverInfo ChkCover, optional out int out_FireLinkIdx);

final function GetSlotActions(int SlotIdx, out array<CoverLink.ECoverAction> Actions)
{
    local CoverSlot Slot;

    Slot = Slots[SlotIdx];
    // End:0x2E
    if(Slot.bLeanRight)
    {
        Actions[Actions.Length] = 10;
    }
    // End:0x4B
    if(Slot.bLeanLeft)
    {
        Actions[Actions.Length] = 9;
    }
    // End:0x6F
    if(int(Slot.CoverType) == int(2))
    {
        Actions[Actions.Length] = 11;
    }
    return;
}

function OnModifyCover(SeqAct_ModifyCover Action)
{
    local array<int> SlotIndices;
    local int idx, SlotIdx;

    // End:0x2C
    if(Action.Slots.Length > 0)
    {
        SlotIndices = Action.Slots;        
    }
    else
    {
        idx = 0;
        J0x33:

        // End:0x5F [Loop If]
        if(idx < Slots.Length)
        {
            SlotIndices[SlotIndices.Length] = idx;
            idx++;
            // [Loop Continue]
            goto J0x33;
        }
    }
    idx = 0;
    J0x66:

    // End:0x20C [Loop If]
    if(idx < SlotIndices.Length)
    {
        SlotIdx = SlotIndices[idx];
        // End:0x202
        if((SlotIdx >= 0) && SlotIdx < Slots.Length)
        {
            // End:0xD3
            if(Action.InputLinks[0].bHasImpulse)
            {
                Slots[SlotIdx].bEnabled = true;
                // [Explicit Continue]
                goto J0x202;
            }
            // End:0x139
            if(Action.InputLinks[1].bHasImpulse)
            {
                Slots[SlotIdx].bEnabled = false;
                // End:0x136
                if(Slots[SlotIdx].SlotOwner != none)
                {
                    Slots[SlotIdx].SlotOwner.NotifyCoverDisabled(self, SlotIdx);
                }
                // [Explicit Continue]
                goto J0x202;
            }
            // End:0x198
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x195
                if(AutoAdjustSlot(SlotIdx, false) && Slots[SlotIdx].SlotOwner != none)
                {
                    Slots[SlotIdx].SlotOwner.NotifyCoverAdjusted();
                }
                // [Explicit Continue]
                goto J0x202;
            }
            // End:0x202
            if(Action.InputLinks[3].bHasImpulse)
            {
                Slots[SlotIdx].CoverType = Action.ManualCoverType;
                // End:0x202
                if(Slots[SlotIdx].SlotOwner != none)
                {
                    Slots[SlotIdx].SlotOwner.NotifyCoverAdjusted();
                }
            }
        }
        J0x202:

        idx++;
        // [Loop Continue]
        goto J0x66;
    }
    return;
}

// Export UCoverLink::execAutoAdjustSlot(FFrame&, void* const)
native final function bool AutoAdjustSlot(int SlotIdx, bool bOnlyCheckLeans);

final simulated function bool IsEnabled()
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(idx < Slots.Length)
    {
        // End:0x2D
        if(Slots[idx].bEnabled)
        {
            return true;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function int SpecialCost(Pawn Seeker, ReachSpec Path)
{
    return Seeker.SpecialCostForPath(Path);
    return;
}

function bool HasMantlePartner(CoverLink Link)
{
    local int SlotIdx;

    // End:0x4D
    if(Link != none)
    {
        SlotIdx = 0;
        J0x12:

        // End:0x4D [Loop If]
        if(SlotIdx < Slots.Length)
        {
            // End:0x43
            if(Slots[SlotIdx].MantleTarget.Link == Link)
            {
                return true;
            }
            SlotIdx++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    return false;
    return;
}

function bool HasSwatTurnPartner(CoverLink Link)
{
    local int SlotIdx;

    // End:0x4D
    if(Link != none)
    {
        SlotIdx = 0;
        J0x12:

        // End:0x4D [Loop If]
        if(SlotIdx < Slots.Length)
        {
            // End:0x43
            if(Slots[SlotIdx].SwatTurnTarget.Link == Link)
            {
                return true;
            }
            SlotIdx++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    return false;
    return;
}

function bool GetMantleTarget(int SlotIdx, out CoverInfo out_Info)
{
    out_Info = Slots[SlotIdx].MantleTarget;
    return out_Info.Link != none;
    return;
}

function bool GetSwatTurnTarget(int SlotIdx, out CoverInfo out_Info)
{
    out_Info = Slots[SlotIdx].SwatTurnTarget;
    return out_Info.Link != none;
    return;
}

function bool HasShortCutPath(int SlotIdx, NavigationPoint nav)
{
    local int idx;
    local CoverSlot Slot;

    Slot = Slots[SlotIdx];
    idx = 0;
    J0x18:

    // End:0x53 [Loop If]
    if(idx < Slot.ShortCutPaths.Length)
    {
        // End:0x49
        if(Slot.ShortCutPaths[idx] == nav)
        {
            return true;
        }
        idx++;
        // [Loop Continue]
        goto J0x18;
    }
    return false;
    return;
}

defaultproperties
{
    Slots[0]=(SlotOwner=none,CoverType=0,LocationOffset=(X=64.0000000,Y=0.0000000,Z=0.0000000),RotationOffset=(Pitch=0,Yaw=0,Roll=0),FireLinks=none,ForcedFireLinks=none,InfluenceLinks=none,ShortCutPaths=none,MantleTarget=(Link=none,SlotIdx=0),SwatTurnTarget=(Link=none,SlotIdx=0),bLeanLeft=false,bLeanRight=false,bCanMantle=true,bEnabled=true,bAllowPopup=true,bSelected=false,LeanTraceDist=64.0000000)
    bAutoSort=true
    bAutoAdjust=true
    MaxFireLinkDist=2048.0000000
    AlignDist=34.0000000
    StandHeight=150.0000000
    MidHeight=90.0000000
    LeanDist=64.0000000
    PopupDist=32.0000000
    AdhesionScale=1.0000000
    bSpecialForced=true
    // Reference: CylinderComponent'Default__CoverLink.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=58.0000000
        CollisionRadius=48.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__CoverLink.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.CoverNodeNone'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__CoverLink.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
    end object
    Components[2]=ArrowComponent0
    // Reference: CoverRenderingComponent'Default__CoverLink.CoverRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CoverRenderer" class=Class'CoverRenderingComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[3]=CoverRenderer
    CollisionComponent=CollisionCylinder
}