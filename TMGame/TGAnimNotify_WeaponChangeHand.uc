class TGAnimNotify_WeaponChangeHand extends AnimNotify_Scripted;

var() bool LeftHand;
var() bool Back;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local TGPawn P;

	P = TGPawn(Owner);
	if (P != None)
	{
		P.WeaponChangeHand(LeftHand, Back);
	}
}
