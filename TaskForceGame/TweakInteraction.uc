class TweakInteraction extends interaction;

struct TweakInfo
{
	var string ClassName;
	var string PropertyName;
	var bool IsFloat;
	
	var int DefIntVal;
	var float DefFloatVal;
	
	var int CurIntVal;
	var float CurFloatVal;
	
	var int IntInc;
	var float FloatInc;
};

var float TWEAK_BASE_X;
var float TWEAK_BASE_Y;

var float TWEAK_NAME_OFFSET;
var float TWEAK_VAL_OFFSET;
var float TWEAK_INC_OFFSET;

var float TWEAK_FONT_SIZE;

var int CurSelectedItem;

var int CurTweakInfo;

const NUM_TWEAK_INFOS = 8;
var TweakInfo TweakInfos[NUM_TWEAK_INFOS];

function SetActive()
{
	bActive=true;
	bVisible=true;
}

function SetInActive()
{
	bActive=false;
	bVisible=false;
}

function ToggleActive()
{
	if (bActive)
	{
		SetInactive();
	}
	else
	{
		SetActive();
	}
}

function PostRender( canvas c )
{
	local string nameStr, valStr, incStr;
	local float scale;

	scale = 1/c.Scale;

	class'ZombieGame.ZombieFontDescriptor'.static.SetRadarFont(c, TWEAK_FONT_SIZE*scale);
	c.SetDrawColor(255, 255, 255);	
	
	nameStr = TweakInfos[CurTweakInfo].ClassName $ "." $ TweakInfos[CurTweakInfo].PropertyName;

	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		valStr = "" $ TweakInfos[CurTweakInfo].CurFloatVal $ " (" $ TweakInfos[CurTweakInfo].DefFloatVal $ ")";
		incStr = "" $ TweakInfos[CurTweakInfo].FloatInc;
	}
	else
	{
		valStr = "" $ TweakInfos[CurTweakInfo].CurIntVal $ " (" $ TweakInfos[CurTweakInfo].DefIntVal $ ")";
		incStr = "" $ TweakInfos[CurTweakInfo].IntInc;
	}

	if (CurSelectedItem == 0)
	{
		nameStr = "Tweaking: " $ nameStr;
	}
	else if (CurSelectedItem == 1)
	{
		valStr = "Tweaking: " $ valStr;
	}
	else if (CurSelectedItem == 2)
	{
		incStr = "Tweaking: " $ incStr;
	}
	
	c.DrawText2(nameStr,
				TWEAK_BASE_X*scale,
				(TWEAK_BASE_Y+TWEAK_NAME_OFFSET)*scale);
	
	c.DrawText2(valStr,
				TWEAK_BASE_X*scale,
				(TWEAK_BASE_Y+TWEAK_VAL_OFFSET)*scale);
				
	c.DrawText2(incStr,
				TWEAK_BASE_X*scale,
				(TWEAK_BASE_Y+TWEAK_INC_OFFSET)*scale);
	
	class'ZombieGame.ZombieFontDescriptor'.static.ResetFont(c);
}

function NameInc()
{
	CurTweakInfo = (CurTweakInfo + 1) % NUM_TWEAK_INFOS;
}

function NameDec()
{
	CurTweakInfo = (CurTweakInfo + (NUM_TWEAK_INFOS-1)) % NUM_TWEAK_INFOS;
}

function UpdateValues()
{
	local string cmd;
	
	cmd = "SET " $ TweakInfos[CurTweakInfo].ClassName @ TweakInfos[CurTweakInfo].PropertyName;
	
	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		cmd = cmd @ TweakInfos[CurTweakInfo].CurFloatVal;
	}
	else
	{
		cmd = cmd @ TweakInfos[CurTweakInfo].CurIntVal;
	}
	
	ConsoleCommand(cmd);
}

function ValInc()
{
	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		TweakInfos[CurTweakInfo].CurFloatVal += TweakInfos[CurTweakInfo].FloatInc;
	}
	else
	{
		TweakInfos[CurTweakInfo].CurIntVal += TweakInfos[CurTweakInfo].IntInc;
	}
	
	UpdateValues();
}

function ValDec()
{
	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		TweakInfos[CurTweakInfo].CurFloatVal -= TweakInfos[CurTweakInfo].FloatInc;
	}
	else
	{
		TweakInfos[CurTweakInfo].CurIntVal -= TweakInfos[CurTweakInfo].IntInc;
	}
	
	UpdateValues();
}

