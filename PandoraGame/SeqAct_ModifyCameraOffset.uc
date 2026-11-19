class SeqAct_ModifyCameraOffset extends SequenceAction;

enum _person
{
    CT_First,                       // 0
    CT_Third,                       // 1
    CT_MAX                          // 2
};

struct _Offset
{
    /** Variable Declaration */
    var() float Forward;
    /** Variable Declaration */
    var() float Height;
    /** Variable Declaration */
    var() float Side;

    structdefaultproperties
    {
        Forward=0.0000000
        Height=0.0000000
        Side=0.0000000
    }
};

/** not using vector because its very confusing w/ unreals coordinate system */
var() _Offset Offset;
var() SeqAct_ModifyCameraOffset._person Person;
