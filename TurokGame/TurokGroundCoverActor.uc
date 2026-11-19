class TurokGroundCoverActor extends Actor
    placeable
    hidecategories(Navigation);

var() const editconst export editinline @NULL TurokGroundCoverComponent;

simulated function OnSetMaterial(@NULL Action)
{
    TurokGroundCoverComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    //return;    
}

defaultproperties
{
    // Reference: TurokGroundCoverComponent'Default__TurokGroundCoverActor.TurokGroundCoverComponent0'
    begin object name=TurokGroundCoverComponent0 class=Class'TurokGroundCoverComponent'
        StaticMesh=StaticMesh'ProxyStaticMesh_DO_NOT_USE.AGAIN_DO_NOT_USE_PLEASE.foliageproxy'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    TurokGroundCoverComponent=TurokGroundCoverComponent0
    bStatic=true
    bNoDelete=true
    bGameRelevant=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__TurokGroundCoverActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=TurokGroundCoverComponent0
    TickGroup=1
    CollisionComponent=TurokGroundCoverComponent0
}