class SoundCue extends Object
    native
    hidecategories(Object);

struct SoundNodeEditorData
{
    var native const int NodePosX;
    var native const int NodePosY;
};

var bool m_bIsLoopingSound;
var transient R6EngineEnums.ESoundOccluderType m_eOccluderType;
var transient R6EngineEnums.ESoundSurfaceType m_eSoundSurfaceType;
var name SoundGroup;
var SoundNode FirstNode;
var native const map{VOID,VOID} EditorData;
var float MaxAudibleDistance;
var() float VolumeMultiplier;
var() float PitchMultiplier;

event float GetDuration()
{
    local SoundNodeWave Wave;

    Wave = SoundNodeWave(FirstNode);
    // End:0x2A
    if(Wave != none)
    {
        return Wave.Duration;
    }
    return 0.0000000;
    return;
}

defaultproperties
{
    VolumeMultiplier=1.0000000
    PitchMultiplier=1.0000000
}