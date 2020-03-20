function setDepthMode(source, eventdata)
    str = source.String;
    val = source.Value;
    switch str{val};
        case 'Default' % User selects Peaks.
            assignin('base', 'Selected_Depth', 'Default');
        case 'Near' % User selects Membrane.
            assignin('base', 'Selected_Depth', 'Near');
    end
    
end