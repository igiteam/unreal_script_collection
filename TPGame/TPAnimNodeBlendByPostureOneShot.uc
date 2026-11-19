class TPAnimNodeBlendByPostureOneShot extends AnimNodeBlendList
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



// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


