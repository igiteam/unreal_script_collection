class BombInteraction extends Interaction
    deprecated;

//	within GameViewportClient
//    dependson(SeqAct_StartBombGame)
//	transient
//	config(Input);
//
//`define NATIVE_RES_X      1024.0
//`define NATIVE_RES_Y       768.0
//
//`define PERCENT_X            0.4
//`define PERCENT_Y            0.6
//
//`define DEFAULT_ALPHA        150
//
//`define FAIL_TIME             0.2
//`define SUCCESS_TIME          0.8
//
//enum eButtonState {Start, Pause, Flash};
//
//struct ButtonTexture
//{
//    var const Texture2D Tex;
//    var int             Alpha;
//};
//
//var Array<RoundInfo>    Rounds;
//var int                 RoundIndex;
//
//var eXboxButtons        ButtonPressed;
//var int                 Index;
//var eButtonState        ButtonState;
//var ButtonTexture       XboxButton[4];
//var float               TotalTime;
//var name                PendingState;
//var TPPlayerController  tpController;
//var SoundCue            SuccessSound;
//var SoundCue            FailSound;
//var SoundCue            FlashSound;
//
//
//function PostRender(Canvas Canvas)
//{
//    local int       Center, Left, Right, ButtonSizeX, ButtonSizeY;
//	local float     RatioX, RatioY;
//    local int       Offset;
//
//	RatioX = Canvas.SizeX / `NATIVE_RES_X;
//	RatioY = Canvas.SizeY / `NATIVE_RES_Y;
//
//    ButtonSizeX = XboxButton[XboxA].Tex.SizeX*RatioX;  // they should all be the same size - so just use this one
//    ButtonSizeY = XboxButton[XboxA].Tex.SizeY*RatioY;
//
//    Center = Canvas.SizeX/2 - ButtonSizeX/2;
//    Left   = Canvas.SizeX*`PERCENT_X - ButtonSizeX/2;
//    Right  = Canvas.SizeX - Canvas.SizeX*`PERCENT_X - ButtonSizeX/2;
//
//    Offset = (Canvas.SizeX - Canvas.SizeX*`PERCENT_X - ButtonSizeX/2) -
//        (Canvas.SizeX*`PERCENT_X - ButtonSizeX/2);
//    //Offset = Right - Left; // why doesn't this work?!
//    Offset *= 0.5;
//
//    Canvas.SetPos(Center, Canvas.SizeY*`PERCENT_Y - (ButtonSizeY/2));
//    Canvas.SetDrawColor(255,255,255, XboxButton[XboxY].alpha);
//    Canvas.DrawTile(XboxButton[XboxY].Tex, ButtonSizeX, ButtonSizeY, 0, 0, XboxButton[XboxY].Tex.SizeX, XboxButton[XboxY].Tex.SizeY);
//
//    Canvas.SetPos(Right, Canvas.SizeY*`PERCENT_Y - (ButtonSizeY/2) + Offset);
//    Canvas.SetDrawColor(255,255,255, XboxButton[XboxB].alpha);
//    Canvas.DrawTile(XboxButton[XboxB].Tex, ButtonSizeX, ButtonSizeY, 0, 0, XboxButton[XboxY].Tex.SizeX, XboxButton[XboxY].Tex.SizeY);
//
//    Canvas.SetPos(Left, Canvas.SizeY*`PERCENT_Y - (ButtonSizeY/2) + Offset);
//    Canvas.SetDrawColor(255,255,255, XboxButton[XboxX].alpha);
//    Canvas.DrawTile(XboxButton[XboxX].Tex, ButtonSizeX, ButtonSizeY, 0, 0, XboxButton[XboxY].Tex.SizeX, XboxButton[XboxY].Tex.SizeY);
//
//    Canvas.SetPos(Center, Canvas.SizeY*`PERCENT_Y - (ButtonSizeY/2) + Offset*2);
//    Canvas.SetDrawColor(255,255,255, XboxButton[XboxA].alpha);
//    Canvas.DrawTile(XboxButton[XboxA].Tex, ButtonSizeX, ButtonSizeY, 0, 0, XboxButton[XboxY].Tex.SizeX, XboxButton[XboxY].Tex.SizeY);
//}
//
//function Initialized()
//{
//	GotoState('Inactive');
//	Super.Initialized();
//}
//
//state Inactive
//{
//    event BeginState(name PrevState)
//    {
//        RoundIndex = 0;
//    }
//
//    function PostRender(Canvas Canvas)
//    {
//
//    }
//}
//
//state Active
//{
//    event BeginState(name PrevState)
//    {
//        local int i;
//
//        TotalTime     = 0;
//        Index         = 0;
//        ButtonState   = Start;
//        ButtonPressed = XboxNone;
//        if (!Rounds[RoundIndex].bCustomSequence)
//            InitializeButtonSequence();
//
//        for (i = 0; i < 4; i++)
//            XboxButton[i].Alpha = `DEFAULT_ALPHA;
//
//        if (RoundIndex == 0 && tpController.BombProp != None)
//            tpController.BombProp.TriggerEventClass(class'SeqEvent_BombGameStart', tpController);
//    }
//
//    event EndState (name NextState)
//    {
//    }
//
//    function InitializeButtonSequence()
//    {
//        local int i, r;
//
//        Rounds[RoundIndex].ButtonSequence.Length = 0;
//
//        for (i = 0; i < Rounds[RoundIndex].RandomGameLength; i++)
//        {
//            r = rand(4); // number of buttons in game
//            switch (r)
//            {
//            case 0:
//                `log ("BombSequence - XboxA");
//                Rounds[RoundIndex].ButtonSequence[i]=XboxA;
//                break;
//            case 1:
//                `log ("BombSequence - XboxB");
//                Rounds[RoundIndex].ButtonSequence[i]=XboxB;
//                break;
//            case 2:
//                `log ("BombSequence - XboxX");
//                Rounds[RoundIndex].ButtonSequence[i]=XboxX;
//                break;
//            case 3:
//                `log ("BombSequence - XboxY");
//                Rounds[RoundIndex].ButtonSequence[i]=XboxY;
//                break;
//            }
//        }
//    }
//
//    event Tick (float DeltaTime)
//    {
//        // Allow not strictly flashing and pausing according to real time,
//        // otherwise with really low frame rates, buttons will be skipped.
//
//        TotalTime += DeltaTime;
//
//        if (ButtonState == Start)
//        {
//            if (TotalTime > Rounds[RoundIndex].StartTime)
//            {
//                TotalTime   = 0;
//                ButtonState = Flash;
//                XboxButton[Rounds[RoundIndex].ButtonSequence[Index]].alpha = 255;
//                tpController.PlaySound(FlashSound);
//            }
//        }
//        else if (ButtonState == Pause)
//        {
//            if (TotalTime > Rounds[RoundIndex].PauseTime)
//            {
//                Index++;
//                if (Index >= Rounds[RoundIndex].ButtonSequence.Length)
//                {
//                    Index = 0;
//                    PendingState = 'PlayerInput';
//                    GoToState('Success');
//                }
//                else
//                {
//                    TotalTime   = 0;
//                    ButtonState = Flash;
//                    XboxButton[Rounds[RoundIndex].ButtonSequence[Index]].alpha = 255;
//                    tpController.PlaySound(FlashSound);
//                }
//            }
//        }
//        else if (ButtonState == Flash)
//        {
//            if (TotalTime > Rounds[RoundIndex].FlashTime)
//            {
//                TotalTime   = 0;
//                ButtonState = Pause;
//                XboxButton[Rounds[RoundIndex].ButtonSequence[Index]].alpha = `DEFAULT_ALPHA;
//            }
//        }
//    }
//}
//
//state PlayerInput
//{
//    event BeginState(name PrevState)
//    {
//        Index = 0;
//        ResetTimeLimit();
//    }
//
//    event EndState (name NextState)
//    {
//        //ButtonSequence.Length = 0; // Reset game
//    }
//
//    function ResetTimeLimit()
//    {
//        local int i;
//
//        TotalTime = 0;
//        for (i = 0; i < 4; i++)
//        {
//            XboxButton[i].Alpha = `DEFAULT_ALPHA;
//        }
//    }
//
//    event Tick (float DeltaTime)
//    {
//        local int   i;
//        local float Percent;
//
//        TotalTime += DeltaTime;
//        Percent    = TotalTime/Rounds[RoundIndex].TimeLimit;
//
//        for (i = 0; i < 4; i++)
//        {
//            if (ButtonPressed == i)
//                XboxButton[i].Alpha = 255;
//            else
//                XboxButton[i].Alpha = `DEFAULT_ALPHA - `DEFAULT_ALPHA*Percent;
//        }
//
//        if (Percent >= 1.0)
//        {
//            PendingState = 'Inactive';
//            GoToState('Failed');
//        }
//    }
//
//	event bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f )
//	{
//		if (Event == IE_Pressed)
//		{
//            ButtonPressed = XboxNone;
//
//			if(Key == 'XboxTypeS_B')
//                ButtonPressed = XboxB;
//            else if (Key == 'XboxTypeS_X')
//                ButtonPressed = XboxX;
//            else if (Key == 'XboxTypeS_Y')
//                ButtonPressed = XboxY;
//            else if (Key == 'XboxTypeS_A')
//                ButtonPressed = XboxA;
//
//            if (ButtonPressed != XboxNone)
//            {
//                if (Rounds[RoundIndex].ButtonSequence[Index] == ButtonPressed)
//                {
//                    Index++;
//                    ResetTimeLimit();
//                    tpController.PlaySound(FlashSound);
//
//                    if (Index >= Rounds[RoundIndex].ButtonSequence.Length)
//                    {
//                        RoundIndex++;
//                        if (RoundIndex >= Rounds.Length)
//                            PendingState = 'Inactive';
//                        else
//                            PendingState = 'Active';
//                        GoToState('Success');
//                    }
//                }
//                else
//                {
//                    PendingState = 'Inactive';
//                    GoToState('Failed');
//                }
//            }
//		}
//        else if (Event == IE_Released)
//        {
//            ButtonPressed = XboxNone;
//        }
//
//		return true; //absorb input
//	}
//}
//
//state Failed
//{
//    event BeginState(name PrevState)
//    {
//        local int i;
//
//        ButtonState = Flash;
//        TotalTime   = 0;
//        Index       = 0;
//
//        for (i = 0; i < 4; i++)
//            XboxButton[i].Alpha = 255;
//
//        tpController.PlaySound(FailSound);
//
//        if (tpController.BombProp != None)
//        {
//            tpController.BombProp.TriggerEventClass(class'SeqEvent_BombGameFail', tpController);
//            tpController.BombProp.FailCheck();
//        }
//    }
//
//    event Tick(float DeltaTime)
//    {
//        local int i;
//
//        TotalTime += DeltaTime;
//
//        if (ButtonState == Flash)
//        {
//            if (TotalTime > `FAIL_TIME)
//            {
//                TotalTime = 0;
//                ButtonState = Pause;
//                Index++;
//
//                for (i = 0; i < 4; i++)
//                    XboxButton[i].Alpha = `DEFAULT_ALPHA;
//            }
//        }
//        else if (ButtonState == Pause)
//        {
//            if (TotalTime > `FAIL_TIME)
//            {
//                if (Index >= 4) // Flash this many times
//                    GoToState(PendingState);
//
//                TotalTime = 0;
//                ButtonState = Flash;
//
//                for (i = 0; i < 4; i++)
//                    XboxButton[i].Alpha = 255;
//            }
//        }
//    }
//}
//
//state Success
//{
//    event BeginState(name PrevState)
//    {
//        local int i;
//
//        TotalTime = 0;
//        for (i = 0; i < 4; i++)
//            XboxButton[i].Alpha = 255;
//
//        tpController.PlaySound(SuccessSound);
//
//        if (PrevState == 'PlayerInput' && tpController.BombProp != None)
//        {
//            tpController.BombProp.TriggerEventClass(class'SeqEvent_BombGameSuccess', tpController, 0);
//
//            if (PendingState == 'Inactive')
//            {
//                tpController.BombProp.Success();
//                tpController.BombProp.TriggerEventClass(class'SeqEvent_BombGameSuccess', tpController, 1);
//            }
//        }
//    }
//
//    event Tick(float DeltaTime)
//    {
//        TotalTime += DeltaTime;
//
//        if (TotalTime > `SUCCESS_TIME)
//            GoToState(PendingState);
//    }
//}
//
//function GetPlayerController(TPPlayerController PlayerController)
//{
//    tpController = PlayerController;
//}
//
//function NotifyGameSessionEnded()
//{
//    tpController = none;
//	super.NotifyGameSessionEnded();
//}
//
//defaultproperties
//{
//    XboxButton(XboxY)=(Tex=Texture2D'HUD_Materials.Textures.xbox_btn_y', alpha=`DEFAULT_ALPHA)
//    XboxButton(XboxX)=(Tex=Texture2D'HUD_Materials.Textures.xbox_btn_x', alpha=`DEFAULT_ALPHA)
//    XboxButton(XboxB)=(Tex=Texture2D'HUD_Materials.Textures.xbox_btn_b', alpha=`DEFAULT_ALPHA)
//    XboxButton(XboxA)=(Tex=Texture2D'HUD_Materials.Textures.xbox_btn_a', alpha=`DEFAULT_ALPHA)
//    //XboxButtonWhat=Texture2D'HUD_Materials.Textures.xbox_btn_what'
//
//    //XboxButtonA=Texture2d'HUD_Materials.Textures.XBX_A_Button_D'
//	//XboxButtonB=Texture2d'HUD_Materials.Textures.XBX_B_Button_D'
//	//XboxButtonX=Texture2d'HUD_Materials.Textures.XBX_X_Button_D'
//	//XboxButtonY=Texture2d'HUD_Materials.Textures.XBX_Y_Button_D'
//
//    Rounds(0)=()
//
//    ButtonState=Start
//    ButtonPressed=XboxNone;
//
//	SuccessSound=SoundCue'S_Prp_Bomb.Bomb_Plant_Success_Cue'
//	FailSound=SoundCue'S_Prp_Bomb.Bomb_Plant_Fail_Cue'
//    FlashSound=SoundCue'S_Prp_Bomb.Bomb_Button_Cue'
//}
