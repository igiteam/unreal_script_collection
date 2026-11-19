class SoundNodeWave extends SoundNode
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object,Object);

var native const noexport Pointer VfTable;
var native const int ResourceIndex;
var native const int UpdateHint;
var() float Volume;
var() float Pitch;
var() int CompressionQualityXbox360;
var const float Duration;
var native const name FileType;
var native const LazyArray_Mirror RawData;
var native const array<byte> StreamData;
var const transient int bWaitForStream;
var const int ResourceID;
var R6EngineEnums.ESoundSlot m_eSoundSlot;

defaultproperties
{
    Volume=0.6000000
    Pitch=1.0000000
    CompressionQualityXbox360=40
}