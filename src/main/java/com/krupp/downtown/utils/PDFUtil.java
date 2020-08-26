package com.krupp.downtown.utils;

import com.itextpdf.text.pdf.BaseFont;
import com.lowagie.text.DocumentException;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.util.ResourceUtils;
import org.xhtmlrenderer.pdf.ITextFontResolver;
import org.xhtmlrenderer.pdf.ITextRenderer;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Map;

public class PDFUtil {

    private static final Logger logger = LoggerFactory.getLogger(PDFUtil.class);
    private volatile static Configuration configuration;
    private static ResourceLoader resourceLoader = new DefaultResourceLoader();

    static {
        if (configuration == null) {
            synchronized (PDFUtil.class) {
                if (configuration == null) {
                    configuration = new Configuration(Configuration.VERSION_2_3_28);
                }
            }
        }
    }

    private PDFUtil() {
    }

    /**
     * freemarker 引擎渲染 html
     *
     * @param dataMap 传入 html 模板的 Map 数据
     * @return
     */
    public static String freemarkerRender(Map<String, Object> dataMap) {
        Writer out = new StringWriter();
        configuration.setDefaultEncoding("UTF-8");
        configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        try {
            //使用临时文件夹。解决将项目打包为jar。报错问题
            configuration.setDirectoryForTemplateLoading(FileUtils.getTempDirectory());
            getTempPath("prepare.ftl", "templates/prepare.ftl");
            configuration.setLogTemplateExceptions(false);
            configuration.setWrapUncheckedExceptions(true);
            Template template = configuration.getTemplate("prepare.ftl");
            template.process(dataMap, out);
            out.flush();
            return out.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 使用 iText 生成 PDF 文档
     *
     * @param htmlTmpStr html 模板文件字符串
     */
    public static byte[] createPDF(String htmlTmpStr) {
        ByteArrayOutputStream outputStream = null;
        byte[] result = null;
        try {
            outputStream = new ByteArrayOutputStream();
            ITextRenderer renderer = new ITextRenderer();
            renderer.setDocumentFromString(htmlTmpStr);
            ITextFontResolver fontResolver = renderer.getFontResolver();
            //插入字体，解决中文不显示问题
            fontResolver.addFont(getTempPath("simsun.ttc", "font/simsun.ttc"), BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
            renderer.layout();
            renderer.createPDF(outputStream);
            result = outputStream.toByteArray();
            if (outputStream != null) {
                outputStream.flush();
                outputStream.close();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    private static String getTempPath(String fileName, String srcPath) {
        try {
            File baseDirFile = FileUtils.getTempDirectory();
            String filePath = baseDirFile.getCanonicalPath() + File.separator + fileName;
            File f = new File(filePath);
            if (!f.exists()) {
                Files.createFile(f.toPath());
            }
            Resource srcRes = resourceLoader.getResource(ResourceUtils.CLASSPATH_URL_PREFIX + srcPath);
            Files.copy(srcRes.getInputStream(), f.toPath(), StandardCopyOption.REPLACE_EXISTING);
            return filePath;
        } catch (IOException ex) {
            logger.error("create temp font fail, ex:", ex);
        }

        return "";
    }
}
