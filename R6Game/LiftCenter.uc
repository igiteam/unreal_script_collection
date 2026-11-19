class LiftCenter extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

var InterpActor MyLift;
var float MaxDist2D;
var Vector LiftOffset;
var bool bJumpLift;
var float CollisionHeight;

function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x31
    if(Base == MyLift)
    {
        LiftOffset = Location - MyLift.Location;
    }
    return;
}

event bool SuggestMovePreparation(Pawn other)
{
    // End:0x1A
    if(other.Base == MyLift)
    {
        return false;
    }
    // End:0x6E
    if((Base != MyLift) || Location != (MyLift.Location + LiftOffset))
    {
        SetLocation(MyLift.Location + LiftOffset);
        SetBase(MyLift);
    }
    // End:0xC1
    if((MyLift.Velocity != vect(0.0000000, 0.0000000, 0.0000000)) || !ProceedWithMove(other))
    {
        other.Controller.WaitForMover(MyLift);
        return true;
    }
    return false;
    return;
}

function bool ProceedWithMove(Pawn other)
{
    // End:0x19
    if(other.Controller == none)
    {
        return false;        
    }
    else
    {
        // End:0x81
        if((LiftExit(other.Controller.MoveTarget) != none) && other.ReachedDestination(self))
        {
            return LiftExit(other.Controller.MoveTarget).CanBeReachedFromLiftBy(other);            
        }
        else
        {
            // End:0x13B
            if((((Location.Z - CollisionHeight) < ((other.Location.Z - other.GetCollisionHeight()) + other.MaxStepHeight)) && (Location.Z - CollisionHeight) > ((other.Location.Z - other.GetCollisionHeight()) - float(1200))) && VSize2D(Location - other.Location) < MaxDist2D)
            {
                return true;
            }
        }
    }
    return false;
    return;
}

defaultproperties
{
    MaxDist2D=400.0000000
    CollisionHeight=50.0000000
    bNeverUseStrafing=true
    bForceNoStrafing=true
    bSpecialMove=true
    bNoAutoConnect=true
    ExtraCost=400
    bStatic=false
    // Reference: SpriteComponent'Default__LiftCenter.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.lift_center'
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__LiftCenter.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__LiftCenter.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
}