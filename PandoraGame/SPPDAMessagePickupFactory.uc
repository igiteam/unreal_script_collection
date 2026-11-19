class SPPDAMessagePickupFactory extends SPItemPickupFactory
    abstract
    native;

enum PDA_MessageCategory
{
    ePdaMsgCat_Objective,           // 0
    ePdaMsgCat_Creature,            // 1
    ePdaMsgCat_Equipment,           // 2
    ePdaMsgCat_People,              // 3
    ePdaMsgCat_Pickup,              // 4
    ePdaMsgCat_MAX                  // 5
};

var(PDAMessage) bool m_bAutoPickup;
var(PDAMessage) SPPDAMessagePickupFactory.PDA_MessageCategory m_PdaMsgCat;
var(PDAMessage) array<string> m_UnlockUISceneNames;
var(PDAMessage) array<string> m_RelockUISceneNames;
var(PDAMessage) const localized string m_PickupMessage;
var(PDAMessageMesh) export editinline StaticMeshComponent m_StaticMeshComponent;

// Export USPPDAMessagePickupFactory::execUnlockMessage(FFrame&, void* const)
native function bool UnlockMessage();

// Export USPPDAMessagePickupFactory::execIsUserInUsableLocation(FFrame&, void* const)
native function bool IsUserInUsableLocation(Pawn User);

// Export USPPDAMessagePickupFactory::execIsPickupedUp(FFrame&, void* const)
native function bool IsPickupedUp();

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    ResetPickupState();
    //return;    
}

event bool CanBeUsed(Pawn User)
{
    // End:0x0B
    if(m_bAutoPickup)
    {
        return false;
    }
    // End:0x64
    if(User.IsA('PlayerPawn') && PandoraPlayerController(User.Controller) != none)
    {
        // End:0x64
        if((IsUserInUsableLocation(User)) && !IsPickupedUp())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool UsedBy(Pawn User)
{
    super(Actor).UsedBy(User);
    // End:0x21
    if(!CanBeUsed(User))
    {
        return false;
    }
    UnlockMessage();
    GiveTo(User);
    return true;
    //return ReturnValue;    
}

simulated event ResetPickupState()
{
    // End:0x1B
    if(IsPickupedUp())
    {
        GotoState('PreDestroy');
    }
    //return;    
}

event UnlockPDAPickupAchievement(PandoraPlayerController PC, PandoraGameInfo GameInfo)
{
    local int UnlockedPDAPickupMessageCount, I;

    UnlockedPDAPickupMessageCount = 0;
    I = 0;
    J0x0E:

    // End:0x78 [Loop If]
    if(I < PC.PDAManager.UnlockedPDAMessages.Length)
    {
        // End:0x6E
        if(int(PC.PDAManager.UnlockedPDAMessages[I].eMsgType) == int(8))
        {
            UnlockedPDAPickupMessageCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0xD1
    if(UnlockedPDAPickupMessageCount >= (GameInfo.TotalPDAPickupMessages / 2))
    {
        PC.ProfileSettings.Achievement_BookWorm(LocalPlayer(PC.Player).ControllerId);
    }
    // End:0x126
    if(UnlockedPDAPickupMessageCount == GameInfo.TotalPDAPickupMessages)
    {
        PC.ProfileSettings.Achievement_MintInBox(LocalPlayer(PC.Player).ControllerId);
    }
    //return;    
}

auto state Pickup
{
    simulated function bool ValidTouch(Pawn Other)
    {
        // End:0x15
        if(!super.ValidTouch(Other))
        {
            return false;            
        }
        else
        {
            // End:0x2C
            if(m_bAutoPickup)
            {
                return UnlockMessage();                
            }
            else
            {
                return false;
            }
        }
        //return ReturnValue;        
    }
    stop;    
}
