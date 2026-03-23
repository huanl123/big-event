package com.itheima.utils;

import com.aliyun.oss.ClientException;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.OSSException;
import com.aliyun.oss.model.PutObjectRequest;

import java.io.InputStream;

public class AliOssUtil {

    private static final String ENDPOINT = System.getenv("OSS_ENDPOINT") != null ? System.getenv("OSS_ENDPOINT") : "https://oss-cn-beijing.aliyuncs.com";
    private static final String ACCESS_KEY_ID = System.getenv("OSS_ACCESS_KEY_ID");
    private static final String ACCESS_KEY_SECRET = System.getenv("OSS_ACCESS_KEY_SECRET");
    private static final String BUCKET_NAME = System.getenv("OSS_BUCKET_NAME") != null ? System.getenv("OSS_BUCKET_NAME") : "big-event";

    public static String uploadFile(String objectName, InputStream inputStream) throws Exception {
        OSS ossClient = new OSSClientBuilder().build(ENDPOINT, ACCESS_KEY_ID, ACCESS_KEY_SECRET);

        try {
            PutObjectRequest putObjectRequest = new PutObjectRequest(BUCKET_NAME, objectName, inputStream);
            ossClient.putObject(putObjectRequest);
            return "https://" + BUCKET_NAME + "." + ENDPOINT.substring(ENDPOINT.lastIndexOf('/') + 1) + "/" + objectName;
        } catch (OSSException exception) {
            throw new RuntimeException("OSS 上传失败: " + exception.getErrorMessage(), exception);
        } catch (ClientException exception) {
            throw new RuntimeException("无法连接 OSS，请检查网络或 OSS 配置", exception);
        } finally {
            ossClient.shutdown();
        }
    }
}
