pro demo_02
   arr = [[1,2,3],[4,5,6]]
   help,arr
   ;ARR             INT       = Array[3, 2]
   
   arr = [1,2,3]
   help,arr
   ;ARR             INT       = Array[3]
   
   arr = [1,2,3B]
   help,arr
   ;ARR             INT       = Array[3]
   
   arr = [1,2,3D]
   help,arr
   ;ARR             DOUBLE    = Array[3]
   
   ;若变量类型可以转换，则取最大的类型
   
   
   ;创建全零数组
   arr = intarr(3,2)
   print,arr
   ;0       0       0
   ;0       0       0
   
   ;创建数组并按索引填充
   arr = indgen(4,3)
   print,arr
   ;0       1       2       3
   ;4       5       6       7
   ;8       9      10      11
   
   arr = make_array(2,3,/integer,/index)
   print,arr
   
   ;创建数组并指定填充
   arr = make_array(5,4,/integer,value = 9)
   print,arr
   
   print,"" 
   arr = indgen(4,3)
   print,arr
   print,"arr(6)=",arr(6)
   ;6
   print,"arr[1,2]=",arr[1,2]
   ;9
   
   str = "字符串"
   print,str
   arr = strArr(5)
   arr(0) = "字" 
   arr(1) = "符"
   arr(2) = "串"
   arr(3) = "数"
   arr(4) = "组"
   print,arr
   
   ;字符串操作
   str = 'abc2023_hyper.tif'
   ;get index of first key
   a = strpos(str,'h')
   ;get str word from str
   ; strmid([str],index,len)
   tag = strmid(str,a,5)
   ;hyper
   
   ;结构体
   jdata = {name:"tom",age:13,uuid:114514LL}
   print,jdata
   ;{ tom      13                114514}
   print,jdata.name
   ;tom
   ;get count of key 
   print,N_TAGS(jdata)
   ; 3
   print,tag_names(jdata)
   ;NAME AGE UUID
   
   ;指针
   a = ptr_new(1.0d)
   help,a
   ;A               POINTER   = <NullPointer>
   b = a
   *a = 1.0d
   print,b
   print,""
   
   data = indgen(5,5)
   ;0       1       2       3       4
   ;5       6       7       8       9
   ;10      11      12      13      14
   ;15      16      17      18      19
   ;20      21      22      23      24
   ;内存分配
   pd = ptr_new(data,/no_copy)
   ;释放内存
   ptr_free,pd
   
   ;oop
   ;obj = obj_new("objClassName",1,"arg_02","...")
   ;obj.functionName,Argument,[Optional_Argument]
   ;result = obj.functionName,Argument,[Optional_Argument]
   
   ;linked list
   linked_list = LIST(1,2,3,length=5,/no_copy)
   print,linked_list
   ;1,2,3,1,2
   
   print,"linked_list[0]:",linked_list[0]
   ;1
   print,"linked_list[4]:",linked_list[4]
   ;2
   print,"链表已销毁"
   obj_destroy,linked_list
   
   linked_list = LIST(1,2,3,4)
   print,linked_list
   linked_list.add,'abc'
   print,linked_list
   ;1,2,3,4,abc
   linked_list.add,'def',0
   print,linked_list
   ;0,1,2,3,4,abc
   print,linked_list.count()
   ;6
   print,linked_list.isempty()
   ;0
   linked_list.remove,2
   print,linked_list
   ;0,1,3,4,abc
   
   hash_table = hash("name","tom","age",4,/extract,/no_copy)
   print,hash_table["name"]
   ;tom
   
   hash_table['score'] = 60
   print,hash_table
   ;name: tom
   ;score:       60
   ;age:        4
   
   print,"hash_table已销毁"
   obj_destroy,hash_table
   
   ;hash_table.count()
   ;hash_table.haskey
   ;hash_table.isempty
   ;hash_table.keys
   ;hash_table.remove,{key_name}
   
   ;转为结构体
   ;struct_01 = hash_table.tostring()
   
   var = 1
   ;print,var++
   ;1
   print,++var
   ;2
   ;--var
   ;var--
   ;res = var*var
   ;res = var/var
   ;var = var ^ 2
   
   ;and
   print,5&&2
   ;1
   
   ;or
   print,5||0
   ;1
   
   ;not
   print,~3
   ;0
   print,~0
   ;1
   
   ;bit-operatio
   ;AND
   ;NOT
   ;OR
   ;XOR
   
   ;logic-operatio
   ;EQ ==
   ;NE !=
   ;GE >=
   ;GT >
   ;LE <=
   ;LT <
   
   res = 4 gt 3 ? 1:0
   print,res
   ;1
   
   ;等价于for(i=0;i<=10;i++)
   for i=0,10 do begin
    print,i
   endfor
   
   
   res = 'No'
   ;先判断,再执行
   WHILE res EQ 'Yes' DO BEGIN
     res = dialog_message("It's only a joke.",title=!DIR,DISPLAY_NAME='joke',/QUESTION)
     ;break
     ;continue
   ENDWHILE
   
   ;先执行，再判断
   repeat begin
    res = dialog_message("It's only a joke.",title=!DIR,DISPLAY_NAME='joke',/QUESTION)
   endrep until (res EQ 'Yes')
   
   if var eq 10 then begin
    var++
   endif else begin
    var--
   endelse
   
   case var of
    1:print,var
    2:print,var
    else:print,var
   endcase
   ;case不用写break，但是switch要写
   var = 2
   print,""
   SWITCH var OF
     1:begin
       print,var
       break
      end
     2:print,var
     3:print,var
     ELSE:print,var
   ENDSWITCH


  ;捕捉错误
   A = FLTARR(10)

   CATCH, Error_status
   ;This statement begins the error handler:
   IF Error_status NE 0 THEN BEGIN
     PRINT, 'Error index: ', Error_status
     PRINT, 'Error message: ', !ERROR_STATE.MSG
     ; Handle the error by extending A:
     A=FLTARR(12)
     CATCH, /CANCEL

   ENDIF


end