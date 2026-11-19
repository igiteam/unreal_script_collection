class SeqAct_SetMummyVulnerabilities extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() array< class<EvilDmgType_Base> > VulnerableDmgTypeList;
var() float NotVulnerableDmgScale;

defaultproperties
{
    VulnerableDmgTypeList[0]=Class'AdvDmgType_Crushed'
    VulnerableDmgTypeList[1]=Class'AdvDmgType_MG34'
    VulnerableDmgTypeList[2]=Class'AdvDmgType_Leuchpistol'
    VulnerableDmgTypeList[3]=Class'AdvDmgType_Grenade'
    VulnerableDmgTypeList[4]=Class'AdvDmgType_TrapLight'
    VulnerableDmgTypeList[5]=Class'AdvDmgType_TrapCrushed'
    VulnerableDmgTypeList[6]=Class'AdvDmgType_TrapSpear'
    VulnerableDmgTypeList[7]=Class'AdvDmgType_TrapBolt'
    VulnerableDmgTypeList[8]=Class'AdvDmgType_MummyHands_perk'
    VulnerableDmgTypeList[9]=Class'AdvDmgType_MG34_perk'
    VulnerableDmgTypeList[10]=Class'AdvDmgType_PZB38_perk'
    NotVulnerableDmgScale=0.2500000
    ObjName="Set Mummy Vulnerabilities"
}