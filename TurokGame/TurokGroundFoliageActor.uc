class TurokGroundFoliageActor extends Actor
    placeable
    hidecategories(Navigation);

var() const editconst export editinline @NULL TurokGroundFoliageComponent;

simulated function OnSetMaterial(@NULL Action)
{
    TurokGroundFoliageComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    //return;    
}

defaultproperties
{
    // Reference: TurokGroundFoliageComponent'Default__TurokGroundFoliageActor.TurokGroundFoliageComponent0'
    begin object name=TurokGroundFoliageComponent0 class=Class'TurokGroundFoliageComponent'
        StaticMesh=StaticMesh'ProxyStaticMesh_DO_NOT_USE.AGAIN_DO_NOT_USE_PLEASE.foliageproxy'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    TurokGroundFoliageComponent=TurokGroundFoliageComponent0
    bStatic=true
    bNoDelete=true
    bGameRelevant=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__TurokGroundFoliageActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=TurokGroundFoliageComponent0
    TickGroup=1
    CollisionComponent=TurokGroundFoliageComponent0
}