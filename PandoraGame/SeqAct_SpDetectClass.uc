class SeqAct_SpDetectClass extends SequenceAction
    native;

struct native DetectClassInfo
{
    /** Class we are trying to find. */
    var() class<SPPawn> classToDetect;
    var bool linked;

    structdefaultproperties
    {
        classToDetect=Class'SPPawn'
        linked=false
    }
};

/** VARIABLE DECLARATIONS */
var() array<DetectClassInfo> DetectClasses;
