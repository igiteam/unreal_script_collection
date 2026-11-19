/**********************************************************************
TM_Kismet Tasktip WX202
**********************************************************************/
class HDGFxAction_TaskTip extends SequenceAction
      native(HDSequence)
      dependsOn(HDGFxTaskTipHud);

/** Swf Movie data to use */
var SwfMovie              Movie;

/** Type of movie player to use */
var class<GFxMoviePlayer>           MoviePlayerClass;

var GFxMoviePlayer MoviePlayer;

var array<Actor> TaskTipActor;

/** if true, Auto Close Down Tips when Closely*/
var() bool                  bAutoToClose;

/** Chose TaskTipIcon Type */
enum IconType
{
    EIT_Attack,
    EIT_Defence,
    EIT_Move,
    EIT_Destroy,
    EIT_Special,
    EIT_AirFire,
};
var() IconType               TaskIconType;
/** if true, start paused */
var() bool                   bStartPaused;
/** Mission tip text */
var() string                 TipText;
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
event bool IsValidLevelSequenceObject() {return true; }

event Activated()
{
 if (TipText != "")
  HDGFxTaskTipHud(MoviePlayer).AddMissionText(TipText);
 else
  HDGFxTaskTipHud(MoviePlayer).MissionStrings.Remove(0,HDGFxTaskTipHud(MoviePlayer).MissionStrings.Length);
 if (InputLinks[2].bHasImpulse)
  HDGFxTaskTipHud(MoviePlayer).FinishMission();
 HDGFxTaskTipHud(MoviePlayer).bAlwaysShow = bStartPaused;
}

