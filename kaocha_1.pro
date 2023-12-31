FUNCTION get_meta,fp
   OPENR, lun, fp, /GET_LUN
   IF lun EQ -1 THEN BEGIN
     PRINT, "文件打开失败"
   ENDIF ELSE BEGIN
     ;PRINT, "文件打开成功"
     line = ""
     header = HASH()
     WHILE not eof(lun) DO BEGIN
        READF, lun, line
        IF (STRPOS(line, "=") GT 0) and (STRPOS(line, "{") eq -1) THEN BEGIN
            tmp = STRSPLIT(line, "=",/EXTRACT)
            new_str = strtrim(tmp[0], 2)
            key = new_str
            new_str = strtrim(tmp[1], 2)
            value = new_str
            header[key] = value
            ;PRINT,key,"=",value
        endif
        tmp = STRSPLIT(fp, ".",/EXTRACT)
        header["file name"] = tmp[0] + ".dat" 
     end 
     FREE_LUN, lun
     return,header
   END   
END


FUNCTION get_data,header
  ; 读取二进制文件头信息
  fp = header["file name"]
  dtype = fix(header['data type'])
  n_bands = FLOAT(header['bands'])
  samples = FLOAT(header['samples'])
  lines = FLOAT(header['lines'])

  data = BYTARR(n_bands,samples,lines)
  
  OPENU, lun, fp, /GET_LUN
  IF lun EQ -1 THEN BEGIN
      PRINT, "文件打开失败"
  ENDIF ELSE BEGIN
      ;PRINT, "文件打开成功"
      t_data = BYTARR(3,samples,lines)
      ; 显示图像
      FOR index = 0, 3-1 DO BEGIN
          band_data = bytarr(samples,lines)
          readu, lun, band_data
          t_data[index,*,*] = band_data[*,*]
      ENDFOR
      min_value = MIN(t_data)
      max_value = MAX(t_data)
      scaled_data = byte((FLOAT(t_data) - FLOAT(min_value)) / (FLOAT(max_value) - FLOAT(min_value)) * 256)
      window, 0, xsize=samples, ysize=lines,/FREE
      TV,  scaled_data,/true
      free_lun, lun;
  ENDELSE
  
  OPENU, lun, fp, /GET_LUN
  IF lun EQ -1 THEN BEGIN
    PRINT, "文件打开失败"
  ENDIF ELSE BEGIN
    ;PRINT, "文件打开成功"
    
    ; 读取图像数据
    FOR index = 0, n_bands-1 DO BEGIN
        band_data = bytarr(samples,lines)
        readu, lun, band_data
        data[index,*,*] = band_data[*,*]
    ENDFOR
    free_lun, lun;        
    RETURN,data
  ENDELSE
  return, -1
END


FUNCTION output_tiff,data
    fp='E:\Documents\2023IDL\data2023\bhtmref.tif'
    WRITE_TIFF,fp,data
    return, 1
END

PRO kaocha_1
    fp_hdr = 'E:\Documents\2023IDL\data2023\bhtmref.hdr'
    tmp = STRSPLIT(fp_hdr, ".",/EXTRACT)
    fp_img = tmp + ".img"
    header =  get_meta(fp_hdr)
    img = get_data(header)   
    res = output_tiff(img)
    print,"ok!"
END