function IncInc()
{
	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		TweakInfos[CurTweakInfo].FloatInc *= 2;
	}
	else
	{
		TweakInfos[CurTweakInfo].IntInc *= 2;
	}
}

function IncDec()
{
	if (TweakInfos[CurTweakInfo].IsFloat)
	{
		TweakInfos[CurTweakInfo].FloatInc /= 2;
	}
	else
	{
		TweakInfos[CurTweakInfo].IntInc /= 2;
	}
}

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local bool retVal;

	if (Action == EInputAction.IST_Release)
	{
		if ((Key == EInputKey.IK_JOY9) || (Key == EInputKey.IK_Up))
		{
			CurSelectedItem = (CurSelectedItem + 2)%3;
			
			retVal = true;
		}
		else if ((Key == EInputKey.IK_JOY10) || (Key == EInputKey.IK_Down))
		{
			CurSelectedItem = (CurSelectedItem + 1)%3;
			
			retVal = true;
		}
		else if ((Key == EInputKey.IK_JOY11) || (Key == EInputKey.IK_Left))
		{
			if (CurSelectedItem == 0)
			{
				NameDec();
			}
			else if (CurSelectedItem == 1)
			{
				ValDec();
			}
			else if (CurSelectedItem == 2)
			{
				IncDec();
			}
			
			retVal = true;
		}
		else if ((Key == EInputKey.IK_JOY12) || (Key == EInputKey.IK_Right))
		{
			if (CurSelectedItem == 0)
			{
				NameInc();
			}
			else if (CurSelectedItem == 1)
			{
				ValInc();
			}
			else if (CurSelectedItem == 2)
			{
				IncInc();
			}
			
			retVal = true;
		}
	}
	
	return retVal;
}


// Decompiled with UE Explorer.
defaultproperties
{
    TWEAK_BASE_X=50.0000000
    TWEAK_BASE_Y=100.0000000
    TWEAK_VAL_OFFSET=15.0000000
    TWEAK_INC_OFFSET=30.0000000
    TWEAK_FONT_SIZE=12.0000000
    TweakInfos[0]=(ClassName="ZombieGame.ZombiePlayerPawn",PropertyName="GroundSpeed",IsFloat=true,DefIntVal=0,DefFloatVal=350.0000000,CurIntVal=0,CurFloatVal=350.0000000,IntInc=0,FloatInc=10.0000000)
    TweakInfos[1]=(ClassName="ZombieGame.SFRMPlayerController",PropertyName="DesiredFOV",IsFloat=true,DefIntVal=0,DefFloatVal=90.0000000,CurIntVal=0,CurFloatVal=90.0000000,IntInc=0,FloatInc=10.0000000)
    TweakInfos[2]=(ClassName="Engine.PlayerInput",PropertyName="LookSensitivity",IsFloat=false,DefIntVal=4,DefFloatVal=0.0000000,CurIntVal=4,CurFloatVal=0.0000000,IntInc=1,FloatInc=0.0000000)
    TweakInfos[3]=(ClassName="Engine.PlayerInput",PropertyName="XAccelDelay",IsFloat=true,DefIntVal=0,DefFloatVal=0.1000000,CurIntVal=0,CurFloatVal=0.1000000,IntInc=0,FloatInc=0.0500000)
    TweakInfos[4]=(ClassName="Engine.PlayerInput",PropertyName="XDecelThresh",IsFloat=true,DefIntVal=0,DefFloatVal=0.1500000,CurIntVal=0,CurFloatVal=0.1500000,IntInc=0,FloatInc=0.0500000)
    TweakInfos[5]=(ClassName="Engine.PlayerInput",PropertyName="XAccel",IsFloat=true,DefIntVal=0,DefFloatVal=1.5000000,CurIntVal=0,CurFloatVal=1.5000000,IntInc=0,FloatInc=0.1000000)
    TweakInfos[6]=(ClassName="Engine.PlayerInput",PropertyName="ZoomDecel",IsFloat=true,DefIntVal=0,DefFloatVal=0.5000000,CurIntVal=0,CurFloatVal=0.5000000,IntInc=0,FloatInc=0.1000000)
    TweakInfos[7]=(ClassName="Engine.PlayerController",PropertyName="LeanDist",IsFloat=true,DefIntVal=0,DefFloatVal=80.0000000,CurIntVal=0,CurFloatVal=80.0000000,IntInc=0,FloatInc=16.0000000)
    bActive=false
}