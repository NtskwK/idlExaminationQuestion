pro kaocha_4
  compile_opt idl2, hidden
  on_error, 2

  filename = 'C:\Users\natsuu\Desktop\AA'
  raster_1 = ENVI.OpenRaster(filename)


  task_1 = ENVITask('QUAC')
  task_1.input_raster = raster_1
  task_1.sensor = 'Landsat TM/ETM/OLI'
  task_1.output_raster_uri = "E:\CodeLearning\idl\AA_quac"
  task_1.Execute


  task_5 = ENVITask('ISODATAClassification')
  task_5.input_raster = task_1.output_raster
  task_5.iterations = 30
  task_5.output_raster_uri = "E:\CodeLearning\idl\AA_ISO"
  task_5.Execute


  task_2 = ENVITask('SpectralIndex')
  task_2.input_raster = task_1.output_raster
  task_2.index = 'MNDWI'
  task_2.output_raster_uri = "E:\CodeLearning\idl\AA_mndwi"
  task_2.Execute


  task_3 = ENVITask('ColorSliceClassification')
  task_3.input_raster = task_2.output_raster
  task_3.color_table_name = 'Mac Style'
  task_3.output_raster_uri = "E:\CodeLearning\idl\AA_CS"
  task_3.Execute


  task_4 = ENVITask('GaussianLowPassFilter')
  task_4.input_raster = task_3.output_raster
  task_4.output_raster_uri = "E:\CodeLearning\idl\AA_GLPF"
  task_4.Execute

end
