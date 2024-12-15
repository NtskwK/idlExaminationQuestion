pro envi5x
  e=envi()
  fp = ENVI_PICKFILE(DEFAULT=e.root_dir)
  raster=e.OpenRaster(fp)
  print,raster.nbands
  print,raster.nrows
  view=e.GetView()
  layer=view.createLayer(raster)
  layer2=view.createLayer(raster,/cir)
  portal=view.createPortal()
  portal.close
  layer2.close
  
  centerX = raster.NCOLUMNS/2
  centerY = raster.NROWS/2
  
  ref = raster.SPATIALREF
  ref.ConvertFileT,centerX,centerY,mapX,mapY
  ref.ConvertMapToLonLat,mapX,mapY,lon,lat
end