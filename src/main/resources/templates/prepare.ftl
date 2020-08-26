<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>动态表单下载</title>
    <style>
        @page {
            size:a4;
        }
        table{
            margin: auto;
            border: 1px solid #333;
            border-bottom: none;
            border-left: none;
            font-family: SimSun;
        }
        .tg-lboi{
            border-color:inherit;text-align:left;vertical-align:middle
        }
        th{
            height: 30px;
            border: 1px solid #333;
            border-top: none;
            text-align: center;
            /*position: relative;*/
        }
        td{
            height: 30px;
            border: 1px solid #333;
            font-size: 10px;
           /* text-align: left;*/
            border-top: none;
            text-align: center;
            position: relative;
        }
        td.context{
            font-size: 12px;
        }
        
        td.title{
            height: 50px;
            font-size: 36px;
        }
    </style>
</head>
<body>
<table class="table" cellspacing="0" colspan="12">
    <tr >
        <td class="title" colspan="12">
            <#if formName??>
                ${formName}
            </#if>
        </td>
    </tr>

    <tr>
        <td class="context" colspan="3">任务名称</td>
        <td colspan="3"></td>
        <td class="context" colspan="3">任务编号</td>
        <td colspan="3"></td>
    </tr>
    <tr>
        <td class="context" colspan="3">检查对象名称</td>
        <td colspan="3"></td>
        <td class="context" colspan="3">检查对象编码</td>
        <td colspan="3"></td>
    </tr>
    <tr>
        <td class="context" colspan="3">关联对象名称</td>
        <td colspan="3"></td>
        <td class="context" colspan="3">关联对象编码</td>
        <td colspan="3"></td>
    </tr>
    <tr>
        <td class="context" colspan="3">地址</td>
        <td  colspan="9"></td>
    </tr>

    <tr >
        <td class="context" style="width: 10%" colspan="1">序号</td>
        <td class="context" style="width: 15%" colspan="2">检查项目</td>
        <td class="context" style="width: 50%" colspan="6">检查内容</td>
        <td class="context" style="width: 10%" colspan="1">是否检查</td>
        <td class="context" style="width: 15%" colspan="2">是否发现问题</td>
    </tr>
    <#if itemList??>
        <#list itemList as item>
                 <#if item.checkPointList?size gt 1 >
                     <tr>
                     <td width="10%"  colspan="1" rowspan="${item.checkPointList?size}" > ${item_index + 1} </td>
                     <td width="15%" colspan="2" rowspan="${item.checkPointList?size}" >
                         ${item.itemName}
                     </td>
                     <#list item.checkPointList as point >
                         <#if point_index == 0>
                             <td width="50%" colspan="6"> ${point.pointName}</td>
                             <td width="10%" class="tg-lboi" colspan="1" >
                                 □是<br/>
                                 □否<br/>
                                 □不涉及
                             </td>
                             <td width="15%" class="tg-lboi" colspan="2" >
                                 □是<br/>
                                 □否________
                             </td>
                             </tr>
                         <#else>
                             <tr>
                                 <td width="50%" colspan="6" > ${point.pointName}</td>
                                 <td width="10%" style="text-align: left;" class="tg-lboi" colspan="1" >
                                     □是<br/>
                                     □否<br/>
                                     □不涉及
                                 </td>
                                 <td width="15%" style="text-align: left;" colspan="1" >
                                     □是<br/>
                                     □否________
                                 </td>
                             </tr>
                         </#if>
                     </#list>
                 <#else>
                     <tr>
                     <td width="10%" colspan="1"> ${item_index + 1} </td>
                     <td width="15%" colspan="2">
                         ${item.itemName}
                     </td>
                     <#list item.checkPointList as point >
                             <td width="50%" style="text-align: left;" colspan="6" >
                                 ${point.pointName}

                             </td>
                             <td width="10%" style="text-align: left;" colspan="1">
                                 □是<br/>
                                 □否<br/>
                                 □不涉及
                             </td>
                             <td width="15%" style="text-align: left;" colspan="2">
                                 □是<br/>
                                 □否________
                             </td>
                     </#list>
                     </tr>
                 </#if>
        </#list>
    </#if>
  <#if checkList??>
        <#list checkList as check>
            <tr>
                <td class="context"  colspan="2" > ${check.resultItemName}</td>
                <td colspan="5" class="tg-lboi" style="border-right-style:none;vertical-align:top">
                    <#list check.checkResultElementAddDtoList as checkResult>
                        <#if checkResult?is_even_item>
                        <#else>
                            <#if checkResult.elementType == "CHECKBOX_TEXT">
                                □${checkResult.elementTitle}______________________<br/>
                            <#else>
                                □${checkResult.elementTitle}<br/>
                            </#if>
                        </#if>
                    </#list>
                </td>
                <td colspan="5" class="tg-lboi"  style="border-left-style:none;vertical-align:top">
                    <#list check.checkResultElementAddDtoList as checkResult>
                        <#if checkResult?is_even_item>
                            <#if checkResult.elementType == "CHECKBOX_TEXT">
                                □${checkResult.elementTitle}______________________<br/>
                            <#else>
                                □${checkResult.elementTitle}<br/>
                            </#if>
                        <#else>

                        </#if>
                    </#list>
                </td>
            </tr>
        </#list>
    </#if>
    <tr>
        <td class="context" colspan="3" >其他情况说明</td>
        <td colspan="9" ></td>
    </tr>
    <tr>
        <td class="context" width="25%"  colspan="3" >被检查单位意见</td>
        <td width="25%"  colspan="3" ></td>
        <td class="context" width="25%"  colspan="3" >法定代表人（负责人）签字</td>
        <td width="25%"  colspan="3" style="text-align:right">       年   月    日</td>
    </tr>
    <tr>
        <td class="context" colspan="3" >检查组员签名</td>
        <td colspan="3" style="text-align:right">       年   月    日</td>
        <td class="context" colspan="3" >检查组长签名</td>
        <td colspan="3" style="text-align:right">       年   月    日</td>
    </tr>
    <tr>
        <td class="context" colspan="3">备注</td>
        <td colspan="9"></td>
    </tr>
</table>
</body>
</html>