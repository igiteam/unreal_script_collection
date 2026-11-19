
class UIAction_CyclePlayerMesh extends UIAction
	native(Sequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var UIImage CharacterTexture;
var string DisplayName;
var() bool bCycleForward;
var() bool bReset;			// Set the display name to the current team index 0

//event BuildCharacterInfo()
//{
//	local int i;
//	
//	if (PartisanList.Length == 0 && NaziList.Length == 0)
//	{
//		for (i = 0; i < Characters.Length; i++)
//		{
//			if (Characters[i].TeamID == T_PARTISAN)
//			{
//				PartisanList[PartisanList.Length] = Characters[i];
//			}
//			else if (Characters[i].TeamID == T_NAZI)
//			{
//				NaziList[NaziList.Length] = Characters[i];
//			}
//		}
//	}
//}

