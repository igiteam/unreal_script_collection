class R6PipeControlPointActor extends Actor
    native
    notplaceable
    hidecategories(lighting,Object);

var(PipeElbow) float m_fRadius;
var(PipeElbow) byte m_iNbSides;
var R6PipeActor m_Parent;

defaultproperties
{
    m_fRadius=45.0000000
    m_iNbSides=3
    // Reference: SpriteComponent'Default__R6PipeControlPointActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.S_PipeControlPoint'
    end object
    Components[0]=Sprite
}