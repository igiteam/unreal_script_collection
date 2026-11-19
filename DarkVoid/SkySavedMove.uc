class SkySavedMove extends SavedMove;

var CoverLink Link;
var CoverLink.ECoverType CoverType;
var CoverLink.ECoverAction CoverAction;
var CoverLink.ECoverDirection CoverDirection;
var CoverLink.ECoverDirection CurrentSlotDirection;
var bool bWantsToBeMirrored;
var bool bIsInStationaryCover;

function Clear()
{
    super.Clear();
    Link = none;
    CoverType = 0;
    CoverAction = 0;
    CoverDirection = 0;
    bWantsToBeMirrored = false;
    CurrentSlotDirection = 0;
    bIsInStationaryCover = false;
    //return;    
}

function SetMoveFor(PlayerController P, float DeltaTime, Vector newAccel, Actor.EDoubleClickDir InDoubleClick)
{
    local SkyPawnCoverUser WP;

    super.SetMoveFor(P, DeltaTime, newAccel, InDoubleClick);
    WP = SkyPawnCoverUser(P.Pawn);
    // End:0x7F
    if(WP != none)
    {
        Link = WP.CurrentLink;
        CoverType = WP.GetCoverType();
        CoverAction = WP.CoverAction;
    }
    //return;    
}

function bool CanCombineWith(SavedMove NewMove, Pawn inPawn, float MaxDelta)
{
    local SkySavedMove NewSkyMove;

    NewSkyMove = SkySavedMove(NewMove);
    return ((((int(CoverType) == int(0)) && Link == NewSkyMove.Link) && int(CoverType) == int(NewSkyMove.CoverType)) && int(CoverAction) == int(NewSkyMove.CoverAction)) && super.CanCombineWith(NewMove, inPawn, MaxDelta);
    //return ReturnValue;    
}
