class EvilLocalizedMessages extends Info
    hidecategories(Navigation,Movement,Collision);

struct native MessageInfo
{
    var const localized string Id;
    var const localized string Message;
    var const localized string Sound;

    structdefaultproperties
    {
        Id=""
        Message=""
        Sound=""
    }
};

var array<MessageInfo> Messages;

function string FindMessage(string Id)
{
    local int I;

    I = Messages.Find('Id', Id);
    // End:0x66
    if(I != -1)
    {
        return Messages[I].Message;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

function MessageInfo FindMessageInfo(string Id)
{
    local int I;
    local MessageInfo MSI;

    I = Messages.Find('Id', Id);
    // End:0x59
    if(I != -1)
    {
        MSI = Messages[I];
    }
    return MSI;
    //return ReturnValue;    
}

defaultproperties
{
    Messages[0]=(Id="look",Message="Use {RS} to look around. Try to find three torches nearby.",Sound="")
    Messages[1]=(Id="grabammo",Message="Great. Now grab some ammo from the boxes.",Sound="")
    Messages[2]=(Id="FirstEnemy",Message="Use {RT} to shoot.",Sound="")
    Messages[3]=(Id="souls",Message="Green orbs which drop from fallen enemies are their souls. Collect them to regenerate your health.",Sound="")
    Messages[4]=(Id="ammo",Message="Pick up ammo for secondary fire mode.",Sound="")
    Messages[5]=(Id="SecondEnemy",Message="Use {LT} for alternative fire mode and freeze the enemies.",Sound="")
    Messages[6]=(Id="Combo",Message="You can use combo mode by combining secondary and primary fire modes.",Sound="")
    Messages[7]=(Id="compass",Message="The compass on top of the screen points you in the right direction.",Sound="")
    Messages[8]=(Id="slab",Message="All enemies are dead. You may proceed further. Look for a checkpoint. Help yourself with a compass.",Sound="")
    Messages[9]=(Id="Checkpoint",Message="You've just activated a checkpoint and your health has been restored. Game was also saved.",Sound="")
    Messages[10]=(Id="Healthpack",Message="Orbs of all colors regenerate your health. Try to discover which color gives you the most.",Sound="")
    Messages[11]=(Id="Pickups",Message="You can also pick up other things, like ammo or armor. Certain items are located on plain sight. Others are hidden.",Sound="")
    Messages[12]=(Id="tarotunlockcondition",Message="You can obtain a Tarot Card on every level, by meeting some special requirements. You can check the card's unlocking condition, by using {BK}",Sound="")
    Messages[13]=(Id="destroybarrels",Message="Destroy all chests to get a first Tarot Card.",Sound="")
    Messages[14]=(Id="coins",Message="You can find gold coins hidden in some destroyable objects. It's a good idea to collect them.",Sound="")
    Messages[15]=(Id="tarotcard",Message="Congratulations! You've obtained your first Tarot Card!",Sound="")
    Messages[16]=(Id="holy",Message="Holy items tend to be hidden in secret areas. They will bring you more gold.",Sound="")
    Messages[17]=(Id="holy2",Message="Good. Now try to find the second one.",Sound="")
    Messages[18]=(Id="levelend",Message="Enter the portal to finish the level.",Sound="")
    Messages[19]=(Id="jump",Message="Jump down and grab a weapon!",Sound="")
    Messages[20]=(Id="firstwave",Message="Enemies ahead! Give'em hell!",Sound="")
    Messages[21]=(Id="weapon_change",Message="You can change weapon with {DP}",Sound="")
    Messages[22]=(Id="usetarot",Message="Press {USE} to use your Tarot Card.",Sound="")
    Messages[23]=(Id="demon",Message="After collecting 66 souls, you automatically turn into demon. Let's do this...",Sound="")
    Messages[24]=(Id="end",Message="Great, Daniel! Now you are ready to give'em hell.",Sound="")
    Messages[25]=(Id="soulcatcher",Message="Once you have collected enough souls and all skulls eyes on your Soulcatcher are glowing, hold {LT} and press {RT} to make a combo shot and turn several enemies into your minions.",Sound="")
    Messages[26]=(Id="bolt",Message="Press {RSC} to zoom in with the Boltgun.",Sound="")
    Messages[27]=(Id="DLCMAP",Message="DLC MAP",Sound="")
    Messages[28]=(Id="morgenstern",Message="Hold {LT} for some time to charge mine and release it with {RT}.",Sound="")
}