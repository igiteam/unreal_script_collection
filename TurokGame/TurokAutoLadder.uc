class TurokAutoLadder extends AutoLadder
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

event bool SuggestMovePreparation(@NULL Other)
{
    // End:0x10
    if(MyLadder == none)
    {
        return false;        
    }
    else
    {
        // End:0x32
        if(!MyLadder.InUse(Other))
        {
            return false;            
        }
        else
        {
            Other.Controller.bPreparingMove = true;
            Other.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            return true;
        }
    }
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokAutoLadder.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=50.0000000
        CollisionRadius=50.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokAutoLadder.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokAutoLadder.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokAutoLadder.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokAutoLadder.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}