class SPCoverNode extends SPPathNode
    native;

struct native CoverFireLink
{
    var array<CoverLink.ECoverAction> CoverActions;
    var SPCoverNode TargetNode;

    structdefaultproperties
    {
        CoverActions=none
        TargetNode=none
    }
};

var float CrouchAlignDist;
/** If true, the node will automatically adjust and link up with other cover nodes */
var() const bool bAutoSetup;
/** Can a player lean to the left at this node */
var() const bool bLeanLeft;
/** Can a player lean to the right at this node */
var() const bool bLeanRight;
/** Is this node current enabled for use? */
var() bool bEnabled;
/** Is this cover node a circular link? */
var() bool bCircular;
/** Additional weighting to apply when AI is evaluation cover */
var() const byte AIRating;
var() CoverLink.ECoverType CoverType;
var const float AlignDist;
var const float EdgeAlignDist;
var const float CornerAlignDist;
var const float TransitionDist;
var const float StandHeight;
var const float MidHeight;
var const float CrouchHeight;
var const float StandAtLowCoverHeight;
var const float LeanDist;
var const Vector PopupDelta;
/** Linked node to the left of this node */
var() const SPCoverNode LeftNode;
/** Linked node to the right of this node */
var() const SPCoverNode RightNode;
/** Linked node that can be transitioned to from this node */
var() const SPCoverNode TransitionNode;
var Vector MaxAimRight;
var Vector MaxAimLeft;
var Vector MaxAimUp;
var Vector MaxAimDown;
var Vector SecondaryMaxAimRight;
var Vector SecondaryMaxAimLeft;
var Vector SecondaryMaxAimUp;
var Vector SecondaryMaxAimDown;
var Vector HorizontalBisector;
var Vector VerticalBisector;
var Vector SecondaryHorizontalBisector;
var Vector SecondaryVerticalBisector;
var float HorizontalAimLimitDotProduct;
var float VerticalAimLimitDotProduct;
var float SecondaryHorizontalAimLimitDotProduct;
var float SecondaryVerticalAimLimitDotProduct;
/** List of all attackable nodes */
var() const array<CoverFireLink> CoverFireLinks;
var Controller CoverClaim;
var MaterialInterface CoverRenderingMaterial;
var transient Vector CachedFacingDirection;
var transient Vector CachedRightDirection;
var transient int BlockedByObjectCount;

// Export USPCoverNode::execIsPointWithinPrimaryAimProfile(FFrame&, void* const)
native function bool IsPointWithinPrimaryAimProfile(Vector testPoint);

// Export USPCoverNode::execIsPointWithinSecondaryAimProfile(FFrame&, void* const)
native function bool IsPointWithinSecondaryAimProfile(Vector testPoint);

// Export USPCoverNode::execGetViewPointFromCoverType(FFrame&, void* const)
native function Vector GetViewPointFromCoverType(CoverLink.ECoverType chkCoverType);

// Export USPCoverNode::execGetViewPointOffset(FFrame&, void* const)
native function Vector GetViewPointOffset();

// Export USPCoverNode::execGetViewPointOffsetFromCoverType(FFrame&, void* const)
native function Vector GetViewPointOffsetFromCoverType(CoverLink.ECoverType chkCoverType);

// Export USPCoverNode::execGetPeekViewPoint(FFrame&, void* const)
native function Vector GetPeekViewPoint(optional Controller forController);

// Export USPCoverNode::execGetPeekViewPointFromCoverType(FFrame&, void* const)
native function Vector GetPeekViewPointFromCoverType(CoverLink.ECoverType chkCoverType, CoverLink.ECoverAction coverAction);

// Export USPCoverNode::execGetPeekViewPointOffsetFromCoverType(FFrame&, void* const)
native function Vector GetPeekViewPointOffsetFromCoverType(CoverLink.ECoverType chkCoverType, CoverLink.ECoverAction coverAction);

// Export USPCoverNode::execTestCanFireFromCover(FFrame&, void* const)
native function bool TestCanFireFromCover(CoverLink.ECoverType chkCoverType, CoverLink.ECoverAction coverAction);

// Export USPCoverNode::execIsAvailableTo(FFrame&, void* const)
native simulated function bool IsAvailableTo(Actor chkActor);

final function bool IsClaimed()
{
    return ((CoverClaim != none) && CoverClaim.Pawn != none) && CoverClaim.Pawn.Health > 0;
    //return ReturnValue;    
}

final event bool Claim(Controller NewClaim)
{
    local SPSoldierAIController soldier;

    // End:0x8F
    if((NewClaim != CoverClaim) && NewClaim != none)
    {
        soldier = SPSoldierAIController(CoverClaim);
        // End:0x4C
        if(soldier != none)
        {
            soldier.NotifyCoverClaimRevoked(self);
        }
        // End:0x8F
        if((NewClaim.Pawn != none) && NewClaim.Pawn.Health > 0)
        {
            CoverClaim = NewClaim;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

final event UnClaim(Controller OldClaim, optional bool bNotify)
{
    local SPSoldierAIController soldier;

    // End:0x5F
    if((OldClaim == CoverClaim) && CoverClaim != none)
    {
        soldier = SPSoldierAIController(CoverClaim);
        // End:0x58
        if((soldier != none) && bNotify)
        {
            soldier.NotifyCoverClaimRevoked(self);
        }
        CoverClaim = none;
    }
    //return;    
}

// Export USPCoverNode::execIsClaimedBy(FFrame&, void* const)
native final function bool IsClaimedBy(Controller ChkClaim);

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2B
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x56
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0x86
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    // End:0xAA
    if(!bEnabled && CoverClaim != none)
    {
        UnClaim(CoverClaim);
    }
    //return;    
}

// Export USPCoverNode::execIsLinkedTo(FFrame&, void* const)
native final function bool IsLinkedTo(SPCoverNode ChkCover);

// Export USPCoverNode::execGetViewPoint(FFrame&, void* const)
native final function Vector GetViewPoint();

final function bool GetFireLinkTo(SPCoverNode ChkCover, out array<CoverLink.ECoverAction> Actions)
{
    local int Idx;

    // End:0x54
    if(ChkCover != none)
    {
        Idx = CoverFireLinks.Find('TargetNode', ChkCover);
        // End:0x54
        if(Idx != -1)
        {
            Actions = CoverFireLinks[Idx].CoverActions;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

// Export USPCoverNode::execHasFireLinkTo(FFrame&, void* const)
native final function bool HasFireLinkTo(SPCoverNode ChkCover);
