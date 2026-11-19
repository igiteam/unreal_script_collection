//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxFrontend_SinglePlay extends HDGFxFrontend;

var transient GFxObject HD_SinglePlayTempGFxObject;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
    return TRUE;
}
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
  	local bool bWasHandled;
	bWasHandled = false;
 switch(WidgetName)
 {
    case ('level1'):

    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[1]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[1]);
   	bWasHandled = true;
   	break;

    case ('level2'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[2]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[2]);
   	bWasHandled = true;
   	break;

    case ('level3'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[3]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[3]);
   	bWasHandled = true;
   	break;
   	case ('level4'):

    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[4]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[4]);
   	bWasHandled = true;
   	break;

    case ('level5'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[5]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[5]);
   	bWasHandled = true;
   	break;

    case ('level6'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[6]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[6]);
   	bWasHandled = true;
   	break;

   	case ('level7'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[7]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[7]);
   	bWasHandled = true;
   	break;

    case ('level8'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[8]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[8]);
   	bWasHandled = true;
   	break;

    case ('level9'):
    HD_SinglePlayTempGFxObject = Widget.GetObject("label");
    HD_SinglePlayTempGFxObject.SetText(LevelName[9]);
    HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
    HD_SinglePlayTempGFxObject.SetText(LevelName[9]);
   	bWasHandled = true;
   	break;
 }
	if (!bWasHandled)
	{
		bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
	}
	return bWasHandled;

}
