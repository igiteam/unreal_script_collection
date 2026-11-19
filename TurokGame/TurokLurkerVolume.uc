class TurokLurkerVolume extends PhysicsVolume
    native
    hidecategories(Navigation,Object,Movement,Display,Advanced,Brush,Collision,PhysicsVolume);

var bool mbInitialized;
var int mnEnemyInVolume;

simulated function PostBeginPlay()
{
    mbInitialized = true;
    super.PostBeginPlay();
    //return;    
}

simulated event PawnEnteredVolume(@NULL P)
{
    local @NULL LurkerController, TP;

    TP = TurokPawn(P);
    // End:0x25
    if(!mbInitialized)
    {
        PostBeginPlay();
    }
    super.PawnEnteredVolume(P);
    // End:0x87
    if(TP != none)
    {
        mnEnemyInVolume++;
        // End:0x86
        foreach WorldInfo.AllControllers(Class'TurokAIControllerLurker', LurkerController)
        {
            LurkerController.PawnEnteredSurfaceVolume(TurokLurkerSurface(self.Owner), P);            
        }        
    }
    //return;    
}

simulated event PawnLeavingVolume(@NULL P)
{
    local @NULL TP;

    TP = TurokPawn(P);
    super.PawnLeavingVolume(P);
    // End:0x2D
    if(TP != none)
    {
        mnEnemyInVolume--;
    }
    //return;    
}

defaultproperties
{
    // Reference: BrushComponent'Default__TurokLurkerVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}