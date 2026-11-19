class TPAnimNodeDeadOrAlive extends AnimNodeBlendList
		native;


//-----------------------------------------------------------------------
// Event:  OnInit
//-----------------------------------------------------------------------
function SetDefaultChild(const int DefaultChild)
{
	local int i;
		
	ActiveChildIndex = DefaultChild;
	for (i = 0; i < Children.Length; i++)
	{
		if (i != DefaultChild)
			Children[i].Weight = 0;
		else
			Children[i].Weight = 1;
	}
}

event OnInit()
{
	if (SkelComponent != None && SkelComponent.Owner != None && TPPawn(SkelComponent.Owner).bPlayedDeath)
		SetDefaultChild(0); // Dead
	else
		SetDefaultChild(1); // Alive
	//log('OnInit');

	super.OnInit();
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


