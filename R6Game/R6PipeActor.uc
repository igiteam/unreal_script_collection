class R6PipeActor extends StaticMeshActor
    native
    hidecategories(lighting,Object);

var(Pipe) float m_fScaleU;
var(Pipe) float m_fScaleV;
var(PipeSection) float m_fRadius;
var(PipeSection) byte m_iNbSides;
var Matrix m_PreviousWorldToLocal;
var array<R6PipeControlPointActor> m_ControlPoints;

defaultproperties
{
    m_fScaleU=1.0000000
    m_fScaleV=1.0000000
    m_fRadius=3.0000000
    m_iNbSides=3
    // Reference: R6PipeComponent'Default__R6PipeActor.R6PipeComponent0'
    begin object name="R6PipeComponent0" class=Class'R6PipeComponent'
    end object
    StaticMeshComponent=R6PipeComponent0
    // Reference: StaticMeshComponent'Default__R6PipeActor.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Engine.Default__StaticMeshActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
    end object
    Components[0]=StaticMeshComponent0
    // Reference: SpriteComponent'Default__R6PipeActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Sprite" class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'KellerResource.S_Pipe'
    end object
    Components[1]=Sprite
    Components[2]=R6PipeComponent0
}