class R6WavePoint extends R6SpawnPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var R6Wave m_pWave;

defaultproperties
{
    // Reference: SpriteComponent'Default__R6WavePoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6SpawnPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AIWavePoint_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6WavePoint.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: ArrowComponent'Default__R6SpawnPoint.Arrow'
    begin object name="Arrow"
    end object
    Components[1]=Arrow
}