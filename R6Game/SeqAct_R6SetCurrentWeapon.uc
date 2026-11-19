class SeqAct_R6SetCurrentWeapon extends SequenceAction
    native
    hidecategories(Object);

var() bool SetPrimary;
var() bool SetSecondary;
var() bool SetPistol;
var() bool bInstantSwitch;

defaultproperties
{
    SetPrimary=true
    ObjClassVersion=2
    ObjName="Set Current Weapon"
    ObjCategory="Pawn"
}