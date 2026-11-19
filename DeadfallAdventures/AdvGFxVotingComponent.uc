class AdvGFxVotingComponent extends Object;

var const localized string VoteTitleString;
var const localized string VoteKickString;
var const localized string VoteAvailableYesString;
var const localized string VoteAvailableNoString;
var const localized string VoteYesString;
var const localized string VoteNoString;
var const localized string VoteTimeLeftString;
var const localized string VoteSuccessString;
var const localized string VoteFailString;
var GFxObject VoteMC;
var GFxObject VoteTitleTF;
var GFxObject VoteNameTF;
var GFxObject VoteYesTF;
var GFxObject VoteNoTF;
var GFxObject VoteCountTF;
var GFxObject VoteNumbersTF;
var AdvGRI AdvGRI;
var AdvPRI AdvPRI;
var AdvPlayerController AdvPC;
var bool bVoteMenuVisible;
var string YesPCKey;
var string NoPCKey;

function Initialize(GFxObject BaseObj, AdvPlayerController PC)
{
    AdvPC = PC;
    VoteMC = BaseObj.GetObject("votekickMC");
    VoteTitleTF = VoteMC.GetObject("voteTitle_tf");
    VoteNameTF = VoteMC.GetObject("voteName_tf");
    VoteYesTF = VoteMC.GetObject("voteYes_tf");
    VoteNoTF = VoteMC.GetObject("voteNo_tf");
    VoteCountTF = VoteMC.GetObject("voteCount_tf");
    VoteNumbersTF = VoteMC.GetObject("voteNumbers_tf");
    // End:0x1F7
    if(ADVMenuPC(PC) != none)
    {
        VoteNameTF.SetInt("_x", VoteNameTF.GetInt("_x") - 27);
    }
    VoteNameTF.SetInt("_width", VoteNameTF.GetInt("_width") + 150);
    VoteNameTF.SetFloat("_xscale", VoteNameTF.GetFloat("_xscale") * 0.8100000);
    VoteNameTF.SetFloat("_yscale", VoteNameTF.GetFloat("_yscale") * 0.8100000);
    VoteMC.SetVisible(false);
    //return;    
}

function SetGRI(AdvGRI GRI)
{
    // End:0x52
    if(AdvGRI == none)
    {
        AdvGRI = GRI;
        AdvGRI.__VoteStateChanged__Delegate = OnVoteStateChanged;
    }
    //return;    
}

function OnVoteStateChanged()
{
    local PlayerReplicationInfo PRI;
    local string VoteForYesKey, VoteForNoKey;

    // End:0x51
    if((AdvPRI == none) && AdvPC != none)
    {
        AdvPRI = AdvPRI(AdvPC.PlayerReplicationInfo);
    }
    // End:0x1AE
    if(!bVoteMenuVisible)
    {
        // End:0x1AE
        if(int(AdvGRI.LastVotingState) == int(1))
        {
            bVoteMenuVisible = true;
            VoteMC.SetVisible(bVoteMenuVisible);
            VoteTitleTF.SetText(VoteTitleString);
            // End:0x1AD
            foreach AdvGRI.PRIArray(PRI)
            {
                // End:0x1AC
                if(PRI.UniqueId == AdvGRI.PlayerToKick)
                {
                    VoteNameTF.SetText(Repl(VoteKickString, "`p", PRI.PlayerName));                    
                }
                else
                {                    
                }
            }            
        }
    }
    // End:0x743
    if(bVoteMenuVisible)
    {
        // End:0x23D
        if(int(AdvGRI.LastVotingState) == int(0))
        {
            bVoteMenuVisible = false;
            AdvPRI.bSubmittedVote = false;
            VoteMC.SetVisible(bVoteMenuVisible);            
        }
        else
        {
            // End:0x2D2
            if(int(AdvGRI.LastVotingState) == int(1))
            {
                VoteNumbersTF.SetText(VoteTimeLeftString);
                VoteCountTF.SetText(string(AdvGRI.VotingTimeLeft));                
            }
            else
            {
                VoteCountTF.SetText(" ");
                // End:0x34A
                if(int(AdvGRI.LastVotingState) == int(2))
                {
                    VoteNumbersTF.SetText(VoteSuccessString);                    
                }
                else
                {
                    VoteNumbersTF.SetText(VoteFailString);
                }
            }
            // End:0x64B
            if((int(AdvGRI.LastVotingState) == int(1)) && !AdvPRI.bSubmittedVote)
            {
                VoteYesTF.SetBool("html", true);
                VoteNoTF.SetBool("html", true);
                // End:0x52E
                if(AdvPC.WorldInfo.IsConsoleBuild(1) || !AdvPC.WorldInfo.IsConsoleBuild(0) && AdvPC.IsPCGamepadMode())
                {
                    VoteForYesKey = "<Strings:ADVGame.ControllerFont_XBOX.Controller_Start>";
                    VoteForNoKey = "<Strings:ADVGame.ControllerFont_XBOX.Controller_Back>";                    
                }
                else
                {
                    VoteForYesKey = ("[" $ YesPCKey) $ "]";
                    VoteForNoKey = ("[" $ NoPCKey) $ "]";
                }
                VoteYesTF.SetString("htmlText", ((Repl(VoteAvailableYesString, "`p", VoteForYesKey) $ " (") $ string(AdvGRI.VotesForCount)) $ ")");
                VoteNoTF.SetString("htmlText", ((Repl(VoteAvailableNoString, "`p", VoteForNoKey) $ " (") $ string(AdvGRI.VotesAgainstCount)) $ ")");                
            }
            else
            {
                VoteYesTF.SetBool("html", false);
                VoteNoTF.SetBool("html", false);
                VoteYesTF.SetText(((VoteYesString $ " (") $ string(AdvGRI.VotesForCount)) $ ")");
                VoteNoTF.SetText(((VoteNoString $ " (") $ string(AdvGRI.VotesAgainstCount)) $ ")");
            }
        }
    }
    //return;    
}

defaultproperties
{
    VoteTitleString="Vote"
    VoteKickString="Kick player `p?"
    VoteAvailableYesString="Press `p to vote YES"
    VoteAvailableNoString="Press `p to vote NO"
    VoteYesString="YES"
    VoteNoString="NO"
    VoteTimeLeftString="Time left:"
    VoteSuccessString="Vote succeeded"
    VoteFailString="Vote failed"
    YesPCKey="F3"
    NoPCKey="F4"
}