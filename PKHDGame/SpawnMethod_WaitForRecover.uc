class SpawnMethod_WaitForRecover extends SpawnMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EvilTypes.ELayFirstFrameAnimation AnimationID;
var() bool bWaitForKismetImpulse;
var() bool bEnableMotionDelta;
var() bool bEnableTakeDamage;
var() float SenseLength;

function PostCreateActor(Actor NewActor)
{
    local EvilPawn P;

    P = EvilPawn(NewActor);
    // End:0x1C6
    if(P != none)
    {
        // End:0x1C6
        if((P.PawnActionClasses.Length >= 14) && P.PawnActionClasses[14] != none)
        {
            P.SetShowOnRadar(bShowOnRadar);
            P.ServerDoPawnAction(14, true,, Class'EPA_Emerge'.static.EncodeEmergeInfo(P.GetLayAnimation(AnimationID), ((bWaitForKismetImpulse) ? 1 : 2), 2, AnimationID));
            P.WakeInformation.bEnabledMotionDelta = bEnableMotionDelta;
            EPA_Emerge(P.PawnActions[14]).DoEmerge(SenseLength, bEnableMotionDelta, bEnableTakeDamage);
        }
    }
    //return;    
}

defaultproperties
{
    SenseLength=1000.0000000
}