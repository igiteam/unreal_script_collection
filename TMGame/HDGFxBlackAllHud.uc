//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxBlackAllHud extends HDGFxTweenableMoviePlayer;

var array<String> StringT;
var float ttime;
var float bgtime;
var float totaltime;
var float FontSize;
var Bool  bAutoUnload;
var GFxObject RootMC;
var GFxObject HD_TextMC;
var GFxObject HD_Text;
var GFxObject HD_BgMc;


	function bool Start(optional bool StartPaused = false)
	{
		Super.Start(StartPaused);
		RootMC   = GetVariableObject("_root");
		Advance(0);
		return TRUE;
	}

	function SetS()
	{
		local int idx;

		HD_TextMC = RootMC.GetObject("TextMc");
		HD_Text   = HD_TextMC.GetObject("textF");
		HD_BgMc   = RootMC.GetObject("BackG");
		idx = Rand(StringT.Length);
		HD_Text.SetText(StringT[idx]);
		HD_Text.SetFloat("_size",FontSize);
		RootMC.SetFloat("ttime",ttime);
		RootMC.SetFloat("bgtime",bgtime);
	}
	function ShowEndGame()
	{
		HD_TextMC.SetFloat("_alpha",0.0);
		HD_BgMc.SetFloat("_alpha",0.0);
		TweenTo(HD_TextMC,ttime, "_alpha",100.0 ,TWEEN_Linear);
		TweenTo(HD_BgMc, bgtime, "_alpha",100.0 ,TWEEN_Linear);
		TweenTo(HD_TextMC, totaltime, "_z",0.0 ,TWEEN_Linear);
		RootMC.SetBool("bTick",TRUE);
		//RootMC.ActionScriptVoid("End");
	}

	function ShowStartGame()
	{
		HD_TextMC.SetFloat("_alpha",100.0);
		HD_BgMc.SetFloat("_alpha",100.0);
		TweenTo(HD_TextMC, ttime, "_alpha",0.0 ,TWEEN_Linear);
		TweenTo(HD_BgMc, bgtime, "_alpha",0.0 ,TWEEN_Linear);
		TweenTo(HD_TextMC, totaltime, "_z",0.0 ,TWEEN_Linear);
		RootMC.SetBool("bTick",TRUE);
		//RootMC.ActionScriptVoid("Start");
	}
	function TweenComplete(int index)
	{
		super.TweenComplete(index);
		if(TweenList.Length == 0)
		 {
		 RootMC.SetBool("bTick",FALSE);
		 if(bAutoUnload)
			{
			self.Close();
			}
		 }
	}

