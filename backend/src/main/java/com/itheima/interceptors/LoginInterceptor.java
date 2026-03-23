package com.itheima.interceptors;

import com.itheima.pojo.Result;
import com.itheima.utils.JwtUtil;
import com.itheima.utils.ThreadLocalUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Map;

@Component
public class LoginInterceptor implements HandlerInterceptor {
    @Autowired
    private StringRedisTemplate stringRedisTemplate;
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //浠ょ墝楠岃瘉
        String token = request.getHeader("Authorization");
        //楠岃瘉token
        try {
            //浠巖edis涓幏鍙栫浉鍚岀殑token
            ValueOperations<String, String> operations = stringRedisTemplate.opsForValue();
            String redisToken = operations.get(token);
            if (redisToken==null){
                //token宸茬粡澶辨晥浜?
                throw new RuntimeException();
            }
            Map<String, Object> claims = JwtUtil.parseToken(token);

            //鎶婁笟鍔℃暟鎹瓨鍌ㄥ埌ThreadLocal涓?
            ThreadLocalUtil.set(claims);
            //鏀捐
            return true;
        } catch (Exception e) {
            //http鍝嶅簲鐘舵€佺爜涓?01
            response.setStatus(401);
            //涓嶆斁琛?
            return false;
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        //娓呯┖ThreadLocal涓殑鏁版嵁
        ThreadLocalUtil.remove();
    }
}
