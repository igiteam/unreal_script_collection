class SpawnMethod_PlayAnimation extends SpawnMethod
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() EvilTypes.ESpawnAnimation AnimationID;
var() bool bEnableMotionDelta;

function PostCreateActor(Actor NewActor)
{
    local EvilPawn P;

    P = EvilPawn(NewActor);
    // End:0x160
    if(P != none)
    {
        // End:0x160
        if((P.PawnActionClasses.Length >= 14) && P.PawnActionClasses[14] != none)
        {
            P.SetShowOnRadar(bShowOnRadar);
            P.ServerDoPawnAction(14, true,, Class'EPA_Emerge'.static.EncodeEmergeInfo(P.GetSpawnAnimation(AnimationID), 0, 1, 0));
            EPA_Emerge(P.PawnActions[14]).DoEmerge(,, bEnableMotionDelta);
        }
    }
    //return;    
}
