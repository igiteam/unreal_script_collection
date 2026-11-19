class PPA_Boss_Alastor_Charge extends EPA_BasePlaySingleAnim;

function SetActionParamsFromAniminfo(const out EvilAnimInfo InAnimInfo)
{
    AnimName = InAnimInfo.AnimName;
    SpeedModifier = InAnimInfo.AnimSpeed * 0.2000000;
    BlendInTime = InAnimInfo.BlendInTime;
    BlendOutTime = InAnimInfo.BlendOutTime;
    //return;    
}

defaultproperties
{
    AnimName="Charge"
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
    SpeedModifier=0.5000000
}