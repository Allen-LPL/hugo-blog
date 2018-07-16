---
title: 记一次PHPExcel导出特殊字符的问题和解决
date: 2017-08-10 17:38:15
tags: [PHP]
---
#描述
在导出数据时，碰见了直接崩溃，报505。
打断点和异常捕获都不能组织任性的505.
最后分析是特殊字符的问题， 最早想到的解决方式是str_replace替换掉所有特殊字符， 但是在业务上需要保证数据的完整和正确性。
那么就从PHPExcel解决问题。

#解决方式
找到有可能出现特殊字符的那一列， 在初始化列的时候，将

    setCellValue改成setCellValueExplicit

**Show Code**
```PHP
    public function insert_row_key($rows = array())
    {
        $i = 0;
        foreach ($rows as $v) {
            $this->activeCell = $this->get_cell($i, $this->row);
            if ($i == 0) {
                $v = ' ' . $v;
            }

            // 此处是为了解决PHPExcel导出时有特殊字符的问题
            // setCellValueExplicit 是将该列默认以字符串输出
            if ($this->chessLogExcel && $i == $this->chessLogExcel) {
                $this->activeSheet->setCellValueExplicit($this->activeCell, $v);
            } else {
                $this->activeSheet->setCellValue($this->activeCell, $v);
            }

            $i++;
        }
        $this->row ++;
    }
```
