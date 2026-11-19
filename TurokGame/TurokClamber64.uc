class TurokClamber64 extends TurokLadderVolume
    hidecategories(Navigation,Object,Movement,Display,Attachment,Advanced,Brush,Volume,Collision,PhysicsVolume)
    autoexpandcategories(TurokLadderVolume);

defaultproperties
{
    // Reference: DrawSphereComponent'Default__TurokClamber64.BottomEdgeSphere'
    begin object name=BottomEdgeSphere
    end object
    mBottomEdgeSphere=BottomEdgeSphere
    // Reference: DrawSphereComponent'Default__TurokClamber64.TopEdgeSphere'
    begin object name=TopEdgeSphere
    end object
    mTopEdgeSphere=TopEdgeSphere
    // Reference: BrushComponent'Default__TurokClamber64.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    // Reference: ArrowComponent'Default__TurokClamber64.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=BottomEdgeSphere
    Components[3]=TopEdgeSphere
    CollisionComponent=BrushComponent0
}