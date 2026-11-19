class UTJumpLiftExit extends LiftExit
    hidecategories(Navigation,Lighting,LightColor,Force);

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    // End:0x72
    if((MyLiftCenter != none) && WorldInfo.Game.GameDifficulty < float(4))
    {
        ExtraCost = 10000000;
        bBlocked = true;
    }
    //return;    
}

function WaitForLift(Pawn Other)
{
    super.WaitForLift(Other);
    // End:0x7E
    if((MyLiftCenter != none) && MyLiftCenter.MyLift != none)
    {
        MyLiftCenter.MyLift.bMonitorZVelocity = true;
    }
    //return;    
}

function bool CanBeReachedFromLiftBy(Pawn Other)
{
    local float RealJumpZ;
    local Vector NewVelocity;

    // End:0x366
    if((Other.Base == MyLiftCenter.MyLift) && MyLiftCenter.MyLift.MaxZVelocity > 0.0000000)
    {
        RealJumpZ = Other.JumpZ;
        Other.JumpZ += MyLiftCenter.MyLift.MaxZVelocity;
        // End:0x1AA
        if(!Other.SuggestJumpVelocity(NewVelocity, Location + (vect(0.0000000, 0.0000000, 1.0000000) * Other.GetCollisionHeight()), Other.Location))
        {
            Other.JumpZ = RealJumpZ;
            return false;
        }
        Other.Velocity = NewVelocity;
        Other.bWantsToCrouch = false;
        Other.Controller.MoveTarget = self;
        Other.Controller.SetDestinationPosition(Location);
        Other.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x2FE
        if(UTPawn(Other) != none)
        {
            UTPawn(Other).bNoJumpAdjust = true;
            UTPawn(Other).bReadyToDoubleJump = true;
        }
        Other.SetPhysics(2);
        Other.DestinationOffset = 50.0000000;
        Other.JumpZ = RealJumpZ;
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bExitOnly=true
    ExtraCost=500
    // Reference: CylinderComponent'Default__UTJumpLiftExit.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=none
    Components[3]=CollisionCylinder
    Components[4]=none
    CollisionComponent=CollisionCylinder
}