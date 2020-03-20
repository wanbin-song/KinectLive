function Save_Stream(Color_vid, Depth_vid, dImage)
    colorImage = getsnapshot(Color_vid);
    depthImage = getsnapshot(Depth_vid);
    AlignedImage = dImage;
    
    
    imwrite(colorImage, 'color.png');
    imwrite(depthImage, 'depth.png');
    imwrite(AlignedImage, 'aligned.png');
    
end
