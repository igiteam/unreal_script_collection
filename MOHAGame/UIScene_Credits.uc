class UIScene_Credits extends UIScene_MOHABase
    native
    hidecategories(Object,UIRoot,Object);

var() float SceneTimeInSec;
var() float ScrollAmount;
var transient float StartTime;
var transient UILabel TextLabels[3];
var transient int CurrentTextSet;
var transient float StartOffset[3];
var transient array<string> TextSets;

// Export UUIScene_Credits::execSetupInfo(FFrame&, void* const)
native function SetupInfo();

defaultproperties
{
    SceneTimeInSec=20.0000000
    ScrollAmount=-10000.0000000
    TextSets[0]="<Strings:UIStrings.Credits.01>"
    TextSets[1]="<Strings:UIStrings.Credits.02>"
    TextSets[2]="<Strings:UIStrings.Credits.03>"
    TextSets[3]="<Strings:UIStrings.Credits.04>"
    TextSets[4]="<Strings:UIStrings.Credits.05>"
    TextSets[5]="<Strings:UIStrings.Credits.06>"
    TextSets[6]="<Strings:UIStrings.Credits.07>"
    TextSets[7]="<Strings:UIStrings.Credits.08>"
    TextSets[8]="<Strings:UIStrings.Credits.09>"
    TextSets[9]="<Strings:UIStrings.Credits.10>"
    TextSets[10]="<Strings:UIStrings.Credits.11>"
    TextSets[11]="<Strings:UIStrings.Credits.12>"
    TextSets[12]="<Strings:UIStrings.Credits.13>"
    TextSets[13]="<Strings:UIStrings.Credits.14>"
    TextSets[14]="<Strings:UIStrings.Credits.15>"
    TextSets[15]="<Strings:UIStrings.Credits.16>"
    TextSets[16]="<Strings:UIStrings.Credits.17>"
    TextSets[17]="<Strings:UIStrings.Credits.18>"
    TextSets[18]="<Strings:UIStrings.Credits.19>"
    TextSets[19]="<Strings:UIStrings.Credits.20>"
    TextSets[20]="<Strings:UIStrings.Credits.21>"
    TextSets[21]="<Strings:UIStrings.Credits.22>"
    TextSets[22]="<Strings:UIStrings.Credits.23>"
    TextSets[23]="<Strings:UIStrings.Credits.24>"
    TextSets[24]="<Strings:UIStrings.Credits.25>"
    TextSets[25]="<Strings:UIStrings.Credits.26>"
    TextSets[26]="<Strings:UIStrings.Credits.27>"
    TextSets[27]="<Strings:UIStrings.Credits.28>"
    TextSets[28]="<Strings:UIStrings.Credits.29>"
    TextSets[29]="<Strings:UIStrings.Credits.30>"
    TextSets[30]="<Strings:UIStrings.Credits.31>"
    TextSets[31]="<Strings:UIStrings.Credits.32>"
    // Reference: UIComp_Event'Default__UIScene_Credits.SceneEventComponent'
    begin object name=SceneEventComponent
    end object
    EventProvider=SceneEventComponent
}