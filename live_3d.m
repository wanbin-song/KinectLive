function live_3d(Color_vid, Depth_vid, depthImage, colorImage)
ptCloud = pcfromkinect(Depth_vid, depthImage, colorImage);
player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits,...
	'VerticalAxis','y','VerticalAxisDir','down');
xlabel(player.Axes,'X (m)');
ylabel(player.Axes,'Y (m)');
zlabel(player.Axes,'Z (m)');
for i = 1:150
    colorImage = getsnapshot(Color_vid);
    depthImage = getsnapshot(Depth_vid);
    ptCloud = pcfromkinect(Depth_vid, depthImage, colorImage);
    view(player, ptCloud)
end
end