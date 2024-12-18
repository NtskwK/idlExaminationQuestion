FUNCTION putout_data,data,output_dir,file_name,task
    ;不支持文件覆写
    ;发生冲突时请先关闭 IDL 再手动删除已经存在的文件
    COMPILE_OPT idl2
    e=envi()
    out_name = file_name + "_" + task + ".tif"
    out_path = output_dir + '\' + out_name
    data.Export,out_path, 'TIFF'
    View = e.GetView()
    Layer = View.CreateLayer(data) 
    return,0
END


PRO kaocha_3
    ;如果在e.OpenRaster  或者 ENVIQUACRaster 发生错误
    ;你可能需要重置IDL环境并手动在控制台执行以下两行
    ENVI,/RESTORE_BASE_SAVE_FILES
    e=envi()
    
    input_dir  = 'E:\CodeLearning\idl\in'
    output_dir = 'E:\CodeLearning\idl\out'

    ; 获取存储在 input_folder 中的所有图像文件
    files = FILE_SEARCH(input_dir + '\' + '*.hdr',COUNT=n_files)

    ; 循环遍历每个文件
    FOR i=0, n_files-1 DO BEGIN
        fp = files[i]
        filename = FILE_BASENAME(fp)
        ; 输出当前正在处理的文件名
        PRINT, 'Processing file: ' + filename
        out_name = STRSPLIT(filename,".",/EXTRACT)
        out_name = out_name[0]
        
        header = meta_data(fp,'dat')
        data_path = header["file name"]

        ; 读取输入图像
        data = e.OpenRaster(data_path)
        print,"quac!"
        quac_data = ENVIQUACRaster(data,SENSOR='Landsat TM/ETM/OLI')
        data.Close
        stauts = putout_data(quac_data,output_dir,out_name,"QUAC")
        
        
        ;NDVI
        print,"NDVI!"
        result = ENVISpectralIndexRaster(quac_data,"NDVI") 
        stauts = putout_data(result,output_dir,out_name,"NDVI")
        ndvi = result.GetData(BANDS=0)
        
        
        ;EVI
        print,"EVI!"
        result = ENVISpectralIndexRaster(quac_data,"EVI") 
        stauts = putout_data(result,output_dir,out_name,"EVI")
        
        ;fvc
        print,"FVC!"
        ndvi=ndvi>(0)
        fvc=ndvi<(1)
        ndvis = min(ndvi)
        ndviv = max(ndvi)
        fvc=(ndvi-ndvis)/(ndviv-ndvis)
        fvc=fvc>(0)
        fvc=fvc<(1)

        Temp_file = e.GetTemporaryFilename()
        result = ENVIRaster(fvc,URI=Temp_file,INHERITS_FROM=quac_data)
        result.Save
        stauts = putout_data(result,output_dir,out_name,"FVC")
        
        ;Binary Image
        binary = fvc gt median(fvc)
         
        Temp_file = e.GetTemporaryFilename()
        result = ENVIRaster(binary,URI=Temp_file,INHERITS_FROM=quac_data)
        result.Save
        stauts = putout_data(result,output_dir,out_name,"binary")
    ENDFOR
END