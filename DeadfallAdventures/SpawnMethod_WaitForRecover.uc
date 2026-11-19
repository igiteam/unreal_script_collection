class SpawnMethod_WaitForRecover extends SpawnMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EvilTypes.ELayFirstFrameAnimation AnimationID;
var() bool bWaitForKismetImpulse;
var() bool bEnableMotionDelta;
var() bool bEnableTakeDamage;
var() float SightSenseLength;
var() float HearSenseLength;

function PostCreateActor(Actor NewActor)
{
    local EvilPawn P;

    P = EvilPawn(NewActor);
    // End:0x1CF
    if(P != none)
    {
        // End:0x1CF
        if((P.PawnActionClasses.Length >= 14) && P.PawnActionClasses[14] != none)
        {
            P.SetShowOnRadar(bShowOnRadar);
            P.ServerDoPawnAction(14, true,, Class'EPA_Emerge'.static.EncodeEmergeInfo(P.GetLayAnimation(AnimationID), ((bWaitForKismetImpulse) ? 1 : 2), 2, AnimationID));
            P.WakeInformation.bEnabledMotionDelta = bEnableMotionDelta;
            EPA_Emerge(P.PawnActions[14]).DoEmerge(SightSenseLength, HearSenseLength, bEnableMotionDelta, bEnableTakeDamage);
        }
    }
    //return;    
}

defaultproperties
{
    SightSenseLength=1000.0000000
    HearSenseLength=1000.0000000
}