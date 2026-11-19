class TurokSeqAct_LowerPlayerWeapons extends SequenceAction
    hidecategories(Object);

var() bool mbHideReticle;
var() bool mbHideHud;
var() bool mbAffectDiveAbility;
var() bool mbDoNotAffectWeapons;

defaultproperties
{
    mbAffectDiveAbility=true
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjClassVersion=2
    ObjName="Lower Player Weapons"
    ObjCategory="Turok Cinema"
}