function refresh_stream(Depth_src, Selected_Angle, Selected_Depth, V)
    Depth_src.DepthMode = Selected_Depth;
    Depth_src.CameraElevationAngle = floor(Selected_Angle);
    updateEditBox(V, Selected_Angle);
end