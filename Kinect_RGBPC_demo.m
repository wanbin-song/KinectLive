function Kinect_RGBPC_demo()
%
%
%
%    Kinect RGB-PC Visualization GUI
%    Copyright 2015 The MathWorks, Inc.
%
%    Wanbin Song,
%    The MathWorks Korea, LLC
%
%
%
%% Get Kinect Data Stream
Color_vid = videoinput('kinect', 1, 'RGB_640x480');
Depth_vid = videoinput('kinect', 2, 'Depth_640x480');

Depth_src = getselectedsource(Depth_vid);
Selected_Depth = 'Default';
Selected_Angle = Depth_src.CameraElevationAngle;
    
Color_vidRes = Color_vid.VideoResolution;
Depth_vidRes = Depth_vid.VideoResolution;
imWidth = Depth_vidRes(1);
imHeight = Depth_vidRes(2);
nBands = Depth_vid.NumberOfBands;

%% Set the GUI position
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name','Kinect Live Streaming', 'Position', [900 100 910 774]);

% Set up the push buttons
uicontrol('String', 'Live 3D Stitching',...
    'Callback', 'Live_Stitch(Color_vid, Depth_vid);',...
    'Position',[670 10 100 50]);
uicontrol('String', 'Live 3D Alignment',...
    'Callback', 'live_3d(Color_vid, Depth_vid, depthImage, colorImage)',...
    'Position',[560 10 100 50]);
uicontrol('String', 'Start Preview',...
    'Callback', 'preview(Depth_vid); preview(Color_vid)',...
    'Position',[10 10 100 50]);
uicontrol('String', 'Stop Preview',...
    'Callback', 'stoppreview(Depth_vid); stoppreview(Color_vid)',...
    'Position',[120 10 100 50]);
uicontrol('String', 'Close',...
    'Callback', 'close(gcf)',...
    'Position',[230 10 100 50]);
uicontrol('String', 'Align Update',...
    'Callback', 'align_update(Color_vid, Depth_vid)', ...
    'Position',[340 10 100 50]);
uicontrol('String', 'Refresh',...
    'Callback', 'refresh_stream(Depth_src, Selected_Angle, Selected_Depth, V)', ...
    'Position',[450 10 100 50]);
uicontrol('Style','popupmenu',...
           'String',{'Default','Near'}, 'Callback', {@setDepthMode}, ...
           'Position',[810 75 60 20]);
uicontrol('Style', 'slider',...
        'Min',-27,'Max',27,'Value',0,...
        'Position',[780 5 120 30], ...
        'Callback', {@Elevation_Angle});
V = uicontrol('Style', 'edit', 'Position', [780 40 120 30], ...
    'String', ['Elevation Angle = ' num2str(floor(Selected_Angle))]);

%% Visualization
subplot(221); 
hImage = image( zeros(imHeight, imWidth, nBands) );
setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);
preview(Color_vid, hImage);           
title('Kinect Color Stream');

subplot(223);
dImage = image( zeros(imHeight, imWidth, nBands) );
setappdata(dImage,'UpdatePreviewWindowFcn',@mypreview_fcn);
preview(Depth_vid, dImage);
title('Kinect Depth Stream');

subplot(2, 2, [2 4]);
colorImage = getsnapshot(Color_vid);
depthImage = getsnapshot(Depth_vid);
xyzPoints = depthToPointCloud(depthImage, Depth_vid);
aligned = alignColorToDepth(depthImage, colorImage, Depth_vid);
pcshow(xyzPoints, aligned, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');