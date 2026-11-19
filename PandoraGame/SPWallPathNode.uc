class SPWallPathNode extends SPPathNode
    native;

var() bool bUseManualNormalSetup;
var Vector WallNormal;
var float wallDistance;

event bool SuggestMovePreparation(Pawn Pawn)
{
    // End:0x32
    if(Pawn.IsA('SPPawn'))
    {
        SPPawn(Pawn).PrepareForNavPoint(self);
    }
    return true;
    //return ReturnValue;    
}

event int SpecialCost(Pawn Seeker, ReachSpec Path)
{
    // End:0x37
    if(Seeker.IsA('SPPawn'))
    {
        return SPPawn(Seeker).SpecialCost(Path);
    }
    return 0;
    //return ReturnValue;    
}
