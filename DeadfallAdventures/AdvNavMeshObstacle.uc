class AdvNavMeshObstacle extends NavMeshObstacle
    hidecategories(Navigation);

event bool GetObstacleBoudingShape(out array<Vector> Shape)
{
    local float Scale;
    local Vector Offset;

    Scale = 200.0000000 * DrawScale;
    Offset.X = Scale * DrawScale3D.X;
    Offset.Y = Scale * DrawScale3D.Y;
    Offset.Z = -Scale * DrawScale3D.Z;
    Shape.AddItem(Location + (Offset >> Rotation));    
    Offset.X = -Scale * DrawScale3D.X;
    Offset.Y = Scale * DrawScale3D.Y;
    Offset.Z = -Scale * DrawScale3D.Z;
    Shape.AddItem(Location + (Offset >> Rotation));    
    Offset.X = -Scale * DrawScale3D.X;
    Offset.Y = -Scale * DrawScale3D.Y;
    Offset.Z = -Scale * DrawScale3D.Z;
    Shape.AddItem(Location + (Offset >> Rotation));    
    Offset.X = Scale * DrawScale3D.X;
    Offset.Y = -Scale * DrawScale3D.Y;
    Offset.Z = -Scale * DrawScale3D.Z;
    Shape.AddItem(Location + (Offset >> Rotation));    
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    Components[0]=none
    // Reference: DrawBoxComponent'Default__AdvNavMeshObstacle.DrawBox0'
    begin object name=DrawBox0
        ReplacementPrimitive=none
    end object
    Components[1]=DrawBox0
}