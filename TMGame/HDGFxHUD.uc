//-----------------------------------------------------------
//GFx HUD InGame
//-----------------------------------------------------------
class HDGFxHUD extends HDGFxTweenableMoviePlayer;

var localized array<string> HeadShotText;
var localized array<string> TipText;

var GFxObject RootMC;
var GFxObject HandshootMC;
var GFxObject HandshootText;
var GFxObject HandshootTextMC;
var GFxObject MGunMC;
var GFxObject MGunLoadMC;
var GFxObject MGunText;
var GFxObject MGunTextMC;
var Array<GFxObject> GrenadeMC;
//Weapon HUD
var GFxObject WeaponTipTextMC;
var GFxObject WeaponMC;
var GFxObject ClipBulletMC;
var GFxObject ClipBulletText;
var GFxObject AmmoBulletText;
var GFxObject WeaponNameText;
var array<GFxObject> GrenadeCountText;
var GFxObject WeaponBar;
var GFxObject WeaponBarAdd;
var GFxObject HealthBar;
var GFxObject HealthBarAdd;
var GFxObject LowHealthTip;
var GFxObject BossHealth;
var array<GFxObject> DrawTextMC;
var array<GFxObject> DrawText;

var array<HDProj_GrenadeBase> HDProj_Grenade;
var int GrenadeIdx;

var bool      bHeadShotOpen;
var bool      bMGunOpen;
var bool      bLowTipPlay;

