class SeqAct_Weaponfactory extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

struct WaveList
{
    var() array<EvilTouchPickUp_WeaponBase> WeaponsList;
    var() int PickupTime;

    structdefaultproperties
    {
        WeaponsList=none
        PickupTime=0
    }
};

var() array<WaveList> WavesList;
var Vector Location;
var Rotator Rotation;
var SeqVar_Object ObjVar;
var Object Obj;
var EvilTouchPickUp_WeaponBase W;
var EvilTouchPickUp_WeaponBase Pickup;
var Actor Locator;
var int WaveCounter;

event Activated()
{
    local int Counter;

    Counter = 0;
    // End:0x441
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Spawn Points")
    {
        Obj = ObjVar.GetObjectValue();
        Locator = Actor(Obj);
        // End:0x275
        if(Counter < WavesList[WaveCounter].WeaponsList.Length)
        {
            WavesList[WaveCounter].WeaponsList[Counter].Lifetime = WavesList[WaveCounter].PickupTime;
            W = Locator.Spawn(WavesList[WaveCounter].WeaponsList[Counter].Class,,, Locator.Location, Locator.Rotation, WavesList[WaveCounter].WeaponsList[Counter], true);
            W.SetLocation(Locator.Location);
            W.SetRotation(Locator.Rotation);
            Counter++;
            // End:0x440
            continue;
        }
        Counter = 0;
        WavesList[WaveCounter].WeaponsList[Counter].Lifetime = WavesList[WaveCounter].PickupTime;
        W = Locator.Spawn(WavesList[WaveCounter].WeaponsList[Counter].Class,,, Locator.Location, Locator.Rotation, WavesList[WaveCounter].WeaponsList[Counter], true);
        W.SetLocation(Locator.Location);
        W.SetRotation(Locator.Rotation);
        Counter++;        
    }    
    WaveCounter++;
    // End:0x470
    if(WaveCounter > WavesList.Length)
    {
        WaveCounter = 0;
    }
    self.OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    OutputLinks[0]=(Links=none,LinkDesc="Activated",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawn Points",LinkVar="None",PropertyName="ObjList",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Wepon Pickup Factory"
}