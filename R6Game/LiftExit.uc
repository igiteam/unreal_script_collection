class LiftExit extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

var() edfindable LiftCenter MyLiftCenter;
var() bool bExitOnly;

function bool CanBeReachedFromLiftBy(Pawn other)
{
    return (Location.Z < (other.Location.Z + other.GetCollisionHeight())) && other.LineOfSightTo(self);
    return;
}

function WaitForLift(Pawn other)
{
    // End:0x58
    if(MyLiftCenter != none)
    {
        other.DesiredRotation = Rotator(Location - other.Location);
        other.Controller.WaitForMover(MyLiftCenter.MyLift);
    }
    return;
}

event bool SuggestMovePreparation(Pawn other)
{
    local Controller C;

    // End:0x23
    if((MyLiftCenter == none) || other.Controller == none)
    {
        return false;
    }
    // End:0x9A
    if(int(other.Physics) == int(4))
    {
        // End:0x98
        if(other.AirSpeed > float(0))
        {
            other.Controller.MoveTimer = 2.0000000 + (VSize(Location - other.Location) / other.AirSpeed);
        }
        return false;
    }
    // End:0xF7
    if((other.Base == MyLiftCenter.Base) || other.ReachedDestination(MyLiftCenter))
    {
        // End:0xE6
        if(CanBeReachedFromLiftBy(other))
        {
            return false;
        }
        WaitForLift(other);
        return true;        
    }
    else
    {
        // End:0x1B6
        if(MyLiftCenter != none)
        {
            // End:0x1B5
            foreach WorldInfo.AllControllers(Class'Controller', C)
            {
                // End:0x1B4
                if((((C.Pawn != none) && C.PendingMover == MyLiftCenter.MyLift) && WorldInfo.GRI.OnSameTeam(C, other.Controller)) && C.Pawn.ReachedDestination(self))
                {
                    WaitForLift(other);                    
                    return true;
                }                
            }            
        }
    }
    return false;
    return;
}

defaultproperties
{
    bNeverUseStrafing=true
    bForceNoStrafing=true
    bSpecialMove=true
    // Reference: SpriteComponent'Default__LiftExit.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.lift_exit'
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__LiftExit.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__LiftExit.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
}