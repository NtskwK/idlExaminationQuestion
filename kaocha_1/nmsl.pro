

pro nmsl
    e = envi() 
    ;要打开envi使用，来读取数据
    ENVI_OPEN_FILE,fp,R_FID=fid
    ENVI_SELECT,fid=fid,DIMS=dims,POS=pos
    raster = e.OpenRaster() 
    
    QUACImage = ENVIQUACRaster(raster)
    print,data
end