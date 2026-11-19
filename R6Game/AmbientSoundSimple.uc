class AmbientSoundSimple extends AmbientSound
    native
    notplaceable
    hidecategories(lighting,AmbientSound);

var() editconst editinline SoundNodeAmbient AmbientProperties;
var const export editinline SoundCue SoundCueInstance;
var const export editinline SoundNodeAmbient SoundNodeInstance;

defaultproperties
{
    // Reference: SoundCue'Default__AmbientSoundSimple.SoundCue0'
    begin object name="SoundCue0" class=Class'SoundCue'
        SoundGroup="Ambient"
    end object
    SoundCueInstance=SoundCue0
    // Reference: SoundNodeAmbient'Default__AmbientSoundSimple.SoundNodeAmbient0'
    begin object name="SoundNodeAmbient0" class=Class'SoundNodeAmbient'
    end object
    SoundNodeInstance=SoundNodeAmbient0
    // Reference: SpriteComponent'Default__AmbientSoundSimple.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__AmbientSound.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: DrawSoundRadiusComponent'Default__AmbientSoundSimple.DrawSoundRadius0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DrawSoundRadius0" class=Class'DrawSoundRadiusComponent'
    end object
    Components[1]=DrawSoundRadius0
}