var PlayerController PC;

	 function bool Start(optional bool StartPaused = false)
	 {
			super.Start();
			Advance(0);
			RootMC         = GetVariableObject("_root");
			WeaponMC       = RootMC.GetObject("WeaponMC");
			ClipBulletMC   = WeaponMC.GetObject("ClipBulletMC");
			ClipBulletText = ClipBulletMC.GetObject("ClipBullet_text");
			AmmoBulletText = WeaponMC.GetObject("AmmoBullet_text");
			WeaponNameText = WeaponMC.GetObject("WeaponName_text");
			GrenadeCountText[0]= WeaponMC.GetObject("GrenadeCount_text0");
			GrenadeCountText[1]= WeaponMC.GetObject("GrenadeCount_text1");
			GrenadeCountText[2]= WeaponMC.GetObject("GrenadeCount_text2");
			WeaponBar      = WeaponMC.GetObject("WeaponBar");
			WeaponBarAdd   = WeaponMC.GetObject("WeaponBarAdd");
			HealthBar      = WeaponMC.GetObject("HealthBar");
			HealthBarAdd   = WeaponMC.GetObject("HealthBarAdd");
			LowHealthTip   = RootMC.GetObject("LowHealthmc");
			BossHealth     = RootMC.GetObject("Bosshp");
			PC =  GetPC();
			return TRUE;
	}
	function SetDrawTextMCVisible(bool bOpen)
	{
		 DrawTextMC[0].SetVisible(bOpen);
		 DrawText[0].SetVisible(bOpen);
	}
	function SetVisible(bool bShowHUD)
	{
		RootMC.SetVisible(bShowHUD);
	}
	//Updata Weapon
	function SetWeaponInfo(int AmmoBulletCount,float ClipBulletCount,float ClipBulletMax,string WeaponName)
	{
		 if(WeaponMC!=none && ClipBulletMax >= 0)
		 {
			 AmmoBulletText.SetText("/"$ AmmoBulletCount);
			 ClipBulletText.SetText(int(ClipBulletCount));
			 ClipBulletCount = ClipBulletCount/(ClipBulletMax+0.01);
			 WeaponBarAdd.SetFloat("_width",127.0*ClipBulletCount);//_width max 150.0 pix
			 WeaponNameText.SetText(WeaponName);
		 }

		 UpdataGrenadeInfo();
	}
	function SetHealthInfo(int HealthNum)
	{
		 if(WeaponMC!=none)
		 {
			 HealthBarAdd.SetFloat("_width",HealthNum*1.27);
		 }
		 if((HealthNum > 45||HealthNum==0) && TGGameSP_Base( PC.WorldInfo.Game ) != none)
		 {
		  bLowTipPlay = True;
		  LowHealthTip.GotoAndStopI(1);
		 }
		 else if(bLowTipPlay)
		 {
		 LowHealthTip.GotoAndPlay("ShowUp");
		 bLowTipPlay = False;
		 }
	}
	function SetBossHelth(int HealthNum)
	{
	 if(HealthNum > 110)
		 {
		 BossHealth.SetText("BossHP?" $ HealthNum);
		 }
	}
	//HeadShot
	function HeadShotInit()
	{
		if(!bHeadShotOpen)
		{
			RootMC.AttachMovie("Tip_Handshoot","Handshoot");
			HandshootMC= RootMC.GetObject("Handshoot");
			HandshootTextMC = HandshootMC.GetObject("HandshootText");
			HandshootText = HandshootTextMC.GetObject("_text");
			bHeadShotOpen = TRUE;
			SetHeadShotText();
		}
	}

	function SetHeadShotText()
	{
	  local Int TextInt;

	   if(HandshootText!= none)
	   {
			TextInt = Rand(HeadShotText.Length);
			HandshootText.SetText(HeadShotText[TextInt]);
	   }
	}

	function HeadShotPlayReplay()
	{
		HandshootMC.GotoAndPlayI(2);
		SetHeadShotText();
	}

	// MGunLoad
	function MGunInit()
	{
		if(!bMGunOpen&&MGunMC == none)
		{
				RootMC.AttachMovie("Tip_MGun","MGun");
				MGunMC = RootMC.GetObject("MGun");
				MGunLoadMC = MGunMC.GetObject("MGunLoadMC");
				MGunTextMC = MGunMC.GetObject("MGunTextMC");
				MGunText = MGunTextMC.GetObject("_text");
			}
		MGunMC.SetVisible(TRUE);
		bMGunOpen = TRUE;
	}

	function MGunClose()
	{
		MGunMC.SetVisible(FALSE);
		bMGunOpen = FALSE;
	}

	function MGunUpdata(float TopOverload,float CurrOverload,optional bool  bOverload)
	{
	 local float MGunLoadMC_HEIGHT;
	 local float MGunLoadMC_ALPHA;

		 MGunLoadMC_HEIGHT = (CurrOverload/TopOverload)*33.3+0.15;
		 MGunLoadMC_ALPHA = (CurrOverload/TopOverload)*67+33;
		 MGunLoadMC.SetFloat("_height",MGunLoadMC_HEIGHT);
		 MGunLoadMC.SetFloat("_alpha",MGunLoadMC_ALPHA);
		 MGunText.SetText("");
	// if(bOverload)
	//  {
	//  MGunText.SetText("????");
	//  }
	}

	//GrenadeBroadcast

	function UpdataGrenadeInfo()
	{
		local Int Idx;
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
		local float GreAlpha;

		for(Idx=0;Idx<GrenadeIdx;Idx++)
		{
			if(HDProj_Grenade[Idx]!=None)
			{
			   if(GrenadeMC[Idx] == none)
				{
					GrenadeMC[Idx] = RootMC.AttachMovie("Tip_GrenadeMC","GrenadeMC"$Idx);
				}
				GrenadeMC[Idx].SetVisible(TRUE);
			  /**Get info **/
			  Deg2Rad = 3.14159265359/180;
			  PC.ViewTarget.GetActorEyesViewPoint(PlayerLocation,PlayerRotation);
			  //PC.Pawn.GetActorEyesViewPoint(PlayerLocation,PlayerRotation);
			  TipLocation = HDProj_Grenade[Idx].Location;
			  //TipRotation = MapInfo.TaskTipActors[Idx].Rotation;
			  VTaskTip    = TipLocation - PlayerLocation;
			  GreAlpha    = 130-VSize(VTaskTip)/5;
			  if(VSize(VTaskTip)>=500)
			  {
			  RemoveGrenadeInfo(HDProj_Grenade[Idx]);
			  Continue;
			  }
			  Aspect = 1920.0 / 1080.0;
			  FovX = PC.GetFOVAngle()/2.0;
			  FovY = Atan(Tan(FovX*Deg2Rad)/Aspect) / Deg2Rad;
			  Yaw = AngleClamp180((rotator(VTaskTip).Yaw-PlayerRotation.Yaw) / 182.04);
			  Pitch = AngleClamp180((rotator(VTaskTip).Pitch-PlayerRotation.Pitch) / 182.04);
				 /**Set new Postion **/
				 if (Yaw > FovX)
				 MoveTo_x = 1914;
				 else if (Yaw < -FovX)
				 MoveTo_x = 10;
				 else
				 MoveTo_x       =   1920.0*(Tan(Deg2Rad*Yaw) / Tan(Deg2Rad*FovX) * 0.5 + 0.5);

				 if (Pitch > FovY)
				 MoveTo_y = 30;
				 else if (Pitch < -FovY)
				 MoveTo_y = 1080;
				 else
				 MoveTo_y       =   1080.0*(1.0 - (Tan(Deg2Rad*Pitch) / Tan(Deg2Rad*FovY) * 0.5 + 0.5));

		//         if(MoveTo_x>10&&MoveTo_x<1014&&MoveTo_y>60&&MoveTo_y<768)
		//         Task_DMC.GotoAndPlayI(1);
		//         else
		//         Task_DMC.GotoAndPlayI(2);
				 GrenadeMC[Idx].SetFloat("_x",MoveTo_x);
				 GrenadeMC[Idx].SetFloat("_y",MoveTo_y);
				 GrenadeMC[Idx].SetFloat("_alpha",GreAlpha);

		//        UpdateTipRotarion(MoveTo_x,MoveTo_y);

	   }
	   else
	   {
	   RemoveGrenadeInfo(HDProj_Grenade[Idx]);
	   }
	  }
	}
	function AddGrenadeInfo(optional HDProj_GrenadeBase HDG)
	{
		local int Idx;
		local bool bAdd;

		bAdd = TRUE;

		if(HDG!= None)
		{
		 for(Idx=0;Idx<GrenadeIdx;Idx++)
			{
			  if(HDG == HDProj_Grenade[Idx] )
				{
				 bAdd = FALSE;
				 Break;
				}
			}
		if(bAdd)
			{
			HDProj_Grenade[GrenadeIdx] = HDG;
			GrenadeIdx++;
			}
		}
	}

	function RemoveGrenadeInfo(optional HDProj_GrenadeBase HDG)
	{
	local int Idx;

		if(HDG!= None)
		{
		 for(Idx=0;Idx<HDProj_Grenade.Length;Idx++)
		  {
		   if(HDG == HDProj_Grenade[Idx])
			Break;
		  }
			GrenadeIdx--;
			GrenadeMC[Idx].SetVisible(FALSE);
			HDProj_Grenade.Remove(Idx,1);
			GrenadeMC.Remove (Idx,1);
		}
	}

	function RemoveAllGrenadeInfo()
	{
	local int Idx;
		if(GrenadeMC.Length > 0)
		 {
		 for(Idx=0;Idx<GrenadeMC.Length;Idx++)
		  {
			GrenadeMC[Idx].SetVisible(FALSE);
		  }
		 HDProj_Grenade.Remove(0,Idx+1);
		 GrenadeMC.Remove (0,Idx+1);
		 GrenadeIdx = 0;
		 }
	}



	function DrawTextGFx(optional string text)
	{
	 if(DrawTextMC[0] == None)
	 {
		 RootMC.AttachMovie("DrawTextMC","Drawtextmc");
		 DrawTextMC[0] = RootMC.GetObject("Drawtextmc");
		 DrawText[0]   = DrawTextMC[0].GetObject("_text");
	 }
	 DrawText[0].SetText(text);
	}

	function DrawTipText(optional string text)
	{
		local GFxObject TempTextMC;

			if(WeaponTipTextMC  == None)
			{
			 RootMC.AttachMovie("Tip_WeaponText","TipText");
			}

			WeaponTipTextMC = RootMC.GetObject("TipText");
			WeaponTipTextMC.SetVisible(True);

			if(text != "")
			{
			  TempTextMC = WeaponTipTextMC.GetObject("TextMC");
			  TempTextMC = TempTextMC.GetObject("_text");
			  TempTextMC.SetText(text);
			}
	}

	function CloseTipText()
	{
		if(WeaponTipTextMC  != None)
		{
		 WeaponTipTextMC.SetVisible(False);
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

