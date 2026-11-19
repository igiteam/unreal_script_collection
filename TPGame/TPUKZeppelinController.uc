class TPUKZeppelinController extends TPAIController;

var SeqAct_PlayPerformance   PlayPerf;

var float                    Timer;
var float                    CheckTime;
var int                      CheckIndexL;
var int                      CheckIndexR;

var SeqAct_BlimpNaziFactory  NaziFactory;

var TPUKZeppelin             Blimp;


function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn,bVehicleTransition);

    Blimp = TPUKZeppelin(aPawn);
}

function OnBlimpNaziFactory (SeqAct_BlimpNaziFactory Act)
{
    // Log a warning if NaziFactory is replaced before
    // the current one has finished
    if (NaziFactory != None)
    {
        ;
    }

    NaziFactory = Act;
}

function OnBlimpNaziModifier(SeqAct_BlimpNaziModifier Act)
{
    local int i;
    
    //`log(" ChadAI - TPAssaultBlimpController OnBlimpNaziModifier() called Act.NewBehaviorInfo.Length: " @ Act.NewBehaviorInfo.Length @ " -----------------------------------------------------------------------------------");


    for(i = 0; i < Act.NewBehaviorInfo.Length; i++)
    {
        ChangeAction (Act.NewBehaviorInfo[i].Side, Act.NewBehaviorInfo[i].NewAction, Act.NewBehaviorInfo[i].HowManyToModify);
    }
}

function OnBlimpNazis(SeqAct_BlimpNazis Act)
{
    local int i;
    local WehrmachtPawn Dummy;
    local array <class <Inventory> > DummyList;
    DummyList[0] = None;
    
	//`log(" ChadAI - AssultBlimp::OnBlimpNazis Called *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
    

    for(i = 0; i < Act.SpawnInfo.Length; i++)
    {
        SpawnEnemy (class'WehrmachtPawn', Act.SpawnInfo[i].Side, Act.SpawnInfo[i].InitialAction, DummyList, Dummy);
    }

    for(i = 0; i < Blimp.ModifiedL.Length; i++) // L and R same size
    {
        Blimp.ModifiedL[i] = AB_Idle;
        Blimp.ModifiedR[i] = AB_Idle;
    }

    for(i = 0; i < Act.ActionInfo.Length; i++)
    {
        ChangeAction (Act.ActionInfo[i].Side, Act.ActionInfo[i].NewAction, Act.ActionInfo[i].HowManyToModify);
    }
}

function ChangeAction(ABS_Side Side, AB_Action Action, int Count)
{
    local int i;
    local array<WehrmachtPawn> Wehrs;
    local array<AB_Action>     States;
    local array<AB_Action>     Modified;

    if (Action == AB_Gunner)   // Can't change into gunner
        return;

    if (Side == ABS_Left)
    {
        Wehrs     = Blimp.WehrmachtL;
        States    = Blimp.WehrmachtStatesL;
        Modified  = Blimp.ModifiedL;
    }
    else if (Side == ABS_Right)
    {
        Wehrs     = Blimp.WehrmachtR;
        States    = Blimp.WehrmachtStatesR;
        Modified  = Blimp.ModifiedR;
    }

    for(i = 0; i < Wehrs.Length; i++)
    {
        // Check if current state is different from new state and
        // that the state hasn't already been just changed
        if (Wehrs[i] != None && States[i] != Action && Modified[i] == AB_Idle)
        {
            States[i]            = Action;
            Wehrs[i].BlimpAction = Action;
            Modified[i]          = AB_Attack;
            Count--;
        }

        if (Count <= 0)
        {
            break;
        }
    }

    // Set the reference back
    if (Side == ABS_Left)
    {
        Blimp.WehrmachtStatesL = States;
        Blimp.ModifiedL        = Modified;
    }
    else if (Side == ABS_Right)
    {
        Blimp.WehrmachtStatesR = States;
        Blimp.ModifiedR        = Modified;
    }
}

