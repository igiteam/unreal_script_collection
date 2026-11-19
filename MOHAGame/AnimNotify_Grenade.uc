class AnimNotify_Grenade extends AnimNotify_Script
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name ThrowingHandBoneName;
//var delegate<AnimNotifyGrenadeCallback> __AnimNotifyGrenadeCallback__Delegate;

delegate AnimNotifyGrenadeCallback(name BoneName)
{
    //return;    
}

defaultproperties
{
    NotifyName="ThrowGrenade"
}