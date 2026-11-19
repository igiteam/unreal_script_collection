class MOHALadderVolume extends LadderVolume
    native
    hidecategories(Navigation,Object,Movement,Display);

var() PhysicalMaterial PhysMaterial;
var() float fRecheckTime;
var Pawn PawnInVolume;

simulated event PawnEnteredVolume(Pawn P)
{
    // End:0x7B
    if(P.IsA('MOHAPlayerPawn'))
    {
        super.PawnEnteredVolume(P);
        // End:0x64
        if(!P.CanGrabLadder())
        {
            PawnInVolume = P;
            PawnInVolume.SetTimer(fRecheckTime, true, 'CheckIfPawnCanGrabLadder', self);
            return;
        }
        P.ClimbLadder(self);        
    }
    else
    {
        super.PawnEnteredVolume(P);
    }
    //return;    
}

simulated function CheckIfPawnCanGrabLadder()
{
    // End:0x57
    if((PawnInVolume != none) && PawnInVolume.CanGrabLadder())
    {
        PawnInVolume.ClearTimer('CheckIfPawnCanGrabLadder');
        PawnInVolume.ClimbLadder(self);
        PawnInVolume = none;
    }
    //return;    
}

simulated event PawnLeavingVolume(Pawn P)
{
    // End:0x2B
    if(PawnInVolume != none)
    {
        PawnInVolume.ClearTimer('CheckIfPawnCanGrabLadder');
        PawnInVolume = none;
    }
    // End:0x46
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    super.PawnLeavingVolume(P);
    //return;    
}

defaultproperties
{
    PhysMaterial=PhysicalMaterial'GCm_PhysMaterials.Metal_Rung_Ladder'
    fRecheckTime=0.2000000
    bAllowLadderStrafing=false
    // Reference: BrushComponent'Default__MOHALadderVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    // Reference: ArrowComponent'Default__MOHALadderVolume.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    RemoteRole=0
    CollisionComponent=BrushComponent0
}