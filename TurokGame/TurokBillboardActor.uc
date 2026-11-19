class TurokBillboardActor extends Actor
    placeable
    hidecategories(Navigation);

var() const editconst export editinline @NULL TurokBillboardComponent;

simulated function OnSetMaterial(@NULL Action)
{
    TurokBillboardComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    //return;    
}

defaultproperties
{
    // Reference: TurokBillboardComponent'Default__TurokBillboardActor.TurokBillboardComponent0'
    begin object name=TurokBillboardComponent0 class=Class'TurokBillboardComponent'
        StaticMesh=StaticMesh'ProxyStaticMesh_DO_NOT_USE.AGAIN_DO_NOT_USE_PLEASE.foliageproxy'
        CastShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
    end object
    TurokBillboardComponent=TurokBillboardComponent0
    bStatic=true
    bNoDelete=true
    bGameRelevant=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__TurokBillboardActor.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    Components[1]=TurokBillboardComponent0
    TickGroup=1
    CollisionComponent=TurokBillboardComponent0
}