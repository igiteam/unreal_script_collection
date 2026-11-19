class AdvChessMovableBlock extends Pawn
    config(Game)
    hidecategories(Navigation)
    classgroup(Adventurer);

var private Pawn User;
var private AdvPlayerController UserController;
var() private bool bUsed;
var() private CameraActor RoomCamera;
var() private export editinline StaticMeshComponent BlockMesh;

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    // End:0x5F
    if(RoomCamera != none)
    {
        out_CamLoc = RoomCamera.Location;
        out_CamRot = RoomCamera.Rotation;
    }
    return true;
    //return ReturnValue;    
}

function bool TryToControl(Pawn P)
{
    // End:0x4E
    if(bUsed)
    {
        AdvPlayerController(P.Controller).bDeactivateBlock = true;
        return false;
    }
    return PlayerUse(P);
    //return ReturnValue;    
}

function bool PlayerUse(Pawn P)
{
    local Controller C;

    C = P.Controller;
    User = P;
    // End:0xEA
    if(AdvPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        AdvPlayerController(C).GotoState('BlockControlling');
        UserController = AdvPlayerController(C);
        bUsed = true;        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool DetachUser()
{
    User = none;
    bUsed = false;
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvChessMovableBlock.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'adv_en_TestLevels.Meshes.sm_en_Block_Big_01'
        ReplacementPrimitive=none
        Scale3D=(X=0.5000000,Y=0.5000000,Z=0.5000000)
    end object
    BlockMesh=Mesh
    MaxStepHeight=10.0000000
    GroundSpeed=80.0000000
    // Reference: CylinderComponent'Default__AdvChessMovableBlock.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=CollisionCylinder
    Components[2]=none
    Components[3]=Mesh
    CollisionComponent=Mesh
}