function CheckNaziFactory()
{
    if (NaziFactory == None)
        return;

    if (NaziFactory.CurrentIndex == NaziFactory.SpawnInfo.Length)
    {
        ClearLatentAction(class'SeqAct_BlimpNaziFactory',false);
        NaziFactory.bDone = true;
        NaziFactory = None;
        return;
    }

	//`log(" ChadAI - AssultBlimp::CheckNaziFactory Calling SpawnEnemy Class: " @ NaziFactory.SpawnInfo[NaziFactory.CurrentIndex].WehrmachtClass @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

    SpawnEnemy (NaziFactory.SpawnInfo[NaziFactory.CurrentIndex].WehrmachtClass,
        NaziFactory.SpawnInfo[NaziFactory.CurrentIndex].Side,
        NaziFactory.SpawnInfo[NaziFactory.CurrentIndex].InitialAction,
        NaziFactory.SpawnInfo[NaziFactory.CurrentIndex].InventoryList,
        NaziFactory.SpawnTarget);
        

    NaziFactory.CurrentIndex++;
}

function bool SpawnEnemy (class<WehrmachtPawn> WehrType, ABS_Side Side,
                          AB_Action Action, array<class<Inventory> > InvList, out WehrmachtPawn SpawnTarget)
{
    local vector  Pos;
    local rotator Rot;
    local int     i, j;
    local bool    bSpawned;

    local array<WehrmachtPawn> Wehrs;
    local array<Name>          Socks;
    local array<AB_Action>     States;

    bSpawned = false;
    
	//`log(" ChadAI - AssultBlimp::SpawnEnemy Called SpawnEnemy WehrType: " @ WehrType @ " Side: " @ Side @ " Action: " @ Action @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

    if (Side == ABS_Left)
    {
        Wehrs     = Blimp.WehrmachtL;
        Socks     = Blimp.HangarSocketsL;
        States    = Blimp.WehrmachtStatesL;
    }
    else if (Side == ABS_Right)
    {
        Wehrs     = Blimp.WehrmachtR;
        Socks     = Blimp.HangarSocketsR;
        States    = Blimp.WehrmachtStatesR;
    }

    for (i = 0; i < Wehrs.Length; i++)
    {
        if (Wehrs[i] == None)
        {
            Blimp.Mesh.GetSocketWorldLocationAndRotation(Socks[i],Pos,Rot);
            Wehrs[i] = Spawn(WehrType,,,Pos,Rot,,true);
            SpawnTarget = Wehrs[i];
            
            
			//`log(" ChadAI - AssultBlimp::SpawnEnemy just called Spawn Wehrs[i]: " @ Wehrs[i] @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );

            Wehrs[i].Blimp = Blimp;

            for (j = 0; j < InvList.Length; ++j)
                Wehrs[i].CreateInventory(InvList[j]);

            //TPWehrmachtAIController(Wehrs[i].Controller).EnableAI();
            TPWehrmachtAIController(Wehrs[i].Controller).bIsOnVehicle = true;
            TPWehrmachtAIController(Wehrs[i].Controller).AssignSquadFromSelector(NaziFactory.SquadType);
            Wehrs[i].SightRadius      = NaziFactory.SightRadius;
            Wehrs[i].PeripheralVision = NaziFactory.PeripheralVision;

            Wehrs[i].SetPhysics(PHYS_None);
            Wehrs[i].SetHardAttach(true);
		    Wehrs[i].SetCollision(true, false);
            Wehrs[i].SetBase(Blimp, , Blimp.Mesh, Socks[i]);
            
            //TPAIController(Wehrs[i].Controller).ChangeKynapseEntityToPassiveEntity();
			/* should not use, causes sliding
            TPAIController(Wehrs[i].Controller).ActivateKynapseBrain(false);
			*/


            States[i]            = Action;
            Wehrs[i].BlimpAction = Action;

            bSpawned = true;
            break;
        }
    }

    // Set the reference back
    if (Side == ABS_Left)
    {
        Blimp.WehrmachtL       = Wehrs;
        Blimp.WehrmachtStatesL = States;
    }
    else if (Side == ABS_Right)
    {
        Blimp.WehrmachtR       = Wehrs;
        Blimp.WehrmachtStatesR = States;
    }

    return bSpawned;
}

