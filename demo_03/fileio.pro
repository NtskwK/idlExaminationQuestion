;read file line by line
FUNCTION print_line
  ;get filepath
  ;fp = 'D:\JRY\IDL\demo_03\data2023\ascii.txt'
  fp = DIALOG_PICKFILE($
    title = '读取ascii.txt',$
    filter = '*.txt',$
    path = FILE_DIRNAME(ROUTINE_FILEPATH('READASCIIFILE')))

  ;open file
  OPENR,lun,fp,/get_lun
  IF lun EQ -1 THEN BEGIN
    msg = DIALOG_MESSAGE('IO ERROR!',/error)
    return,-1
  ENDIF

  ;read file line by line
  tmp = ''
  WHILE ( ~EOF(lun)) DO BEGIN
    readf,lun,tmp
    print,tmp
  ENDWHILE

  ;关闭文件
  free_lun,lun
end 

FUNCTION print_ascii_data
  fp = DIALOG_PICKFILE($
    title = '读取ascii.txt',$
    filter = '*.txt',$
    path = FILE_DIRNAME(ROUTINE_FILEPATH('fileio.pro')))

  openr,lun,fp,/get_lun
  meta = intarr(3)
  readf,lun,meta
  str = strarr(2)
  readf,lun,str
  data = FLTARR(meta(0),meta(1))
  readf,lun,data
  print,data
  free_lun,lun
  RETURN,data
END

function read_asc_data
  fp = DIALOG_PICKFILE($
    title = '读取dsm.asc',$
    filter = '*.asc',$
    path = FILE_DIRNAME(ROUTINE_FILEPATH('READASCIIFILE')))
  openr,lun,fp,/get_lun
  info = strarr(6)
  readf,lun,info
  meta = HASH()
  FOR index = 0, size(info,/N_Elements) - 1 DO BEGIN
    temp = info[index]
    msg = STRSPLIT(temp,/EXTRACT,' ')
    print,msg
    meta[msg[0]]=msg[1]
  ENDFOR
  
  data = FLTARR(meta['ncols'],meta['nrows'])
  readf,lun,data
  print,data
  free_lun,lun
  RETURN,data
end

FUNCTION read_byte, lun,type,len_byte
  tmp = BYTARR(len_byte)
  readu,lun,tmp
  CASE (type) OF
    'string':info = STRING(tmp)
    'int':begin
            info = FIX(tmp)
            IF (N_ELEMENTS(info) gt 1) THEN BEGIN
              res = 0
              FOREACH num, info DO BEGIN
                res = res + num
              ENDFOREACH
              info = res
            ENDIF
          end
    ELSE: info = STRING(tmp)
  ENDCASE
  return, info
END


FUNCTION read_awx_data
  fp = DIALOG_PICKFILE($
    title = '读取FY2C.AWX',$
    filter = '*.awx')
  OPENU,lun,fp,/GET_LUN
  POINT_LUN,lun,20
  HeadLine = INDGEN(3)
  readu,lun,HeadLine
  
  data = BYTARR(HeadLine[2],HeadLine[0])
  POINT_LUN,lun,HeadLine[0] * HeadLine[1]
  readu,lun,data
  ;print,data
  FREE_LUN,lun
  WRITE_TIFF,'D:\demo.tif',data,/FLOATD
END
  

FUNCTION read_jpg
  fp = DIALOG_PICKFILE()
  READ_JPEG,fp,img
  WINDOW,0,XSIZE=400,YSIZE=400
  tv,img,TRUE=1
  return, img
END

FUNCTION write_jpg,data
  COMPILE_OPT idl2
    WRITE_IMAGE,"D:\JRY\IDL\demo_03\data2023\test.jpg","JPEG",data
  return, 1
END


pro fileio
  ;data = read_awx_data()
  data = read_jpg()
  res = write_jpg(data)
  WINDOW,0,XSIZE=400,YSIZE=400
  tv,CONGRID(data,400,400)
  
end