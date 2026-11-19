class TurokSeqAct_AIFireMode extends SequenceAction
    hidecategories(Object);

enum FireMode
{
    FIREMODE_Primary,               // 0
    FIREMODE_Secondary,             // 1
    FIREMODE_MAX                    // 2
};

var() byte mFireMode;

defaultproperties
{
    ObjName="AI Fire Mode"
    ObjCategory="Turok AI"
}