function pc = getPC(Color_vid, Depth_vid)
colorImage = getsnapshot(Color_vid);
depthImage = getsnapshot(Depth_vid);
pc = pcfromkinect(Depth_vid, depthImage, colorImage);
end