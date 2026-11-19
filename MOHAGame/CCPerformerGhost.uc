class CCPerformerGhost extends CCPerformer
    hidecategories(Object,Object,Object);

var(Ghost) float MinRadius;
var(Ghost) float MaxRadius;
var(Ghost) float SectorAngleDeg;
var private float OffsetFront;
var private float OffsetRight;
var int GhostIndex;

function SkeletalMeshComponent Owner_GetSkeletalMeshComponent()
{
    return MOHAPlayerPawn(Owner).Mesh;
    //return ReturnValue;    
}

function Vector Owner_GetLocation()
{
    local Vector Front, Right, Up, GhostLocation;

    GetAxes(Owner.Rotation, Front, Right, Up);
    GhostLocation = (Owner.Location + (Normal(Front) * OffsetFront)) + (Normal(Right) * OffsetRight);
    return GhostLocation;
    //return ReturnValue;    
}

function PostBeginPlay(int TeamIndex)
{
    local float Radius, AngleDeg, AngleRad;

    super.PostBeginPlay(TeamIndex);
    Radius = MinRadius + (FRand() * (MaxRadius - MinRadius));
    AngleDeg = (SectorAngleDeg * FRand()) - (SectorAngleDeg * 0.5000000);
    AngleRad = (AngleDeg * 3.1415930) / 180.0000000;
    OffsetFront = 0.0000000;
    OffsetRight = Radius * Sin(AngleRad);
    //return;    
}

event AudioComponent Owner_GetFaceFXAudioComponent()
{
    local MOHASingleplayerPawn SPP;

    SPP = MOHASingleplayerPawn(Owner);
    // End:0x41
    if((GhostIndex >= 0) && none != SPP)
    {
        return SPP.GetGhostAudioComponent(GhostIndex);
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    MinRadius=20.0000000
    MaxRadius=100.0000000
    SectorAngleDeg=120.0000000
    GhostIndex=-1
    bNoPA=true
    bNoExpression=true
    // Reference: CCHistory'Default__CCPerformerGhost.StimHist'
    begin object name=StimHist
    end object
    StimulusHistory=StimHist
    // Reference: CCPerformanceState'Default__CCPerformerGhost.PerfState'
    begin object name=PerfState
    end object
    PerformanceState=PerfState
    // Reference: CCHistoryEventStimulus'Default__CCPerformerGhost.HistEvent'
    begin object name=HistEvent
    end object
    TestStimulusHistoryEvent=HistEvent
}