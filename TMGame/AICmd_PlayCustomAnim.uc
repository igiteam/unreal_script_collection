//-----------------------------------------------------------
// ????AI/Pawn???????Matinee??SKMA
//-----------------------------------------------------------
class AICmd_PlayCustomAnim extends AICommand
	within TGAI;

var SeqAct_GearPlayerAnim Action;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool PlayCustomAnim(TGAI AI, SeqAct_GearPlayerAnim inAction)
{
	local AICmd_PlayCustomAnim Cmd;

	if(AI != None)
	{
		Cmd = new(AI) class'AICmd_PlayCustomAnim';
		if(Cmd != None)
		{
			Cmd.Action = inAction;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
    Super.Pushed();

    //`AILog(GetFuncName()@"C.R="@Rotation@"P.R="@Pawn.Rotation@"Focus="@Focus);

    MyTGPawn.bLockRotation = false;
    Pawn.LockDesiredRotation(false);
    Focus = none;

    GotoState('RotateToward');
}

function Popped()
{
   Super.Popped();

   //`AILog(GetFuncName()@"C.R="@Rotation@"P.R="@Pawn.Rotation@"Focus="@Focus);

   MyTGPawn.bLockRotation = false;
   //Pawn.LockDesiredRotation(false);
   Pawn.ResetDesiredRotation();

   if(Action.bUseRootMotion)
       MyTGPawn.ZeroMovementVariables(); //RootMotion???????

   Action.bFinished = true;
}

state Play
{
Begin:
   MyTGPawn.ProcessGearPlayerAnim(Action, true);
   while(MyTGPawn.BS_IsPlaying(MyTGPawn.KismetBodyStance))
   {
   // `AILog("Play: C.R="@Rotation@"P.R="@Pawn.Rotation@"Focus="@Focus);
     Sleep(0.2); //Wait anim done
   }

   Status = 'Success';
   PopCommand(Self);
}

state RotateToward
{
Begin:
	Pawn.SetDesiredRotation(Action.DirActor.Rotation/*, true*/);
	FinishRotation(); //Wait

    MyTGPawn.bLockRotation = true;  //??Controller???????

   //`AILog("RotateToward: C.R="@Rotation@"P.R="@Pawn.Rotation@"Focus="@Focus);

   ;
	GotoState('Play');
}
