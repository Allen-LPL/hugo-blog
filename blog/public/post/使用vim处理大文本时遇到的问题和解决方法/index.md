#使用Vim处理大文本时遇到的问题和解决方法
在使用vim处理大文本（20G）文件时，由于是在Linux服务器上进行操作，就遇到了打开与保存缓慢的问题，现记录下解决方式。

``` bash
#!/bin/sh

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 hugeFilePath startLine endLine" >&2
  exit 1
fi

sed -n -e $2','$3'p' -e $3'q' $1 > hfnano_temporary_file
vim hfnano_temporary_file
(head -n `expr $2 - 1` $1; cat hfnano_temporary_file; sed -e '1,'$3'd' $1) > hfnano_temporary_file2
cat hfnano_temporary_file2 > $1
rm hfnano_temporary_file hfnano_temporary_file2
```
使用方式：

	sh hfnano yourHugeFile 3 8

这种解决方式首先解决了打开的问题，但是在保存时依旧会随着文件的大小而产生不同时间的等待，双核4G的服务器我处理20G文件，等待了60s.
