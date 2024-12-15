FUNCTION fvc_compute,red,nir,min=min,max=max
  if  ~N_ELEMENTS(min) then min=0.05
  IF  ~N_ELEMENTS(max) THEN max=0.95
  ndvi = (float(nir)-red)/(float(nir)+red)
  fvc = (ndvi ge max)*1 $
      + (ndvi gt min and ndvo lt max) $
          *(ndvi-min)/(max-min)           
  return, fvc
END
