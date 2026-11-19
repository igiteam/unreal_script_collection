class MOHAComboBox extends UILabelButton
    native
    hidecategories(Object,UIRoot,Object);

var(ComboBox) string ComboBoxStringArray[20];
var(ComboBox) int CurrentIndex;
var int MaxIndex;

event DisplayNextEntry()
{
    // End:0x19
    if(CurrentIndex < MaxIndex)
    {
        CurrentIndex++;        
    }
    else
    {
        CurrentIndex = 0;
    }
    SetCaption(ComboBoxStringArray[CurrentIndex]);
    //return;    
}

event DisplayPrevEntry()
{
    // End:0x15
    if(CurrentIndex > 0)
    {
        CurrentIndex--;        
    }
    else
    {
        CurrentIndex = MaxIndex;
    }
    SetCaption(ComboBoxStringArray[CurrentIndex]);
    //return;    
}

defaultproperties
{
    ComboBoxStringArray[0]="**default**"
    ComboBoxStringArray[1]="**default**"
    ComboBoxStringArray[2]="**default**"
    ComboBoxStringArray[3]="**default**"
    ComboBoxStringArray[4]="**default**"
    ComboBoxStringArray[5]="**default**"
    ComboBoxStringArray[6]="**default**"
    ComboBoxStringArray[7]="**default**"
    ComboBoxStringArray[8]="**default**"
    ComboBoxStringArray[9]="**default**"
    ComboBoxStringArray[10]="**default**"
    ComboBoxStringArray[11]="**default**"
    ComboBoxStringArray[12]="**default**"
    ComboBoxStringArray[13]="**default**"
    ComboBoxStringArray[14]="**default**"
    ComboBoxStringArray[15]="**default**"
    ComboBoxStringArray[16]="**default**"
    ComboBoxStringArray[17]="**default**"
    ComboBoxStringArray[18]="**default**"
    ComboBoxStringArray[19]="**default**"
    // Reference: UIComp_DrawString'Default__MOHAComboBox.LabelStringRenderer'
    begin object name=LabelStringRenderer
    end object
    StringRenderComponent=LabelStringRenderer
    // Reference: UIComp_DrawImage'Default__MOHAComboBox.BackgroundImageTemplate'
    begin object name=BackgroundImageTemplate
    end object
    BackgroundImageComponent=BackgroundImageTemplate
    // Reference: UIComp_Event'Default__MOHAComboBox.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}