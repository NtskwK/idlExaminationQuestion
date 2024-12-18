FUNCTION VegEnhanceJRY, b1,b2,b3
    den = b2 + 6*FLOAT(b1) - 7.5*b3 + 1
    count = den
    if(den eq 0)then den = 1.0                
    EVI = 2.5*(b2- FLOAT(b1)) / den
    if(count eq 0)then evi = 0.0
    RETURN, EVI
END

FUNCTION meta_data,fp
    OPENR, lun, fp, /GET_LUN
    IF lun EQ -1 THEN BEGIN
        PRINT, "文件打开失败"
    ENDIF ELSE BEGIN
        ;PRINT, "文件打开成功"
        line = ""
        header = HASH()
        WHILE NOT eof(lun) DO BEGIN
            READF, lun, line
            IF (STRPOS(line, "=") GT 0) AND (STRPOS(line, "{") EQ -1) THEN BEGIN
                tmp = STRSPLIT(line, "=",/EXTRACT)
                new_str = strtrim(tmp[0], 2)
                key = new_str
                new_str = strtrim(tmp[1], 2)
                value = new_str
                header[key] = value
                ;PRINT,key,"=",value
            ENDIF
            tmp = STRSPLIT(fp, ".",/EXTRACT)
            header["file name"] = tmp[0] + ".img"
        END
        FREE_LUN, lun
        return,header
    END
END


FUNCTION read_data,header
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

FUNCTION compute,data
    COMPILE_OPT idl2
    tmp = size(data)
    b1 = bytarr(tmp[2],tmp[3])
    b2 = bytarr(tmp[2],tmp[3])
    b3 = bytarr(tmp[2],tmp[3])
    b1[*,*] = data[2,*,*]
    b2[*,*] = data[3,*,*]
    b3[*,*] = data[0,*,*]
    new_data = FLTARR(tmp[2],tmp[3])
    FOR i = 0, tmp[2]-1 DO BEGIN
        FOR j = 0, tmp[3]-1 DO BEGIN
            new_data[i,j] = VegEnhanceJRY(b1[i,j],b2[i,j],b3[i,j])
        ENDFOR
    ENDFOR
    return, new_data
END


FUNCTION output,data,fp
    WRITE_TIFF,fp,data,/FLOAT
    return, 1
END

pro kaocha_2
     fp_hdr = 'E:\Documents\2023IDL\data2023\can_tmr.hdr'
     fp_out='E:\Documents\2023IDL\data2023\can_tmr_evi.bmp'   
     tmp = STRSPLIT(fp_hdr, ".",/EXTRACT)
     fp_img = tmp + ".img"
     header =  meta_data(fp_hdr)
     img = read_data(header)
     out_data = compute(img)
     res = output(out_data,fp)
     print,"ok!"
end