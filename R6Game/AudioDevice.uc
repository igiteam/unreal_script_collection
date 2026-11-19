class AudioDevice extends Subsystem
    transient
    native
    config(Engine)
    noexport;

struct ListenerStruct
{
    var int Index;
    var Vector Location;
    var Vector Up;
    var Vector Right;
    var Vector Front;
    var int m_iTriangleIdx;
    var int m_iZoneIdx;
    var Pointer m_pNavMesh;

    structdefaultproperties
    {
        Index=0
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Up=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Right=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Front=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iTriangleIdx=0
        m_iZoneIdx=0
        m_pNavMesh=none
    }
};

struct SoundGroupProperties
{
    var() float Volume;
    var() float Priority;

    structdefaultproperties
    {
        Volume=1.0000000
        Priority=1.0000000
    }
};

struct SoundGroup
{
    var() SoundGroupProperties Properties;
    var() name GroupName;
    var() array<name> ChildGroupNames;

    structdefaultproperties
    {
        Properties=(Volume=0.0000000,Priority=0.0000000)
        GroupName="None"
        ChildGroupNames=none
    }
};

var int m_iLevelZoneInfoAtReloadCheckpoint;
var string m_sZoneInfoNameAtReloadCheckpoint;
var const config int MaxChannels;
var const export editinline transient array<export editinline AudioComponent> AudioComponents;
var native const array<Pointer> Sources;
var native const array<Pointer> FreeSources;
var native const int bLastRealtime;
var native const int bRestartFlushedSounds;
var native const array<ListenerStruct> Listener;
var native const QWord CurrentTick;
var native const Map_Mirror NameToSoundGroupMap;
var native const Map_Mirror NameToPropagatedSoundGroupPropertiesMap;
var() config array<config SoundGroup> SoundGroups;
var native const Pointer SoundResourceHandler;
var native const Pointer m_pDevice;
var native const int m_bIsPlayLevel;
var native bool m_bGenerateBankSet;
