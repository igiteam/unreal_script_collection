
class SFRMInteraction extends Interaction 
	abstract
	native; 

event Activate()
{
	bActive = true;
	bVisible = true;
}

event DeActivate()
{
	bActive = false;
	bVisible = false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bActive=false
}