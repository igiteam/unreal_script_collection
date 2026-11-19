class Ladder extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

var LadderVolume MyLadder;
var Ladder LadderList;

event bool SuggestMovePreparation(Pawn other)
{
    // End:0x0D
    if(MyLadder == none)
    {
        return false;
    }
    // End:0x3D
    if(!MyLadder.InUse(other))
    {
        MyLadder.PendingClimber = other;
        return false;
    }
    other.Controller.bPreparingMove = true;
    other.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    return true;
    return;
}

defaultproperties
{
    bSpecialMove=true
    bNotBased=true
    // Reference: CylinderComponent'Default__Ladder.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=80.0000000
        CollisionRadius=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__Ladder.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Ladder'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__Ladder.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__Ladder.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
    end object
    Components[3]=Arrow
    CollisionComponent=CollisionCylinder
}