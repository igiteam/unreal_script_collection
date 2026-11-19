class R6NavMeshPortal extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation,NavMeshGeneration);

var name m_OldKeyName;
var(Key) name m_KeyName;
var(Key) const editconst name m_NavMeshName;
var ENavMesh m_pOnNavMesh;

defaultproperties
{
    // Reference: SpriteComponent'Default__R6NavMeshPortal.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.PortalNavMesh_Pic'
    end object
    Components[0]=Sprite
}