//-----------------------------------------------------------
//TMGame_Hud Tasktip WX202
//-----------------------------------------------------------
class HDGFxTaskTip extends GFxObject
    dependson(HDMapInfo);

var WorldInfo               ThisWorld;
var HDMapInfo               MapInfo;
var bool                    bUpdateData;
var GFxObject               Task_D,Task_T;
var GFxObject               RootMC;
var GFxObject               TaskTextMC;
var GFxObject               TaskText;
var GFxObject               Task_DMC;
var GFxObject               TempTask;
var array<GFxObject>        TaskTip;
var GFxObject               MissionTextMC;
var GFxObject               MissionText;
var GFxObject               MissionTextFinish;
var bool                    bAlwaysShow;


    function Init(HDGFxTaskTipHud h)
    {
        local int Idx;

        ThisWorld = GetPC().WorldInfo;
        MapInfo = HDMapInfo(ThisWorld.GetMapInfo());
        if(MapInfo!=None)
        {
         RootMc = GetVariableObject("_root");
         if(MapInfo.CurrentTaskTipHud != none)
            MapInfo.CurrentTaskTipHud.Close(true);
         MapInfo.CurrentTaskTipHud = h;
         TempTask = GetVariableObject("_root.task");
         TaskTextMC = GetVariableObject("_root.task.task_text");
         Task_DMC = GetVariableObject("_root.task.task_d.task_d_mc");
         TaskText = GetVariableObject("_root.task.task_text.Tasktip_text");
         TempTask.SetVisible(False);

           if(MapInfo.TaskTipActors.Length>0)
            {
            for(Idx = 0;Idx<MapInfo.TaskTipActors.Length;Idx++)
            {
            switch(MapInfo.TaskTipType[Idx])
                {
                case 0:
                    TaskTip[Idx] = RootMc.AttachMovie("Task_Attack","Task"$Idx);
                    break;
                case 1:
                    TaskTip[Idx] = RootMc.AttachMovie("Task_Defence","Task"$Idx);
                    break;
                case 2:
                    TaskTip[Idx] = RootMc.AttachMovie("Task_Move","Task"$Idx);
                    break;
                case 3:
                    TaskTip[Idx] = RootMc.AttachMovie("Task_Destroy","Task"$Idx);
                    break;
                case 4:
                    TaskTip[Idx] = RootMc.AttachMovie("Task","Task"$Idx);
                    break;
                case 5:
                    TaskTip[Idx] = RootMc.AttachMovie("Task_AirFire","Task"$Idx);
                    break;
                }
                if(H.bAlwaysShow)
                    {
                        TaskTip[Idx].GotoAndStopI(120);//AlwaysShow
                    }
            }
            bUpdateData = true;
            }
        }
    }
    function UpdataInfo(bool bAutoClose)
    {

     local PlayerController PC;
     local vector TipLocation;
     //local rotator TipRotation;
     local vector PlayerLocation;
     local rotator PlayerRotation;
     local vector VTaskTip;
     local float MoveTo_x;
     local float MoveTo_y;
     local float FovX;
     local float FovY;
     local float Deg2Rad;
     local float Yaw;
     local float Pitch;
     local float Aspect; //W/H
     local Canvas Canvas;
     local int Idx;

     PC = GetPC();
     Canvas = PC.myHUD.Canvas;
     RootMc.SetFloat("_x",0);
    if(MapInfo != None && MapInfo.TaskTipActors.Length>0 && PC.myHUD.bShowHUD)
     {
         for(Idx = 0;Idx<MapInfo.TaskTipActors.Length;Idx++)
         {
          /**Set GFxValue **/
          TaskTextMC = TaskTip[Idx].GetObject("task_text");
          TaskText = TaskTextMC.GetObject("Tasktip_text");
          Task_DMC = TaskTip[Idx].GetObject("task_d").GetObject("task_d_mc");
          TempTask =  TaskTip[Idx];

          /**Get info **/
          Deg2Rad = 3.14159265359/180;
          PC.ViewTarget.GetActorEyesViewPoint(PlayerLocation,PlayerRotation);
          //PC.Pawn.GetActorEyesViewPoint(PlayerLocation,PlayerRotation);
          TipLocation = MapInfo.TaskTipActors[Idx].Location;
          //TipRotation = MapInfo.TaskTipActors[Idx].Rotation;
          VTaskTip    = TipLocation - PlayerLocation;
          Aspect = Canvas.SizeX / Canvas.SizeY;
          FovX = PC.GetFOVAngle()/2.0;
          FovY = Atan(Tan(FovX*Deg2Rad)/Aspect) / Deg2Rad;
          Yaw = AngleClamp180((rotator(VTaskTip).Yaw-PlayerRotation.Yaw) / 182.04);
          Pitch = AngleClamp180((rotator(VTaskTip).Pitch-PlayerRotation.Pitch) / 182.04);
             /**Set new Postion **/
             if (Yaw > FovX)
             MoveTo_x = 1014;
             else if (Yaw < -FovX)
             MoveTo_x = 10;
             else
             MoveTo_x       =   1024.0*(Tan(Deg2Rad*Yaw) / Tan(Deg2Rad*FovX) * 0.5 + 0.5);

             if (Pitch > FovY)
                 MoveTo_y = 60;
                 else if (Pitch < -FovY)
                 MoveTo_y = 768;
             else
                 MoveTo_y       =   768.0*(1.0 - (Tan(Deg2Rad*Pitch) / Tan(Deg2Rad*FovY) * 0.5 + 0.5));

             if(MoveTo_x > 10 && MoveTo_x < 1014 && MoveTo_y > 60 && MoveTo_y < 768)
             {
                Task_DMC.GotoAndPlayI(1);
                MoveTo_x = Canvas.Project(MapInfo.TaskTipActors[Idx].Location).X;
                MoveTo_y = Canvas.Project(MapInfo.TaskTipActors[Idx].Location).Y;
                if(Canvas.SizeX>1024.0)
                     MoveTo_x -= (Canvas.SizeX-1024)/2;
                if(Canvas.SizeY>768.0)
                     MoveTo_y -= (Canvas.SizeY-768)/2;
             }
             UpdateTipText( VTaskTip ,bAutoClose);
             UpdateTipPosition(MoveTo_x,MoveTo_y);
             UpdateTipRotarion(MoveTo_x,MoveTo_y);
          }
     }
    }
    function UpdateTipText(vector VTip ,bool bAutoClose)
    {
     local string s;
     local float f;
     f =VSize(VTip)/25;
     if(f<5.1&&bAutoClose)
        TempTask.SetVisible(false);
     else
     {
        s = string(int(f))@"m";
        TaskText.SetText(s);
     }
    }

    function UpdateTipPosition(float MoveX,float MoveY)
    {
     if( MoveX>=10 && MoveX<=1014.0)
        TempTask.SetFloat("_x",MoveX);
     if( MoveY>60 && MoveY<768.0)
        TempTask.SetFloat("_y",MoveY);
    }

    function UpdateTipRotarion(float MoveX,float MoveY)
    {
     if(MoveX<=10)
     {
        Task_DMC.GotoAndPlayI(2);
        TempTask.SetFloat("_x",10);
        Task_DMC.SetFloat("_rotation",-90);
        TaskText.SetText(" ");
     }

     if(MoveX>=1014)
     {
        Task_DMC.GotoAndPlayI(2);
        TempTask.SetFloat("_x",1014);
        Task_DMC.SetFloat("_rotation",90);
        TaskText.SetText(" ");
     }

     if(MoveY<=60||(MoveX>10&&MoveX<1014&&MoveY>60&&MoveY<768))
        Task_DMC.SetFloat("_rotation",0);

     if(MoveY<=60)
     {
        Task_DMC.GotoAndPlayI(2);
        TempTask.SetFloat("_y",60);
        TaskText.SetText(" ");
     }
      if(MoveY>=768)
     {
        Task_DMC.GotoAndPlayI(2);
        TempTask.SetFloat("_y",768);
        Task_DMC.SetFloat("_rotation",180);
        TaskText.SetText(" ");
     }

    }
    // Gives the result as an angle between - 180 and 180
    function float AngleClamp180(float angle)
    {
        local float angleFrac;

        angleFrac = angle / 360.0;
        angle = (angleFrac - ffloor(angleFrac)) * 360.0;
        if (angle > 180.0)
            return angle - 360.0;
        return angle;
    }

    function CreatMissionText()
    {
        local GFxObject TempObj;

        RootMc.AttachMovie("Mission_text","Missiontext");
        MissionTextMC = RootMc.GetObject("Missiontext");
        MissionTextFinish = MissionTextMC.GetObject("_text_icon");
        TempObj       = MissionTextMC.GetObject("_text");
        MissionText   = TempObj.GetObject("_text");

        if(bAlwaysShow)
            MissionTextMC.GotoAndStopI(2);
    }
    function SetRootMC(float X)
    {
     RootMc.SetFloat("_x",X);
    }
