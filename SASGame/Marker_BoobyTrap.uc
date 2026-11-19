//=============================================================================
// Marker_BoobyTrap
//
// Marker effects for booby trap device.
//=============================================================================

class Marker_BoobyTrap extends Emitter;


//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'Marker_BoobyTrap.BTMarker'
    begin object name=BTMarker class=Class'Engine.SpriteEmitter'
        UseColorScale=true
        ColorScale=/* Array type was not detected. */
        FadeOutStartTime=0.0500000
        FadeOut=true
        FadeInEndTime=0.0500000
        FadeIn=true
        MaxParticles=1
        StartSizeRange=(X=(Min=10.0000000,Max=10.0000000),Y=(Min=10.0000000,Max=10.0000000),Z=(Min=10.0000000,Max=10.0000000))
        UniformSize=true
        Texture=Texture'SFXTx.Misc.FxM_spark01'
        LifetimeRange=(Min=1.0000000,Max=1.0000000)
    end object
    Emitters[0]=BTMarker
    RemoteRole=1
    bLightChanged=true
    bNoDelete=false
    bDynamicLight=true
}