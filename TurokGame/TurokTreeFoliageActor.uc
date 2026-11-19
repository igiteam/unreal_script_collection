class TurokTreeFoliageActor extends Actor
    placeable
    hidecategories(Navigation);

var() const editconst export editinline @NULL TurokTreeFoliageComponent;

simulated function OnSetMaterial(@NULL Action)
{
    TurokTreeFoliageComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    //return;    
}

defaultproperties
{
    // Reference: TurokTreeFoliageComponent'Default__TurokTreeFoliageActor.TurokTreeFoliageComponent0'
    begin object name=TurokTreeFoliageComponent0 class=Class'TurokTreeFoliageComponent'
        StaticMesh=StaticMesh'ProxyStaticMesh_DO_NOT_USE.AGAIN_DO_NOT_USE_PLEASE.foliageproxy'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    TurokTreeFoliageComponent=TurokTreeFoliageComponent0
    bStatic=true
    bNoDelete=true
    bGameRelevant=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__TurokTreeFoliageActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=TurokTreeFoliageComponent0
    TickGroup=1
    CollisionComponent=TurokTreeFoliageComponent0
}