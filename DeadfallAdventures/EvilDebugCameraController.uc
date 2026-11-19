class EvilDebugCameraController extends DebugCameraController
    config(Input)
    hidecategories(Navigation);

simulated event PostBeginPlay()
{
    super(PlayerController).PostBeginPlay();
    // End:0x31
    if(myHUD != none)
    {
        myHUD.Destroy();
    }
    myHUD = Spawn(Class'EvilDebugCameraHUD', self);
    //return;    
}

exec function AILogOn()
{
    local GameAIController GAIC;
    local Pawn P;

    P = Pawn(SelectedActor);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    GAIC = GameAIController(P.Controller);
    // End:0x6F
    if(GAIC == none)
    {
        return;
    }
    GAIC.bAILogging = true;
    GAIC.bAILogToWindow = true;
    //return;    
}

exec function AILogOff()
{
    local GameAIController GAIC;
    local Pawn P;

    P = Pawn(SelectedActor);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    GAIC = GameAIController(P.Controller);
    // End:0x6F
    if(GAIC == none)
    {
        return;
    }
    GAIC.bAILogging = false;
    GAIC.bAILogToWindow = false;
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__EvilDebugCameraController.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}