class MOHALadderCSA extends MOHACSA
    hidecategories(Navigation);

var() MOHAMPLadder Ladder;
var() float LookAtLadderAngle;
var() bool bTop;
var const localized string MPLadderMessage;

simulated function LoadLocalizedStrings()
{
    csaText = MPLadderMessage;
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    LoadLocalizedStrings();
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local MOHAMultiplayerPawn PlayerPawn;
    local MOHAMultiplayerController LocalPlayer;

    CheckReMount();
    PlayerPawn = MOHAMultiplayerPawn(Other);
    // End:0xBE
    if(((((PlayerPawn != none) && int(PlayerPawn.Role) == int(ROLE_Authority)) && PlayerPawn.OnLadderMP == none) && IsLookingAtLadder(PlayerPawn)) && PlayerPawn.CanGrabLadder())
    {
        LocalPlayer = MOHAMultiplayerController(PlayerPawn.Controller);
        // End:0xBE
        if(LocalPlayer != none)
        {
            LocalPlayer.ServerClimbLadder(Ladder);
        }
    }
    bRecentlyTriggered = false;
    //return;    
}

function CheckTouching()
{
    local MOHAPlayerPawn P;

    // End:0x33
    foreach TouchingActors(Class'MOHAPlayerPawn', P)
    {
        Touch(P, none, Location, vect(0.0000000, 0.0000000, 1.0000000));        
    }    
    //return;    
}

function CheckReMount()
{
    SetTimer(0.2000000, false, 'CheckTouching');
    //return;    
}

simulated event bool IsLookingAtLadder(MOHAMultiplayerPawn P)
{
    local float dotProduct;
    local Vector PlayerRot, LadderDir;
    local bool bLooking, bWalking;

    PlayerRot = Vector(P.Rotation);
    PlayerRot.Z = 0.0000000;
    LadderDir = Ladder.Location - P.Location;
    LadderDir += ((bTop) ? Normal(Vector(Ladder.Rotation)) * float(-200) : Normal(Vector(Ladder.Rotation)) * float(200));
    LadderDir.Z = 0.0000000;
    dotProduct = Normal(LadderDir) Dot Normal(PlayerRot);
    bLooking = dotProduct > LookAtLadderAngle;
    // End:0xF5
    if(!bLooking || IsZero(P.Acceleration))
    {
        return false;
    }
    // End:0x15C
    if(!bTop && (P.Controller.Rotation.Pitch < 4000) || P.Controller.Rotation.Pitch > 16384)
    {
        return false;
    }
    // End:0x1C1
    if(bTop && (P.Controller.Rotation.Pitch > 56385) || P.Controller.Rotation.Pitch < 49152)
    {
        return false;
    }
    PlayerRot = P.Acceleration;
    PlayerRot.Z = 0.0000000;
    dotProduct = Normal(LadderDir) Dot Normal(PlayerRot);
    bWalking = dotProduct > LookAtLadderAngle;
    return bLooking && bWalking;
    //return ReturnValue;    
}

defaultproperties
{
    LookAtLadderAngle=0.9000000
    MPLadderMessage="Press %b to Use Ladder"
    bLookAt=false
    bOneShot=false
    fWeightScale=1.0000000
    // Reference: CylinderComponent'Default__MOHALadderCSA.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=30.0000000
        CollisionRadius=25.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHALadderCSA.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}