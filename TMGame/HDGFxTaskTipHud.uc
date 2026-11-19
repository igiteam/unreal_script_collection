//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxTaskTipHud extends GFxMoviePlayer;

var HDGFxTaskTip   TaskTip;
var array<string>  MissionStrings;
var bool           bFinish;
var bool           bAlwaysShow;

    function Init(optional LocalPlayer player)
    {

            super.Init(player);
            Start();
            Advance(0);
        //  ThisWorld = GetPC().WorldInfo;
        //  TaskTip.Init(self);
        //  GRI = UTGameReplicationInfo(GetPC().WorldInfo.GRI);

    }
    function StartTaskTip(HDGFxTaskTip mc)
    {
        TaskTip = mc;
        TaskTip.Init(self);
        TaskTip.bAlwaysShow = bAlwaysShow;
        UpdataMissionText();
    }

    function UpdataMissionText()
    {
     local string TempS;
     local int    Idx;
         if(TaskTip != None && MissionStrings.Length>0)
         {
          TaskTip.CreatMissionText();
          for(Idx=0;Idx< MissionStrings.Length;Idx++)
           {
              TempS $= MissionStrings[Idx];
           }

          if(!TaskTip.bAlwaysShow)
            TaskTip.MissionTextMC.GotoAndPlayI(1);

          TaskTip.MissionText.SetText(TempS);

          if(bFinish)
           TaskTip.MissionTextFinish.GotoAndStopI(2);
         }
    }

    function AddMissionText(string AddText)
    {
        MissionStrings[MissionStrings.Length]= AddText;
    }

    function FinishMission()
    {
        bFinish = TRUE;
    }
