function align_update(Color_obj, Depth_obj)
    subplot(2,2,[2 4]);
    colorImage = getsnapshot(Color_obj);
    depthImage = getsnapshot(Depth_obj);
    xyzPoints = depthToPointCloud(depthImage, Depth_obj);
    aligned = alignColorToDepth(depthImage, colorImage, Depth_obj);
    pcshow(xyzPoints, aligned, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
end