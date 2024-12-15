function compute_ndvi,R,NIR
  ndvi = (float(NIR)-R)/(float(NIR)+R)
  return, ndvi
END