package com.krupp.downtown.controller;

import com.krupp.downtown.utils.PDFUtil;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.HashMap;

@RestController
@RequestMapping("prepare")
public class PrepareController {


    /**
     * 功能描述: 下载表单
     *
     * @param response
     */
    @RequestMapping(value = "/downloadForm", method = RequestMethod.GET)
    public void downloadForm(HttpServletResponse response, @RequestParam String fromId) {
        try {
            HashMap<String, Object> dataMap = new HashMap<>();
            //将数据写入模版
            String htmlStr = PDFUtil.freemarkerRender(dataMap);
            //将模版转为pdf格式
            byte[] pdf = PDFUtil.createPDF(htmlStr);
            String formName = dataMap.get("formName") + ".pdf";
            formName = URLEncoder.encode(formName, "UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename*=utf-8'zh_cn'" + formName);
            response.getOutputStream().write(pdf);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
