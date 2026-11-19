class Sequence extends SequenceOp
    native
    hidecategories(Object);

var const Pointer LogFile;
var const Pointer FileOutput;
var const Pointer ConsoleOutput;
var const export array<export SequenceObject> SequenceObjects;
var const array<SequenceOp> ActiveSequenceOps;
var const array<Sequence> NestedSequences;
var const array<SequenceEvent> UnregisteredEvents;
var int DefaultViewX;
var int DefaultViewY;
var float DefaultViewZoom;
var(Register) bool DisableEvents;
var bool m_bParentDisabledEvents;
var bool m_bEventsAreRegistered;
var bool m_bEventsAreUnregistered;
var() R6EngineEnums.EGameType SupportedGameType;
var() R6EngineEnums.EGameMode SupportedGameMode;

// Export USequence::execFindSeqObjectsByClass(FFrame&, void* const)
native final function FindSeqObjectsByClass(class<SequenceObject> DesiredClass, bool bRecursive, out array<SequenceObject> OutputObjects);

// Export USequence::execOnEvent(FFrame&, void* const)
native final function OnEvent(name EventName);

// Export USequence::execShowKismetDebug(FFrame&, void* const)
native final function ShowKismetDebug();

defaultproperties
{
    DefaultViewZoom=1.0000000
    SupportedGameType=1
    SupportedGameMode=10
    InputLinks=none
    OutputLinks=none
    ObjName="Sequence"
}