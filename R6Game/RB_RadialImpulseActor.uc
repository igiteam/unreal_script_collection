class RB_RadialImpulseActor extends Actor
    native
    placeable
    hidecategories(lighting);

var export editinline DrawSphereComponent RenderComponent;
var() const editconst export editinline RB_RadialImpulseComponent ImpulseComponent;

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x2E
    if(inAction.InputLinks[0].bHasImpulse)
    {
        ImpulseComponent.FireImpulse(Location);
    }
    return;
}

defaultproperties
{
    // Reference: DrawSphereComponent'Default__RB_RadialImpulseActor.DrawSphere0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawSphere0" class=Class'DrawSphereComponent'
    end object
    RenderComponent=DrawSphere0
    // Reference: RB_RadialImpulseComponent'Default__RB_RadialImpulseActor.ImpulseComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ImpulseComponent0" class=Class'RB_RadialImpulseComponent'
        PreviewSphere=DrawSphereComponent'Default__RB_RadialImpulseActor.DrawSphere0'
    end object
    ImpulseComponent=ImpulseComponent0
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__RB_RadialImpulseActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_RadImpulse'
    end object
    Components[0]=Sprite
    Components[1]=DrawSphere0
    Components[2]=ImpulseComponent0
}