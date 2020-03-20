function Live_Stitch(Color_vid, Depth_vid)

gridSize = 0.1;
mergeSize = 0.015;

ptCloud{1} = getPC(Color_vid, Depth_vid);
%Next
ptCloud{2} = getPC(Color_vid, Depth_vid);

fixed = pcdownsample(ptCloud{1}, 'gridAverage', gridSize);
moving = pcdownsample(ptCloud{2}, 'gridAverage', gridSize);

tform = pcregrigid(moving, fixed, 'Metric','pointToPlane','Extrapolate', true);
ptCloudAligned = pctransform(ptCloud{2},tform);
ptCloudScene = pcmerge(ptCloud{1}, ptCloudAligned, mergeSize);

% Stitch sequence of PC in Live
% Store the transformation object that accumulates the transformation.
accumTform = tform;

h = figure;
h.Name = 'Kinect 3D Live Stitching WS';
hAxes = pcshow(ptCloudScene, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down');
title('Updated world scene')
hAxes.CameraViewAngleMode = 'auto';
hScatter = hAxes.Children;

for i = 3:100
    ptCloudCurrent = getPC(Color_vid, Depth_vid);
    fixed = moving;
    moving = pcdownsample(ptCloudCurrent, 'gridAverage', gridSize);
    
    if size(moving.Location,1)<100
        continue
    end
    
    % ICP
    tform = pcregrigid(moving, fixed, 'Metric', 'pointToPlane', 'Extrapolate', true);
    accumTform = affine3d(tform.T * accumTform.T);
    ptCloudAligned = pctransform(ptCloudCurrent, accumTform);
    
    % Update
    ptCloudScene = pcmerge(ptCloudScene, ptCloudAligned, mergeSize);
    
    hScatter.XData = ptCloudScene.Location(:,1);
    hScatter.YData = ptCloudScene.Location(:,2);
    hScatter.ZData = ptCloudScene.Location(:,3);
    hScatter.CData = ptCloudScene.Color;
    drawnow('update')       
    
end

% During the recording, the Kinect was pointing downward. To visualize the
% result more easily, let's transform the data so that the ground plane is
% parallel to the X-Z plane.
angle = -pi/10;
A = [1,0,0,0;...
     0, cos(angle), sin(angle), 0; ...
     0, -sin(angle), cos(angle), 0; ...
     0 0 0 1];
ptCloudScene = pctransform(ptCloudScene, affine3d(A));
pcshow(ptCloudScene, 'VerticalAxis','Y', 'VerticalAxisDir', 'Down', ...
        'Parent', hAxes)
title('Updated world scene')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

end
