class TurokSeqAct_BetterGiveInventory extends SeqAct_GiveInventory
    hidecategories(Object);

var() bool mbClearInventory;
var() bool mbSwitchToDualWield;
var() bool mbNoExplodingArrowHack;
var() bool mbDrawItemPickups;
var() bool mbNoDynamicPilotLightHack;
var() byte mbSwitchToWeapon;

defaultproperties
{
    mbDrawItemPickups=true
    ObjName="Better Give Inventory"
}