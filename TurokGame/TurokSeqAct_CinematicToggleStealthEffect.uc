class TurokSeqAct_CinematicToggleStealthEffect extends SequenceAction
    hidecategories(Object);

enum TurokSeqActCinematicToggleStealthEffectType
{
    TSACTSET_Blend,                 // 0
    TSACTSET_NoBlend,               // 1
    TSACTSET_MAX                    // 2
};

var() byte mTransitionType;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Allow",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disallow",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Toggle Stealth Effect for Cinema"
    ObjCategory="Turok Cinema"
}