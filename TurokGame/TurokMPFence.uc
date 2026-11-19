class TurokMPFence extends TurokFence
    native
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokFenceMeshComponent'Default__TurokMPFence.StaticMesh'
    begin object name=StaticMesh
    end object
    mWallData=StaticMesh
    bAlwaysRelevant=true
    Components[0]=StaticMesh
    // Reference: TurokFenceRenderingComponent'Default__TurokMPFence.Connections'
    begin object name=Connections
    end object
    Components[1]=Connections
    // Reference: SpriteComponent'Default__TurokMPFence.Sprite'
    begin object name=Sprite
    end object
    Components[2]=Sprite
    CollisionComponent=StaticMesh
}