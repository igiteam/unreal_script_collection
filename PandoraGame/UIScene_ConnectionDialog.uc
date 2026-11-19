class UIScene_ConnectionDialog extends UIScene_BaseFrontEnd;

var string MsgStr;
var transient UILabel MsgUILabelObj;
var string ProgressDotsStr;
var transient int NumProgressDots;
var transient float TimeSinceLastProgressDot;
var transient float MaxTimeBetweenProgressDots;

event InitScene()
{
    MsgUILabelObj = UILabel(FindChild('lblInfoText', true));
    SetVisibility(true);
    super.InitScene();
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    super.UpdateScene(DeltaTime, WorldInfo);
    TimeSinceLastProgressDot += DeltaTime;
    // End:0x6B
    if(TimeSinceLastProgressDot > MaxTimeBetweenProgressDots)
    {
        NumProgressDots++;
        // End:0x50
        if(NumProgressDots > 4)
        {
            NumProgressDots = 0;
            ProgressDotsStr = "";            
        }
        else
        {            
            ProgressDotsStr $= ".";
        }
        TimeSinceLastProgressDot = 0.0000000;
    }
    // End:0x93
    if(MsgUILabelObj != none)
    {
        MsgUILabelObj.SetDataStoreBinding(MsgStr $ ProgressDotsStr);
    }
    //return;    
}

function bool MouseIsOverMenuButton()
{
    return true;
    //return ReturnValue;    
}
