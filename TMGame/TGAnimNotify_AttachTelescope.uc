class TGAnimNotify_AttachTelescope extends AnimNotify_Scripted;

var() ItemKind item;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local TGPawn P;

	P = TGPawn(Owner);
	if (P != None)
	{
		P.AttachItem(item);
	}
}