auto state Patroling
{
    // Since enemies on the blimp are not AI controlled, we have to end
    // the performance animation if the player is not shootable.  Intentionally
    // not checking all wehrmachts at once for performance reasons.
    function WehrAction(array<WehrmachtPawn> Wehrs, array<AB_Action> States, out int CheckIndex)
    {
        local vector PlayerToWehr;
        
		//`log(" ChadAI - AssultBlimp::WehrAction Called CheckIndex: " @ CheckIndex @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
        

        if( m_ThePlayerController != None && m_ThePlayerController.Pawn != None )
        {
        
	 		//`log(" ChadAI - AssultBlimp::WehrAction (Player != None) Wehrs.Length: " @ Wehrs.Length @ " Wehrs[CheckIndex]: " @ Wehrs[CheckIndex]  @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
       
            //if (Wehrs.Length<=CheckIndex && Wehrs[CheckIndex] != None)
            if ( Wehrs[CheckIndex] != None )
            {
            
	 			//`log(" ChadAI - AssultBlimp::WehrAction States[CheckIndex]: " @ States[CheckIndex] @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
                if (States[CheckIndex] == AB_Attack)
                {
                    PlayerToWehr = Normal (m_ThePlayerController.Pawn.Location - Wehrs[CheckIndex].Location);
                    if (vector(Wehrs[CheckIndex].Rotation) dot PlayerToWehr < 0.0)
                    {
                        Wehrs[CheckIndex].OnPerformanceEnd();
                    }
                    else if (!Wehrs[CheckIndex].IsPlayingPerformance())
                    {
                        Wehrs[CheckIndex].OnPlayPerformance(PlayPerf);
                    }
                }
                else if (States[CheckIndex] == AB_Rappel)
                {
   					//`log(" ChadAI - AssultBlimp::WehrAction States[CheckIndex] == AB_Rappel for Wehrs[CheckIndex]: " @ Wehrs[CheckIndex] @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );
                    if (Wehrs[CheckIndex].IsPlayingPerformance())
                        Wehrs[CheckIndex].OnPerformanceEnd();

                    Wehrs[CheckIndex].SetBase(None);
                    TPAIController(Wehrs[CheckIndex].Controller).ClearYourMindFunc();
                    TPAIController(Wehrs[CheckIndex].Controller).PushState('Rappelling');
                    States[CheckIndex] = AB_Idle;
                    // After this the position in the array will be set to None in
                    // TPAssaultBlimp's Tick, essentially detaching the enemy from the blimp
                }
                else if (States[CheckIndex] == AB_Idle && Wehrs[CheckIndex].IsPlayingPerformance())
                {
                    Wehrs[CheckIndex].OnPerformanceEnd();
                }
            }

            CheckIndex++;
        }

        if (CheckIndex == Wehrs.Length)
        {
            CheckIndex = 0;
            CheckTime  = Default.CheckTime;
            Timer      = 0;
        }
    }

    function Tick (float DeltaTime)
    {
        Timer += DeltaTime;

        CheckNaziFactory();

        if (Timer > CheckTime)
        {
            CheckTime += 0.1;
            if( Blimp != None )
            {
 				WehrAction(Blimp.WehrmachtL, Blimp.WehrmachtStatesL, CheckIndexL);
				WehrAction(Blimp.WehrmachtR, Blimp.WehrmachtStatesR, CheckIndexR);
           }
        }
    }
}

