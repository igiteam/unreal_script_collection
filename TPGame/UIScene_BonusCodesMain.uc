class UIScene_BonusCodesMain extends UIScene_BonusBase;



var UIScrollFrame wBonusCodeInfoFrame;
var () float ScrollFramePauseTime;
var () float ScrollSpeed;
var float ScrollFramePauseDelta;
var () float MaxScrollLimit;
var bool bScrollFramePaused;
var float ScrollFramePostion;
var int ScrollDirection;

event InitScene()
{
	local UILabel UserIDLabel, clientLabel;
	local string myID;
	local int i, numZeroesToPad;
	super.InitScene();

	UserIDLabel = UILabel(FindChild('UserID', true));

	wBonusCodeInfoFrame = UIScrollFrame(FindChild('BonusTextScroller', true));
	clientLabel = UILabel(wBonusCodeInfoFrame.FindChild('UILabel_1', true));
	
	if (GetWorldInfo().IsPS3Build())
		MaxScrollLimit = 75;
	else
		MaxScrollLimit = clientLabel.GetPosition(UIFACE_Bottom, EVALPOS_PixelViewport) - clientLabel.GetPosition(UIFACE_Top, EVALPOS_PixelViewport);
	
	myID = string(myTPC.GetBonusUserID());
	
	//Requirement - pad user IDs with leading zeroes to make 5 digits long.
	if( Len(myID) < 5)
	{
		numZeroesToPad = 5- Len(myID);
		for(i=0; i<numZeroesToPad; i++)
		{
			myID = "0" $ myID;
		}
	}
	
	
	
	UserIDLabel.SetValue(myID);
	UnlockBonusStrings();
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	if (bScrollFramePaused)
	{
		ScrollFramePauseDelta += DeltaTime;
		if (ScrollFramePauseDelta >= ScrollFramePauseTime)
		{
			ScrollFramePauseDelta = 0.0;
			bScrollFramePaused = false;
		}
	}
	else
	{
		ScrollFramePostion += DeltaTime * ScrollDirection * ScrollSpeed;
	}
	
	//`log(self @ "ScrollFramePosition=" @ ScrollFramePostion @ "MaxScrollLimit=" @ MaxScrollLimit);
	
	if (ScrollFramePostion > MaxScrollLimit)
	{
		ScrollFramePostion = MaxScrollLimit;
		ScrollDirection *= -1;
		bScrollFramePaused = true;
	}
	else if (ScrollFramePostion < 0)
	{
		ScrollFramePostion = 0;
		ScrollDirection *= -1;
		bScrollFramePaused = true;
	}

	wBonusCodeInfoFrame.SetClientRegionPosition(UIORIENT_Vertical, wBonusCodeInfoFrame.GetPosition(UIFACE_Top, EVALPOS_PixelViewport) - ScrollFramePostion);
	super.UpdateScene(DeltaTime, WorldInfo);
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	switch (MenuIndex)
	{
		case 1:
			if (myTPC.IsBonusUnlocked(BONUS_ALWAYS_HAVE_GRENADES))
			{
				if (myTPC.IsBonusActive(BONUS_ALWAYS_HAVE_GRENADES))
					myTPC.SetBonusActive(BONUS_ALWAYS_HAVE_GRENADES, 0);
				else
					myTPC.SetBonusActive(BONUS_ALWAYS_HAVE_GRENADES, 1);
				UnlockBonusStrings();
			}
			break;
		case 2:
			if (myTPC.IsBonusUnlocked(BONUS_ALWAYS_HAVE_AMMO))
			{
				if (myTPC.IsBonusActive(BONUS_ALWAYS_HAVE_AMMO))
					myTPC.SetBonusActive(BONUS_ALWAYS_HAVE_AMMO, 0);
				else
					myTPC.SetBonusActive(BONUS_ALWAYS_HAVE_AMMO, 1);
				UnlockBonusStrings();
			}
			break;
		case 3:
			if (myTPC.IsBonusUnlocked(BONUS_DOUBLE_HEALTH_REGEN_RATE))
			{
				if (myTPC.IsBonusActive(BONUS_DOUBLE_HEALTH_REGEN_RATE))
					myTPC.SetBonusActive(BONUS_DOUBLE_HEALTH_REGEN_RATE, 0);
				else
					myTPC.SetBonusActive(BONUS_DOUBLE_HEALTH_REGEN_RATE, 1);
				UnlockBonusStrings();
			}
			break;
	}
}

